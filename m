Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107EF395CFE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhEaNki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231790AbhEaNib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:38:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9477D61456;
        Mon, 31 May 2021 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467603;
        bh=mw4sCkTMA40ZfohJTNgo1lGvjbpv9nYURaBPS8G/Nw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUQJf3EjXuH8gUCWL08alAVjfu03oAnB4U1EqfR7d/EtffOGAhrP3+d7epfGWwTpD
         Kj5G8uJLEo+QgO0bK5TIyS5p6keW4w9TGKKIT28IUH/fP3Rt0is2I75qHZW0GuMVdp
         3fMOQrHCBu5Gm8YX+RRayTjPvFS/QTzwjUifJ5g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 11/79] proc: Check /proc/$pid/attr/ writes against file opener
Date:   Mon, 31 May 2021 15:13:56 +0200
Message-Id: <20210531130636.364464527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit bfb819ea20ce8bbeeba17e1a6418bf8bda91fc28 upstream.

Fix another "confused deputy" weakness[1]. Writes to /proc/$pid/attr/
files need to check the opener credentials, since these fds do not
transition state across execve(). Without this, it is possible to
trick another process (which may have different credentials) to write
to its own /proc/$pid/attr/ files, leading to unexpected and possibly
exploitable behaviors.

[1] https://www.kernel.org/doc/html/latest/security/credentials.html?highlight=confused#open-file-credentials

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2557,6 +2557,10 @@ static ssize_t proc_pid_attr_write(struc
 	ssize_t length;
 	struct task_struct *task = get_proc_task(inode);
 
+	/* A task may only write when it was the opener. */
+	if (file->f_cred != current_real_cred())
+		return -EPERM;
+
 	length = -ESRCH;
 	if (!task)
 		goto out_no_task;



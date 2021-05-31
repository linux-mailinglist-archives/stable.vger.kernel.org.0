Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB97395DC1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhEaNuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhEaNrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB5A56161C;
        Mon, 31 May 2021 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467833;
        bh=c2Ydtpu8WFdXD9/MbJ9qltC44GUSDVsmkHak/Ob/xFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSyg4j8Hff6rm9UDGpFWGQzTyouAR7g2mEjM66UbPmmdc9CB6+U7b2R5DJkdZeIbF
         4RHGgNN6DHeKaCIV0IQ2rxk4jPuw+EBIkSenKMP465Hya/L9bMECaWton04C2j2rq0
         ot/t4X4raEj6/MloRA0Tlcoet19qGjyR0YWJUeXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 018/252] proc: Check /proc/$pid/attr/ writes against file opener
Date:   Mon, 31 May 2021 15:11:23 +0200
Message-Id: <20210531130658.597576820@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -2704,6 +2704,10 @@ static ssize_t proc_pid_attr_write(struc
 	void *page;
 	int rv;
 
+	/* A task may only write when it was the opener. */
+	if (file->f_cred != current_real_cred())
+		return -EPERM;
+
 	rcu_read_lock();
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (!task) {



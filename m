Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4831D821B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgERRxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731141AbgERRx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:53:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF0420674;
        Mon, 18 May 2020 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824408;
        bh=8KW1i2wmH5EBan1tCvs1sWmWIm+rOa+TpyNnyeV6VdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSVj2YFhBWnv9VzphZiQNodVLyUi0/HohShdbtFh49XcnFysUWJ242ssV139SSvuJ
         zSxzIKjQDDpUBY/yZOgF3uQ2wOs70VHYyKvncnnR4s5+vDQ0UwCKE+86PAWYM8GXhw
         hYNDBWyjlrec2qOwO49XMWuuJz8PZtq6zB+QWvig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.19 65/80] exec: Move would_dump into flush_old_exec
Date:   Mon, 18 May 2020 19:37:23 +0200
Message-Id: <20200518173503.493770817@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit f87d1c9559164294040e58f5e3b74a162bf7c6e8 upstream.

I goofed when I added mm->user_ns support to would_dump.  I missed the
fact that in the case of binfmt_loader, binfmt_em86, binfmt_misc, and
binfmt_script bprm->file is reassigned.  Which made the move of
would_dump from setup_new_exec to __do_execve_file before exec_binprm
incorrect as it can result in would_dump running on the script instead
of the interpreter of the script.

The net result is that the code stopped making unreadable interpreters
undumpable.  Which allows them to be ptraced and written to disk
without special permissions.  Oops.

The move was necessary because the call in set_new_exec was after
bprm->mm was no longer valid.

To correct this mistake move the misplaced would_dump from
__do_execve_file into flos_old_exec, before exec_mmap is called.

I tested and confirmed that without this fix I can attach with gdb to
a script with an unreadable interpreter, and with this fix I can not.

Cc: stable@vger.kernel.org
Fixes: f84df2a6f268 ("exec: Ensure mm->user_ns contains the execed files")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1269,6 +1269,8 @@ int flush_old_exec(struct linux_binprm *
 	 */
 	set_mm_exe_file(bprm->mm, bprm->file);
 
+	would_dump(bprm, bprm->file);
+
 	/*
 	 * Release all of the old mmap stuff
 	 */
@@ -1814,8 +1816,6 @@ static int __do_execve_file(int fd, stru
 	if (retval < 0)
 		goto out;
 
-	would_dump(bprm, bprm->file);
-
 	retval = exec_binprm(bprm);
 	if (retval < 0)
 		goto out;



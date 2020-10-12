Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AC028B668
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgJLNdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389142AbgJLNdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:33:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCCBE2076E;
        Mon, 12 Oct 2020 13:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509598;
        bh=kMn9LsPkYIaEn3BCjd0s9jSqH6l7DgqHta1lfxvkPYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/seLyquKvvk7mk5OhyGRR7qS7quIfLrtbbpWcoO10R6rxFBmEM/ETJ0Xg8PeSjvZ
         DzSN8ImdKDUkq5Ss8cVCTdc437IBE0zkhuZAHA8Tb5BCfC4gXMODCwV1GOedvUK64m
         YUsJu8IjMZOEJKw4DyktoODUeysGMyU7FPTdD7hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 22/39] usermodehelper: reset umask to default before executing user process
Date:   Mon, 12 Oct 2020 15:26:52 +0200
Message-Id: <20201012132629.188589120@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 4013c1496c49615d90d36b9d513eee8e369778e9 upstream.

Kernel threads intentionally do CLONE_FS in order to follow any changes
that 'init' does to set up the root directory (or cwd).

It is admittedly a bit odd, but it avoids the situation where 'init'
does some extensive setup to initialize the system environment, and then
we execute a usermode helper program, and it uses the original FS setup
from boot time that may be very limited and incomplete.

[ Both Al Viro and Eric Biederman point out that 'pivot_root()' will
  follow the root regardless, since it fixes up other users of root (see
  chroot_fs_refs() for details), but overmounting root and doing a
  chroot() would not. ]

However, Vegard Nossum noticed that the CLONE_FS not only means that we
follow the root and current working directories, it also means we share
umask with whatever init changed it to. That wasn't intentional.

Just reset umask to the original default (0022) before actually starting
the usermode helper program.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kmod.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -28,6 +28,7 @@
 #include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/fs_struct.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/mount.h>
@@ -223,6 +224,14 @@ static int call_usermodehelper_exec_asyn
 	spin_unlock_irq(&current->sighand->siglock);
 
 	/*
+	 * Initial kernel threads share ther FS with init, in order to
+	 * get the init root directory. But we've now created a new
+	 * thread that is going to execve a user process and has its own
+	 * 'struct fs_struct'. Reset umask to the default.
+	 */
+	current->fs->umask = 0022;
+
+	/*
 	 * Our parent (unbound workqueue) runs with elevated scheduling
 	 * priority. Avoid propagating that into the userspace child.
 	 */



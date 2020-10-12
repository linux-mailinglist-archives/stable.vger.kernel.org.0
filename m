Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F14328C0D4
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388523AbgJLTGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391186AbgJLTDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 430932067C;
        Mon, 12 Oct 2020 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529429;
        bh=p3pDvLemUq7qOEZDJTDyDXm0HyfeG2n1DlwU+lVlrzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tr+VE/Elh70AgQBdIWjadAHunNgT8xf+nmCIb2UL5wJ6cPNY26jgHpGm0laLifFak
         Xek8al8Z0uxuIpBc2qDYWlECPGK2HJoDqmFVLMdzXOtzYwvjKM0clRRimKENmn/1uT
         xcSNDpzjZXIGpj69K+RWD8T8SAHEoveHSm72L81o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 10/12] usermodehelper: reset umask to default before executing user process
Date:   Mon, 12 Oct 2020 15:03:33 -0400
Message-Id: <20201012190335.3279538-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190335.3279538-1-sashal@kernel.org>
References: <20201012190335.3279538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4013c1496c49615d90d36b9d513eee8e369778e9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/umh.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/umh.c b/kernel/umh.c
index 52a9084f85419..16653319c8ce8 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -13,6 +13,7 @@
 #include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/fs_struct.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/mount.h>
@@ -72,6 +73,14 @@ static int call_usermodehelper_exec_async(void *data)
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/*
+	 * Initial kernel threads share ther FS with init, in order to
+	 * get the init root directory. But we've now created a new
+	 * thread that is going to execve a user process and has its own
+	 * 'struct fs_struct'. Reset umask to the default.
+	 */
+	current->fs->umask = 0022;
+
 	/*
 	 * Our parent (unbound workqueue) runs with elevated scheduling
 	 * priority. Avoid propagating that into the userspace child.
-- 
2.25.1


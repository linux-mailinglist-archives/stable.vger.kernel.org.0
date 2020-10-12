Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3451128C0E6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391493AbgJLTHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390144AbgJLTDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC1620BED;
        Mon, 12 Oct 2020 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529411;
        bh=c9nU640zVNBStUGukOZ+zHWdfrnRG8n044nrkjvSuPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAxWQ7jvbUqaGPjS2Wq4dsn/PsHDutb84z8bifyo2Wgo9iiNby8raHspcb23tj8ad
         HTdivifVdVcvNZADE97lftKtC4V9/I5/B5U80kzZT5KZxWEGx8ZjXPjVz/T1+9ij0c
         qIWlyukQ5TcbYdQnJzhpwY0QPQ3hb22UWSd1SOoE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 13/15] usermodehelper: reset umask to default before executing user process
Date:   Mon, 12 Oct 2020 15:03:10 -0400
Message-Id: <20201012190313.3279397-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190313.3279397-1-sashal@kernel.org>
References: <20201012190313.3279397-1-sashal@kernel.org>
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
index 3474d6aa55d83..b8c524dcc76f1 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -14,6 +14,7 @@
 #include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/fs_struct.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/mount.h>
@@ -75,6 +76,14 @@ static int call_usermodehelper_exec_async(void *data)
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


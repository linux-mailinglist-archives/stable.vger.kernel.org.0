Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B58FF3D8
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfKPQ2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:28:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfKPPlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:19 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C7372075B;
        Sat, 16 Nov 2019 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918878;
        bh=3rZd8WAF0bdHLPMC9H3Bv1cYv1WRtPTVMC3DphGZp8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZUU022/PcOd2DEu/kYBsk8LMN4SgAhUDqObdwW/eN6jVwn5NM65XLvuh4X96Zpmm
         zCQsRNISC/q+y+VeseoyZCo7sWujcYQX+nYQ8oj45jjDqLy88dui9AfIGVHEhucDw6
         XyDH7sI4WiYtZPofK1SCioOdq2mV5OZOt2R3Szt0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 008/237] pty: fix compat ioctls
Date:   Sat, 16 Nov 2019 10:37:23 -0500
Message-Id: <20191116154113.7417-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 50f45326afab723df529eca54095e2feac24da2d ]

pointer-taking ones need compat_ptr(); int-taking one doesn't.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/pty.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 678406e0948b2..00099a8439d21 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 #include <linux/file.h>
 #include <linux/ioctl.h>
+#include <linux/compat.h>
 
 #undef TTY_DEBUG_HANGUP
 #ifdef TTY_DEBUG_HANGUP
@@ -488,6 +489,7 @@ static int pty_bsd_ioctl(struct tty_struct *tty,
 	return -ENOIOCTLCMD;
 }
 
+#ifdef CONFIG_COMPAT
 static long pty_bsd_compat_ioctl(struct tty_struct *tty,
 				 unsigned int cmd, unsigned long arg)
 {
@@ -495,8 +497,11 @@ static long pty_bsd_compat_ioctl(struct tty_struct *tty,
 	 * PTY ioctls don't require any special translation between 32-bit and
 	 * 64-bit userspace, they are already compatible.
 	 */
-	return pty_bsd_ioctl(tty, cmd, arg);
+	return pty_bsd_ioctl(tty, cmd, (unsigned long)compat_ptr(arg));
 }
+#else
+#define pty_bsd_compat_ioctl NULL
+#endif
 
 static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
 /*
@@ -676,6 +681,7 @@ static int pty_unix98_ioctl(struct tty_struct *tty,
 	return -ENOIOCTLCMD;
 }
 
+#ifdef CONFIG_COMPAT
 static long pty_unix98_compat_ioctl(struct tty_struct *tty,
 				 unsigned int cmd, unsigned long arg)
 {
@@ -683,8 +689,12 @@ static long pty_unix98_compat_ioctl(struct tty_struct *tty,
 	 * PTY ioctls don't require any special translation between 32-bit and
 	 * 64-bit userspace, they are already compatible.
 	 */
-	return pty_unix98_ioctl(tty, cmd, arg);
+	return pty_unix98_ioctl(tty, cmd,
+		cmd == TIOCSIG ? arg : (unsigned long)compat_ptr(arg));
 }
+#else
+#define pty_unix98_compat_ioctl NULL
+#endif
 
 /**
  *	ptm_unix98_lookup	-	find a pty master
-- 
2.20.1


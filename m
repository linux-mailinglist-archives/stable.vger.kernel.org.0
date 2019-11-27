Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4EF10BD95
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbfK0U4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbfK0U4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC7C2158C;
        Wed, 27 Nov 2019 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888165;
        bh=3rZd8WAF0bdHLPMC9H3Bv1cYv1WRtPTVMC3DphGZp8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN/0mKNiU3LXglYxzppjHsYAVZI/6SGngoD+012QBcFO3CcpvLwckVGM+nhQX/O7n
         7XbpeBP44IpTKpv881ReIYV+rkyevuv51zHnQkQjNFgfFvLXwJLD+woXkV8JcYf9P3
         c1ygzbblntxYTRJmO4mNCIRoOVIL8eqYgSoVXWLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/306] pty: fix compat ioctls
Date:   Wed, 27 Nov 2019 21:27:59 +0100
Message-Id: <20191127203116.849803786@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




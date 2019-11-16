Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73FCFF3D2
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfKPQ2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbfKPPlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:19 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E36582075C;
        Sat, 16 Nov 2019 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918879;
        bh=B7wpAoZb0vOP2wxAkqsNJK7GjdfckQh97xZRiHY1kRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXSYfzDRkvF6WNEC7poFoIp8482nk6po3OFJR+ykcWJCl5OcocUHGNLc/lZqiYPmR
         56HW65A25IwIUqG285QZhYojCF6aew3RXo2fABFoAJf9VAfw5ZIx62f71A2foGnJgg
         JZBdCjyGf27QIans7IhLQbrRaKgDAbJzTPmGXbJo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 009/237] synclink_gt(): fix compat_ioctl()
Date:   Sat, 16 Nov 2019 10:37:24 -0500
Message-Id: <20191116154113.7417-9-sashal@kernel.org>
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

[ Upstream commit 27230e51349fde075598c1b59d15e1ff802f3f6e ]

compat_ptr() for pointer-taking ones...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/synclink_gt.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index a94086597ebd6..b88ecf102764e 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1186,14 +1186,13 @@ static long slgt_compat_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct slgt_info *info = tty->driver_data;
-	int rc = -ENOIOCTLCMD;
+	int rc;
 
 	if (sanity_check(info, tty->name, "compat_ioctl"))
 		return -ENODEV;
 	DBGINFO(("%s compat_ioctl() cmd=%08X\n", info->device_name, cmd));
 
 	switch (cmd) {
-
 	case MGSL_IOCSPARAMS32:
 		rc = set_params32(info, compat_ptr(arg));
 		break;
@@ -1213,18 +1212,11 @@ static long slgt_compat_ioctl(struct tty_struct *tty,
 	case MGSL_IOCWAITGPIO:
 	case MGSL_IOCGXSYNC:
 	case MGSL_IOCGXCTRL:
-	case MGSL_IOCSTXIDLE:
-	case MGSL_IOCTXENABLE:
-	case MGSL_IOCRXENABLE:
-	case MGSL_IOCTXABORT:
-	case TIOCMIWAIT:
-	case MGSL_IOCSIF:
-	case MGSL_IOCSXSYNC:
-	case MGSL_IOCSXCTRL:
-		rc = ioctl(tty, cmd, arg);
+		rc = ioctl(tty, cmd, (unsigned long)compat_ptr(arg));
 		break;
+	default:
+		rc = ioctl(tty, cmd, arg);
 	}
-
 	DBGINFO(("%s compat_ioctl() cmd=%08X rc=%d\n", info->device_name, cmd, rc));
 	return rc;
 }
-- 
2.20.1


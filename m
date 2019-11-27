Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4572810B9B8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfK0U4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731030AbfK0U4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF72C2084D;
        Wed, 27 Nov 2019 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888167;
        bh=B7wpAoZb0vOP2wxAkqsNJK7GjdfckQh97xZRiHY1kRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPIBsMfMIY/CVe5u56TmoJOW4D8niv7NGtwebhogE5I/0ea8Er4shTegcGpzDADqC
         ReQ3uitfnSN0eDxC1C9uaugsc3ADIFHz3MLRGQ5dg7ihjstndt4BzAJumgVNFuR47Q
         4Tw1/dmo3rrnkNPlVUkpUiIIzg25F+0CerCdvSJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/306] synclink_gt(): fix compat_ioctl()
Date:   Wed, 27 Nov 2019 21:28:00 +0100
Message-Id: <20191127203116.924730296@linuxfoundation.org>
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




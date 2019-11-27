Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3789610BFD0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfK0Vpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbfK0UfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D387920866;
        Wed, 27 Nov 2019 20:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886913;
        bh=5XTVctNyzk6Pgxq8rjqvXvZW0PO39MZ7Adbv+jjPc3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRSLpa7RFoK3MJg2JlmOVtEQi5TQp3WqykReIPICRRtltmfPz/uiXxbEfZL4SBgIH
         yOZVDmfbpCYFjhIty2jbqCZeLPx+b8fZ5jqbB+0YD8Tfxz3JOtsRhFAF/3NLRh/lTk
         20h2hXoJDD21FkiefyMW1PwKKP5sB1dodH7lPrrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 024/132] synclink_gt(): fix compat_ioctl()
Date:   Wed, 27 Nov 2019 21:30:15 +0100
Message-Id: <20191127202920.953069607@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
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
index 6fc39fbfc2755..b5145e8bdf0a2 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1192,14 +1192,13 @@ static long slgt_compat_ioctl(struct tty_struct *tty,
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
@@ -1219,18 +1218,11 @@ static long slgt_compat_ioctl(struct tty_struct *tty,
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




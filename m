Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7D833B8AC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbhCOOEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhCOOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83DBB64F3D;
        Mon, 15 Mar 2021 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816823;
        bh=r9IaDPDk+ptV25I4aXmNB7R3lT/iUVsASqzBFjoj5+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3ZjI0trlH+JkdCO9Ek/Z6iLSh8Py7qiOMsgu4zXk9yBM6os04ioRoZCJKF+aKK/m
         wwhnY2LYDKqiCB/UJ/T3+y6z7H6wk8bLVwSz+qUQzUVnVvrONQRaQXlp7DZpTWQLZV
         IpFledLnIBOzHXShlI3oygSuD61zhuTG5p1LBHC8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ronald=20Tschal=C3=A4r?= <ronald@innovation.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 146/306] Input: applespi - dont wait for responses to commands indefinitely.
Date:   Mon, 15 Mar 2021 14:53:29 +0100
Message-Id: <20210315135512.578088858@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ronald Tschalär <ronald@innovation.ch>

[ Upstream commit 0ce1ac23149c6da939a5926c098c270c58c317a0 ]

The response to a command may never arrive or it may be corrupted (and
hence dropped) for some reason. While exceedingly rare, when it did
happen it blocked all further commands. One way to fix this was to
do a suspend/resume. However, recovering automatically seems like a
nicer option. Hence this puts a time limit (1 sec) on how long we're
willing to wait for a response, after which we assume it got lost.

Signed-off-by: Ronald Tschalär <ronald@innovation.ch>
Link: https://lore.kernel.org/r/20210217190718.11035-1-ronald@innovation.ch
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/applespi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/input/keyboard/applespi.c b/drivers/input/keyboard/applespi.c
index d22223154177..27e87c45edf2 100644
--- a/drivers/input/keyboard/applespi.c
+++ b/drivers/input/keyboard/applespi.c
@@ -48,6 +48,7 @@
 #include <linux/efi.h>
 #include <linux/input.h>
 #include <linux/input/mt.h>
+#include <linux/ktime.h>
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
@@ -409,7 +410,7 @@ struct applespi_data {
 	unsigned int			cmd_msg_cntr;
 	/* lock to protect the above parameters and flags below */
 	spinlock_t			cmd_msg_lock;
-	bool				cmd_msg_queued;
+	ktime_t				cmd_msg_queued;
 	enum applespi_evt_type		cmd_evt_type;
 
 	struct led_classdev		backlight_info;
@@ -729,7 +730,7 @@ static void applespi_msg_complete(struct applespi_data *applespi,
 		wake_up_all(&applespi->drain_complete);
 
 	if (is_write_msg) {
-		applespi->cmd_msg_queued = false;
+		applespi->cmd_msg_queued = 0;
 		applespi_send_cmd_msg(applespi);
 	}
 
@@ -771,8 +772,16 @@ static int applespi_send_cmd_msg(struct applespi_data *applespi)
 		return 0;
 
 	/* check whether send is in progress */
-	if (applespi->cmd_msg_queued)
-		return 0;
+	if (applespi->cmd_msg_queued) {
+		if (ktime_ms_delta(ktime_get(), applespi->cmd_msg_queued) < 1000)
+			return 0;
+
+		dev_warn(&applespi->spi->dev, "Command %d timed out\n",
+			 applespi->cmd_evt_type);
+
+		applespi->cmd_msg_queued = 0;
+		applespi->write_active = false;
+	}
 
 	/* set up packet */
 	memset(packet, 0, APPLESPI_PACKET_SIZE);
@@ -869,7 +878,7 @@ static int applespi_send_cmd_msg(struct applespi_data *applespi)
 		return sts;
 	}
 
-	applespi->cmd_msg_queued = true;
+	applespi->cmd_msg_queued = ktime_get_coarse();
 	applespi->write_active = true;
 
 	return 0;
@@ -1921,7 +1930,7 @@ static int __maybe_unused applespi_resume(struct device *dev)
 	applespi->drain = false;
 	applespi->have_cl_led_on = false;
 	applespi->have_bl_level = 0;
-	applespi->cmd_msg_queued = false;
+	applespi->cmd_msg_queued = 0;
 	applespi->read_active = false;
 	applespi->write_active = false;
 
-- 
2.30.1




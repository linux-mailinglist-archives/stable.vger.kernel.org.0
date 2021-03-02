Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0497332AF1D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhCCAPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350226AbhCBMC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:02:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3393B64F2E;
        Tue,  2 Mar 2021 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686174;
        bh=Q8QoCWn0zrvn2VEGKj/DLiIbYOnwej6fNhaDTCBlQwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki6S7dLt9rjqpamccIURmJmXwX4XIRZnZtAJTwkzaMZPIUCl0N0Vp0pXxbeky6m6q
         lzNpwKoH/hjQmTzmDCGJz75IugecxcBSUAXsfjUF78kzhnt+iOtOLZoMHbLVecdHqL
         Wou2NgPYN6pXyByCpC/iggiBxxr86ypijueoRoyA6LCGpXKLDXFNJyufMHu22HYHbi
         zCiGr0a50VJLNt6+o/r7eBqGqCK1DsV0jVIIwyWE0X+3nI8YeZYxE9ErbepWo/X+8l
         eHWPEgKXSHGs6WLijK2kzF4rfDxvS825+MUCwQoM+h3RWi+YjWVwpc88py8gdDGHDK
         ClzqJMbN28UVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ronald=20Tschal=C3=A4r?= <ronald@innovation.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 30/52] Input: applespi - don't wait for responses to commands indefinitely.
Date:   Tue,  2 Mar 2021 06:55:11 -0500
Message-Id: <20210302115534.61800-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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


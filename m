Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF2633B93B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhCOOFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhCOOBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C21EE64F3F;
        Mon, 15 Mar 2021 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816850;
        bh=kjxumV4br8Djx7CcdbieHo+oWJwoGFQOrcc3ul1kcnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9nbfZdW9d/oBlcsCXC2qDb7MDGXnqvGM9RBbm0xh82NigopCqlposoBDgVCGibmk
         rsknda1xCLKQGIJad+nXwDwyb2d4u9S4sw/84NLNlwMnSlJVpdgVDaPrjjV1fUvn/0
         tVEmbeOphNwQb+pcj9IzEW+D/cPz4hANDFM5QcpU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ronald=20Tschal=C3=A4r?= <ronald@innovation.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/290] Input: applespi - dont wait for responses to commands indefinitely.
Date:   Mon, 15 Mar 2021 14:54:03 +0100
Message-Id: <20210315135546.987574721@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
index 14362ebab9a9..0b46bc014cde 100644
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
@@ -400,7 +401,7 @@ struct applespi_data {
 	unsigned int			cmd_msg_cntr;
 	/* lock to protect the above parameters and flags below */
 	spinlock_t			cmd_msg_lock;
-	bool				cmd_msg_queued;
+	ktime_t				cmd_msg_queued;
 	enum applespi_evt_type		cmd_evt_type;
 
 	struct led_classdev		backlight_info;
@@ -716,7 +717,7 @@ static void applespi_msg_complete(struct applespi_data *applespi,
 		wake_up_all(&applespi->drain_complete);
 
 	if (is_write_msg) {
-		applespi->cmd_msg_queued = false;
+		applespi->cmd_msg_queued = 0;
 		applespi_send_cmd_msg(applespi);
 	}
 
@@ -758,8 +759,16 @@ static int applespi_send_cmd_msg(struct applespi_data *applespi)
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
@@ -856,7 +865,7 @@ static int applespi_send_cmd_msg(struct applespi_data *applespi)
 		return sts;
 	}
 
-	applespi->cmd_msg_queued = true;
+	applespi->cmd_msg_queued = ktime_get_coarse();
 	applespi->write_active = true;
 
 	return 0;
@@ -1908,7 +1917,7 @@ static int __maybe_unused applespi_resume(struct device *dev)
 	applespi->drain = false;
 	applespi->have_cl_led_on = false;
 	applespi->have_bl_level = 0;
-	applespi->cmd_msg_queued = false;
+	applespi->cmd_msg_queued = 0;
 	applespi->read_active = false;
 	applespi->write_active = false;
 
-- 
2.30.1




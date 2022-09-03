Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2075AC0B4
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiICSZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbiICSZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:25:50 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC2F41D3A
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:25:49 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m7so7668168lfq.8
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4o+b765lLTQxjm9m03kL0SxZJpjY5eHHf0HvxaVAILc=;
        b=XPBNipfdVcqyL5ozFTg/VutdYRynkNRUfLHHIWPfFEjgkWhF7PS+x7lF0O6VDkHjze
         uQLySsDIlU5FXvybsaKsscHtb7USkGLnWeQvCxQJ+qLDS5pV0R0F9a3OJo9kaHBAWJeI
         sL/UVDNd9NnDnQgxEGLFO1tc2DM/9pjCyxyW2h/EoW6/dOqSE/zWA+teRwJpaKwDmx5D
         MM4R+L0mdm3+i4T7jD9HMTjjWkJPxsF23xqUnVmMXrgPxFwmchBg6ZMm9dvgNqqJx2gI
         Wpv4ZaJAjCTfhokjmakjAnAX5qphZWBmXYxQtB97ICwS/TmU1A95baBMshZbyyArRBQ/
         N+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4o+b765lLTQxjm9m03kL0SxZJpjY5eHHf0HvxaVAILc=;
        b=R9Qzr/698tX99rF1jLOCV36Us9Rc8QUNpvxGkWIAo21vgq6esYZu2FIgz/CfrWDycr
         B81F0b4iD8MbfLwlRr3Bqgh4JcWNQRGXRUjVIe651wxiIlBSOzx/DDpz9J4ys2CD+2qP
         +/LHjIaED4x3QSPK6gSJ9CHst2Xi0aPQlaOwkqVAfG2zC93Uuh/FBx0e575rX0EE5pq1
         WU/E48LOwQmv5M6S8OkPiDLdNiOvGMA/29Rh8sFR84TlwE2xqPwMo+xiqI9UfXtC+JHw
         WaT9GahPNEyxTd4kVoqQN+Ehj2SnpjmCeDk+Pya+W9G1whl43GnwwDGjt6pPClCkxQWU
         lZCw==
X-Gm-Message-State: ACgBeo28dIydAdIZksOOcEBz/UaXtcHVLroFScj1svSxvO/q8AfAJvAD
        CcWKz1b70mKMBatQLIPKvroD3Q==
X-Google-Smtp-Source: AA6agR7CbUOK3doeyNN38hPzt1KUpn5eIUXliNbvrNbou91QLjL8roZv4hQ5Gy07sexdlU5j8yMqwA==
X-Received: by 2002:a05:6512:32c6:b0:494:99fe:49b9 with SMTP id f6-20020a05651232c600b0049499fe49b9mr4236602lfg.410.1662229548513;
        Sat, 03 Sep 2022 11:25:48 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u18-20020ac24c32000000b00492f6ddba59sm658330lfq.75.2022.09.03.11.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:25:47 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 12/15] can: kvaser_usb_leaf: Ignore stale bus-off after start
Date:   Sat,  3 Sep 2022 20:25:56 +0200
Message-Id: <20220903182559.189-12-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220903182559.189-1-extja@kvaser.com>
References: <20220903182559.189-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

With 0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778 it was observed
that if the device was bus-off when stopped, at next start (either via
interface down/up or manual bus-off restart) the initial
CMD_CHIP_STATE_EVENT received just after CMD_START_CHIP_REPLY will have
the M16C_STATE_BUS_OFF bit still set, causing the interface to
immediately go bus-off again.

The bit seems to internally clear quickly afterwards but we do not get
another CMD_CHIP_STATE_EVENT.

Fix the issue by ignoring any initial bus-off state until we see at
least one bus-on state. Also, poll the state periodically until that
occurs.

It is possible we lose one actual immediately occurring bus-off event
here in which case the HW will auto-recover and we see the recovery
event. We will then catch the next bus-off event, if any.

This issue did not reproduce with 0bfd:0017 Kvaser Memorator
Professional HS/HS FW 2.0.50.

Cc: stable@vger.kernel.org
Fixes: 71873a9b38d1 ("can: kvaser_usb: Add support for more Kvaser Leaf v2 devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
Changes in v4:
 - No changes

Changes in v3:
 - Rebased on 1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
 - Add stable to CC
 - Add S-o-b

Changes in v2:
  - Rebased on b3b6df2c56d8 ("can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits")

 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 4f9c76f4d0da..f8a12a285050 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -427,6 +427,9 @@ struct kvaser_usb_net_leaf_priv {
 	struct kvaser_usb_net_priv *net;
 
 	struct delayed_work chip_state_req_work;
+
+	/* started but not reported as bus-on yet */
+	bool joining_bus;
 };
 
 static const struct can_bittiming_const kvaser_usb_leaf_m16c_bittiming_const = {
@@ -966,6 +969,7 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 					const struct kvaser_usb_err_summary *es,
 					struct can_frame *cf)
 {
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	struct kvaser_usb *dev = priv->dev;
 	struct net_device_stats *stats = &priv->netdev->stats;
 	enum can_state cur_state, new_state, tx_state, rx_state;
@@ -990,6 +994,22 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 		new_state = CAN_STATE_ERROR_ACTIVE;
 	}
 
+	/* 0bfd:0124 FW 4.18.778 was observed to send the initial
+	 * CMD_CHIP_STATE_EVENT after CMD_START_CHIP with M16C_STATE_BUS_OFF
+	 * bit set if the channel was bus-off when it was last stopped (even
+	 * across chip resets). This bit will clear shortly afterwards, without
+	 * triggering a second unsolicited chip state event.
+	 * Ignore this initial bus-off.
+	 */
+	if (leaf->joining_bus) {
+		if (new_state == CAN_STATE_BUS_OFF) {
+			netdev_dbg(priv->netdev, "ignoring bus-off during startup");
+			new_state = cur_state;
+		} else {
+			leaf->joining_bus = false;
+		}
+	}
+
 	if (new_state != cur_state) {
 		tx_state = (es->txerr >= es->rxerr) ? new_state : 0;
 		rx_state = (es->txerr <= es->rxerr) ? new_state : 0;
@@ -1065,9 +1085,12 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 
 	/* If there are errors, request status updates periodically as we do
 	 * not get automatic notifications of improved state.
+	 * Also request updates if we saw a stale BUS_OFF during startup
+	 * (joining_bus).
 	 */
 	if (new_state < CAN_STATE_BUS_OFF &&
-	    (es->rxerr || es->txerr || new_state == CAN_STATE_ERROR_PASSIVE))
+	    (es->rxerr || es->txerr || new_state == CAN_STATE_ERROR_PASSIVE ||
+	     leaf->joining_bus))
 		schedule_delayed_work(&leaf->chip_state_req_work,
 				      msecs_to_jiffies(500));
 
@@ -1587,8 +1610,11 @@ static int kvaser_usb_leaf_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 
 static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 {
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	int err;
 
+	leaf->joining_bus = true;
+
 	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
@@ -1719,12 +1745,15 @@ static int kvaser_usb_leaf_set_mode(struct net_device *netdev,
 				    enum can_mode mode)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	int err;
 
 	switch (mode) {
 	case CAN_MODE_START:
 		kvaser_usb_unlink_tx_urbs(priv);
 
+		leaf->joining_bus = true;
+
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;
-- 
2.37.3


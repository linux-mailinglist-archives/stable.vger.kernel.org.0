Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D9C5A96E4
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiIAM3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiIAM3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:33 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3D912DA09
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:32 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bq23so24180190lfb.7
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0SFX/Ww/fXP+l/kMc3DpUYXZ6gNv2gqXykQIoYHOUJQ=;
        b=b12rNpkuIRxAFZVPm3uoqRC14I37LBwynsCE2Dm1Bt2XuKvcTpTnBRFFojCSI82B/o
         gfexDgKeggQ0W5LaczoznVkej43jEywNbTpnc1Mxf88R6ChcRcHH/0uz26rTTG+Ested
         3COdfYBy6/R9GTRHXQEEycXlvYhcZBI2de5ymIBMAtjHuGAt/9NXibdZkG2zV0GOwCd0
         VeQuJ4o+x1Kphyw0uC8mHwUChBnx0y8a7vh9Xqz6aJ+wAsM0Maw2cQVG7bdEY27eKm63
         wFOpAe6syezjdUzjgWx789OxepgjNaaWWnvPnmWmBGfCJxE6m0g0m8Yy+orbycPHAKEj
         RbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0SFX/Ww/fXP+l/kMc3DpUYXZ6gNv2gqXykQIoYHOUJQ=;
        b=jQ+wQ9xu8SUWJWLRixzsfIDyauqBm81Hy69NSH4+x5FKpsxgbXpwo6P+MTaTcz0CE/
         I1I5oENXK7gwxEcP/fBCw4Ma0bg8r3ZOlvpBmraNHS2tv5KHGvlVvjV76fvoQdSmd+ZV
         9zKayEaVT0gcpMRRqkDp97voQ3nwV4LYM4SvTwx8Fwy9vALi64pU05rf/WOR1UOyxXJU
         lgtayj6wYkTdG1kEPEA55dVZzgCR2cpt+DzT1RXmsJahk1kZuwH33B5ZjFiIlhPtSelG
         TXOEalK2m8KlWb2madEJBGVuPssJ71X0MhzE6Sxs4O3yKt8M9SL2rl/S/A4oLZgWJt4p
         4MDQ==
X-Gm-Message-State: ACgBeo2LtabjWzod+waYsvjhMo2zWUinEefsJ3mkaF2KcmvbDOqtobvv
        ZrgM4EQkdyepm7BHh69s+vy11A==
X-Google-Smtp-Source: AA6agR4rO35JzgWNGM+kNDBgdJA5XQY7QRKsrbiGlgrSRlhlO3UHj1RlGy+siSBErVwC7mbagB8fJw==
X-Received: by 2002:a05:6512:22c7:b0:48b:38f3:79a8 with SMTP id g7-20020a05651222c700b0048b38f379a8mr11137421lfu.530.1662035308964;
        Thu, 01 Sep 2022 05:28:28 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:28 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 10/15] can: kvaser_usb_leaf: Fix improved state not being reported
Date:   Thu,  1 Sep 2022 14:27:24 +0200
Message-Id: <20220901122729.271-11-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220901122729.271-1-extja@kvaser.com>
References: <20220901122729.271-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

The tested 0bfd:0017 Kvaser Memorator Professional HS/HS FW 2.0.50 and
0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778 do not seem to send
any unsolicited events when error counters decrease or when the device
transitions from ERROR_PASSIVE to ERROR_ACTIVE (or WARNING).

This causes the interface to e.g. indefinitely stay in the ERROR_PASSIVE
state.

Fix that by asking for chip state (inc. counters) event every 0.5 secs
when error counters are non-zero.

Since there are non-error-counter devices, also always poll in
ERROR_PASSIVE even if the counters show zero.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
Changes in v3:
 - Rebased on 1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
 - Add stable to CC
 - Add S-o-b

Changes in v2:
  - Rebased on b3b6df2c56d8 ("can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits")
  - Rephrase commit message regarding non-error-counter devices.

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  7 +++
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 19 +++++-
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 58 +++++++++++++++++++
 3 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index f6c0938027ec..d9c5dd5da908 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -104,6 +104,9 @@ struct kvaser_usb_net_priv {
 	struct can_priv can;
 	struct can_berr_counter bec;
 
+	/* subdriver-specific data */
+	void *sub_priv;
+
 	struct kvaser_usb *dev;
 	struct net_device *netdev;
 	int channel;
@@ -125,6 +128,8 @@ struct kvaser_usb_net_priv {
  *
  * @dev_setup_endpoints:	setup USB in and out endpoints
  * @dev_init_card:		initialize card
+ * @dev_init_channel:		initialize channel
+ * @dev_remove_channel:		uninitialize channel
  * @dev_get_software_info:	get software info
  * @dev_get_software_details:	get software details
  * @dev_get_card_info:		get card info
@@ -146,6 +151,8 @@ struct kvaser_usb_dev_ops {
 				    struct can_berr_counter *bec);
 	int (*dev_setup_endpoints)(struct kvaser_usb *dev);
 	int (*dev_init_card)(struct kvaser_usb *dev);
+	int (*dev_init_channel)(struct kvaser_usb_net_priv *priv);
+	void (*dev_remove_channel)(struct kvaser_usb_net_priv *priv);
 	int (*dev_get_software_info)(struct kvaser_usb *dev);
 	int (*dev_get_software_details)(struct kvaser_usb *dev);
 	int (*dev_get_card_info)(struct kvaser_usb *dev);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index e91648ed7386..19df05887166 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -684,6 +684,7 @@ static const struct ethtool_ops kvaser_usb_ethtool_ops_hwts = {
 
 static void kvaser_usb_remove_interfaces(struct kvaser_usb *dev)
 {
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	int i;
 
 	for (i = 0; i < dev->nchannels; i++) {
@@ -699,6 +700,9 @@ static void kvaser_usb_remove_interfaces(struct kvaser_usb *dev)
 		if (!dev->nets[i])
 			continue;
 
+		if (ops->dev_remove_channel)
+			ops->dev_remove_channel(dev->nets[i]);
+
 		free_candev(dev->nets[i]->netdev);
 	}
 }
@@ -772,17 +776,26 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 
 	dev->nets[channel] = priv;
 
+	if (ops->dev_init_channel) {
+		err = ops->dev_init_channel(priv);
+		if (err)
+			goto err;
+	}
+
 	err = register_candev(netdev);
 	if (err) {
 		dev_err(&dev->intf->dev, "Failed to register CAN device\n");
-		free_candev(netdev);
-		dev->nets[channel] = NULL;
-		return err;
+		goto err;
 	}
 
 	netdev_dbg(netdev, "device registered\n");
 
 	return 0;
+
+err:
+	free_candev(netdev);
+	dev->nets[channel] = NULL;
+	return err;
 }
 
 static int kvaser_usb_probe(struct usb_interface *intf,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index a6a26085bc15..993fcc19637d 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/units.h>
 #include <linux/usb.h>
+#include <linux/workqueue.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -56,6 +57,7 @@
 #define CMD_RX_EXT_MESSAGE		14
 #define CMD_TX_EXT_MESSAGE		15
 #define CMD_SET_BUS_PARAMS		16
+#define CMD_GET_CHIP_STATE		19
 #define CMD_CHIP_STATE_EVENT		20
 #define CMD_SET_CTRL_MODE		21
 #define CMD_RESET_CHIP			24
@@ -421,6 +423,12 @@ struct kvaser_usb_err_summary {
 	};
 };
 
+struct kvaser_usb_net_leaf_priv {
+	struct kvaser_usb_net_priv *net;
+
+	struct delayed_work chip_state_req_work;
+};
+
 static const struct can_bittiming_const kvaser_usb_leaf_m16c_bittiming_const = {
 	.name = "kvaser_usb_ucii",
 	.tseg1_min = 4,
@@ -943,6 +951,16 @@ static int kvaser_usb_leaf_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 	return err;
 }
 
+static void kvaser_usb_leaf_chip_state_req_work(struct work_struct *work)
+{
+	struct kvaser_usb_net_leaf_priv *leaf =
+		container_of(work, struct kvaser_usb_net_leaf_priv,
+			     chip_state_req_work.work);
+	struct kvaser_usb_net_priv *priv = leaf->net;
+
+	kvaser_usb_leaf_simple_cmd_async(priv, CMD_GET_CHIP_STATE);
+}
+
 static void
 kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 					const struct kvaser_usb_err_summary *es,
@@ -1014,6 +1032,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 	struct sk_buff *skb;
 	struct net_device_stats *stats;
 	struct kvaser_usb_net_priv *priv;
+	struct kvaser_usb_net_leaf_priv *leaf;
 	enum can_state old_state, new_state;
 
 	if (es->channel >= dev->nchannels) {
@@ -1023,6 +1042,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 	}
 
 	priv = dev->nets[es->channel];
+	leaf = priv->sub_priv;
 	stats = &priv->netdev->stats;
 
 	/* Update all of the CAN interface's state and error counters before
@@ -1039,6 +1059,14 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 	kvaser_usb_leaf_rx_error_update_can_state(priv, es, &tmp_cf);
 	new_state = priv->can.state;
 
+	/* If there are errors, request status updates periodically as we do
+	 * not get automatic notifications of improved state.
+	 */
+	if (new_state < CAN_STATE_BUS_OFF &&
+	    (es->rxerr || es->txerr || new_state == CAN_STATE_ERROR_PASSIVE))
+		schedule_delayed_work(&leaf->chip_state_req_work,
+				      msecs_to_jiffies(500));
+
 	skb = alloc_can_err_skb(priv->netdev, &cf);
 	if (!skb) {
 		stats->rx_dropped++;
@@ -1573,10 +1601,13 @@ static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 
 static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
 {
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
 	int err;
 
 	reinit_completion(&priv->stop_comp);
 
+	cancel_delayed_work(&leaf->chip_state_req_work);
+
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);
 	if (err)
@@ -1623,6 +1654,31 @@ static int kvaser_usb_leaf_init_card(struct kvaser_usb *dev)
 	return 0;
 }
 
+static int kvaser_usb_leaf_init_channel(struct kvaser_usb_net_priv *priv)
+{
+	struct kvaser_usb_net_leaf_priv *leaf;
+
+	leaf = devm_kzalloc(&priv->dev->intf->dev, sizeof(*leaf), GFP_KERNEL);
+	if (!leaf)
+		return -ENOMEM;
+
+	leaf->net = priv;
+	INIT_DELAYED_WORK(&leaf->chip_state_req_work,
+			  kvaser_usb_leaf_chip_state_req_work);
+
+	priv->sub_priv = leaf;
+
+	return 0;
+}
+
+static void kvaser_usb_leaf_remove_channel(struct kvaser_usb_net_priv *priv)
+{
+	struct kvaser_usb_net_leaf_priv *leaf = priv->sub_priv;
+
+	if (leaf)
+		cancel_delayed_work_sync(&leaf->chip_state_req_work);
+}
+
 static int kvaser_usb_leaf_set_bittiming(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
@@ -1720,6 +1776,8 @@ const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops = {
 	.dev_get_berr_counter = kvaser_usb_leaf_get_berr_counter,
 	.dev_setup_endpoints = kvaser_usb_leaf_setup_endpoints,
 	.dev_init_card = kvaser_usb_leaf_init_card,
+	.dev_init_channel = kvaser_usb_leaf_init_channel,
+	.dev_remove_channel = kvaser_usb_leaf_remove_channel,
 	.dev_get_software_info = kvaser_usb_leaf_get_software_info,
 	.dev_get_software_details = NULL,
 	.dev_get_card_info = kvaser_usb_leaf_get_card_info,
-- 
2.37.3


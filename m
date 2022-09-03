Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF95AC0B9
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiICSZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiICSZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:25:53 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F294360D
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:25:51 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g7so7629306lfe.11
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=I2V9wFdSoveXAEHA/UuDLjvKIBLh+/872Z0Q+Z2O/V4=;
        b=P8ZZUPjhaB5OJx/kdXlDPoPXH3qTCR87uBvtuIe/xhukWUC5PBMrBZZqXAflHOz8Zc
         xJmzgUIQ6BDHEgMkXdswDm8ayzei3hdltWeD7aS1W7w3AP5/MQjQsI2l6jI6An4Bi9bv
         55TVDe4GlA2h2WYIs99eaDd+KGue1gzRVXJeQl1EcSyWzV/yQrAgiNMSDWSB1CbLBVEa
         01DDOCJ3hShE1zHTZ//r/+MLkXr4MnUvTd0BBuOVHw4QonXiP0hDzCWY5mKulrMjBCWQ
         Lh9y2vvM7+pxP0nGVNnf/6Ti+UksQr488MEHlFOhaWKxigiQ+bcu9W4/uAnz/l8vpAZf
         /BXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=I2V9wFdSoveXAEHA/UuDLjvKIBLh+/872Z0Q+Z2O/V4=;
        b=OCng9KKtoH6KLKOx5lCWxIfScMVxf1r8UjzcSxg1cbSUlIZAZNomd/sqlO7BF7tRJs
         WkMfdOlqPPRlWKuSsVlJw9d5jYtpSP14b+x8eZYsAwiWiN+vivArdxk5dDelPrmd/WMU
         IkDXcNtOe+pKHm7JJzcB5PsR7Bw636SKeUmCSIwJuK9PtnVbOWRq+xoA5IedYK5VxBKF
         4XZK2VoAvfKub+yu888SVgykTYhWVLXEETRtKljhCCNwzeYzicpGC5auQepcxp3RGS/N
         Z/1IXORLZWytGW42VQbarrlY3UoGeQtTYjX306Ez/brcvnkjfKOcQQ1YGW4k9DpDuQX4
         mQXA==
X-Gm-Message-State: ACgBeo1thRMYJu3TNDpgauxZbJaqAZVytB0oOFaTw032SyD2M0sKORAE
        vrQJEH9WGoQV9OGSHX6rOXn4tA==
X-Google-Smtp-Source: AA6agR5fykbZ9tP+K1J/Q9BYXIbGYip7SVSF/W6AHd13sVR453i54dcT9x0QuZcfSc/MTTzaYBtgVw==
X-Received: by 2002:a05:6512:4026:b0:494:5ea4:18e5 with SMTP id br38-20020a056512402600b004945ea418e5mr10907053lfb.579.1662229550280;
        Sat, 03 Sep 2022 11:25:50 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u18-20020ac24c32000000b00492f6ddba59sm658330lfq.75.2022.09.03.11.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:25:49 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 14/15] can: kvaser_usb: Add struct kvaser_usb_busparams
Date:   Sat,  3 Sep 2022 20:25:58 +0200
Message-Id: <20220903182559.189-14-extja@kvaser.com>
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

Add struct kvaser_usb_busparams containing the busparameters used in
CMD_{SET,GET}_BUSPARAMS* commands.

Cc: stable@vger.kernel.org
Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
Changes in v4:
 - No changes

Changes in v3:
 - Rebased on 1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
 - Add stable to CC
 - Add Tested-by Anssi Hannula

Changes in v2:
  - New in v2.

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  8 +++++
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 32 +++++++------------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 18 ++++-------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index d9c5dd5da908..040885c7d0c4 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -76,6 +76,14 @@ struct kvaser_usb_tx_urb_context {
 	u32 echo_index;
 };
 
+struct kvaser_usb_busparams {
+	__le32 bitrate;
+	u8 tseg1;
+	u8 tseg2;
+	u8 sjw;
+	u8 nsamples;
+};
+
 struct kvaser_usb {
 	struct usb_device *udev;
 	struct usb_interface *intf;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 3abfaa77e893..b8ae29872217 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -196,17 +196,9 @@ struct kvaser_cmd_chip_state_event {
 #define KVASER_USB_HYDRA_BUS_MODE_CANFD_ISO	0x01
 #define KVASER_USB_HYDRA_BUS_MODE_NONISO	0x02
 struct kvaser_cmd_set_busparams {
-	__le32 bitrate;
-	u8 tseg1;
-	u8 tseg2;
-	u8 sjw;
-	u8 nsamples;
+	struct kvaser_usb_busparams busparams_arb;
 	u8 reserved0[4];
-	__le32 bitrate_d;
-	u8 tseg1_d;
-	u8 tseg2_d;
-	u8 sjw_d;
-	u8 nsamples_d;
+	struct kvaser_usb_busparams busparams_data;
 	u8 canfd_mode;
 	u8 reserved1[7];
 } __packed;
@@ -1538,11 +1530,11 @@ static int kvaser_usb_hydra_set_bittiming(struct net_device *netdev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_REQ;
-	cmd->set_busparams_req.bitrate = cpu_to_le32(bt->bitrate);
-	cmd->set_busparams_req.sjw = (u8)sjw;
-	cmd->set_busparams_req.tseg1 = (u8)tseg1;
-	cmd->set_busparams_req.tseg2 = (u8)tseg2;
-	cmd->set_busparams_req.nsamples = 1;
+	cmd->set_busparams_req.busparams_arb.bitrate = cpu_to_le32(bt->bitrate);
+	cmd->set_busparams_req.busparams_arb.sjw = (u8)sjw;
+	cmd->set_busparams_req.busparams_arb.tseg1 = (u8)tseg1;
+	cmd->set_busparams_req.busparams_arb.tseg2 = (u8)tseg2;
+	cmd->set_busparams_req.busparams_arb.nsamples = 1;
 
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
@@ -1572,11 +1564,11 @@ static int kvaser_usb_hydra_set_data_bittiming(struct net_device *netdev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_FD_REQ;
-	cmd->set_busparams_req.bitrate_d = cpu_to_le32(dbt->bitrate);
-	cmd->set_busparams_req.sjw_d = (u8)sjw;
-	cmd->set_busparams_req.tseg1_d = (u8)tseg1;
-	cmd->set_busparams_req.tseg2_d = (u8)tseg2;
-	cmd->set_busparams_req.nsamples_d = 1;
+	cmd->set_busparams_req.busparams_data.bitrate = cpu_to_le32(dbt->bitrate);
+	cmd->set_busparams_req.busparams_data.sjw = (u8)sjw;
+	cmd->set_busparams_req.busparams_data.tseg1 = (u8)tseg1;
+	cmd->set_busparams_req.busparams_data.tseg2 = (u8)tseg2;
+	cmd->set_busparams_req.busparams_data.nsamples = 1;
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 		if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 3e31a9ebea88..bb59ee01a093 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -164,11 +164,7 @@ struct usbcan_cmd_softinfo {
 struct kvaser_cmd_busparams {
 	u8 tid;
 	u8 channel;
-	__le32 bitrate;
-	u8 tseg1;
-	u8 tseg2;
-	u8 sjw;
-	u8 no_samp;
+	struct kvaser_usb_busparams busparams;
 } __packed;
 
 struct kvaser_cmd_tx_can {
@@ -1725,15 +1721,15 @@ static int kvaser_usb_leaf_set_bittiming(struct net_device *netdev)
 	cmd->len = CMD_HEADER_LEN + sizeof(struct kvaser_cmd_busparams);
 	cmd->u.busparams.channel = priv->channel;
 	cmd->u.busparams.tid = 0xff;
-	cmd->u.busparams.bitrate = cpu_to_le32(bt->bitrate);
-	cmd->u.busparams.sjw = bt->sjw;
-	cmd->u.busparams.tseg1 = bt->prop_seg + bt->phase_seg1;
-	cmd->u.busparams.tseg2 = bt->phase_seg2;
+	cmd->u.busparams.busparams.bitrate = cpu_to_le32(bt->bitrate);
+	cmd->u.busparams.busparams.sjw = bt->sjw;
+	cmd->u.busparams.busparams.tseg1 = bt->prop_seg + bt->phase_seg1;
+	cmd->u.busparams.busparams.tseg2 = bt->phase_seg2;
 
 	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		cmd->u.busparams.no_samp = 3;
+		cmd->u.busparams.busparams.nsamples = 3;
 	else
-		cmd->u.busparams.no_samp = 1;
+		cmd->u.busparams.busparams.nsamples = 1;
 
 	rc = kvaser_usb_send_cmd(dev, cmd, cmd->len);
 
-- 
2.37.3


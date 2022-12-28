Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36939657C56
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiL1Pbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiL1Pb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:31:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5AE15FD5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E445C6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03360C433EF;
        Wed, 28 Dec 2022 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241485;
        bh=AsM3FlyknExZPP2FEIGqqcKR8SEAUFg9TzbKq2niAVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrvGey5TlMgdKddE9RISDhuP8CRsUlPryTK88AYkDwVQ3EUU2uI3A5bKbx/GROMUZ
         UhmoRXXCyZDNAOGS6ipPFivHCjQxpxojG9fOrh5EdwJfd+CWq4oSgV7Rz8gLWU0hvZ
         uElwewaapJqaVWt6hvRWG+xM2EAnbFaIf5sEqNbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0252/1146] can: kvaser_usb: Add struct kvaser_usb_busparams
Date:   Wed, 28 Dec 2022 15:29:51 +0100
Message-Id: <20221228144336.983210121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit 00e5786177649c1e3110f9454fdd34e336597265 ]

Add struct kvaser_usb_busparams containing the busparameters used in
CMD_{SET,GET}_BUSPARAMS* commands.

Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-11-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  8 +++++
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 32 +++++++------------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 18 ++++-------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index d9c5dd5da908..778b61c90c2b 100644
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
+} __packed;
+
 struct kvaser_usb {
 	struct usb_device *udev;
 	struct usb_interface *intf;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 66f672ea631b..3319af181e0e 100644
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
index fa940be4e1b0..996d58b97af1 100644
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
@@ -1699,15 +1695,15 @@ static int kvaser_usb_leaf_set_bittiming(struct net_device *netdev)
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
2.35.1




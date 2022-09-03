Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695505AC0A0
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiICSZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiICSZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:25:32 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4233B3DF30
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:25:31 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z25so7713274lfr.2
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=0UfrXsya2qLRV7IjXa7b7nre57GV5V4bFw64zEERfnY=;
        b=ZWwPqxM08ZqzGIu/76z5cdObPeTZSPxWDfA4DY0slpzMfiYeJ6j9QHhX6C4xIfp0vY
         0VcIMiZIMPDvVWar0jj5vSPzvSpGe2LscbwkuccNaJ9HpjXs6XnpyaeNJk1Jnf7fSRcu
         Re8NGFbmU1A+aEtwqLYzovmnvt15dZ1ABVpLmgvQPY/4z5XRyTeYMmXflpc6+FA3BwIH
         OwqQk1vTmYR+onVNBMOEjfmBeX2gQahtPehs/kFODMyCQTH0U64x5R5lYy8eKPLBrMhE
         +Ycb1VbRYrwmexCNvJO3bTISXcld1uObpUDGUevGVCSaYrLWW/NUg7egKYGtWi77eaER
         ZeuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=0UfrXsya2qLRV7IjXa7b7nre57GV5V4bFw64zEERfnY=;
        b=sdoK7o6JqwJL4Z4k/AmMFS3KENc/NPsaWs40Hp+Z6xd1bosAAquIgOI4oEtrmsyYLQ
         qXvcKvfWI1b4OO1gONKTCDvT7QKEt4DFW6zeVsNQyIyvxMuF/9PfusAiTZFOVUGiElK0
         GEcqDuP+28jv+P9i3/5YcrE5sDn1p3cbgUYb4Zk9mPeArFdQP1al0gnBFUi/z1x4xpVd
         Br/0skascGENQ3iovjs9iuE/fS2fAQVwo7sBeALC9A0Kt4/EoGNRL4aEN3DtycgOjv+t
         5qtDKhkqnTc9p4uuV2ilTmno0j1iEccQEftQ33PvaaLrtAy0ejDV9gWbfXqfBmsWI/Dk
         Au7A==
X-Gm-Message-State: ACgBeo23BM1OZKhh4SsZGOuEioAnscBUriV8AFH8DZNGudPxCA57sN5J
        d5mC9HaOyCtiyQDPx1ZaQyZjMQ==
X-Google-Smtp-Source: AA6agR56gVOgT//mjx27J0BCUYKNo4HUezl+iiW2v/UUPq5gTAkdDqNeKJdJ7KfiwnjH4FHk/wco5A==
X-Received: by 2002:a05:6512:23a1:b0:48a:fde8:ce8c with SMTP id c33-20020a05651223a100b0048afde8ce8cmr14792807lfv.393.1662229529061;
        Sat, 03 Sep 2022 11:25:29 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u18-20020ac24c32000000b00492f6ddba59sm658330lfq.75.2022.09.03.11.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:25:28 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 01/15] can: kvaser_usb_leaf: Fix overread with an invalid command
Date:   Sat,  3 Sep 2022 20:25:45 +0200
Message-Id: <20220903182559.189-1-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
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

For command events read from the device,
kvaser_usb_leaf_read_bulk_callback() verifies that cmd->len does not
exceed the size of the received data, but the actual kvaser_cmd handlers
will happily read any kvaser_cmd fields without checking for cmd->len.

This can cause an overread if the last cmd in the buffer is shorter than
expected for the command type (with cmd->len showing the actual short
size).

Maximum overread seems to be 22 bytes (CMD_LEAF_LOG_MESSAGE), some of
which are delivered to userspace as-is.

Fix that by verifying the length of command before handling it.

This issue can only occur after RX URBs have been set up, i.e. the
interface has been opened at least once.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
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

 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 07f687f29b34..8e11cda85624 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -310,6 +310,38 @@ struct kvaser_cmd {
 	} u;
 } __packed;
 
+#define CMD_SIZE_ANY 0xff
+#define kvaser_fsize(field) sizeof_field(struct kvaser_cmd, field)
+
+static const u8 kvaser_usb_leaf_cmd_sizes_leaf[] = {
+	[CMD_START_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_STOP_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_GET_CARD_INFO_REPLY]	= kvaser_fsize(u.cardinfo),
+	[CMD_TX_ACKNOWLEDGE]		= kvaser_fsize(u.tx_acknowledge_header),
+	[CMD_GET_SOFTWARE_INFO_REPLY]	= kvaser_fsize(u.leaf.softinfo),
+	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
+	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
+	[CMD_LEAF_LOG_MESSAGE]		= kvaser_fsize(u.leaf.log_message),
+	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.leaf.chip_state_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.error_event),
+	/* ignored events: */
+	[CMD_FLUSH_QUEUE_REPLY]		= CMD_SIZE_ANY,
+};
+
+static const u8 kvaser_usb_leaf_cmd_sizes_usbcan[] = {
+	[CMD_START_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_STOP_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_GET_CARD_INFO_REPLY]	= kvaser_fsize(u.cardinfo),
+	[CMD_TX_ACKNOWLEDGE]		= kvaser_fsize(u.tx_acknowledge_header),
+	[CMD_GET_SOFTWARE_INFO_REPLY]	= kvaser_fsize(u.usbcan.softinfo),
+	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
+	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
+	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.usbcan.chip_state_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.error_event),
+	/* ignored events: */
+	[CMD_USBCAN_CLOCK_OVERFLOW_EVENT] = CMD_SIZE_ANY,
+};
+
 /* Summary of a kvaser error event, for a unified Leaf/Usbcan error
  * handling. Some discrepancies between the two families exist:
  *
@@ -397,6 +429,43 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
+static int kvaser_usb_leaf_verify_size(const struct kvaser_usb *dev,
+				       const struct kvaser_cmd *cmd)
+{
+	/* buffer size >= cmd->len ensured by caller */
+	u8 min_size = 0;
+
+	switch (dev->driver_info->family) {
+	case KVASER_LEAF:
+		if (cmd->id < ARRAY_SIZE(kvaser_usb_leaf_cmd_sizes_leaf))
+			min_size = kvaser_usb_leaf_cmd_sizes_leaf[cmd->id];
+		break;
+	case KVASER_USBCAN:
+		if (cmd->id < ARRAY_SIZE(kvaser_usb_leaf_cmd_sizes_usbcan))
+			min_size = kvaser_usb_leaf_cmd_sizes_usbcan[cmd->id];
+		break;
+	}
+
+	if (min_size == CMD_SIZE_ANY)
+		return 0;
+
+	if (min_size) {
+		min_size += CMD_HEADER_LEN;
+		if (cmd->len >= min_size)
+			return 0;
+
+		dev_err_ratelimited(&dev->intf->dev,
+				    "Received command %u too short (size %u, needed %u)",
+				    cmd->id, cmd->len, min_size);
+		return -EIO;
+	}
+
+	dev_warn_ratelimited(&dev->intf->dev,
+			     "Unhandled command (%d, size %d)\n",
+			     cmd->id, cmd->len);
+	return -EINVAL;
+}
+
 static void *
 kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			     const struct sk_buff *skb, int *cmd_len,
@@ -502,6 +571,9 @@ static int kvaser_usb_leaf_wait_cmd(const struct kvaser_usb *dev, u8 id,
 end:
 	kfree(buf);
 
+	if (err == 0)
+		err = kvaser_usb_leaf_verify_size(dev, cmd);
+
 	return err;
 }
 
@@ -1133,6 +1205,9 @@ static void kvaser_usb_leaf_stop_chip_reply(const struct kvaser_usb *dev,
 static void kvaser_usb_leaf_handle_command(const struct kvaser_usb *dev,
 					   const struct kvaser_cmd *cmd)
 {
+	if (kvaser_usb_leaf_verify_size(dev, cmd) < 0)
+		return;
+
 	switch (cmd->id) {
 	case CMD_START_CHIP_REPLY:
 		kvaser_usb_leaf_start_chip_reply(dev, cmd);
-- 
2.37.3


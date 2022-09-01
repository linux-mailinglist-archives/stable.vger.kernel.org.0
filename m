Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AACB5A96C9
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiIAM3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiIAM3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:04 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66BE1348BF
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id q7so24145824lfu.5
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=micp9l/IrFsytBE0ixGDZGXfLbebeBUN0SkeEHhmqcc=;
        b=gIUIELVJ+69xEDMH9d3G58DllYSnfQr6f8WShzhQtVJsARqQj48BMLkEeKLYz1Y2kS
         W1ZrLzQ2LX1Kpt7eXSMoKF1fG9SKBUm6zFqP1684ouuwfFyIzPgmJhWcWkV/nLA5Brg6
         o6/E6HYKfwQVIh89kNaDBZyLoog1Uf58tQH1E5TV+jAABnKNgIDudIArODrx7NFvKSfY
         mtwT6fNZ8y2n5kSuX9EKghqV/QAEQi51NVUr0n8e2BzlUWvniHUVh9t52VzeJa+rzl4Y
         FGOFAtBR/LZKXnOlym4T9Tu4ipxKOe8kHN3VmADq9OVaVISL4uD4cFUXEtdbbSjPpydV
         Q9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=micp9l/IrFsytBE0ixGDZGXfLbebeBUN0SkeEHhmqcc=;
        b=dsgggLHG1Zn8BEDVZtOvJu3v0fAdRB8Zor2cDdBnlRJ3pKot7XWlI4GIyPpq7fSZYl
         vjVL5GdxI8i1ifLsZ8FK4Jptjhj7ZU4g5CeVBTiJX2mCV4vI4LDlFn+BAkBN2myIAnAg
         HjbdEuMVsB+ya9KDlu0xm4GLmP330RU/AlRWfTgC/KBxB0L4SSyz3MAgBFCpR4AHiR7r
         dInBrBEzIviJlNRR26PL7viWnjPpiZa8pSq0VcSpZNA881B/2oFPTjmEI6yiyJ7HJETd
         lPhpT7kgs4DIT5lQPXW41Y7TcJ5QUPhw27sREbZmRnr05spHuHV9YDWHu4vKUiO7JuBF
         EYSg==
X-Gm-Message-State: ACgBeo2flpSHkmh5aqvClf4vJ5Vs5auwwLVbQwmjFFWN1ll0LCiQ91Iw
        hSSDvwxEjJvr3JOSPQSkdeF53g==
X-Google-Smtp-Source: AA6agR7Iq22cgNXc9fGKB0+ThF7a+KXN9rSvkSeZ9lF8T8O0JF3NQBvCVpO4Tre/hmJtjtAa9V6F6A==
X-Received: by 2002:a05:6512:2609:b0:491:10ba:31f0 with SMTP id bt9-20020a056512260900b0049110ba31f0mr10030481lfb.334.1662035301449;
        Thu, 01 Sep 2022 05:28:21 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:21 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 01/15] can: kvaser_usb_leaf: Fix overread with an invalid command
Date:   Thu,  1 Sep 2022 14:27:15 +0200
Message-Id: <20220901122729.271-2-extja@kvaser.com>
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


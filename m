Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17FD5A96D4
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiIAM3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiIAM3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:25 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA6812C3E4
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:29 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id w8so15101617lft.12
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=modbssTzv7nnhgDun3VSr893KrmwknbbHWyiJ8OUTsc=;
        b=a51HqVnl+WNIsxUq//MzcUCgJDBoM52czR3MjSiSYK5V0m80NnZgIYzTneXtFcLleP
         1XiWz+ehMzMqb25Eb/6uX5oC+vHHffyLaxImw6nuA3o3UbYtt4LVX1yXnbR6/9p/+F7j
         F2nTC+MLhMd7oyCkySBOK7HI2+OPN98jzXjI4oxvSI8HYHGB/VmGGaMsCfOpocNHS3Ie
         z6DuACzi0qQq9szNVCimem2/vC0mU3+7hQPQFN3PHHTpxNSm7davClVWH/uAghaUb9YZ
         XZS6ot0l0WHmocXmN3Tcy8RtKPrOcrt38hCaOwDfzD2rtAvfOH9V803AqQR5IIrOJxe5
         40wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=modbssTzv7nnhgDun3VSr893KrmwknbbHWyiJ8OUTsc=;
        b=pRZufqcNBoaUeah4HSDgy51Os4MrfjSoppCFFHH64gwmaWNDhA+G/jl+cysfMdnBnp
         h1KrUmEWwKdBu/JG9h6U/i3DBEZOXpWRTZNXWlrE9IT2RffXfru0inLiF3DY6p/QMzGD
         51BuuAgrnBHAaiLyuT3uUi8MWHawjnwj+NOBzlvz1GgPMP12xIRt5EuUhl5u64ZBDInh
         5XCApytWuOE2dr/Ho5nLmByEqvVKgPFB7quwQWNqLpPmc6p9AQbH7d2Iz5InuHoAPBX2
         SryeF0l6qEKNaaFIDcDpSeX/vOVPZ87OAPfA/vF2cMkrPOPE6PynT8rFFH8kCEwkL5NB
         XCVw==
X-Gm-Message-State: ACgBeo23rMMlFoEKtmVguW+hIekI8Mi0si9BH8/HWv7ABrI6SzVISSOV
        nkPf/mJ9HWYYfjdQmXzmAHB362i14Q32NNY/
X-Google-Smtp-Source: AA6agR4/Ir7fk8z0fzCDW7JhZT30dqcJoeYap8q32l2T9Ich07pLnbQOXFeXSi1KlMFY2r7AQ5iwbw==
X-Received: by 2002:a19:dc1a:0:b0:494:903a:1fa8 with SMTP id t26-20020a19dc1a000000b00494903a1fa8mr2258485lfg.55.1662035307269;
        Thu, 01 Sep 2022 05:28:27 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:26 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 08/15] can: kvaser_usb_leaf: Fix TX queue out of sync after restart
Date:   Thu,  1 Sep 2022 14:27:22 +0200
Message-Id: <20220901122729.271-9-extja@kvaser.com>
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

The TX queue seems to be implicitly flushed by the hardware during
bus-off or bus-off recovery, but the driver does not reset the TX
bookkeeping.

Despite not resetting TX bookkeeping the driver still re-enables TX
queue unconditionally, leading to "cannot find free context" /
NETDEV_TX_BUSY errors if the TX queue was full at bus-off time.

Fix that by resetting TX bookkeeping on CAN restart.

Tested with 0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778.

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
  - Removed explicit queue flush.

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h      | 2 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 841da29cef93..f6c0938027ec 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -178,6 +178,8 @@ struct kvaser_usb_dev_cfg {
 extern const struct kvaser_usb_dev_ops kvaser_usb_hydra_dev_ops;
 extern const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops;
 
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv);
+
 int kvaser_usb_recv_cmd(const struct kvaser_usb *dev, void *cmd, int len,
 			int *actual_len);
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index c2bce6773adc..e91648ed7386 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -477,7 +477,7 @@ static void kvaser_usb_reset_tx_urb_contexts(struct kvaser_usb_net_priv *priv)
 /* This method might sleep. Do not call it in the atomic context
  * of URB completions.
  */
-static void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
 {
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 	kvaser_usb_reset_tx_urb_contexts(priv);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index b4acd9427967..48b8a0f0b362 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1663,6 +1663,8 @@ static int kvaser_usb_leaf_set_mode(struct net_device *netdev,
 
 	switch (mode) {
 	case CAN_MODE_START:
+		kvaser_usb_unlink_tx_urbs(priv);
+
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;
-- 
2.37.3


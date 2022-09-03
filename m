Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D625AC0AE
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiICSZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiICSZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:25:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B4E4360D
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:25:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m7so7667965lfq.8
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=FtYEyGAJaRB0x8ImnvWnEBF8IOBBq297Mde/T1RSt3w=;
        b=aB9FmxIK6o2ysewr84GWl+pyPyYCLkDYNpXn5eziKPtCHd5N8bBLNqVuOZ4VcPevnP
         PKGphpfSXF45SYTuPz6AJ/c6AjR4IwQEv2JIueKfnu+lTK4FBqP1AMFR1GT6E7lUU1ad
         7lhPIEUHut2umww4d3sqBGELjV/tu+8R8zmDlS8WUcF15jiElgBRcGC3gG44aj7dBIMi
         byd5rk2JZUswMBFfbt3A0j3WbWgJDXR10MV+PVw9RIflntGD/s5e2vuKuJyqql5P4IZ2
         pElCkFE99+sYV8NzlDGc+n8zriCQWrwybUfqP8/wfwNNU28lRknqxYA4OPtub6Lq/UCl
         l5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FtYEyGAJaRB0x8ImnvWnEBF8IOBBq297Mde/T1RSt3w=;
        b=z9WuV5CT719J964syVUh3LQ/nEsptlxc+9xLQcXatq9drOrnnVum5ExRfTVISYfTVl
         l0lScLgeourb3k/jvcbcaDjbQ8B2r+cF7fNGnne9p9k7WFM5qVTRejes8+CRTrODGzlL
         BXW0upHiZ9FyPI1Le255g4Nvpd0GW8HYKN0EXOyhPAgYTAFdrrzdslMqErDO3q5XVoLP
         TuuAID/P8TK53aQjCmf74SwVT7ns/OXLRLJk0/fge8vdfKUlto0AAxHvH4yhB/9EvKs9
         LyMe+cYtRoEW8mRL5i/te2/KgOGaqGS+GQn2pOpRTk1gWjy2QZI44xCZ8QLtcyWV91+X
         t/Tw==
X-Gm-Message-State: ACgBeo0NaEcr5jR4AdNVb6QvccgXpa8VhckuVP9RcyO9SWENTF/5t6iq
        40Y6XD1mrQbSI5AtHCb06EKn0w==
X-Google-Smtp-Source: AA6agR4gK/BdhHrVmt67eijB8NQ51Jvr/jmZtRXHXl7oWNnaua/CjOD8BvjP/6WFuGWn63EMSk0uWQ==
X-Received: by 2002:a05:6512:3f02:b0:494:5c72:6a8b with SMTP id y2-20020a0565123f0200b004945c726a8bmr12091837lfa.313.1662229544892;
        Sat, 03 Sep 2022 11:25:44 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u18-20020ac24c32000000b00492f6ddba59sm658330lfq.75.2022.09.03.11.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:25:44 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 08/15] can: kvaser_usb_leaf: Fix TX queue out of sync after restart
Date:   Sat,  3 Sep 2022 20:25:52 +0200
Message-Id: <20220903182559.189-8-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220903182559.189-1-extja@kvaser.com>
References: <20220903182559.189-1-extja@kvaser.com>
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
Changes in v4:
 - No changes

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


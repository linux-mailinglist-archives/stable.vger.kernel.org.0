Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3265AC0B7
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiICSZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbiICSZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:25:51 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C2A422E9
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:25:49 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id v26so7649776lfd.10
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=YmYdAKcIpnJSyVmqbhPyoJ5HvqkEnv1IWOKaHmYNVmg=;
        b=GABzWe+HWd/P7L6Y8akNTPa27TDLJK5Tkiw5lb6+ewpkYnT7U4/urwrkVJUSzSKPrp
         7TS+GpcGj4L0hP9RiOmKCRrDTUSVUFIefWgiUo3qpMvhI+zAHauFiykQNKz2vZP09ZDf
         9Anb8B1DTD6kLMSxydXgMmfFa5itOGe+jZmWuIFoa+Mkys5eIT6hwkMF+h2EdXSRpCuJ
         DHFp02ci46QMD1r3I3GocxqfNwtzTWyuwAIR9F3YgPVMJuWnwjnz+dl0lhSGmdvM6QpU
         yxSlFr580wvO1A00NGWcTazI7C/10kuD0ZMJmJlOpQY41pQNDJPFq74nFnDwwIpJ8WQX
         Gatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YmYdAKcIpnJSyVmqbhPyoJ5HvqkEnv1IWOKaHmYNVmg=;
        b=C3REwMP7kB8AoM2Og6qOfOASkBhRqHdRGpYsRLl65k2uezg7U/h3eLiLl01zDGnkJr
         4ayhTrqJTXEh8ehgRl/vnYcOgFXZhmbkJTP2ivia6ZM2+GOoAIRJEO92HLfKwR5idkDR
         KZBYEobemKvIcHwLQI8G7cBBzFimkNwFnH9QMK9HXK9F19dz1mFzp/iLouLBdvQ+djru
         JNL5fFayAyfiyiRbRhD3+qmKVuE8FuhF8RnaWKlWLtJXa0TnHpq1YIXgBCu5tMazxGOh
         6TBeCYAF5aRXO+08YKAejJr1J2ktWjXe3O5TtCcTivwIL/xHfTuaxOgprCu4Yt6wJAwg
         sOHQ==
X-Gm-Message-State: ACgBeo3lq//e7C+VhrtSAMCPzVzJnY05VXSokS8vt4hWSGdv0koZ+w06
        XKFfK6PpjfzyYasq/yNro7hCmDr8c3INjTMN
X-Google-Smtp-Source: AA6agR53i84RVhzD3TMosiuNqmcsJ/ofgOojHs6zhvX3xIEF52yyqRst/g1647gDkk/u1HlhdBSzrg==
X-Received: by 2002:a19:7017:0:b0:494:649d:f1e2 with SMTP id h23-20020a197017000000b00494649df1e2mr9597006lfc.251.1662229549424;
        Sat, 03 Sep 2022 11:25:49 -0700 (PDT)
Received: from f6a14fef6d45.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u18-20020ac24c32000000b00492f6ddba59sm658330lfq.75.2022.09.03.11.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 11:25:48 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v4 13/15] can: kvaser_usb_leaf: Fix bogus restart events
Date:   Sat,  3 Sep 2022 20:25:57 +0200
Message-Id: <20220903182559.189-13-extja@kvaser.com>
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

When auto-restart is enabled, the kvaser_usb_leaf driver considers
transition from any state >= CAN_STATE_BUS_OFF as a bus-off recovery
event (restart).

However, these events may occur at interface startup time before
kvaser_usb_open() has set the state to CAN_STATE_ERROR_ACTIVE, causing
restarts counter to increase and CAN_ERR_RESTARTED to be sent despite no
actual restart having occurred.

Fix that by making the auto-restart condition checks more strict so that
they only trigger when the interface was actually in the BUS_OFF state.

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

 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index f8a12a285050..3e31a9ebea88 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -901,7 +901,7 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 	context = &priv->tx_contexts[tid % dev->max_tx_urbs];
 
 	/* Sometimes the state change doesn't come after a bus-off event */
-	if (priv->can.restart_ms && priv->can.state >= CAN_STATE_BUS_OFF) {
+	if (priv->can.restart_ms && priv->can.state == CAN_STATE_BUS_OFF) {
 		struct sk_buff *skb;
 		struct can_frame *cf;
 
@@ -1018,7 +1018,7 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 	}
 
 	if (priv->can.restart_ms &&
-	    cur_state >= CAN_STATE_BUS_OFF &&
+	    cur_state == CAN_STATE_BUS_OFF &&
 	    new_state < CAN_STATE_BUS_OFF)
 		priv->can.can_stats.restarts++;
 
@@ -1111,7 +1111,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 		}
 
 		if (priv->can.restart_ms &&
-		    old_state >= CAN_STATE_BUS_OFF &&
+		    old_state == CAN_STATE_BUS_OFF &&
 		    new_state < CAN_STATE_BUS_OFF) {
 			cf->can_id |= CAN_ERR_RESTARTED;
 			netif_carrier_on(priv->netdev);
-- 
2.37.3


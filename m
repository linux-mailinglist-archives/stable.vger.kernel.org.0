Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9AE66CA13
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbjAPQ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbjAPQ6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:58:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611302D172
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:41:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E766104F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE19C433F0;
        Mon, 16 Jan 2023 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887290;
        bh=qtJCI59zFNOMEJQgJZdiKXWcmVFMQp9ZnuuOUa0cmSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ByqH26BybuTyk6FidJYxDL88ems/aATOkWdem/CB77FM6h9O/volSNTjwXHY0mTk
         UgP0jJSoIOdHHhfhbFfoBqKKycACueANu4b+VSgOoCD0NqEEAv8GoEmUYvD0sOCbkz
         X2w6LAHI+6sD1C22H2/Z/lLdP6lwP3lOIrsGT/ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/521] can: kvaser_usb_leaf: Fix bogus restart events
Date:   Mon, 16 Jan 2023 16:45:54 +0100
Message-Id: <20230116154851.353228062@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

[ Upstream commit 90904d326269a38fe5dd895fb2db7c03199654c4 ]

When auto-restart is enabled, the kvaser_usb_leaf driver considers
transition from any state >= CAN_STATE_BUS_OFF as a bus-off recovery
event (restart).

However, these events may occur at interface startup time before
kvaser_usb_open() has set the state to CAN_STATE_ERROR_ACTIVE, causing
restarts counter to increase and CAN_ERR_RESTARTED to be sent despite no
actual restart having occurred.

Fix that by making the auto-restart condition checks more strict so that
they only trigger when the interface was actually in the BUS_OFF state.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-10-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 52ac6446634d..d1877ff2ff71 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -899,7 +899,7 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 	context = &priv->tx_contexts[tid % dev->max_tx_urbs];
 
 	/* Sometimes the state change doesn't come after a bus-off event */
-	if (priv->can.restart_ms && priv->can.state >= CAN_STATE_BUS_OFF) {
+	if (priv->can.restart_ms && priv->can.state == CAN_STATE_BUS_OFF) {
 		struct sk_buff *skb;
 		struct can_frame *cf;
 
@@ -1002,7 +1002,7 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 	}
 
 	if (priv->can.restart_ms &&
-	    cur_state >= CAN_STATE_BUS_OFF &&
+	    cur_state == CAN_STATE_BUS_OFF &&
 	    new_state < CAN_STATE_BUS_OFF)
 		priv->can.can_stats.restarts++;
 
@@ -1092,7 +1092,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 		}
 
 		if (priv->can.restart_ms &&
-		    old_state >= CAN_STATE_BUS_OFF &&
+		    old_state == CAN_STATE_BUS_OFF &&
 		    new_state < CAN_STATE_BUS_OFF) {
 			cf->can_id |= CAN_ERR_RESTARTED;
 			netif_carrier_on(priv->netdev);
-- 
2.35.1




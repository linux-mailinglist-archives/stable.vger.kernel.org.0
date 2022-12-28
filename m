Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1AD6578B3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiL1Ox2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiL1OxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:53:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61157136
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F243D614B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F11C433F0;
        Wed, 28 Dec 2022 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239187;
        bh=yGQbxQdxwy+fTPzjkNdk5+reYJgNka9+ufCnjWK6z7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjhV8wH5LfbWQCwf90Nfy32phOn4T7/XXaBJizhMz9CI/hx+KrCH0kVQIwdawJ0F8
         K8UsYzAilO3f+o8QXjVuiU9hgJBIDXd+Is2zAXVZHPWneTnrSk0hRq/MPf3/R3n7AL
         /g4S7LSVulpYG5Ignu2/kIIJHQyhaLYnm1B7wCBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jimmy Assarsson <extja@kvaser.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/731] can: kvaser_usb: do not increase tx statistics when sending error message frames
Date:   Wed, 28 Dec 2022 15:34:28 +0100
Message-Id: <20221228144301.230175093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 0b0ce2c67795672115ac6ca28351a78799cd114b ]

The CAN error message frames (i.e. error skb) are an interface
specific to socket CAN. The payload of the CAN error message frames
does not correspond to any actual data sent on the wire. Only an error
flag and a delimiter are transmitted when an error occurs (c.f. ISO
11898-1 section 10.4.4.2 "Error flag").

For this reason, it makes no sense to increment the tx_packets and
tx_bytes fields of struct net_device_stats when sending an error
message frame because no actual payload will be transmitted on the
wire.

N.B. Sending error message frames is a very specific feature which, at
the moment, is only supported by the Kvaser Hydra hardware. Please
refer to [1] for more details on the topic.

[1] https://lore.kernel.org/linux-can/CAMZ6RqK0rTNg3u3mBpZOoY51jLZ-et-J01tY6-+mWsM4meVw-A@mail.gmail.com/t/#u

Link: https://lore.kernel.org/all/20211207121531.42941-3-mailhol.vincent@wanadoo.fr
Co-developed-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 35364f5b41a4 ("can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 3ff2cd9828d2..215f2b48db24 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -295,6 +295,7 @@ struct kvaser_cmd {
 #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN	BIT(1)
 #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME	BIT(4)
 #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID	BIT(5)
+#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK		BIT(6)
 /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
 #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK	BIT(12)
 #define KVASER_USB_HYDRA_CF_FLAG_ABL		BIT(13)
@@ -1125,6 +1126,7 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 	struct kvaser_usb_net_priv *priv;
 	unsigned long irq_flags;
 	bool one_shot_fail = false;
+	bool is_err_frame = false;
 	u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
 
 	priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
@@ -1143,10 +1145,13 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 			kvaser_usb_hydra_one_shot_fail(priv, cmd_ext);
 			one_shot_fail = true;
 		}
+
+		is_err_frame = flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
+			       flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;
 	}
 
 	context = &priv->tx_contexts[transid % dev->max_tx_urbs];
-	if (!one_shot_fail) {
+	if (!one_shot_fail && !is_err_frame) {
 		struct net_device_stats *stats = &priv->netdev->stats;
 
 		stats->tx_packets++;
-- 
2.35.1




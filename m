Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9128C66CA9E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjAPRE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbjAPQ6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:58:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782AF367EF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:41:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C32B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CA0C433EF;
        Mon, 16 Jan 2023 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887268;
        bh=Ek0og/auLLzIMABzykGkbxVN6h15RQ1ZY+5/McfIF8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krCA+Ry+LLBYDxeYGoJoZWBxylPwrz8+UULvo/CDRQ7mL5jX8vb4/8fVUXTzVZUSc
         pvwKgrmYZDe4GdnwYSnqCP5XAsFfsmANDsfgMkc8wMqhuyPe40HLnOmywowe4ETeYS
         toEmi2/9eeQbTY9E/7cJovNbhmsmie25sj4wCsHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jimmy Assarsson <extja@kvaser.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/521] can: kvaser_usb: do not increase tx statistics when sending error message frames
Date:   Mon, 16 Jan 2023 16:45:47 +0100
Message-Id: <20230116154851.019733980@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 45d278724883..9588efbfae71 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -293,6 +293,7 @@ struct kvaser_cmd {
 #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN	BIT(1)
 #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME	BIT(4)
 #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID	BIT(5)
+#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK		BIT(6)
 /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
 #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK	BIT(12)
 #define KVASER_USB_HYDRA_CF_FLAG_ABL		BIT(13)
@@ -1099,6 +1100,7 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 	struct kvaser_usb_net_priv *priv;
 	unsigned long irq_flags;
 	bool one_shot_fail = false;
+	bool is_err_frame = false;
 	u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
 
 	priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
@@ -1117,10 +1119,13 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
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




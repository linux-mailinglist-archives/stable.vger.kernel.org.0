Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D64716B4
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 22:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhLKVXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 16:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhLKVXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Dec 2021 16:23:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45142C061714
        for <stable@vger.kernel.org>; Sat, 11 Dec 2021 13:23:11 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mw9pl-00075Z-Ic
        for stable@vger.kernel.org; Sat, 11 Dec 2021 22:23:09 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A52D96C2000
        for <stable@vger.kernel.org>; Sat, 11 Dec 2021 21:23:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4E8FB6C1FFE;
        Sat, 11 Dec 2021 21:23:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id df86fe8c;
        Sat, 11 Dec 2021 21:23:07 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] can: pch_can: pch_can_rx_normal: fix use after free
Date:   Sat, 11 Dec 2021 22:23:06 +0100
Message-Id: <20211211212306.797338-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit 94cddf1e9227a171b27292509d59691819c458db upstream.

After calling netif_receive_skb(skb), dereferencing skb is unsafe.
Especially, the can_frame cf which aliases skb memory is dereferenced
just after the call netif_receive_skb(skb).

Reordering the lines solves the issue.

Fixes: b21d18b51b31 ("can: Topcliff: Add PCH_CAN driver.")
Link: https://lore.kernel.org/all/20211123111654.621610-1-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[mkl: backport to v5.10]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Hey Greg,

this is the backport of
| 94cddf1e9227 ("can: pch_can: pch_can_rx_normal: fix use after free")
to v5.10

regards,
Marc

 drivers/net/can/pch_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 5c180d2f3c3c..79d9abdcc65a 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -692,11 +692,11 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 			cf->data[i + 1] = data_reg >> 8;
 		}
 
-		netif_receive_skb(skb);
 		rcv_pkts++;
 		stats->rx_packets++;
 		quota--;
 		stats->rx_bytes += cf->can_dlc;
+		netif_receive_skb(skb);
 
 		pch_fifo_thresh(priv, obj_num);
 		obj_num++;
-- 
2.33.0



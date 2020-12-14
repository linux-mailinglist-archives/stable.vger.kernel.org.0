Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C95C2D9F88
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440570AbgLNSt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:49:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502268AbgLNRhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 026/105] can: sun4i_can: sun4i_can_err(): dont count arbitration lose as an error
Date:   Mon, 14 Dec 2020 18:28:00 +0100
Message-Id: <20201214172556.535609522@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeroen Hofstee <jhofstee@victronenergy.com>

[ Upstream commit c2d095eff797813461a426b97242e3ffc50e4134 ]

Losing arbitration is normal in a CAN-bus network, it means that a higher
priority frame is being send and the pending message will be retried later.
Hence most driver only increment arbitration_lost, but the sun4i driver also
incremeants tx_error, causing errors to be reported on a normal functioning
CAN-bus. So stop counting them as errors.

Fixes: 0738eff14d81 ("can: Allwinner A10/A20 CAN Controller support - Kernel module")
Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Link: https://lore.kernel.org/r/20201127095941.21609-1-jhofstee@victronenergy.com
[mkl: split into two seperate patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sun4i_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e2c6cf4b2228f..b3f2f4fe5ee04 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -604,7 +604,6 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 		netdev_dbg(dev, "arbitration lost interrupt\n");
 		alc = readl(priv->base + SUN4I_REG_STA_ADDR);
 		priv->can.can_stats.arbitration_lost++;
-		stats->tx_errors++;
 		if (likely(skb)) {
 			cf->can_id |= CAN_ERR_LOSTARB;
 			cf->data[0] = (alc >> 8) & 0x1f;
-- 
2.27.0




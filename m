Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FDA45148E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbhKOUKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344708AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20955636B6;
        Mon, 15 Nov 2021 19:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002971;
        bh=8uSBIqJXtnf0aUHMLoy2HKDxQ+mh9vlZVj0RpJo6CSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCKT3X6SWB75mM1XSaLq0iGQOyrDQZz2NegN9QIfl0DDTIS8cUvanwXjL0FQJMs8Y
         aYASQZMDgJJGtrAqcGVS5Y1t7oXqY1i1AVK8YCOAeb9NDwnIhsATzZ/w508xflTiyF
         zo2E/lEv96ujClbw+f2jqNU7nn/QhOcw5rbKf0VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 763/917] net: davinci_emac: Fix interrupt pacing disable
Date:   Mon, 15 Nov 2021 18:04:18 +0100
Message-Id: <20211115165454.798831409@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kiselev <bigunclemax@gmail.com>

[ Upstream commit d52bcb47bdf971a59a2467975d2405fcfcb2fa19 ]

This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
disable rx irq coalescing.

Previously we could enable rx irq coalescing via ethtool
(For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
it because this part rejects 0 value:

       if (!coal->rx_coalesce_usecs)
               return -EINVAL;

Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing functionality.")
Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Link: https://lore.kernel.org/r/20211101152343.4193233-1-bigunclemax@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/davinci_emac.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index e8291d8488391..d243ca5dfde00 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -420,8 +420,20 @@ static int emac_set_coalesce(struct net_device *ndev,
 	u32 int_ctrl, num_interrupts = 0;
 	u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;
 
-	if (!coal->rx_coalesce_usecs)
-		return -EINVAL;
+	if (!coal->rx_coalesce_usecs) {
+		priv->coal_intvl = 0;
+
+		switch (priv->version) {
+		case EMAC_VERSION_2:
+			emac_ctrl_write(EMAC_DM646X_CMINTCTRL, 0);
+			break;
+		default:
+			emac_ctrl_write(EMAC_CTRL_EWINTTCNT, 0);
+			break;
+		}
+
+		return 0;
+	}
 
 	coal_intvl = coal->rx_coalesce_usecs;
 
-- 
2.33.0




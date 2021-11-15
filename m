Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC73C450EB7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbhKOSSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:18:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240813AbhKOSNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:13:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88FC633CE;
        Mon, 15 Nov 2021 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998518;
        bh=Xr11rTh3oy0fAUWz65XuCVZ3X0ZIJ6i84cPoGNxsGOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNwnAdEr4oLUBXNHHwL2vmxW7nW1zV4Qt8JnDG2NH5qDtUXA4aRBanOuc43X1ch3l
         jnFdkIcTwKFSvnXFPwRLNUBKizKTPRdpUHK4iLzKig1HN09Ka+KWQHO450nRyI2LbG
         7faDaa7hxx7OuilaqDgWcKxkqnl8PJBxNkMn09RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 505/575] net: davinci_emac: Fix interrupt pacing disable
Date:   Mon, 15 Nov 2021 18:03:50 +0100
Message-Id: <20211115165401.158677457@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 03055c96f0760..ad5293571af4d 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -412,8 +412,20 @@ static int emac_set_coalesce(struct net_device *ndev,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4739245BA3D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbhKXMJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhKXMH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A6261059;
        Wed, 24 Nov 2021 12:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755458;
        bh=WM30CWVn00+2EN5Gf4DhUo/6dMjuhdxc7S5hpeBccRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBVGZVxKnOp2rCoRHpsmgXu6V8Vb2IYrgFOfUcu9TKdxC03zFCb6iVFdk6tD6VAqG
         2KlsQ0nkoXq7mUvaNlWeqk0F3Spq8QLJkN4D2pXN6Hftmz/BpOE3zovGOiCxT0smeA
         JzjK7VQtOoKIN0tRvjAJ0uXp5O2iCkDV/FzboFv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 104/162] net: davinci_emac: Fix interrupt pacing disable
Date:   Wed, 24 Nov 2021 12:56:47 +0100
Message-Id: <20211124115701.695690269@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
index e11f436b0726e..ac61d017a4b51 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -555,8 +555,20 @@ static int emac_set_coalesce(struct net_device *ndev,
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




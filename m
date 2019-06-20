Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D93D4D735
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfFTSQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbfFTSQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00534215EA;
        Thu, 20 Jun 2019 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054591;
        bh=I8yePqN8pwCzyU8vApw9YiizwGXr64LMAq5Y4tEhAOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Snz0up14ImcdwgM6TdurfT/Aib00TW6DzcMATxBYlOLvlvOP8kDanQ8byQwvBa16a
         tgvluwfl50z2vjLkKlo/Prs0+aYnaa97JZBaiJBvbTFDKXa90EDmM75d/jRtBZtpPV
         eZz7EaUXslW3jNfbA1de3sWuPJg25wCSeQoVHJLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 53/98] net: stmmac: fix csr_clk cant be zero issue
Date:   Thu, 20 Jun 2019 19:57:20 +0200
Message-Id: <20190620174351.703795898@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5e7f7fc538d894b2d9aa41876b8dcf35f5fe11e6 ]

The specific clk_csr value can be zero, and
stmmac_clk is necessary for MDC clock which can be set dynamically.
So, change the condition from plat->clk_csr to plat->stmmac_clk to
fix clk_csr can't be zero issue.

Fixes: cd7201f477b9 ("stmmac: MDC clock dynamically based on the csr clock input")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Acked-by: Alexandre TORGUE <alexandre.torgue@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 6 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8cebc44108b2..635d88d82610 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4380,10 +4380,10 @@ int stmmac_dvr_probe(struct device *device,
 	 * set the MDC clock dynamically according to the csr actual
 	 * clock input.
 	 */
-	if (!priv->plat->clk_csr)
-		stmmac_clk_csr_set(priv);
-	else
+	if (priv->plat->clk_csr >= 0)
 		priv->clk_csr = priv->plat->clk_csr;
+	else
+		stmmac_clk_csr_set(priv);
 
 	stmmac_check_pcs_mode(priv);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 3031f2bf15d6..f45bfbef97d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -408,7 +408,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	/* Default to phy auto-detection */
 	plat->phy_addr = -1;
 
-	/* Get clk_csr from device tree */
+	/* Default to get clk_csr from stmmac_clk_crs_set(),
+	 * or get clk_csr from device tree.
+	 */
+	plat->clk_csr = -1;
 	of_property_read_u32(np, "clk_csr", &plat->clk_csr);
 
 	/* "snps,phy-addr" is not a standard property. Mark it as deprecated
-- 
2.20.1




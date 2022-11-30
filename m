Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4645663DDD0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiK3Saw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiK3San (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:30:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5F68D666
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AD73B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE01C433D6;
        Wed, 30 Nov 2022 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833040;
        bh=OwJx37HG/bepk19hnsvQmT6VFdCCw5bN3fLhV2fo8TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiiqaNcXPXl5n1aw+hZANt8tv8sNlzXDFY6uz/PkcUN3yk0fcuzlsLiTcsI8pmLBq
         Btiny1/9qG4W8TQyZZ2CtTWuIrFC4jcSngu62dQFlYA34rasKo4LKRzi6ayTGZ/53l
         /ARlArvg1CvGwDgQ8PkWDCHxZkD3n5V9BckuOLBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Cooper <alcooperx@gmail.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/162] mmc: sdhci-brcmstb: Re-organize flags
Date:   Wed, 30 Nov 2022 19:23:03 +0100
Message-Id: <20221130180531.256815683@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit f3a70f991dd07330225ea11e158e1d07ad5733fb ]

Re-organize the flags by basing the bit names on the flag that they
apply to. Also change the "flags" member in the "brcmstb_match_priv"
struct to const.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20220427180853.35970-2-kdasu.kdev@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 56baa208f910 ("mmc: sdhci-brcmstb: Fix SDHCI_RESET_ALL for CQHCI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-brcmstb.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index f24623aac2db..244780481193 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -18,20 +18,22 @@
 #define SDHCI_VENDOR 0x78
 #define  SDHCI_VENDOR_ENHANCED_STRB 0x1
 
-#define BRCMSTB_PRIV_FLAGS_NO_64BIT		BIT(0)
-#define BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT	BIT(1)
+#define BRCMSTB_MATCH_FLAGS_NO_64BIT		BIT(0)
+#define BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT	BIT(1)
+
+#define BRCMSTB_PRIV_FLAGS_HAS_CQE		BIT(0)
 
 #define SDHCI_ARASAN_CQE_BASE_ADDR		0x200
 
 struct sdhci_brcmstb_priv {
 	void __iomem *cfg_regs;
-	bool has_cqe;
+	unsigned int flags;
 };
 
 struct brcmstb_match_priv {
 	void (*hs400es)(struct mmc_host *mmc, struct mmc_ios *ios);
 	struct sdhci_ops *ops;
-	unsigned int flags;
+	const unsigned int flags;
 };
 
 static void sdhci_brcmstb_hs400es(struct mmc_host *mmc, struct mmc_ios *ios)
@@ -134,13 +136,13 @@ static struct sdhci_ops sdhci_brcmstb_ops_7216 = {
 };
 
 static struct brcmstb_match_priv match_priv_7425 = {
-	.flags = BRCMSTB_PRIV_FLAGS_NO_64BIT |
-	BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT,
+	.flags = BRCMSTB_MATCH_FLAGS_NO_64BIT |
+	BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT,
 	.ops = &sdhci_brcmstb_ops,
 };
 
 static struct brcmstb_match_priv match_priv_7445 = {
-	.flags = BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT,
+	.flags = BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT,
 	.ops = &sdhci_brcmstb_ops,
 };
 
@@ -176,7 +178,7 @@ static int sdhci_brcmstb_add_host(struct sdhci_host *host,
 	bool dma64;
 	int ret;
 
-	if (!priv->has_cqe)
+	if ((priv->flags & BRCMSTB_PRIV_FLAGS_HAS_CQE) == 0)
 		return sdhci_add_host(host);
 
 	dev_dbg(mmc_dev(host->mmc), "CQE is enabled\n");
@@ -225,7 +227,6 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	struct sdhci_brcmstb_priv *priv;
 	struct sdhci_host *host;
 	struct resource *iomem;
-	bool has_cqe = false;
 	struct clk *clk;
 	int res;
 
@@ -244,10 +245,6 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 		return res;
 
 	memset(&brcmstb_pdata, 0, sizeof(brcmstb_pdata));
-	if (device_property_read_bool(&pdev->dev, "supports-cqe")) {
-		has_cqe = true;
-		match_priv->ops->irq = sdhci_brcmstb_cqhci_irq;
-	}
 	brcmstb_pdata.ops = match_priv->ops;
 	host = sdhci_pltfm_init(pdev, &brcmstb_pdata,
 				sizeof(struct sdhci_brcmstb_priv));
@@ -258,7 +255,10 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 
 	pltfm_host = sdhci_priv(host);
 	priv = sdhci_pltfm_priv(pltfm_host);
-	priv->has_cqe = has_cqe;
+	if (device_property_read_bool(&pdev->dev, "supports-cqe")) {
+		priv->flags |= BRCMSTB_PRIV_FLAGS_HAS_CQE;
+		match_priv->ops->irq = sdhci_brcmstb_cqhci_irq;
+	}
 
 	/* Map in the non-standard CFG registers */
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -287,14 +287,14 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	 * properties through mmc_of_parse().
 	 */
 	host->caps = sdhci_readl(host, SDHCI_CAPABILITIES);
-	if (match_priv->flags & BRCMSTB_PRIV_FLAGS_NO_64BIT)
+	if (match_priv->flags & BRCMSTB_MATCH_FLAGS_NO_64BIT)
 		host->caps &= ~SDHCI_CAN_64BIT;
 	host->caps1 = sdhci_readl(host, SDHCI_CAPABILITIES_1);
 	host->caps1 &= ~(SDHCI_SUPPORT_SDR50 | SDHCI_SUPPORT_SDR104 |
 			 SDHCI_SUPPORT_DDR50);
 	host->quirks |= SDHCI_QUIRK_MISSING_CAPS;
 
-	if (match_priv->flags & BRCMSTB_PRIV_FLAGS_BROKEN_TIMEOUT)
+	if (match_priv->flags & BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT)
 		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
 	res = sdhci_brcmstb_add_host(host, priv);
-- 
2.35.1




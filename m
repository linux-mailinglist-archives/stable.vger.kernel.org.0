Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F78B59DD73
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354987AbiHWKeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355574AbiHWKcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:32:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7F3A5985;
        Tue, 23 Aug 2022 02:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 246CD6155D;
        Tue, 23 Aug 2022 09:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3129EC433C1;
        Tue, 23 Aug 2022 09:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245604;
        bh=1VwcYKQjh+FqBxB9bypplF9vur1PhNErQ57grdAmqtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoGhhFQ5gD0zKSmbAZzzyyjzGDXbBvG7DI2rPAxXK6LcLrRQDPc+YoXiHh9OCL25R
         Cj4h6y7gstFhy+HSR6Wdkh52xx8fnv8TPLN2QUTxJuQ+5bTJYhYzbg1OTtJZuWPQ5Q
         EVqwgdXVdBqppcnwJ0FWxEY7XCw5Zz0+jcSSnFFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Karl Olsen <karl@micro-technic.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/287] mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R
Date:   Tue, 23 Aug 2022 10:24:59 +0200
Message-Id: <20220823080104.784447534@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 5987e6ded29d52e42fc7b06aa575c60a25eee38e ]

In set_uhs_signaling, the DDR bit is being set by fully writing the MC1R
register.
This can lead to accidental erase of certain bits in this register.
Avoid this by doing a read-modify-write operation.

Fixes: d0918764c17b ("mmc: sdhci-of-at91: fix MMC_DDR_52 timing selection")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Tested-by: Karl Olsen <karl@micro-technic.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20220630090926.15061-1-eugen.hristev@microchip.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-at91.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-at91.c b/drivers/mmc/host/sdhci-of-at91.c
index 8cd1794768ba..70ce977cfeec 100644
--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -117,8 +117,13 @@ static void sdhci_at91_set_power(struct sdhci_host *host, unsigned char mode,
 static void sdhci_at91_set_uhs_signaling(struct sdhci_host *host,
 					 unsigned int timing)
 {
-	if (timing == MMC_TIMING_MMC_DDR52)
-		sdhci_writeb(host, SDMMC_MC1R_DDR, SDMMC_MC1R);
+	u8 mc1r;
+
+	if (timing == MMC_TIMING_MMC_DDR52) {
+		mc1r = sdhci_readb(host, SDMMC_MC1R);
+		mc1r |= SDMMC_MC1R_DDR;
+		sdhci_writeb(host, mc1r, SDMMC_MC1R);
+	}
 	sdhci_set_uhs_signaling(host, timing);
 }
 
-- 
2.35.1




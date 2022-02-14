Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406054B45C7
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbiBNJcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:32:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243595AbiBNJcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:32:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCB060AA5;
        Mon, 14 Feb 2022 01:31:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE94F60F83;
        Mon, 14 Feb 2022 09:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B93C340E9;
        Mon, 14 Feb 2022 09:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831067;
        bh=RuHWb3w5sWFdomNRagX+hTJL7q/b3BKZNtbnuV1Auew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yb/8WwrENztGT1qCGnZ+foFPRevIWJm/U4dPgQwyEyV8HL/EeUmfXIN4YFYp8/dZh
         vG7ZYYWlA3TXVfl9l4VFt2wqqezVZw9VUWmMX757ed0iUixaSbkIZcuN0boN8ZNfyi
         aLZNrFYSCTDNgUQquc1Iq10jFfm9fgcQzRXL8TWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 04/44] mmc: sdhci-of-esdhc: Check for error num after setting mask
Date:   Mon, 14 Feb 2022 10:25:27 +0100
Message-Id: <20220214092448.054893540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit 40c67c291a93f8846c4a972c9ef1b7ba4544c8d0 upstream.

Because of the possible failure of the dma_supported(), the
dma_set_mask_and_coherent() may return error num.
Therefore, it should be better to check it and return the error if
fails.
And since the sdhci_setup_host() has already checked the return value of
the enable_dma, we need not check it in sdhci_resume_host() again.

Fixes: 5552d7ad596c ("mmc: sdhci-of-esdhc: set proper dma mask for ls104x chips")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220112083156.1124782-1-jiasheng@iscas.ac.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -427,12 +427,16 @@ static void esdhc_of_adma_workaround(str
 
 static int esdhc_of_enable_dma(struct sdhci_host *host)
 {
+	int ret;
 	u32 value;
 	struct device *dev = mmc_dev(host->mmc);
 
 	if (of_device_is_compatible(dev->of_node, "fsl,ls1043a-esdhc") ||
-	    of_device_is_compatible(dev->of_node, "fsl,ls1046a-esdhc"))
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+	    of_device_is_compatible(dev->of_node, "fsl,ls1046a-esdhc")) {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+		if (ret)
+			return ret;
+	}
 
 	value = sdhci_readl(host, ESDHC_DMA_SYSCTL);
 



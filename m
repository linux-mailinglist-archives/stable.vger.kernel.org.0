Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC0B4B4B8D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245213AbiBNKVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:21:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346337AbiBNKTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:19:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A172890253;
        Mon, 14 Feb 2022 01:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11F18B80DCF;
        Mon, 14 Feb 2022 09:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200A2C340E9;
        Mon, 14 Feb 2022 09:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832501;
        bh=GmHD2H6wXTPw4OsDfCiRyEE9zZtwRyeGAsCLUx/cKAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQhZw3Yh1WLh8z/aFdtjVlpUC+blT/xndlBeKkgbyeTijlagT0/yQAuQp34YfwXyO
         iJZtB5SFtnOSQvr2e07AWv5p9u9TMPqhrz59FhisQ5yMuxE/6pMmEUVZohVEmD++L8
         IXmfHlHfJhnYPYM0Iiuv3L7F0yfuESLKxxqbjT+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.16 007/203] mmc: sdhci-of-esdhc: Check for error num after setting mask
Date:   Mon, 14 Feb 2022 10:24:11 +0100
Message-Id: <20220214092510.471179552@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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
@@ -524,12 +524,16 @@ static void esdhc_of_adma_workaround(str
 
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
 



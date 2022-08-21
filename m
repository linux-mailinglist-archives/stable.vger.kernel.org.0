Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38D959B42A
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiHUN5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHUN5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6090A17072
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CEF0B80D59
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67895C433D6;
        Sun, 21 Aug 2022 13:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661090236;
        bh=e5Mqz7RmI5XiNVED6CSDOuv5w+jAElPPkfYSuBIJff8=;
        h=Subject:To:Cc:From:Date:From;
        b=F9A/I7f4H4lGjomHKVCCsD1G5XPZQODskzKLQLE42pqSBsihrmjuyrJZMN/25GkDU
         aXeIf8klHIGPpetejS2g7ck97TePcXuEkTmZBSzcdcZSCw+BJq/wNMGZFmDau4y+ja
         zJqcYdiEKfh7rrMkds0qvq9xvjRJDh8bBWXwbfvk=
Subject: FAILED: patch "[PATCH] mmc: mtk-sd: Clear interrupts when cqe off/disable" failed to apply to 5.15-stable tree
To:     wenbin.mei@mediatek.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:57:03 +0200
Message-ID: <16610902231999@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc5d1692600613e72f32af60e27330fe0c79f4fe Mon Sep 17 00:00:00 2001
From: Wenbin Mei <wenbin.mei@mediatek.com>
Date: Thu, 28 Jul 2022 16:00:48 +0800
Subject: [PATCH] mmc: mtk-sd: Clear interrupts when cqe off/disable

Currently we don't clear MSDC interrupts when cqe off/disable, which led
to the data complete interrupt will be reserved for the next command.
If the next command with data transfer after cqe off/disable, we process
the CMD ready interrupt and trigger DMA start for data, but the data
complete interrupt is already exists, then SW assume that the data transfer
is complete, SW will trigger DMA stop, but the data may not be transmitted
yet or is transmitting, so we may encounter the following error:
mtk-msdc 11230000.mmc: CMD bus busy detected.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Fixes: 88bd652b3c74 ("mmc: mediatek: command queue support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220728080048.21336-1-wenbin.mei@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 4ff73d1883de..69d78604d1fc 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2446,6 +2446,9 @@ static void msdc_cqe_disable(struct mmc_host *mmc, bool recovery)
 	/* disable busy check */
 	sdr_clr_bits(host->base + MSDC_PATCH_BIT1, MSDC_PB1_BUSY_CHECK_SEL);
 
+	val = readl(host->base + MSDC_INT);
+	writel(val, host->base + MSDC_INT);
+
 	if (recovery) {
 		sdr_set_field(host->base + MSDC_DMA_CTRL,
 			      MSDC_DMA_CTRL_STOP, 1);
@@ -2932,11 +2935,14 @@ static int __maybe_unused msdc_suspend(struct device *dev)
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	struct msdc_host *host = mmc_priv(mmc);
 	int ret;
+	u32 val;
 
 	if (mmc->caps2 & MMC_CAP2_CQE) {
 		ret = cqhci_suspend(mmc);
 		if (ret)
 			return ret;
+		val = readl(host->base + MSDC_INT);
+		writel(val, host->base + MSDC_INT);
 	}
 
 	/*


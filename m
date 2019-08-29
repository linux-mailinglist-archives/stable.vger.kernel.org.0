Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD24A1770
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfH2Kzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:55:31 -0400
Received: from conuserg-12.nifty.com ([210.131.2.79]:17274 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfH2KuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 06:50:09 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id x7TAnTof013730;
        Thu, 29 Aug 2019 19:49:29 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com x7TAnTof013730
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1567075772;
        bh=bONSGLTFaXqEMmGlC9jNWtPpXwIX2FvApbhg5YEacHY=;
        h=From:To:Cc:Subject:Date:From;
        b=tf+IoCMZ8FnlxiyVUG2h+Gy5Y+i7OqvaRwxaxqL44y7HIrFVR5O1s87bCOlAVmSDO
         0d6p10gASi9nIjm3tDfdhjHFq2KynTVYZMS2Hlvk3AOIz/8dDmc2vTMjKCG9jY/Brk
         nC/tc+Qn1zmMeux84bhSFkZNsGLaRebjUI7E/tWaArsJJJPQcMMfr+cGQz6Zra2blq
         xjYDwGglnO4+WpI83mNxsv5PgnG6GLm8JdX+aWaIfGZxr3u8WEm2BTUd/0T9kQwbOc
         Sfuw5ClVm1CZS5pnCftjK0KGbta7/T3IeQ6x7tWiQPE0KlFFxJUwN87qtqg/vvZxqN
         nGBUW9VnhYAYw==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-mmc@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Piotr Sroka <piotrs@cadence.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mmc: sdhci-cadence: enable v4_mode to fix ADMA 64-bit addressing
Date:   Thu, 29 Aug 2019 19:49:26 +0900
Message-Id: <20190829104928.27404-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The IP datasheet says this controller is compatible with SD Host
Specification Version v4.00.

As it turned out, the ADMA of this IP does not work with 64-bit mode
when it is in the Version 3.00 compatible mode; it understands the
old 64-bit descriptor table (as defined in SDHCI v2), but the ADMA
System Address Register (SDHCI_ADMA_ADDRESS) cannot point to the
64-bit address.

I noticed this issue only after commit bd2e75633c80 ("dma-contiguous:
use fallback alloc_pages for single pages"). Prior to that commit,
dma_set_mask_and_coherent() returned the dma address that fits in
32-bit range, at least for the default arm64 configuration
(arch/arm64/configs/defconfig). Now the host->adma_addr exceeds the
32-bit limit, causing the real problem for the Socionext SoCs.
(As a side-note, I was also able to reproduce the issue for older
kernels by turning off CONFIG_DMA_CMA.)

Call sdhci_enable_v4_mode() to fix this.

I think it is better to back-port this, but only possible for v4.20+.

When this driver was merged (v4.10), the v4 mode support did not exist.
It was added by commit b3f80b434f72 ("mmc: sdhci: Add sd host v4 mode")
i.e. v4.20.

Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/mmc/host/sdhci-cadence.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-cadence.c b/drivers/mmc/host/sdhci-cadence.c
index 163d1cf4367e..44139fceac24 100644
--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -369,6 +369,7 @@ static int sdhci_cdns_probe(struct platform_device *pdev)
 	host->mmc_host_ops.execute_tuning = sdhci_cdns_execute_tuning;
 	host->mmc_host_ops.hs400_enhanced_strobe =
 				sdhci_cdns_hs400_enhanced_strobe;
+	sdhci_enable_v4_mode(host);
 
 	sdhci_get_of_property(pdev);
 
-- 
2.17.1


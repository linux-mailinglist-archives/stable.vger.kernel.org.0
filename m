Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D72A9107
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390622AbfIDSNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389432AbfIDSNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2064B208E4;
        Wed,  4 Sep 2019 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620787;
        bh=QfaEHryzVEL2hXwWkCzJ3WcurmZFn+JfnVJi9dnQP8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=losMKIiGeaIrMhlVfgZgve3+KoQZde7uAtUrG1a6N9Xs+L3LkFFvBgasvtl2hqO0l
         wwt9wXKBE0DyhBfK6Y2UqSwNc3uuz/j/WXNTWQ5QENHoYGlNe1SRH1F2kWZ22CYmWO
         2NrCnM7E4ygh9MGLqCphHyvN7i28Y53lxaoMw4XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.2 094/143] mmc: sdhci-cadence: enable v4_mode to fix ADMA 64-bit addressing
Date:   Wed,  4 Sep 2019 19:53:57 +0200
Message-Id: <20190904175317.813874728@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit e73a3896eaca95ea5fc895720502a3f040eb4b39 upstream.

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

Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-cadence.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -369,6 +369,7 @@ static int sdhci_cdns_probe(struct platf
 	host->mmc_host_ops.execute_tuning = sdhci_cdns_execute_tuning;
 	host->mmc_host_ops.hs400_enhanced_strobe =
 				sdhci_cdns_hs400_enhanced_strobe;
+	sdhci_enable_v4_mode(host);
 
 	sdhci_get_of_property(pdev);
 



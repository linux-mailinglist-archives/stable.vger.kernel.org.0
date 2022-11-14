Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21AF627EAA
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbiKNMuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbiKNMuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B76F031
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A774BB80EBD
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0022EC433C1;
        Mon, 14 Nov 2022 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430214;
        bh=jd8JZu4JpbpiwaIf2LzuA5ZoYhpfEN7ABLgd7sV3Dk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2eqFOPElkARKiZewg6evweEx4PAGfbh0D343oonboThM3u9SiyFTU/1CsWxrGlEI
         7e9DjvoSw9Qxo03UJ1L3PNUjCJ+/HQr5zFk/RC0hBsO54DEMLy9WlQ4rI9Kg/nX9CA
         FnRWl36r3LFkhHk+g4MZvkFzoBRDJXFNOrYOPNRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Norris <briannorris@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 60/95] mmc: sdhci-tegra: Fix SDHCI_RESET_ALL for CQHCI
Date:   Mon, 14 Nov 2022 13:45:54 +0100
Message-Id: <20221114124445.012533789@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

commit 836078449464e6af3b66ae6652dae79af176f21e upstream.

[[ NOTE: this is completely untested by the author, but included solely
    because, as noted in commit df57d73276b8 ("mmc: sdhci-pci: Fix
    SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers"), "other
    drivers using CQHCI might benefit from a similar change, if they
    also have CQHCI reset by SDHCI_RESET_ALL." We've now seen the same
    bug on at least MSM, Arasan, and Intel hardware. ]]

SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
tracking that properly in software. When out of sync, we may trigger
various timeouts.

It's not typical to perform resets while CQE is enabled, but this may
occur in some suspend or error recovery scenarios.

Include this fix by way of the new sdhci_and_cqhci_reset() helper.

This patch depends on (and should not compile without) the patch
entitled "mmc: cqhci: Provide helper for resetting both SDHCI and
CQHCI".

Fixes: 3c4019f97978 ("mmc: tegra: HW Command Queue Support for Tegra SDMMC")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221026124150.v4.5.I418c9eaaf754880fcd2698113e8c3ef821a944d7@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-tegra.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -24,6 +24,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/ktime.h>
 
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 #include "cqhci.h"
 
@@ -361,7 +362,7 @@ static void tegra_sdhci_reset(struct sdh
 	const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
 	u32 misc_ctrl, clk_ctrl, pad_ctrl;
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (!(mask & SDHCI_RESET_ALL))
 		return;



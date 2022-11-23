Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973DD6354EF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiKWJMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiKWJMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:12:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8841E105AB1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2431C6185C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB6CC433D6;
        Wed, 23 Nov 2022 09:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194713;
        bh=KZcb3HGOc4Q8KBrAokYIfuTuxq6MNqkyKu1YhQ6HDZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCbgYj+zoVPH+ljTCHlryImLy865gmoEU83OR00snNz99zqTBV0nRlbcB2IB1NDC3
         AXrGRmad5cYo3M6W60zj99LXh++DW++Oi+jnx0eUVtG1cMJ/mqWuHoVd/3wbN2aZwB
         V476cecodNENim2s7T8YK2YEMF1odV/uGyKsfh6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Norris <briannorris@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 041/156] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
Date:   Wed, 23 Nov 2022 09:49:58 +0100
Message-Id: <20221123084559.398909381@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

commit 5d249ac37fc2396e8acc1adb0650cdacae5a990d upstream.

SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
tracking that properly in software. When out of sync, we may trigger
various timeouts.

It's not typical to perform resets while CQE is enabled, but one
particular case I hit commonly enough: mmc_suspend() -> mmc_power_off().
Typically we will eventually deactivate CQE (cqhci_suspend() ->
cqhci_deactivate()), but that's not guaranteed -- in particular, if
we perform a partial (e.g., interrupted) system suspend.

The same bug was already found and fixed for two other drivers, in v5.7
and v5.9:

  5cf583f1fb9c ("mmc: sdhci-msm: Deactivate CQE during SDHC reset")
  df57d73276b8 ("mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel
                 GLK-based controllers")

The latter is especially prescient, saying "other drivers using CQHCI
might benefit from a similar change, if they also have CQHCI reset by
SDHCI_RESET_ALL."

So like these other patches, deactivate CQHCI when resetting the
controller. Do this via the new sdhci_and_cqhci_reset() helper.

This patch depends on (and should not compile without) the patch
entitled "mmc: cqhci: Provide helper for resetting both SDHCI and
CQHCI".

Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20221026124150.v4.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-arasan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 
 #include "cqhci.h"
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 
 #define SDHCI_ARASAN_VENDOR_REGISTER	0x78
@@ -264,7 +265,7 @@ static void sdhci_arasan_reset(struct sd
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
 		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);



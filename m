Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3977627A39
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiKNKOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiKNKNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14581F2EE
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:12:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C37360FB4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7FDC433C1;
        Mon, 14 Nov 2022 10:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668420771;
        bh=i+LZXofKrSLAfAEeS2MzNsedB+UX3+FVolG7ApBSI7E=;
        h=Subject:To:Cc:From:Date:From;
        b=iO6P3OVwPq3LeibGc4g4g44Rit/ygylXSFbC1dYbGntLu3US5dVPY0TiAcVWfTICX
         bULcEIUNeQKlvWGrXtAoj+MUvYliTiZpDsuPtfBBiZZA1nKd4KGtuTsOAB+pDF/Hr6
         7vDL7rjkKgEd3Y4Cmv+/tKA68kX+pQNVOuIWPr3A=
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI" failed to apply to 4.19-stable tree
To:     briannorris@chromium.org, adrian.hunter@intel.com,
        linux@roeck-us.net, stable@vger.kernel.org, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:12:48 +0100
Message-ID: <1668420768241176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5d249ac37fc2 ("mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5d249ac37fc2396e8acc1adb0650cdacae5a990d Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Wed, 26 Oct 2022 12:42:04 -0700
Subject: [PATCH] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI

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

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 3997cad1f793..cfb891430174 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -25,6 +25,7 @@
 #include <linux/firmware/xlnx-zynqmp.h>
 
 #include "cqhci.h"
+#include "sdhci-cqhci.h"
 #include "sdhci-pltfm.h"
 
 #define SDHCI_ARASAN_VENDOR_REGISTER	0x78
@@ -366,7 +367,7 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
 
-	sdhci_reset(host, mask);
+	sdhci_and_cqhci_reset(host, mask);
 
 	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
 		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);


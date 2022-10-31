Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE6B61308F
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJaGkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJaGkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:40:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5A95FDA
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FDDFB80D3E
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FDBC433D6;
        Mon, 31 Oct 2022 06:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198397;
        bh=2GCg4EVkLht8h+RMtvHCpyPeCrsEHKF8xhBwvWAbcsA=;
        h=Subject:To:Cc:From:Date:From;
        b=vlhdM82Grie0ngX97FUACpUlSeYkhjJpUPMGje76+0EzRNR8a+qh+4qfiot4yjRy/
         G4OZJ4jZQl0nbCm7SKL/sJRmg7+J5DcxRQtx4RI65T0tHveeOajOAoAh7C69cmDs0Q
         rzb2xleZ3zrdjxQdmA7WwJCxnfLSKW8x0dp6ftHo=
Subject: FAILED: patch "[PATCH] mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake" failed to apply to 5.4-stable tree
To:     ptf@google.com, adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:40:45 +0100
Message-ID: <1667198445119228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9dc0033e4658 ("mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake")
ba8734dfbe87 ("mmc: sdhci-pci: Avoid comma separated statements")
bedf9fc01ff1 ("mmc: sdhci: Workaround broken command queuing on Intel GLK")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9dc0033e4658d6f9d9952c3c0c6be3ec25bc2985 Mon Sep 17 00:00:00 2001
From: Patrick Thompson <ptf@google.com>
Date: Thu, 13 Oct 2022 17:00:17 -0400
Subject: [PATCH] mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake

Enhanced Strobe (ES) does not work correctly on the ASUS 1100 series of
devices. Jasper Lake eMMCs (pci_id 8086:4dc4) are supposed to support
ES. There are also two system families under the series, thus this is
being scoped to the ASUS BIOS.

The failing ES prevents the installer from writing to disk. Falling back
to HS400 without ES fixes the issue.

Signed-off-by: Patrick Thompson <ptf@google.com>
Fixes: 315e3bd7ac19 ("mmc: sdhci-pci: Add support for Intel JSL")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221013210017.3751025-1-ptf@google.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 169b84761041..34ea1acbb3cc 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -914,6 +914,12 @@ static bool glk_broken_cqhci(struct sdhci_pci_slot *slot)
 		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
 }
 
+static bool jsl_broken_hs400es(struct sdhci_pci_slot *slot)
+{
+	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_JSL_EMMC &&
+			dmi_match(DMI_BIOS_VENDOR, "ASUSTeK COMPUTER INC.");
+}
+
 static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	int ret = byt_emmc_probe_slot(slot);
@@ -922,9 +928,11 @@ static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE;
 
 	if (slot->chip->pdev->device != PCI_DEVICE_ID_INTEL_GLK_EMMC) {
-		slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
-		slot->host->mmc_host_ops.hs400_enhanced_strobe =
-						intel_hs400_enhanced_strobe;
+		if (!jsl_broken_hs400es(slot)) {
+			slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
+			slot->host->mmc_host_ops.hs400_enhanced_strobe =
+							intel_hs400_enhanced_strobe;
+		}
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
 	}
 


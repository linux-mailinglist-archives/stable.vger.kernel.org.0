Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2936DEE6E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjDLIln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjDLIlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:41:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B67685
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 811306289E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E46C433D2;
        Wed, 12 Apr 2023 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288812;
        bh=t+zrnDSCYRG5wmnmy56If/bOJ/jkaymnE1OLVXFr6aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7aPY4zcqAiGbO3Z37wIZZtXTbQwWHQ5wLyKTuRLxPOkc/g90o8f7ns2Ln5srjwKF
         f0CeHtCazjzO9eGWDjBikeZy+LZ1ju87fSrdK2nx2FJKceWm/lDpzOpETSdgFulHZm
         LsJLxN3BBDPi3Vqi8uiDqbBL2jEdUwYm1OP20bTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/164] wifi: brcmfmac: Fix SDIO suspend/resume regression
Date:   Wed, 12 Apr 2023 10:32:29 +0200
Message-Id: <20230412082838.071973976@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e4efa515d58f1363d8a27e548f9c5769d3121e03 ]

After commit 92cadedd9d5f ("brcmfmac: Avoid keeping power to SDIO card
unless WOWL is used"), the wifi adapter by default is turned off on suspend
and then re-probed on resume.

In at least 2 model x86/acpi tablets with brcmfmac43430a1 wifi adapters,
the newly added re-probe on resume fails like this:

 brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
 ieee80211 phy1: brcmf_bus_started: failed: -110
 ieee80211 phy1: brcmf_attach: dongle is not responding: err=-110
 brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach failed

It seems this specific brcmfmac model does not like being reprobed without
it actually being turned off first.

And the adapter is not being turned off during suspend because of
commit f0992ace680c ("brcmfmac: prohibit ACPI power management for brcmfmac
driver").

Now that the driver is being reprobed on resume, the disabling of ACPI
pm is no longer necessary, except when WOWL is used (in which case there
is no-reprobe).

Move the dis-/en-abling of ACPI pm to brcmf_sdio_wowl_config(), this fixes
the brcmfmac43430a1 suspend/resume regression and should help save some
power when suspended.

This change means that the code now also may re-enable ACPI pm when WOWL
gets disabled. ACPI pm should only be re-enabled if it was enabled by
the ACPI core originally. Add a brcmf_sdiod_acpi_save_power_manageable()
to save the original state for this.

This has been tested on the following devices:

Asus T100TA                brcmfmac43241b4-sdio
Acer Iconia One 7 B1-750   brcmfmac43340-sdio
Chuwi Hi8                  brcmfmac43430a0-sdio
Chuwi Hi8                  brcmfmac43430a1-sdio

(the Asus T100TA is the device for which the prohibiting of ACPI pm
 was originally added)

Fixes: 92cadedd9d5f ("brcmfmac: Avoid keeping power to SDIO card unless WOWL is used")
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230320122252.240070-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 36 +++++++++++++------
 .../broadcom/brcm80211/brcmfmac/sdio.h        |  2 ++
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d0daef674e728..e300278ea38c6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -991,15 +991,34 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
 
-static void brcmf_sdiod_acpi_set_power_manageable(struct device *dev,
-						  int val)
+static void brcmf_sdiod_acpi_save_power_manageable(struct brcmf_sdio_dev *sdiodev)
 {
 #if IS_ENABLED(CONFIG_ACPI)
 	struct acpi_device *adev;
 
-	adev = ACPI_COMPANION(dev);
+	adev = ACPI_COMPANION(&sdiodev->func1->dev);
 	if (adev)
-		adev->flags.power_manageable = 0;
+		sdiodev->func1_power_manageable = adev->flags.power_manageable;
+
+	adev = ACPI_COMPANION(&sdiodev->func2->dev);
+	if (adev)
+		sdiodev->func2_power_manageable = adev->flags.power_manageable;
+#endif
+}
+
+static void brcmf_sdiod_acpi_set_power_manageable(struct brcmf_sdio_dev *sdiodev,
+						  int enable)
+{
+#if IS_ENABLED(CONFIG_ACPI)
+	struct acpi_device *adev;
+
+	adev = ACPI_COMPANION(&sdiodev->func1->dev);
+	if (adev)
+		adev->flags.power_manageable = enable ? sdiodev->func1_power_manageable : 0;
+
+	adev = ACPI_COMPANION(&sdiodev->func2->dev);
+	if (adev)
+		adev->flags.power_manageable = enable ? sdiodev->func2_power_manageable : 0;
 #endif
 }
 
@@ -1009,7 +1028,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	int err;
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
-	struct device *dev;
 
 	brcmf_dbg(SDIO, "Enter\n");
 	brcmf_dbg(SDIO, "Class=%x\n", func->class);
@@ -1017,14 +1035,9 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(SDIO, "sdio device ID: 0x%04x\n", func->device);
 	brcmf_dbg(SDIO, "Function#: %d\n", func->num);
 
-	dev = &func->dev;
-
 	/* Set MMC_QUIRK_LENIENT_FN0 for this card */
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
-	/* prohibit ACPI power management for this device */
-	brcmf_sdiod_acpi_set_power_manageable(dev, 0);
-
 	/* Consume func num 1 but dont do anything with it. */
 	if (func->num == 1)
 		return 0;
@@ -1055,6 +1068,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	dev_set_drvdata(&sdiodev->func1->dev, bus_if);
 	sdiodev->dev = &sdiodev->func1->dev;
 
+	brcmf_sdiod_acpi_save_power_manageable(sdiodev);
 	brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_DOWN);
 
 	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdiod_probe...\n");
@@ -1120,6 +1134,8 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
 
 	if (sdiodev->settings->bus.sdio.oob_irq_supported ||
 	    pm_caps & MMC_PM_WAKE_SDIO_IRQ) {
+		/* Stop ACPI from turning off the device when wowl is enabled */
+		brcmf_sdiod_acpi_set_power_manageable(sdiodev, !enabled);
 		sdiodev->wowl_enabled = enabled;
 		brcmf_dbg(SDIO, "Configuring WOWL, enabled=%d\n", enabled);
 		return;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index b76d34d36bde6..0d18ed15b4032 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -188,6 +188,8 @@ struct brcmf_sdio_dev {
 	char nvram_name[BRCMF_FW_NAME_LEN];
 	char clm_name[BRCMF_FW_NAME_LEN];
 	bool wowl_enabled;
+	bool func1_power_manageable;
+	bool func2_power_manageable;
 	enum brcmf_sdiod_state state;
 	struct brcmf_sdiod_freezer *freezer;
 	const struct firmware *clm_fw;
-- 
2.39.2




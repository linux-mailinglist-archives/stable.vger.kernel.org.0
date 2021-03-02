Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E0832AF30
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhCCAPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383818AbhCBMLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4904F64F56;
        Tue,  2 Mar 2021 11:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686221;
        bh=ErfQwjmd8r4+acZhXc+ggYrttmA12hddJQe7yT8J+dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bp03qdLa0EpKBNodBNH341Dc0btecAQEzuoC2s8mxnkrIy060Y16HfGdaftls+X2D
         VPmjcmGcjzg0XBN2X/vORk7HiEh3kFU4LxRRhbfJIJjdm1oeDfhuNAZLOjEqGgs4zF
         BgxNSm29M9mHjjckFwYgKVMeqprtfB6S76DYHVxUFU8TQyfNGXe8UpR8smykMgEzTx
         PLOnaonNoGeeGDU0u6n061dA6EzkJSed44zdvS8xYzEleTgsvxF6f3AnyVqucAqIhO
         sF8RtMBgfR4Ak2NraDM5eXWsVR1WOd9agcVxyktRvQ7eAhnW26WkV0q7zjDRgMTMLn
         SA2V+ANViCO1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 5.10 11/47] mmc: sdhci-iproc: Add ACPI bindings for the RPi
Date:   Tue,  2 Mar 2021 06:56:10 -0500
Message-Id: <20210302115646.62291-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit 4f9833d3ec8da34861cd0680b00c73e653877eb9 ]

The RPi4 has an Arasan controller it carries over from the RPi3 and a newer
eMMC2 controller.  Because of a couple of quirks, it seems wiser to bind
these controllers to the same driver that DT is using on this platform
rather than the generic sdhci_acpi driver with PNP0D40.

So, BCM2847 describes the older Arasan and BRCME88C describes the newer
eMMC2. The older Arasan is reusing an existing ACPI _HID used by other OSes
booting these tables on the RPi.

With this change, Linux is capable of utilizing the SD card slot, and the
Wi-Fi when booted with UEFI+ACPI on the RPi4.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210120000406.1843400-2-jeremy.linton@arm.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-iproc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index c9434b461aab..ddeaf8e1f72f 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -296,9 +296,27 @@ static const struct of_device_id sdhci_iproc_of_match[] = {
 MODULE_DEVICE_TABLE(of, sdhci_iproc_of_match);
 
 #ifdef CONFIG_ACPI
+/*
+ * This is a duplicate of bcm2835_(pltfrm_)data without caps quirks
+ * which are provided by the ACPI table.
+ */
+static const struct sdhci_pltfm_data sdhci_bcm_arasan_data = {
+	.quirks = SDHCI_QUIRK_BROKEN_CARD_DETECTION |
+		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
+		  SDHCI_QUIRK_NO_HISPD_BIT,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.ops = &sdhci_iproc_32only_ops,
+};
+
+static const struct sdhci_iproc_data bcm_arasan_data = {
+	.pdata = &sdhci_bcm_arasan_data,
+};
+
 static const struct acpi_device_id sdhci_iproc_acpi_ids[] = {
 	{ .id = "BRCM5871", .driver_data = (kernel_ulong_t)&iproc_cygnus_data },
 	{ .id = "BRCM5872", .driver_data = (kernel_ulong_t)&iproc_data },
+	{ .id = "BCM2847",  .driver_data = (kernel_ulong_t)&bcm_arasan_data },
+	{ .id = "BRCME88C", .driver_data = (kernel_ulong_t)&bcm2711_data },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(acpi, sdhci_iproc_acpi_ids);
-- 
2.30.1


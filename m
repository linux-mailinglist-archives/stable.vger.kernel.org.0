Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A96C32AF0C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhCCAOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239897AbhCBL7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:59:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 358A364F1E;
        Tue,  2 Mar 2021 11:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686152;
        bh=ErfQwjmd8r4+acZhXc+ggYrttmA12hddJQe7yT8J+dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XP6P24H240Tye0ruZC9Qwek9earLpWIqr5sehOHc0paKBIhECq7rfcag9vufnksRt
         4aZlx/KJ+f3jrQZTAth84KYAVPUicU1Vvzeke3WjphK48yMgE3+LVua4xoCbokoDqm
         3BAWSIQd0KTI4/MoOiBE3UIyl0t1GBPzQzngP9py5wxz6nv57tzyfQI9otlFc4bRRp
         1BezxcIZY2p3A1QxPi5gejUghT0qrCIgTvNDfcZLVu9AFHvKeMUKO21b6ri/xE5DVb
         VJTaFfdsx1FSHw0uV5c13JSu6dCkIE2xXHETwMqYEMDW364GMCw71ctJT0otl18gVv
         ICHPdgF1+9u7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 5.11 13/52] mmc: sdhci-iproc: Add ACPI bindings for the RPi
Date:   Tue,  2 Mar 2021 06:54:54 -0500
Message-Id: <20210302115534.61800-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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


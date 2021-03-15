Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C287033B8DE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhCOOEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhCOOA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CE764F40;
        Mon, 15 Mar 2021 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816801;
        bh=8Ot3fnhF37NWp6SS6AiQuMpnw4SuJYw28xAlGF+me/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEZl7zBeASVfBVwp9m4Qc0vNW5wEXAlIOqf9U9yM6bV8F0a9DBt+VdpMmkJnIqY88
         6n6Fo40voGaEk8PSbZnzMqWLAUR8EW3FTZG0dZq7xXFddZili34XZEAIqFvRxC0D9o
         6w53cq3mtDlMcMu+/C8E6Forsdv78Yrvt4cIJn0Q=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 133/306] mmc: sdhci-iproc: Add ACPI bindings for the RPi
Date:   Mon, 15 Mar 2021 14:53:16 +0100
Message-Id: <20210315135512.147381673@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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




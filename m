Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1C02A55C7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387591AbgKCVFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387804AbgKCVFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:05:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708F720658;
        Tue,  3 Nov 2020 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437523;
        bh=zAYSBpAeCBEf4/TMh31w9RjdOdb04PUkKjzvWRPX8rE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxv/PCNfFtRG8rbAiSH06afZEZ2MSvIEJJbBdzjyzyxXqE1kAv7joYG1lQwib0Ba0
         o6zSTVegCXf/XO7f8Pbbo6vJ9TuqIhzzowXKH14Lu6BPnLgO/NMflhBtU0eEjyAeya
         JB8Qw4jOPBuUxjF6/97gFSNSk7c5qgg6a8Rv8Ph8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 113/191] mmc: sdhci-acpi: AMDI0040: Set SDHCI_QUIRK2_PRESET_VALUE_BROKEN
Date:   Tue,  3 Nov 2020 21:36:45 +0100
Message-Id: <20201103203244.020938935@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

commit f23cc3ba491af77395cea3f9d51204398729f26b upstream.

This change fixes HS400 tuning for devices with invalid presets.

SDHCI presets are not currently used for eMMC HS/HS200/HS400, but are
used for DDR52. The HS400 retuning sequence is:

    HS400->DDR52->HS->HS200->Perform Tuning->HS->HS400

This means that when HS400 tuning happens, we transition through DDR52
for a very brief period. This causes presets to be enabled
unintentionally and stay enabled when transitioning back to HS200 or
HS400. Some firmware has invalid presets, so we end up with driver
strengths that can cause I/O problems.

Fixes: 34597a3f60b1 ("mmc: sdhci-acpi: Add support for ACPI HID of AMD Controller with HS400")
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200928154718.1.Icc21d4b2f354e83e26e57e270dc952f5fe0b0a40@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-acpi.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -546,6 +546,43 @@ static int sdhci_acpi_emmc_amd_probe_slo
 	    (host->mmc->caps & MMC_CAP_1_8V_DDR))
 		host->mmc->caps2 = MMC_CAP2_HS400_1_8V;
 
+	/*
+	 * There are two types of presets out in the wild:
+	 * 1) Default/broken presets.
+	 *    These presets have two sets of problems:
+	 *    a) The clock divisor for SDR12, SDR25, and SDR50 is too small.
+	 *       This results in clock frequencies that are 2x higher than
+	 *       acceptable. i.e., SDR12 = 25 MHz, SDR25 = 50 MHz, SDR50 =
+	 *       100 MHz.x
+	 *    b) The HS200 and HS400 driver strengths don't match.
+	 *       By default, the SDR104 preset register has a driver strength of
+	 *       A, but the (internal) HS400 preset register has a driver
+	 *       strength of B. As part of initializing HS400, HS200 tuning
+	 *       needs to be performed. Having different driver strengths
+	 *       between tuning and operation is wrong. It results in different
+	 *       rise/fall times that lead to incorrect sampling.
+	 * 2) Firmware with properly initialized presets.
+	 *    These presets have proper clock divisors. i.e., SDR12 => 12MHz,
+	 *    SDR25 => 25 MHz, SDR50 => 50 MHz. Additionally the HS200 and
+	 *    HS400 preset driver strengths match.
+	 *
+	 *    Enabling presets for HS400 doesn't work for the following reasons:
+	 *    1) sdhci_set_ios has a hard coded list of timings that are used
+	 *       to determine if presets should be enabled.
+	 *    2) sdhci_get_preset_value is using a non-standard register to
+	 *       read out HS400 presets. The AMD controller doesn't support this
+	 *       non-standard register. In fact, it doesn't expose the HS400
+	 *       preset register anywhere in the SDHCI memory map. This results
+	 *       in reading a garbage value and using the wrong presets.
+	 *
+	 *       Since HS400 and HS200 presets must be identical, we could
+	 *       instead use the the SDR104 preset register.
+	 *
+	 *    If the above issues are resolved we could remove this quirk for
+	 *    firmware that that has valid presets (i.e., SDR12 <= 12 MHz).
+	 */
+	host->quirks2 |= SDHCI_QUIRK2_PRESET_VALUE_BROKEN;
+
 	host->mmc_host_ops.select_drive_strength = amd_select_drive_strength;
 	host->mmc_host_ops.set_ios = amd_set_ios;
 	return 0;



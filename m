Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8842C3CA948
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbhGOTGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242147AbhGOTFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF4061410;
        Thu, 15 Jul 2021 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375666;
        bh=IRsGpvDEnLkZB5pmpCU3pQWTY0mzb8GmeLn91RKR1EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXHQCk2wlrKh6kn8++/Xyc71O4siogeklZ+/4JTzXwq4LGYNU6a9CYSwJiynVaqKF
         gRUSP8W8GGaYmC22z9IXCD0ecaNhTzP9dnTKbyafu+Yw1a0eADBDhXuKPDRDQlmaT9
         HNfy1JqcvVm/LIXsC9hDw9FUlwzKhb7EhO4+8ctI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.12 184/242] mmc: sdhci: Fix warning message when accessing RPMB in HS400 mode
Date:   Thu, 15 Jul 2021 20:39:06 +0200
Message-Id: <20210715182625.737490739@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

commit d0244847f9fc5e20df8b7483c8a4717fe0432d38 upstream.

When an eMMC device is being run in HS400 mode, any access to the
RPMB device will cause the error message "mmc1: Invalid UHS-I mode
selected". This happens as a result of tuning being disabled before
RPMB access and then re-enabled after the RPMB access is complete.
When tuning is re-enabled, the system has to switch from HS400
to HS200 to do the tuning and then back to HS400. As part of
sequence to switch from HS400 to HS200 the system is temporarily
put into HS mode. When switching to HS mode, sdhci_get_preset_value()
is called and does not have support for HS mode and prints the warning
message and returns the preset for SDR12. The fix is to add support
for MMC and SD HS modes to sdhci_get_preset_value().

This can be reproduced on any system running eMMC in HS400 mode
(not HS400ES) by using the "mmc" utility to run the following
command: "mmc rpmb read-counter /dev/mmcblk0rpmb".

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 52983382c74f ("mmc: sdhci: enhance preset value function")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210624163045.33651-1-alcooperx@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    4 ++++
 drivers/mmc/host/sdhci.h |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1812,6 +1812,10 @@ static u16 sdhci_get_preset_value(struct
 	u16 preset = 0;
 
 	switch (host->timing) {
+	case MMC_TIMING_MMC_HS:
+	case MMC_TIMING_SD_HS:
+		preset = sdhci_readw(host, SDHCI_PRESET_FOR_HIGH_SPEED);
+		break;
 	case MMC_TIMING_UHS_SDR12:
 		preset = sdhci_readw(host, SDHCI_PRESET_FOR_SDR12);
 		break;
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -253,6 +253,7 @@
 
 /* 60-FB reserved */
 
+#define SDHCI_PRESET_FOR_HIGH_SPEED	0x64
 #define SDHCI_PRESET_FOR_SDR12 0x66
 #define SDHCI_PRESET_FOR_SDR25 0x68
 #define SDHCI_PRESET_FOR_SDR50 0x6A



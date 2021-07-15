Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D1E3CAB25
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243427AbhGOTRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242871AbhGOTPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E46160FF4;
        Thu, 15 Jul 2021 19:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376327;
        bh=/90fiOXrGHLe77dycWdZCTCuRQWKsBP2W2WUifJhfkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsnR7Mo17dDIqtoSgx7tAKrAXcPjikAUjLXZa/Jh0Kll0XAeO8NCOX/hKUXgBYV2q
         Wba30HjuCmQ+6WEJn8NGGzp5D05z2DgnnW3FI87wlkX0FLinxZsZSzwMRYaz4TeI8L
         yLVycHTavP8u48seah+Xb86qkyLloHPQLLC54ZuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.13 207/266] mmc: sdhci-acpi: Disable write protect detection on Toshiba Encore 2 WT8-B
Date:   Thu, 15 Jul 2021 20:39:22 +0200
Message-Id: <20210715182646.487320475@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 94ee6782e045645abd9180ab9369b01293d862bd upstream.

On the Toshiba Encore 2 WT8-B the  microSD slot always reports the card
being write-protected even though microSD cards do not have a write-protect
switch at all.

Add a new DMI_QUIRK_SD_NO_WRITE_PROTECT quirk entry to sdhci-acpi.c's
DMI quirk table for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20210503092157.5689-1-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-acpi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -822,6 +822,17 @@ static const struct dmi_system_id sdhci_
 		},
 		.driver_data = (void *)DMI_QUIRK_SD_NO_WRITE_PROTECT,
 	},
+	{
+		/*
+		 * The Toshiba WT8-B's microSD slot always reports the card being
+		 * write-protected.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TOSHIBA ENCORE 2 WT8-B"),
+		},
+		.driver_data = (void *)DMI_QUIRK_SD_NO_WRITE_PROTECT,
+	},
 	{} /* Terminating entry */
 };
 



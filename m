Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38013CA94A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242906AbhGOTGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241945AbhGOTFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C326140E;
        Thu, 15 Jul 2021 19:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375663;
        bh=ycKDcYRU63u++MEQW5GMUFIHAdewgNEfveiRYcO5XWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcST4rcnUASwVuGkfZOkOV/K7kxtVjZirmwymaK5/FwXT2ahfFk7kcG7MjOBPQMox
         h2ZTC+vJFjZUdFsmrVP7mT5+ExiA0Bl3UJmzlOIsQxDS/AWrCW4A/Wezk3cYbSiGsl
         puzO6qU/YyDQ9SfJpJZUBDFHHIQgh5VUL21KQpTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.12 183/242] mmc: sdhci-acpi: Disable write protect detection on Toshiba Encore 2 WT8-B
Date:   Thu, 15 Jul 2021 20:39:05 +0200
Message-Id: <20210715182625.545157496@linuxfoundation.org>
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
@@ -820,6 +820,17 @@ static const struct dmi_system_id sdhci_
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
 



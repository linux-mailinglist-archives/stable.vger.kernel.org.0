Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B573632E918
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCEMag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230081AbhCEMaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C77465019;
        Fri,  5 Mar 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947408;
        bh=PUTTA7UBEvU0HaT7S4PhHxjbYy29Y+6RCwlrVeYLfd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwcxN8bWPR42vkz9DIjQtdbBP9pbEGcwDsjNm4RrkCRw1k+SNV9FMZ1wDH0gZzG7r
         It6GPFHUu2ta8xqa3Gc454a6W/rysIAhv1jwTjVEq7vJ1ZsL+WTD+easWBc4+AHX2g
         sNwAqo0xS+EKND73VM560kka2Xq4FCj6wXCkkClc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/102] brcmfmac: Add DMI nvram filename quirk for Predia Basic tablet
Date:   Fri,  5 Mar 2021 13:21:14 +0100
Message-Id: <20210305120905.997649317@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit af4b3a6f36d6c2fc5fca026bccf45e0fdcabddd9 ]

The Predia Basic tablet contains quite generic names in the sys_vendor and
product_name DMI strings, without this patch brcmfmac will try to load:
brcmfmac43340-sdio.Insyde-CherryTrail.txt as nvram file which is a bit
too generic.

Add a DMI quirk so that a unique and clearly identifiable nvram file name
is used on the Predia Basic tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210129171413.139880-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 4aa2561934d7..824a79f24383 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -40,6 +40,10 @@ static const struct brcmf_dmi_data pov_tab_p1006w_data = {
 	BRCM_CC_43340_CHIP_ID, 2, "pov-tab-p1006w-data"
 };
 
+static const struct brcmf_dmi_data predia_basic_data = {
+	BRCM_CC_43341_CHIP_ID, 2, "predia-basic"
+};
+
 static const struct dmi_system_id dmi_platform_data[] = {
 	{
 		/* ACEPC T8 Cherry Trail Z8350 mini PC */
@@ -111,6 +115,16 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&pov_tab_p1006w_data,
 	},
+	{
+		/* Predia Basic tablet (+ with keyboard dock) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CherryTrail"),
+			/* Mx.WT107.KUBNGEA02 with the version-nr dropped */
+			DMI_MATCH(DMI_BIOS_VERSION, "Mx.WT107.KUBNGEA"),
+		},
+		.driver_data = (void *)&predia_basic_data,
+	},
 	{}
 };
 
-- 
2.30.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0632E9C1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhCEMei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232490AbhCEMeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:34:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E03BF6501A;
        Fri,  5 Mar 2021 12:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947664;
        bh=hK/Ok1kevv7pLNz660F0pBVsk5zM3LWPxclkES4qxNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xjh1zH4stIYezWQ7jmjTpvNtmkte7uGfhE4EIBp+OgTQwxGX0VRAtNkhcsNYXk68i
         2o0EJKwJwvC9h/XNVsTTV3faTmWAnVw3H/KQ8fM1iKpR+GR1q7LT/xPCk6yrV3mmQZ
         abSOb+3gCYOvbyxKbqHoUGtBEWMQFq5LKDE5j40Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/72] brcmfmac: Add DMI nvram filename quirk for Voyo winpad A15 tablet
Date:   Fri,  5 Mar 2021 13:21:42 +0100
Message-Id: <20210305120859.306868273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a338c874d3d9d2463f031e89ae14942929b93db6 ]

The Voyo winpad A15 tablet contains quite generic names in the sys_vendor
and product_name DMI strings, without this patch brcmfmac will try to load:
rcmfmac4330-sdio.To be filled by O.E.M.-To be filled by O.E.M..txt
as nvram file which is a bit too generic.

Add a DMI quirk so that a unique and clearly identifiable nvram file name
is used on the Voyo winpad A15 tablet.

While preparing a matching linux-firmware update I noticed that the nvram
is identical to the nvram used on the Prowise-PT301 tablet, so the new DMI
quirk entry simply points to the already existing Prowise-PT301 nvram file.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210129171413.139880-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/dmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 824a79f24383..6d5188b78f2d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -44,6 +44,14 @@ static const struct brcmf_dmi_data predia_basic_data = {
 	BRCM_CC_43341_CHIP_ID, 2, "predia-basic"
 };
 
+/* Note the Voyo winpad A15 tablet uses the same Ampak AP6330 module, with the
+ * exact same nvram file as the Prowise-PT301 tablet. Since the nvram for the
+ * Prowise-PT301 is already in linux-firmware we just point to that here.
+ */
+static const struct brcmf_dmi_data voyo_winpad_a15_data = {
+	BRCM_CC_4330_CHIP_ID, 4, "Prowise-PT301"
+};
+
 static const struct dmi_system_id dmi_platform_data[] = {
 	{
 		/* ACEPC T8 Cherry Trail Z8350 mini PC */
@@ -125,6 +133,16 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&predia_basic_data,
 	},
+	{
+		/* Voyo winpad A15 tablet */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "11/20/2014"),
+		},
+		.driver_data = (void *)&voyo_winpad_a15_data,
+	},
 	{}
 };
 
-- 
2.30.1




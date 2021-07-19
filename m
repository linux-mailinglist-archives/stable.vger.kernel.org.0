Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811B93CE2E2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhGSPcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347621AbhGSPaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF53C6141E;
        Mon, 19 Jul 2021 16:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710991;
        bh=j4v5bf/wFIPeGXrivdJqrxD4COA5DL2k+uD4+wcYois=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thkZRWgfVSTHYzN960HbIY4JlFMSQC5Q71OHVpxVSPxJATDvs6OdMcxXVV1yJBgs9
         KkBSZ1M91rrfuD0VBQX7sC1ULgrb6mZ3hqFBCc8AL/juBXEkW43fe2nj+oqt/F65dI
         wORkPbOXkKwT+3XQknFWxR0LLJrcNjiQlCqAZuB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 186/351] power: supply: axp288_fuel_gauge: Make "T3 MRD" no_battery_list DMI entry more generic
Date:   Mon, 19 Jul 2021 16:52:12 +0200
Message-Id: <20210719144951.133330019@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3a06b912a5ce494d7b7300b12719c562be7b566f ]

It turns out that the "T3 MRD" DMI_BOARD_NAME value is used in a lot of
different Cherry Trail x5-z8300 / x5-z8350 based Mini-PC / HDMI-stick
models from Ace PC / Meegopad / MinisForum / Wintel (and likely also
other vendors).

Most of the other DMI strings on these boxes unfortunately contain various
generic values like "Default string" or "$(DEFAULT_STRING)", so we cannot
match on them. These devices do have their chassis-type correctly set to a
value of "3" (desktop) which is a pleasant surprise, so also match on that.

This should avoid the quirk accidentally also getting applied to laptops /
tablets (which do actually have a battery). Although in my quite large
database of Bay and Cherry Trail based devices DMIdecode dumps I don't
have any laptops / tables with a board-name of "T3 MRD", so this should
not be an issue.

BugLink: https://askubuntu.com/questions/1206714/how-can-a-mini-pc-be-stopped-from-being-detected-as-a-laptop-with-a-battery/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_fuel_gauge.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index 39e16ecb7638..37af0e216bc3 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -723,15 +723,6 @@ static const struct dmi_system_id axp288_fuel_gauge_blacklist[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MEEGOPAD T02"),
 		},
 	},
-	{
-		/* Meegopad T08 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Default string"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "To be filled by OEM."),
-			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
-			DMI_MATCH(DMI_BOARD_VERSION, "V1.1"),
-		},
-	},
 	{	/* Mele PCG03 Mini PC */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Mini PC"),
@@ -745,6 +736,15 @@ static const struct dmi_system_id axp288_fuel_gauge_blacklist[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
 		}
 	},
+	{
+		/* Various Ace PC/Meegopad/MinisForum/Wintel Mini-PCs/HDMI-sticks */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "3"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
+			DMI_MATCH(DMI_BIOS_VERSION, "5.11"),
+		},
+	},
 	{}
 };
 
-- 
2.30.2




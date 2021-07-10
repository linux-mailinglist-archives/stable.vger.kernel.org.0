Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44C13C37CF
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhGJXxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232804AbhGJXwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 087F861360;
        Sat, 10 Jul 2021 23:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960998;
        bh=j4v5bf/wFIPeGXrivdJqrxD4COA5DL2k+uD4+wcYois=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LB2ymUxlhqw/9G4qjF/rVDWHZ7AyhkEmwditIM5rNTg0/GfqZlowSzUuNoSojATPr
         RwOBBxIMvku2SibX3ZKXq7rqbq9QLxorYfrxW2O7JdoBdwAhQXd219RzehRZPNR470
         XXKYxwB5jlko1AANN8Ysu132yN/uVCWnkXZ+TFAp/UgvBUjmd7AykjF2hFyK0unFMW
         MW1VZkgrwpvuMUFepZAfk2vbtoI7Arv9330NZQkl1lxleEHRkLOS808sW/OI2HL1Ct
         j/dbQMgRII1RgtSKLU76PX4RZYlLgrsbwLLswMfj16sCcVMSB/NW7sxZa36mZNnAi8
         z8GkmsYVwmt0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 30/43] power: supply: axp288_fuel_gauge: Make "T3 MRD" no_battery_list DMI entry more generic
Date:   Sat, 10 Jul 2021 19:49:02 -0400
Message-Id: <20210710234915.3220342-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


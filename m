Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162D71A9F48
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409390AbgDOMIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897599AbgDOLrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EED02166E;
        Wed, 15 Apr 2020 11:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951226;
        bh=pPR3E/+TEmW7X9ElB0tBqcMc5d+em6cDWmEOV6tWQKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT1btFCTd4Kgwu1k97sSmd+E/ypWQJZ6e4AHMVV0qrHVFH1Jo9AGsDCiccZzI5TZu
         CulewAps3mTt2hHe4ZrzWlcmuYa8IDLqBAtVtWoSWVITH7+NfDyscWZjXUcueQIL65
         O5GFM6g69sb7NUuyiaNwkDYJU9Wjcgm1/GzAcprQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffery Miller <jmiller@neverware.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/40] power: supply: axp288_fuel_gauge: Broaden vendor check for Intel Compute Sticks.
Date:   Wed, 15 Apr 2020 07:46:20 -0400
Message-Id: <20200415114623.14972-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffery Miller <jmiller@neverware.com>

[ Upstream commit e42fe5b29ac07210297e75f36deefe54edbdbf80 ]

The Intel Compute Stick `STK1A32SC` can have a system vendor of
"Intel(R) Client Systems".
Broaden the Intel Compute Stick DMI checks so that they match "Intel
Corporation" as well as "Intel(R) Client Systems".

This fixes an issue where the STK1A32SC compute sticks were still
exposing a battery with the existing blacklist entry.

Signed-off-by: Jeffery Miller <jmiller@neverware.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_fuel_gauge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index ab0b6e78ca02a..157cf5ec6b023 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -718,14 +718,14 @@ static const struct dmi_system_id axp288_fuel_gauge_blacklist[] = {
 	{
 		/* Intel Cherry Trail Compute Stick, Windows version */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "STK1AW32SC"),
 		},
 	},
 	{
 		/* Intel Cherry Trail Compute Stick, version without an OS */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "STK1A32SC"),
 		},
 	},
-- 
2.20.1


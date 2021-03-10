Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4808D333E0C
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhCJNZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233057AbhCJNYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AAE864FE8;
        Wed, 10 Mar 2021 13:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382690;
        bh=7bBPpaRXg6o6zGfJIf+9ivk/DwHRISsQu9zyZ7eUcfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bO3O7NgtbcZ4W6ZYohQF36dBcHNGAM91lpmGMdUj1ME3c+mJtHM3DoUMZgQFBM9DR
         V5cM29L4A1X0amHe9LJ5EWtRSwJ32IVfEnmGt5WmkvW2WXeZcPQFARs/vI5QSDgXgh
         xKjPmGfG+tiEH2GPTPu+V8DS4voGg6rUaj4HoHec=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 31/36] ASoC: Intel: sof_sdw: reorganize quirks by generation
Date:   Wed, 10 Mar 2021 14:23:44 +0100
Message-Id: <20210310132321.495115658@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 3d09cf8d0d791a41a75123e135f604d59f4aa870 ]

The quirk table is a mess, let's reorganize it by generation before
making sure that the quirks are consistent for each generation.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210208233336.59449-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 73 +++++++++++++++++---------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index daca06dde99b..9e2e8f508ed4 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -48,37 +48,14 @@ static int sof_sdw_quirk_cb(const struct dmi_system_id *id)
 }
 
 static const struct dmi_system_id sof_sdw_quirk_table[] = {
+	/* CometLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A32")
-		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					SOF_RT711_JD_SRC_JD2 |
-					SOF_RT715_DAI_ID_FIX |
-					SOF_SDW_FOUR_SPK),
-	},
-	{
-		.callback = sof_sdw_quirk_cb,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A3E")
-		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					SOF_RT711_JD_SRC_JD2 |
-					SOF_RT715_DAI_ID_FIX),
-	},
-	{
-		.callback = sof_sdw_quirk_cb,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A5E")
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CometLake Client"),
 		},
-		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
-					SOF_RT711_JD_SRC_JD2 |
-					SOF_RT715_DAI_ID_FIX |
-					SOF_SDW_FOUR_SPK),
+		.driver_data = (void *)SOF_SDW_PCH_DMIC,
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
@@ -109,7 +86,7 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
-		{
+	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
@@ -119,6 +96,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
+	/* IceLake devices */
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Ice Lake Client"),
+		},
+		.driver_data = (void *)SOF_SDW_PCH_DMIC,
+	},
+	/* TigerLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
@@ -134,18 +121,23 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Ice Lake Client"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A3E")
 		},
-		.driver_data = (void *)SOF_SDW_PCH_DMIC,
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_RT711_JD_SRC_JD2 |
+					SOF_RT715_DAI_ID_FIX),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CometLake Client"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A5E")
 		},
-		.driver_data = (void *)SOF_SDW_PCH_DMIC,
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_RT711_JD_SRC_JD2 |
+					SOF_RT715_DAI_ID_FIX |
+					SOF_SDW_FOUR_SPK),
 	},
 	{
 		.callback = sof_sdw_quirk_cb,
@@ -167,7 +159,18 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_SDW_PCH_DMIC |
 					SOF_SDW_FOUR_SPK),
 	},
-
+	/* TigerLake-SDCA devices */
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A32")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_RT711_JD_SRC_JD2 |
+					SOF_RT715_DAI_ID_FIX |
+					SOF_SDW_FOUR_SPK),
+	},
 	{}
 };
 
-- 
2.30.1




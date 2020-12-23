Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D662E172B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgLWDHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgLWCSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2942722285;
        Wed, 23 Dec 2020 02:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689879;
        bh=H1AdHkaBE5KZkU3gYtSTtWOkJBNX+B4Axt/lxQXiXEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmW1+lVnRPieZmWp1OTdxheXA2UZTV81WNkrzPQMIdsr0P3K97rHD+MyHUGKN45lm
         T4OFHBtN3BswCtwt+qOrisyf8mw0Pu6FlGnva7PvzrlEYvcSf51peAYPXP/kVujJU7
         gNWVMm9CGmIcWptVsoiTcu8/l17o+V/cCZpDb10olKzBs9Q1EDJ4p8DC0LJKa8qKxI
         e7ikl95kuM/vadLUpssIM55NtdEbsy6oWsup8cW8Ml+K+CapUeI0mE7iLwXerXReRV
         mAjbOI7Asej/GlzcukOMF1ZdaU3qjifHFeCtkYocCXsD7TloRxuhGEP04Q6sJnPuWT
         EI0RdiY03y/3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 070/217] ASoC: Intel: sof_sdw: add quirk for new TigerLake-SDCA device
Date:   Tue, 22 Dec 2020 21:13:59 -0500
Message-Id: <20201223021626.2790791-70-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 488cdbd8931fe4bc7f374a8b429e81d0e4b7ac76 ]

Add quirks for jack detection, rt715 DAI and number of speakers.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Link: https://lore.kernel.org/r/20201111214318.150529-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index b29946eb43551..ca968901ac96f 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -48,6 +48,16 @@ static int sof_sdw_quirk_cb(const struct dmi_system_id *id)
 }
 
 static const struct dmi_system_id sof_sdw_quirk_table[] = {
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A32")
+		},
+		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+					SOF_RT715_DAI_ID_FIX |
+					SOF_SDW_FOUR_SPK),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.27.0


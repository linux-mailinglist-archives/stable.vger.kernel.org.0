Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8B45C2B3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349660AbhKXNb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351049AbhKXN3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:29:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6571D61548;
        Wed, 24 Nov 2021 12:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758313;
        bh=8gin4xYFGZZvnvIufp+YTmpLpY//PfSLSiDa2pG5IrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VJhCOsDwjwy+VvQjT1ZJPGbvmgYGragFTSOI9iRYyX1tRSBKMWQvCq5GWTSLjmGd
         0h6CiM35Spd6uh4YS3N0YS7cHpEUi71nf1VwvAdlrs08G0xFkFJFLUwfEpUHaIErGB
         A7MhEO3LbYCAjEnuzAjXdv8dTzR7La9BAAjrTNeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/154] ASoC: Intel: sof_sdw: add missing quirk for Dell SKU 0A45
Date:   Wed, 24 Nov 2021 12:57:04 +0100
Message-Id: <20211124115703.278367629@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 64ba6d2ce72ffde70dc5a1794917bf1573203716 ]

This device is based on SDCA codecs but with a single amplifier
instead of two.

BugLink: https://github.com/thesofproject/linux/issues/3161
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20211004213512.220836-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 25548555d8d79..d9b864856be19 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -187,6 +187,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A45")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_RT715_DAI_ID_FIX),
+	},
 	/* AlderLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.33.0




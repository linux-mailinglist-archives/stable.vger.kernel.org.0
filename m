Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD62328E52
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbhCAT1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:27:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241554AbhCATYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD9564ED9;
        Mon,  1 Mar 2021 17:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618794;
        bh=3XJNhc8dqDir7OJsr/oXPv22aujYCTxP9PbKfQ+J9Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViHeVRW5IeB0smeeb5kPFUbMkBuVLWDYt0cNfAYd0ICpFBBk2V3d0uEy/5kux9dXh
         IsOV7udjJ2Wo5QK12qhX1pebpIERaXr4HWs3bT0JeLzsfM7//Qtzx3e99j/3Zqddbt
         qAwtV+LUGrclYhkbjQe3H5nETe3ZapHRG7JBlnB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/663] ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A5E
Date:   Mon,  1 Mar 2021 17:07:47 +0100
Message-Id: <20210301161152.630341912@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f12bbc50f3b14c9b8ed902c6d1da980dd5addcce ]

We missed adding the TGL_HDMI quirk which is very much needed to
expose the 4 display pipelines and will be required on TGL topologies.

Fixes: 9ad9bc59dde10 ('ASoC: Intel: sof_sdw: set proper flags for Dell TGL-H SKU 0A5E')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210204203312.27112-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index a8d43c87cb5a2..3945cb61b95a0 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -63,7 +63,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A5E")
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_RT711_JD_SRC_JD2 |
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0C8328D41
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbhCATIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241002AbhCATDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93D7D65334;
        Mon,  1 Mar 2021 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620741;
        bh=fTP304i9ax/AbNYsUn+Nye1KCND9LW/UqsX0IHRsYmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXcfacm1BBIXEc3rh4wdW9uKpYgFPP9VCyZa5ZXgvJVdxdfCYKHtdYbrQLfOEgY73
         47gE7sj3KFsmTcyVsCfuF9Ldka/waJBCRLPgyUFKv0i9xaJm0yi8OwmbSZVCnhOhqE
         a8aEU83RHEJ5wVpbzbNLC2s0lpo+5R42Yzy2Zs50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 261/775] ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A5E
Date:   Mon,  1 Mar 2021 17:07:09 +0100
Message-Id: <20210301161214.535166914@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 6d0d6ef711e0f..29b6bba3d4257 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -73,7 +73,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D306333E2B
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhCJNZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233178AbhCJNZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C680F64FE0;
        Wed, 10 Mar 2021 13:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382702;
        bh=mWKgiM90xWGEZ7uNtcaRT3FhLD3Rrjk6Uyw/7xBk/ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+Ke7QnHVEMpEM5GA43qeQQs+exSg5hA+57b06KBBVE5Gn7vblcO9Ov2ftZbNQQUv
         uxJarwHV0YJPENe/la/DrB+BcqZbm31sjWtSEofp2dhlpWGDEBbMhJaxk20bYLrxYo
         Nuc4etKNBn7auBItCnM6Tyqik3bP8V94JcfK//iU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/49] ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A32
Date:   Wed, 10 Mar 2021 14:23:42 +0100
Message-Id: <20210310132322.924975281@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 45c92ec32b43c6cb42341ebf07577eefed9d87ec ]

We missed adding the TGL_HDMI quirk which is very much needed to
expose the 4 display pipelines and will be required on TGL topologies.

Fixes: 488cdbd8931fe ('ASoC: Intel: sof_sdw: add quirk for new TigerLake-SDCA device')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210204203312.27112-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 9519e5403cbf..daca06dde99b 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -54,7 +54,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A32")
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_RT711_JD_SRC_JD2 |
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
-- 
2.30.1




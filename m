Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E8D32E952
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCEMcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230214AbhCEMbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE036501A;
        Fri,  5 Mar 2021 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947492;
        bh=RXbyjtAOyXiMC8bIraWZO7C8vXtNmPjjN1rkD8x2pg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIvb0IekjP1Ix8LNx/XwQvyFfTJ6q5wtG4+S6Ch7/95pIgvQE0chbBOvQ816Msnuc
         EzIjKQ45tayOHnVoDyBWkugyBq9QE20hGHYmJ9ugaRPbUVBuBuI100IFtLe2Vh7uYY
         iTdQnKyEhs2wx/FTZ85Q1uDZHETw/SEwZLoj3Jb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bard Liao <bard.liao@intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/102] ASoC: Intel: sof_sdw: detect DMIC number based on mach params
Date:   Fri,  5 Mar 2021 13:21:35 +0100
Message-Id: <20210305120907.017649813@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit f88dcb9b98d3f86ead04d2453475267910448bb8 ]

Current driver create DMIC dai based on quirk for each platforms,
so we need to add quirk for new platforms. Now driver reports DMIC
number to machine driver and machine driver can create DMIC dai based
on this information. The old check is reserved for some platforms
may be failed to set the DMIC number in BIOS.

Reviewed-by: Bard Liao <bard.liao@intel.com>
Signed-off-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210208233336.59449-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index d441ef324c06..0f1d845a0cca 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -925,7 +925,7 @@ static int sof_card_dai_links_create(struct device *dev,
 		ctx->idisp_codec = true;
 
 	/* enable dmic01 & dmic16k */
-	dmic_num = (sof_sdw_quirk & SOF_SDW_PCH_DMIC) ? 2 : 0;
+	dmic_num = (sof_sdw_quirk & SOF_SDW_PCH_DMIC || mach_params->dmic_num) ? 2 : 0;
 	comp_num += dmic_num;
 
 	dev_dbg(dev, "sdw %d, ssp %d, dmic %d, hdmi %d", sdw_be_num, ssp_num,
-- 
2.30.1




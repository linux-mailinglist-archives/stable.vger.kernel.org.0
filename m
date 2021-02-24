Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5969F323CF9
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhBXNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:01:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235418AbhBXMzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 329C564F2A;
        Wed, 24 Feb 2021 12:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171106;
        bh=yHEIALki3xGjYnguiSFsS0rOY+sSE3bgcFZPPAhQZc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMMfn9JUMlPgwLYqlcULlHXdX9oVEqZgf5iQzVuFiKIn+n7dC1U6IyO2fR+IVRvjS
         4xjQ49ab6rlCcAABMusO1F4wjvyKCblhfvnURKYUxkjzq1DHzkWKwlGI7CDdd+jbGW
         7OTqqP4vn0lYAFKjzfHfPDxLEg2594jq/iu/Z9eejNXOBN8CYXF2smYQFXGtylG49D
         9sSMLYUPZQBYZMxVC4p14Sp3ZJduuMCCYX0sd+CmRv9zcTWPpGLpExEcL+vPV7jB0Y
         5i8ovLZHjRXXkDyP+RkmlQukdf9U4lMYVBLR9So1YXYLVd2zht6aSr2heOivLpr4uJ
         eJ/i/3KzH8AMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 59/67] ASoC: Intel: sof_sdw: detect DMIC number based on mach params
Date:   Wed, 24 Feb 2021 07:50:17 -0500
Message-Id: <20210224125026.481804-59-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6e4b2fdb0dcf6..9983bf6356b1f 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -933,7 +933,7 @@ static int sof_card_dai_links_create(struct device *dev,
 		ctx->idisp_codec = true;
 
 	/* enable dmic01 & dmic16k */
-	dmic_num = (sof_sdw_quirk & SOF_SDW_PCH_DMIC) ? 2 : 0;
+	dmic_num = (sof_sdw_quirk & SOF_SDW_PCH_DMIC || mach_params->dmic_num) ? 2 : 0;
 	comp_num += dmic_num;
 
 	dev_dbg(dev, "sdw %d, ssp %d, dmic %d, hdmi %d", sdw_be_num, ssp_num,
-- 
2.27.0


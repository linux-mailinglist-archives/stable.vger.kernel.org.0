Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC7328B12
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbhCAS2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239765AbhCASWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 206206535A;
        Mon,  1 Mar 2021 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620746;
        bh=UOi5plGmmYK3KRsKIzc63RJ8Yep74cFcaNp5dy4/2I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHVab+a9pIYCujNiWreQCC/6s7apfRi9O25eCDqiTzY3Bct0lXdI8AyY4GBOsN6U7
         xtpFK/LMWbgnediGv2UOTnryyRvg2btSjqTrCXzZWGZeKL2f+rnZ63n8jsqnW2Exl7
         TAUFB+P1p26d7mKZdTiBsg3Zu3mh0Dv4ilJdev3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 263/775] ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A3E
Date:   Mon,  1 Mar 2021 17:07:11 +0100
Message-Id: <20210301161214.631278518@linuxfoundation.org>
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

[ Upstream commit 5ab3ff4d66960be766a544886667e7c002f17fd6 ]

We missed adding the TGL_HDMI quirk which is very much needed to
expose the 4 display pipelines and will be required on TGL topologies.

Fixes: e787f5b5b1406 ('ASoC: Intel: add support for new SoundWire hardware layout on TGL')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210204203312.27112-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index afdc336ec9bf5..152ea166eeaef 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -65,7 +65,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A3E")
 		},
-		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_RT711_JD_SRC_JD2 |
 					SOF_RT715_DAI_ID_FIX),
 	},
 	{
-- 
2.27.0




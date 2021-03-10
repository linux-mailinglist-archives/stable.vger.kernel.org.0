Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930A6333E0D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhCJNZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhCJNYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 713ED64FD7;
        Wed, 10 Mar 2021 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382691;
        bh=jnvREqkWOwfPsE+m6wvepIilJ/GqGuTcWPGG1RVnuB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrRcncJ96MHrEIptgqgFN27G5w9kf10IB1a5q3CmnEaJZNVzcYRVJ3i4FJQplOGqN
         Akq+nzpyuLfaa6+D9hWYdvbI8NhA31kGB5qWyn73playI9MX44VXFQAND33/PfN3Py
         Exnh8dgKXr0ap73w6LUwT/vmXZUZJ1jwCOhA+1Oc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 32/36] ASoC: Intel: sof_sdw: add quirk for HP Spectre x360 convertible
Date:   Wed, 10 Mar 2021 14:23:45 +0100
Message-Id: <20210310132321.524091477@linuxfoundation.org>
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

[ Upstream commit d92e279dee56b4b65c1af21f972413f172a9734a ]

This set of devices has SoundWire support along with DMICs.
The DMI information was provided by users for 3 separate skus.

BugLink: https://github.com/thesofproject/linux/issues/2700
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210208233336.59449-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 9e2e8f508ed4..1d7677376e74 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -159,6 +159,22 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_SDW_PCH_DMIC |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		/*
+		 * this entry covers multiple HP SKUs. The family name
+		 * does not seem robust enough, so we use a partial
+		 * match that ignores the product name suffix
+		 * (e.g. 15-eb1xxx, 14t-ea000 or 13-aw2xxx)
+		 */
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Convertible"),
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
+					SOF_RT711_JD_SRC_JD2),
+	},
 	/* TigerLake-SDCA devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.30.1




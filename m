Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612744637EB
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243527AbhK3O5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47804 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243080AbhK3Ox5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6BD9B81A31;
        Tue, 30 Nov 2021 14:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD4FC53FC1;
        Tue, 30 Nov 2021 14:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283835;
        bh=A22XXWwFZsaNMVBUtGFCTiRIpWxh3OaMnoIPT+1EzTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjuZ3dmn5W+abvPIX3xjcepjfgQhSGJ/wRpbUWGNLo/q02bfu0/pABHffmT8vE80G
         YXAVx2UdP49uZZUwTehnJILh0HAVeBlyaOmVkcjd3O/EbJcJMmx/Z7dg/g2VTigG3K
         Ssd+85Y2oZiJHuV2dcpKZyKpIsEmDs+FDZept/hZaZEvDIQO+ozTYll/E4g2IQR7fU
         utgzcLkew4Vnv/3vFLXvN4fXdHtDeHzJvBLFQE1aL1pFTCJCkVKJ/0Ut7lTdmXr0yP
         G+SFgIi1KewOfRLKaYDeanuad6v3HQX6maZFiYubFoP5tTEV2epbDECsfhGrCYu/tt
         D9jCFIEb1opXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gongjun Song <gongjun.song@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, kai.vehmanen@linux.intel.com,
        libin.yang@intel.com, yong.zhi@intel.com,
        vamshi.krishna.gopal@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 04/43] ASoC: Intel: sof_sdw: Add support for SKU 0B11 product
Date:   Tue, 30 Nov 2021 09:49:41 -0500
Message-Id: <20211130145022.945517-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gongjun Song <gongjun.song@intel.com>

[ Upstream commit 6fef4c2f458680399b7c512cb810c1e1784d7444 ]

This product supports a SoundWire headset codec, SoundWire
capture from local microphones and two SoundWire amplifiers.

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 5738aff4937fc..c7a6a4d6570cf 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -229,6 +229,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2 |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B11")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_SDW_FOUR_SPK),
+	},
 	{}
 };
 
-- 
2.33.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4E74EC019
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343849AbiC3Lsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343823AbiC3Lss (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5518C25DAA2;
        Wed, 30 Mar 2022 04:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA582615B7;
        Wed, 30 Mar 2022 11:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24E8C340EE;
        Wed, 30 Mar 2022 11:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640820;
        bh=a+hYV3dWe1oVsX+cvNgh7RLaS51GSRre3hs0wbTB+k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2uP9fqI7ApUQ0nAdxfB5YEJN6Zh8mEKqA6lJar2pdp6t9KEPaVPrMMNLGrYhdSFb
         YZKR/jXe3nR+IXZQhpPgnLC/KArLyDGTxIBLWvbEtGRo0Ci7dmLwbBB5//pE1ObnQh
         LfgN/0DKXuc779kNuQYi4ZkkQ/LBj1vVzPydekM/fuVMeKcCr5KNxM+i6+Hz8cAFnd
         3eoK/SuxiIaoPazf1fw7syBdNo30OdYfrvH4ob+tgDOC/exVjIzCIx/LrVgFXnjIAm
         OpyvzM3MqFiCYJyyY71TGepgsre0njcnnQ7TUlnpd+j0Rz9BixfLnd3AfEeW27v1KK
         yK3HfSwAI682w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        Reddy Muralidhar <muralidhar.reddy@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 08/66] ASoC: SOF: Intel: match sdw version on link_slaves_found
Date:   Wed, 30 Mar 2022 07:45:47 -0400
Message-Id: <20220330114646.1669334-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit f67c0c0d3b9048d86ea6ae52e36a2b78c48f265d ]

Codecs with the same part id, manufacturer id and part id, but different
sdw version should be treated as different codecs. For example, rt711 and
rt711-sdca are different. So, we should match sdw version as well.

Reported-by: Reddy Muralidhar <muralidhar.reddy@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220120232157.199919-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 1385695d7745..848d1d563170 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1188,7 +1188,7 @@ static bool link_slaves_found(struct snd_sof_dev *sdev,
 	struct hdac_bus *bus = sof_to_bus(sdev);
 	struct sdw_intel_slave_id *ids = sdw->ids;
 	int num_slaves = sdw->num_slaves;
-	unsigned int part_id, link_id, unique_id, mfg_id;
+	unsigned int part_id, link_id, unique_id, mfg_id, version;
 	int i, j, k;
 
 	for (i = 0; i < link->num_adr; i++) {
@@ -1198,12 +1198,14 @@ static bool link_slaves_found(struct snd_sof_dev *sdev,
 		mfg_id = SDW_MFG_ID(adr);
 		part_id = SDW_PART_ID(adr);
 		link_id = SDW_DISCO_LINK_ID(adr);
+		version = SDW_VERSION(adr);
 
 		for (j = 0; j < num_slaves; j++) {
 			/* find out how many identical parts were reported on that link */
 			if (ids[j].link_id == link_id &&
 			    ids[j].id.part_id == part_id &&
-			    ids[j].id.mfg_id == mfg_id)
+			    ids[j].id.mfg_id == mfg_id &&
+			    ids[j].id.sdw_version == version)
 				reported_part_count++;
 		}
 
@@ -1212,21 +1214,24 @@ static bool link_slaves_found(struct snd_sof_dev *sdev,
 
 			if (ids[j].link_id != link_id ||
 			    ids[j].id.part_id != part_id ||
-			    ids[j].id.mfg_id != mfg_id)
+			    ids[j].id.mfg_id != mfg_id ||
+			    ids[j].id.sdw_version != version)
 				continue;
 
 			/* find out how many identical parts are expected */
 			for (k = 0; k < link->num_adr; k++) {
 				u64 adr2 = link->adr_d[k].adr;
-				unsigned int part_id2, link_id2, mfg_id2;
+				unsigned int part_id2, link_id2, mfg_id2, version2;
 
 				mfg_id2 = SDW_MFG_ID(adr2);
 				part_id2 = SDW_PART_ID(adr2);
 				link_id2 = SDW_DISCO_LINK_ID(adr2);
+				version2 = SDW_VERSION(adr2);
 
 				if (link_id2 == link_id &&
 				    part_id2 == part_id &&
-				    mfg_id2 == mfg_id)
+				    mfg_id2 == mfg_id &&
+				    version2 == version)
 					expected_part_count++;
 			}
 
-- 
2.34.1


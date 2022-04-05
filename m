Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE64F32A6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353595AbiDEKIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344435AbiDEJT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D751BDF16;
        Tue,  5 Apr 2022 02:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE19161564;
        Tue,  5 Apr 2022 09:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09B9C385A1;
        Tue,  5 Apr 2022 09:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149699;
        bh=qMSq2ZM7H+t3XIYKOQd73sqX230ds6e20YdaLYU4CE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRF3RG0K1xl0Cwo3M4+IzUqsitx89FGqT7EQePtzt9GlSb+WgdyFUewN2yc8O6Hue
         caIQ9HZsMP5FLFf5X20L9L1MTc04iJ6NqQfe/jjHQX9qNkzLOcijn3io8km1FGh5YE
         WqvIJwBMVv59r9B8DSG3B+f7JG49A5+Q5ASELz28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reddy Muralidhar <muralidhar.reddy@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0810/1017] ASoC: SOF: Intel: match sdw version on link_slaves_found
Date:   Tue,  5 Apr 2022 09:28:43 +0200
Message-Id: <20220405070418.291130906@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 25200a0e1dc9..fc88296ab898 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1200,7 +1200,7 @@ static bool link_slaves_found(struct snd_sof_dev *sdev,
 	struct hdac_bus *bus = sof_to_bus(sdev);
 	struct sdw_intel_slave_id *ids = sdw->ids;
 	int num_slaves = sdw->num_slaves;
-	unsigned int part_id, link_id, unique_id, mfg_id;
+	unsigned int part_id, link_id, unique_id, mfg_id, version;
 	int i, j, k;
 
 	for (i = 0; i < link->num_adr; i++) {
@@ -1210,12 +1210,14 @@ static bool link_slaves_found(struct snd_sof_dev *sdev,
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
 
@@ -1224,21 +1226,24 @@ static bool link_slaves_found(struct snd_sof_dev *sdev,
 
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




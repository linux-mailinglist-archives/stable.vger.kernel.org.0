Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF3574247
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiGNEW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiGNEWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:22:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E5127CD7;
        Wed, 13 Jul 2022 21:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4D52B8236F;
        Thu, 14 Jul 2022 04:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80F5C34114;
        Thu, 14 Jul 2022 04:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772556;
        bh=RSnp9C2IndBNx40Bwal1Q5B/rLmbGmA+LVLBOoQj7bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqIVFXQYm9ycoh8YGzg0IbxVCekBmxwfZ1MGgKkqfiW+1cT9LdBcw9sxwC8mK2rWj
         4NbRkQ45Cneg3ifs86xjL2uivfrq7wh5AeGMDC4hFleIbyYUSzsfuGrYc0oqL0rqZD
         YcsCX2XPNpMRhrj0fMSmP8K/6vWAeMPZkWCUsdOMtajqj6N1ZHMqO6EZlWyqxmv/xC
         Wt2cyzDdBuslnbWHxS0mKm9scHPksNChRVXbYmN+UUmNiBpik8MqRaRKHxd9gJ/6lH
         Lj/QRL52Xr/1hGO7vmzZ1ofA0cyzt840F2gl6w9gVZjLNqWTUnugyeoZ9e8smKQXAg
         0whGGWE85ClKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, gongjun.song@intel.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 05/41] ASoC: Intel: sof_sdw: handle errors on card registration
Date:   Thu, 14 Jul 2022 00:21:45 -0400
Message-Id: <20220714042221.281187-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit fe154c4ff376bc31041c6441958a08243df09c99 ]

If the card registration fails, typically because of deferred probes,
the device properties added for headset codecs are not removed, which
leads to kernel oopses in driver bind/unbind tests.

We already clean-up the device properties when the card is removed,
this code can be moved as a helper and called upon card registration
errors.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 51 ++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 1f00679b4240..ad826ad82d51 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1398,6 +1398,33 @@ static struct snd_soc_card card_sof_sdw = {
 	.late_probe = sof_sdw_card_late_probe,
 };
 
+static void mc_dailink_exit_loop(struct snd_soc_card *card)
+{
+	struct snd_soc_dai_link *link;
+	int ret;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(codec_info_list); i++) {
+		if (!codec_info_list[i].exit)
+			continue;
+		/*
+		 * We don't need to call .exit function if there is no matched
+		 * dai link found.
+		 */
+		for_each_card_prelinks(card, j, link) {
+			if (!strcmp(link->codecs[0].dai_name,
+				    codec_info_list[i].dai_name)) {
+				ret = codec_info_list[i].exit(card, link);
+				if (ret)
+					dev_warn(card->dev,
+						 "codec exit failed %d\n",
+						 ret);
+				break;
+			}
+		}
+	}
+}
+
 static int mc_probe(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = &card_sof_sdw;
@@ -1462,6 +1489,7 @@ static int mc_probe(struct platform_device *pdev)
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 	if (ret) {
 		dev_err(card->dev, "snd_soc_register_card failed %d\n", ret);
+		mc_dailink_exit_loop(card);
 		return ret;
 	}
 
@@ -1473,29 +1501,8 @@ static int mc_probe(struct platform_device *pdev)
 static int mc_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct snd_soc_dai_link *link;
-	int ret;
-	int i, j;
 
-	for (i = 0; i < ARRAY_SIZE(codec_info_list); i++) {
-		if (!codec_info_list[i].exit)
-			continue;
-		/*
-		 * We don't need to call .exit function if there is no matched
-		 * dai link found.
-		 */
-		for_each_card_prelinks(card, j, link) {
-			if (!strcmp(link->codecs[0].dai_name,
-				    codec_info_list[i].dai_name)) {
-				ret = codec_info_list[i].exit(card, link);
-				if (ret)
-					dev_warn(&pdev->dev,
-						 "codec exit failed %d\n",
-						 ret);
-				break;
-			}
-		}
-	}
+	mc_dailink_exit_loop(card);
 
 	return 0;
 }
-- 
2.35.1


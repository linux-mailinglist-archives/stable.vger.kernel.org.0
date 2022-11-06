Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614D561E3AD
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiKFRER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiKFREJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:04:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108D8F02D;
        Sun,  6 Nov 2022 09:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB7D5B80C69;
        Sun,  6 Nov 2022 17:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31E0C433D6;
        Sun,  6 Nov 2022 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754242;
        bh=o2+ts7+oQiXTOP7MINi299O0Ta42vbh8+bm3bKn2TRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiprFO/H8NWZrZc4a0SjzKk+C+XUKeTsVUnlMbQj8W7Zw4bMcmqM8GuotcYs0T15n
         TwbGioGn50rdyPQP2TqTj01LTC7E29w4uI9ZMnCj/q8fUNu28o6t6C7DgXztGROUx0
         8qkyHJgvm3ei7bWOs4zdJMZNaCXoxHa9/jG1kW6DWFOTDbWxQY5uAdREgKVvVmlJYX
         srNb/wLFUBxzvIJT/dtjLX5z0CqTW+ck1+4f2sTAQaERbXnOdZwn+zUzSPPPjtHypa
         fMRvh9EfQYeZZl4aGG3cesnDygcf7XJa2F/58DaKFgpQ8KCK09Z/xVm9FlS/eUEVQt
         0GrBDjgYS7CTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        steve@sk2.org, chi.minghao@zte.com.cn,
        ckeepax@opensource.cirrus.com, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 06/30] ASoC: mt6660: Keep the pm_runtime enables before component stuff in mt6660_i2c_probe
Date:   Sun,  6 Nov 2022 12:03:18 -0500
Message-Id: <20221106170345.1579893-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit c4ab29b0f3a6f1e167c5a627f7cd036c1d2b7d65 ]

It would be better to keep the pm_runtime enables before the
IRQ and component stuff. Both of those could start triggering
PM runtime events.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221008140522.134912-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6660.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/mt6660.c b/sound/soc/codecs/mt6660.c
index 45e0df13afb9..b8369eeccc30 100644
--- a/sound/soc/codecs/mt6660.c
+++ b/sound/soc/codecs/mt6660.c
@@ -503,14 +503,14 @@ static int mt6660_i2c_probe(struct i2c_client *client)
 		dev_err(chip->dev, "read chip revision fail\n");
 		goto probe_fail;
 	}
+	pm_runtime_set_active(chip->dev);
+	pm_runtime_enable(chip->dev);
 
 	ret = devm_snd_soc_register_component(chip->dev,
 					       &mt6660_component_driver,
 					       &mt6660_codec_dai, 1);
-	if (!ret) {
-		pm_runtime_set_active(chip->dev);
-		pm_runtime_enable(chip->dev);
-	}
+	if (ret)
+		pm_runtime_disable(chip->dev);
 
 	return ret;
 
-- 
2.35.1


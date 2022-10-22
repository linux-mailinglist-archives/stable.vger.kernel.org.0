Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB05D6089F3
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiJVIpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbiJVIoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:44:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A1B2E96B0;
        Sat, 22 Oct 2022 01:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D376B82E0C;
        Sat, 22 Oct 2022 07:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8CAC433D6;
        Sat, 22 Oct 2022 07:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424977;
        bh=/DO/MJLKGlxxqHVavgVn6SazxotEdrvId6km3FQ0/N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOjb5HI0DtqH/aI+BLrpGRCM+sAqU33Og9kp923XiHH6FcHPziecHbBbS9eWU8IdJ
         LTjuMpe6qS9OBVCHZ94pjxdA3HgXa0MoWF9TDR36TYZvFR8r2t4hSSToy+IARNaSZR
         1ygnIOBVlsqN2zgpp/A+bls/VBv2rL2KimK3HOdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 346/717] ASoC: mt6660: Fix PM disable depth imbalance in mt6660_i2c_probe
Date:   Sat, 22 Oct 2022 09:23:45 +0200
Message-Id: <20221022072510.953833349@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit b73f11e895e140537e7f8c7251211ccd3ce0782b ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by moving
pm_runtime_enable to the endding of mt6660_i2c_probe.

Fixes:f289e55c6eeb4 ("ASoC: Add MediaTek MT6660 Speaker Amp Driver")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220928160116.125020-5-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6660.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/mt6660.c b/sound/soc/codecs/mt6660.c
index ba11555796ad..45e0df13afb9 100644
--- a/sound/soc/codecs/mt6660.c
+++ b/sound/soc/codecs/mt6660.c
@@ -503,13 +503,17 @@ static int mt6660_i2c_probe(struct i2c_client *client)
 		dev_err(chip->dev, "read chip revision fail\n");
 		goto probe_fail;
 	}
-	pm_runtime_set_active(chip->dev);
-	pm_runtime_enable(chip->dev);
 
 	ret = devm_snd_soc_register_component(chip->dev,
 					       &mt6660_component_driver,
 					       &mt6660_codec_dai, 1);
+	if (!ret) {
+		pm_runtime_set_active(chip->dev);
+		pm_runtime_enable(chip->dev);
+	}
+
 	return ret;
+
 probe_fail:
 	_mt6660_chip_power_on(chip, 0);
 	mutex_destroy(&chip->io_lock);
-- 
2.35.1




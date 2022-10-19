Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5672860480D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiJSNsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiJSNrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EDDDED11;
        Wed, 19 Oct 2022 06:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3791DB82433;
        Wed, 19 Oct 2022 08:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ACFC433C1;
        Wed, 19 Oct 2022 08:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169869;
        bh=/DO/MJLKGlxxqHVavgVn6SazxotEdrvId6km3FQ0/N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngoY4gRpv1imChIHVLSGYKYSm83F9QLCJgiIH/Oye8OaGzvuuqd0YcsEcUPGioNdW
         Vp54NJjd9vaO14WtsM98Y/Xa3Z8thFFVIKDDriHE7fwEnS2I2HP4SshFl0MDW0r3cl
         Yh5yDRGoqgCwp3gvg9IZrwzPinmiJRfmX7su67xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 412/862] ASoC: mt6660: Fix PM disable depth imbalance in mt6660_i2c_probe
Date:   Wed, 19 Oct 2022 10:28:19 +0200
Message-Id: <20221019083308.168101481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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




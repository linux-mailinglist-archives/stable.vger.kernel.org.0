Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F16357A5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbiKWJnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiKWJnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8D81147A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:40:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A23CEB81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07949C433D6;
        Wed, 23 Nov 2022 09:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196447;
        bh=7bkjzNFgv06mgFZhBGfKKNT7XUPvaaeDT+Fwn24uAoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VR9OcySKiXycksi8fDTHG2vH54MdAaREm5HGC1qJTyNTUe8iaIB6ko/hn97GjuMY
         YG5AVYq6tAIhh9ak7p9bEGE2zHfDwz3HoyxYMO6WfywQ2pBQWlvEBBPuVcOpMFCYV8
         5/g+QrXLn+uhzmW9qPABBQNVPxuineVg28uzH4J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 006/314] ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"
Date:   Wed, 23 Nov 2022 09:47:31 +0100
Message-Id: <20221123084625.776709045@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 68ce83e3bb26feba0fcdd59667fde942b3a600a1 ]

This reverts commit 41a736ac20602f64773e80f0f5b32cde1830a44a.

The pm_runtime_disable is redundant when error returns in
wm8997_probe, we just revert the old patch to fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221010114852.88127-4-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8997.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 77136a521605..210ad662fc26 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1161,6 +1161,9 @@ static int wm8997_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm8997_digital_vu[i],
 				   WM8997_DIG_VU, WM8997_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	arizona_init_common(arizona);
 
 	ret = arizona_init_vol_limit(arizona);
@@ -1179,9 +1182,6 @@ static int wm8997_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
-- 
2.35.1




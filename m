Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC656584CD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiL1RDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbiL1RCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:02:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46C01FCC2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28013B8188D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE37C433D2;
        Wed, 28 Dec 2022 16:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246593;
        bh=+2f/ByGGh8mwTX2fIHF/zc9Wwd3FoVMz8xvFRmI5psw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y++lne1Rnpfd1mpHXDND4eceBAoa3eoW3nUMRYhNTFYRD9zCGnXRRO9iwpAI3kgMK
         rpvB1eqgm/YRufP4sqCif/6VwKccs4L0WzzxAGnxRbMx2u8pWK6mc1gVICXK1QZ4Od
         7LePU4ygm61g6QCMpzE9Z84SK960Olx2v78mjdu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1066/1146] ASoC: sof_es8336: fix possible use-after-free in sof_es8336_remove()
Date:   Wed, 28 Dec 2022 15:43:25 +0100
Message-Id: <20221228144359.218361866@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1b41beaa7a58467505ec3023af8aad74f878b888 ]

sof_es8336_remove() calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This
means that the callback function may still be running after
the driver's remove function has finished, which would result
in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Fixes: 89cdb224f2ab ("ASoC: sof_es8336: reduce pop noise on speaker")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221205143721.3988988-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 70713e4b07dc..773e5d1d87d4 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -783,7 +783,7 @@ static int sof_es8336_remove(struct platform_device *pdev)
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 	struct sof_es8336_private *priv = snd_soc_card_get_drvdata(card);
 
-	cancel_delayed_work(&priv->pcm_pop_work);
+	cancel_delayed_work_sync(&priv->pcm_pop_work);
 	gpiod_put(priv->gpio_speakers);
 	device_remove_software_node(priv->codec_dev);
 	put_device(priv->codec_dev);
-- 
2.35.1




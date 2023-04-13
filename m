Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C509C6E0467
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjDMCih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDMChq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:37:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9507A84;
        Wed, 12 Apr 2023 19:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B9FE63A82;
        Thu, 13 Apr 2023 02:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408DEC433A1;
        Thu, 13 Apr 2023 02:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353429;
        bh=FxSpL+k7mWLJ/yG1GbUE51+sbJSmAkqDaYqGJUi2tiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pD2pF47I99PzOen4dCdKulzNGNs8og7DEeWeBuYMmACpKy08czk24yWrTViSE/JoR
         RDS0vmXrEGCbE+fnxnyeQjLh0H8qPt7E1qD8qdE3ng8lTIzALiYlTuoo/dXbqKkTzM
         tLzxe65eVa22ZNHcsAZ+NoeNd/qRRmhocSpf+sMjMo/YwbAdCx3uU0k9BlW33RhHBG
         BuaTSG7p+2W+g+3JR5FPrwm2AiWWZDsel17NpZ92l0UZxMUp8AVdnfsvBPEWDxxqSe
         ea380QsRcXencgftLqkAHGhdKp2U4uYApcOk2C8xhZEbZo05J4OsLBJJ3+1S/+84WN
         qNmrw0/giyhLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duy Nguyen <duy.nguyen.rh@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Khanh Le <khanh.le.xr@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        support.opensource@diasemi.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 08/17] ASoC: da7213.c: add missing pm_runtime_disable()
Date:   Wed, 12 Apr 2023 22:36:36 -0400
Message-Id: <20230413023647.74661-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023647.74661-1-sashal@kernel.org>
References: <20230413023647.74661-1-sashal@kernel.org>
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

From: Duy Nguyen <duy.nguyen.rh@renesas.com>

[ Upstream commit 44378cd113e5f15bb0a89f5ac5a0e687b52feb90 ]

da7213.c is missing pm_runtime_disable(), thus we will get
below error when rmmod -> insmod.

	$ rmmod  snd-soc-da7213.ko
	$ insmod snd-soc-da7213.ko
	da7213 0-001a: Unbalanced pm_runtime_enable!"

[Kuninori adjusted to latest upstream]

Signed-off-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Khanh Le <khanh.le.xr@renesas.com>
Link: https://lore.kernel.org/r/87mt3xg2tk.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7213.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/da7213.c b/sound/soc/codecs/da7213.c
index 544ccbcfc8844..5678683c71bee 100644
--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -1996,6 +1996,11 @@ static int da7213_i2c_probe(struct i2c_client *i2c)
 	return ret;
 }
 
+static void da7213_i2c_remove(struct i2c_client *i2c)
+{
+	pm_runtime_disable(&i2c->dev);
+}
+
 static int __maybe_unused da7213_runtime_suspend(struct device *dev)
 {
 	struct da7213_priv *da7213 = dev_get_drvdata(dev);
@@ -2039,6 +2044,7 @@ static struct i2c_driver da7213_i2c_driver = {
 		.pm = &da7213_pm,
 	},
 	.probe_new	= da7213_i2c_probe,
+	.remove		= da7213_i2c_remove,
 	.id_table	= da7213_i2c_id,
 };
 
-- 
2.39.2


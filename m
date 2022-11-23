Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2886635D8A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbiKWMnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237068AbiKWMmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6926D492;
        Wed, 23 Nov 2022 04:41:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 276BFB81F3F;
        Wed, 23 Nov 2022 12:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD2FC4347C;
        Wed, 23 Nov 2022 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207305;
        bh=9eK/YfM8SsXmkglH0WxqzhlfaZd4V7b6t66rSlpQoZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ek8ZpV+pNfmu3anjult1dt3yk4NRgA50qZr2oHN5EFOdr58OJPuSYQKtNBs2gBwUp
         n5kwNc+9B5hcXmtJGnkwHbGAmgx/DNuamkVV7h97nfbzjovI0zGkt6IXd9x07aAK7A
         53NBBttYJw6l7wfvP7IAqXjaJku8bvR1Fg9fI/X3pfjZrhYHl2BEg36QgLlMh9U1rM
         +gsGeGcHKAZw2G5scOou8Se5/xC8wnhFgxswaA99oE8Nlyhh/qDAyNxJ/KgIvSdjV1
         pG8G1NgnJSYewAFLUwKfBrlX5kA94+lLQyRH3zCPx7VNEr2zYAnxbJ9tUDVfU60RAP
         yyx59Y/hO53ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olivier Moysan <olivier.moysan@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, arnaud.pouliquen@foss.st.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        alsa-devel@alsa-project.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 19/44] ASoC: stm32: dfsdm: manage cb buffers cleanup
Date:   Wed, 23 Nov 2022 07:40:28 -0500
Message-Id: <20221123124057.264822-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
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

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 7d945b046be3d2605dbb1806e73095aadd7ae129 ]

Ensure that resources allocated by iio_channel_get_all_cb()
are released on driver unbind.

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20221109170849.273719-1-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_adfsdm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/stm/stm32_adfsdm.c b/sound/soc/stm/stm32_adfsdm.c
index 643fc8a17018..837c1848d9bf 100644
--- a/sound/soc/stm/stm32_adfsdm.c
+++ b/sound/soc/stm/stm32_adfsdm.c
@@ -304,6 +304,11 @@ static int stm32_adfsdm_dummy_cb(const void *data, void *private)
 	return 0;
 }
 
+static void stm32_adfsdm_cleanup(void *data)
+{
+	iio_channel_release_all_cb(data);
+}
+
 static struct snd_soc_component_driver stm32_adfsdm_soc_platform = {
 	.open		= stm32_adfsdm_pcm_open,
 	.close		= stm32_adfsdm_pcm_close,
@@ -350,6 +355,12 @@ static int stm32_adfsdm_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->iio_cb))
 		return PTR_ERR(priv->iio_cb);
 
+	ret = devm_add_action_or_reset(&pdev->dev, stm32_adfsdm_cleanup, priv->iio_cb);
+	if (ret < 0)  {
+		dev_err(&pdev->dev, "Unable to add action\n");
+		return ret;
+	}
+
 	component = devm_kzalloc(&pdev->dev, sizeof(*component), GFP_KERNEL);
 	if (!component)
 		return -ENOMEM;
-- 
2.35.1


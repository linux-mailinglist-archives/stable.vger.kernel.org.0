Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293D066C4AE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjAPP5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjAPP5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7E6234EB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 931ECB81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0DAC433F1;
        Mon, 16 Jan 2023 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884618;
        bh=CSjnrmGcOwKxEg3v82J1nM3cCnXwSL8rJzqR53Oq7YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8OPt7CdbIS7cAzflujK8WnStqx5iGOZVnETffqfp2bHotsHNhw2L+u4P72KmG/aV
         xE6/tlcPA1qCchjzfyRBqhFiWRUb4utKgM+5p7atOKqDCYiMfsCQNk/bBf25VoaHn0
         XF7KceOfdJTtt/we1GWpFzTiqp7Z9gk0RfXS1ac8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 044/183] ASoC: rt9120: Make dev PM runtime bind AsoC component PM
Date:   Mon, 16 Jan 2023 16:49:27 +0100
Message-Id: <20230116154805.239336956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: ChiYuan Huang <cy_huang@richtek.com>

commit 7161bd540eebebae2bbe8c79de25d8caf12dbf78 upstream.

RT9120 uses PM runtime autosuspend to decrease the frequently on/off
spent time. This exists one case, when pcm is closed and dev PM is
waiting for autosuspend time expired to enter runtime suspend state.
At the mean time, system is going to enter suspend, dev PM runtime
suspend won't be called. It makes the rt9120 suspend consumption
current not as expected.

This patch can fix the rt9120 dev PM issue during runtime autosuspend
and system suspend by binding dev PM runtime and ASoC component PM.

Fixes: 80b949f332e3 ("ASoC: rt9120: Use pm_runtime and regcache to optimize 'pwdnn' logic")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/1672301033-3675-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt9120.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/rt9120.c b/sound/soc/codecs/rt9120.c
index 644300e88b4c..fcf4fbaed3c7 100644
--- a/sound/soc/codecs/rt9120.c
+++ b/sound/soc/codecs/rt9120.c
@@ -177,8 +177,20 @@ static int rt9120_codec_probe(struct snd_soc_component *comp)
 	return 0;
 }
 
+static int rt9120_codec_suspend(struct snd_soc_component *comp)
+{
+	return pm_runtime_force_suspend(comp->dev);
+}
+
+static int rt9120_codec_resume(struct snd_soc_component *comp)
+{
+	return pm_runtime_force_resume(comp->dev);
+}
+
 static const struct snd_soc_component_driver rt9120_component_driver = {
 	.probe = rt9120_codec_probe,
+	.suspend = rt9120_codec_suspend,
+	.resume = rt9120_codec_resume,
 	.controls = rt9120_snd_controls,
 	.num_controls = ARRAY_SIZE(rt9120_snd_controls),
 	.dapm_widgets = rt9120_dapm_widgets,
-- 
2.39.0




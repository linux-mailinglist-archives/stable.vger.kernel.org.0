Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAEB6D4A3F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjDCOp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbjDCOpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0751216959
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6054361F1E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D43C4339B;
        Mon,  3 Apr 2023 14:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533092;
        bh=9hA8GOSLTaZsVHBMX+sww97sJaQFGvNAehI835JPCIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vB240l3gMO3DS9VaWFIUaDPhKIBosFnAs21WKPTQllUI/xIGXkkS+KyiZWMzm7D20
         SWxHzsTj3ZO5FsYKdKpizJ/WgVJuioR82VY+Rlfy8L7o9syMRJ/loM3R9MvYzdDdyq
         AbqKuuZ62ki0hy+AEdpdkDMIW95VUwRGGkAhpIMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 021/187] ASoC: Intel: avs: nau8825: Adjust clock control
Date:   Mon,  3 Apr 2023 16:07:46 +0200
Message-Id: <20230403140416.728439697@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 6206b2e787da2ed567922c37bb588a44f6fb6705 ]

Internal clock shall be adjusted also in cases when DAPM event other
than 'ON' is triggered.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230303134854.2277146-6-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/nau8825.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/intel/avs/boards/nau8825.c b/sound/soc/intel/avs/boards/nau8825.c
index 6731d8a490767..49438a67a77c6 100644
--- a/sound/soc/intel/avs/boards/nau8825.c
+++ b/sound/soc/intel/avs/boards/nau8825.c
@@ -33,15 +33,15 @@ avs_nau8825_clock_control(struct snd_soc_dapm_widget *w, struct snd_kcontrol *co
 		return -EINVAL;
 	}
 
-	if (!SND_SOC_DAPM_EVENT_ON(event)) {
+	if (SND_SOC_DAPM_EVENT_ON(event))
+		ret = snd_soc_dai_set_sysclk(codec_dai, NAU8825_CLK_MCLK, 24000000,
+					     SND_SOC_CLOCK_IN);
+	else
 		ret = snd_soc_dai_set_sysclk(codec_dai, NAU8825_CLK_INTERNAL, 0, SND_SOC_CLOCK_IN);
-		if (ret < 0) {
-			dev_err(card->dev, "set sysclk err = %d\n", ret);
-			return ret;
-		}
-	}
+	if (ret < 0)
+		dev_err(card->dev, "Set sysclk failed: %d\n", ret);
 
-	return 0;
+	return ret;
 }
 
 static const struct snd_kcontrol_new card_controls[] = {
-- 
2.39.2




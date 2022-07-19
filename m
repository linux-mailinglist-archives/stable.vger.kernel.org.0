Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A247579BE3
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbiGSMdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240423AbiGSMcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28CC422E6;
        Tue, 19 Jul 2022 05:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB8786177E;
        Tue, 19 Jul 2022 12:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8005C341C6;
        Tue, 19 Jul 2022 12:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232745;
        bh=112p4IasrsPbPAFxru+Qf08e6ZUpipmetpaKg9UAZAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoVoKgxix31PE+7rXInzaOMubQnRC17yWXgU3SZISDWDe63qzrfvcGYdyUHQU6jGh
         bMnbkIEh9Mq7YVy3HWUzCg+R4Ylt/bIlWroucR4WjhIUMZ7UhPe/G0+eLkwYiUOz/4
         IQR6lGa+rFWFHOFqxLOAnV9X4mYEGtJhulHc/Eh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/167] ASoC: tas2764: Add post reset delays
Date:   Tue, 19 Jul 2022 13:52:55 +0200
Message-Id: <20220719114700.826107203@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit cd10bb89b0d57bca98eb75e0444854a1c129a14e ]

Make sure there is at least 1 ms delay from reset to first command as
is specified in the datasheet. This is a fix similar to commit
307f31452078 ("ASoC: tas2770: Insert post reset delay").

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220630075135.2221-1-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 9265af41c235..edc66ff6dc49 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -42,10 +42,12 @@ static void tas2764_reset(struct tas2764_priv *tas2764)
 		gpiod_set_value_cansleep(tas2764->reset_gpio, 0);
 		msleep(20);
 		gpiod_set_value_cansleep(tas2764->reset_gpio, 1);
+		usleep_range(1000, 2000);
 	}
 
 	snd_soc_component_write(tas2764->component, TAS2764_SW_RST,
 				TAS2764_RST);
+	usleep_range(1000, 2000);
 }
 
 static int tas2764_set_bias_level(struct snd_soc_component *component,
@@ -107,8 +109,10 @@ static int tas2764_codec_resume(struct snd_soc_component *component)
 	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
 	int ret;
 
-	if (tas2764->sdz_gpio)
+	if (tas2764->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2764->sdz_gpio, 1);
+		usleep_range(1000, 2000);
+	}
 
 	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
 					    TAS2764_PWR_CTRL_MASK,
@@ -501,8 +505,10 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 
 	tas2764->component = component;
 
-	if (tas2764->sdz_gpio)
+	if (tas2764->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2764->sdz_gpio, 1);
+		usleep_range(1000, 2000);
+	}
 
 	tas2764_reset(tas2764);
 
-- 
2.35.1




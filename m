Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B035E56FB76
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiGKJbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiGKJ2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:28:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ABC67597;
        Mon, 11 Jul 2022 02:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2956FB80DB7;
        Mon, 11 Jul 2022 09:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFF4C34115;
        Mon, 11 Jul 2022 09:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530963;
        bh=ZF+WrzFbhV5KX1eMz2BAXCroj3WkNOc6oPxo40Y+VAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIS3VmYr7gUUNAwu8jDugOEVZzI8KuzQ6Qush6t78GnzDMYUUlyxgbJz+ddbeAcfH
         gMTiJwtJ4hi8TVE2EKERxwofuzI303Aboh0hAvtA6G0oxUby3Hzj5GqhomQjKm0/Pm
         uOgOm8DWX3r/a7TfSr5WkbKcg3Xtq1tphW6dZBiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 048/112] ASoC: rt711: Add endianness flag in snd_soc_component_driver
Date:   Mon, 11 Jul 2022 11:06:48 +0200
Message-Id: <20220711090550.935510604@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 33f06beac3ade10834a82ad4105dcd91d4b00d61 ]

The endianness flag is used on the CODEC side to specify an
ambivalence to endian, typically because it is lost over the hardware
link. This device receives audio over a SoundWire DAI and as such
should have endianness applied.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220504170905.332415-31-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index ea25fd58d43a..9838fb4d5b9c 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -950,6 +950,7 @@ static const struct snd_soc_component_driver soc_codec_dev_rt711 = {
 	.num_dapm_routes = ARRAY_SIZE(rt711_audio_map),
 	.set_jack = rt711_set_jack_detect,
 	.remove = rt711_remove,
+	.endianness = 1,
 };
 
 static int rt711_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
-- 
2.35.1




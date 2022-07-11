Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E264A56FB5A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiGKJ3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiGKJ26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:28:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ABD3D5BB;
        Mon, 11 Jul 2022 02:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C3AECE1257;
        Mon, 11 Jul 2022 09:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3596EC34115;
        Mon, 11 Jul 2022 09:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530966;
        bh=JPTtwrhYO+9fwde/gMayrS/kfAgw334mCpu7LaLrJOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvAOPLoyQTU/f096wBGZMRHNGf/Ftg0Au6nEyN7UyFcFDjI/JGikwfhibOOwDbLq/
         bVVIgS7IgGiWwdDyRN5UfrIwJmYwJyq9FUZWI0IxF0G922QwLuzc9TqmfuQgQFPDMg
         3+6EJ69OfTW9TSNls5z6LyZtvGTf89TaCDYyy7fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 049/112] ASoC: rt711-sdca: Add endianness flag in snd_soc_component_driver
Date:   Mon, 11 Jul 2022 11:06:49 +0200
Message-Id: <20220711090550.964084337@linuxfoundation.org>
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

[ Upstream commit 3e50a5001055d79c04ea1c79fe4b4ff937a3339c ]

The endianness flag is used on the CODEC side to specify an
ambivalence to endian, typically because it is lost over the hardware
link. This device receives audio over a SoundWire DAI and as such
should have endianness applied.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220504170905.332415-32-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index bdb1375f0338..57629c18db38 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -1208,6 +1208,7 @@ static const struct snd_soc_component_driver soc_sdca_dev_rt711 = {
 	.num_dapm_routes = ARRAY_SIZE(rt711_sdca_audio_map),
 	.set_jack = rt711_sdca_set_jack_detect,
 	.remove = rt711_sdca_remove,
+	.endianness = 1,
 };
 
 static int rt711_sdca_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
-- 
2.35.1




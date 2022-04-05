Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D42F4F3641
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344380AbiDEK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347690AbiDEJqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294DEDFD49;
        Tue,  5 Apr 2022 02:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CEFFB81C8B;
        Tue,  5 Apr 2022 09:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B44C385A2;
        Tue,  5 Apr 2022 09:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151176;
        bh=UtAF4TJdgd6LI56pIhGRnVTmygJzn7Y55xHYTWv0Fco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzau5B5b0J8vv6tG5YKIQlzlekWPylQ2Mfz7MaECCnF0qES2D5CrI0HEBt60RWof0
         eFEoU3am/Y5uQOnjrhuW0IBVWIA/fibtlDkx5VMH3L4OSP7kxKtGjCa952EiE8cjOZ
         jgMsARjsoZ/1SSSh7cYukoRdIIf3MhxMPV1KROR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/913] ASoC: codecs: wc938x: fix accessing array out of bounds for enum type
Date:   Tue,  5 Apr 2022 09:23:02 +0200
Message-Id: <20220405070349.442730334@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit cc587b7c8fbbe128f6bd0dad025a0caea5e6d164 ]

Accessing enums using integer would result in array out of bounds access
on platforms like aarch64 where sizeof(long) is 8 compared to enum size
which is 4 bytes.

Fix this by using enumerated items instead of integers.

Fixes: e8ba1e05bdc0 ("ASoC: codecs: wcd938x: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220222183212.11580-7-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index bbc261ab2025..54671bbf7471 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -2504,7 +2504,7 @@ static int wcd938x_tx_mode_get(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 
-	ucontrol->value.integer.value[0] = wcd938x->tx_mode[path];
+	ucontrol->value.enumerated.item[0] = wcd938x->tx_mode[path];
 
 	return 0;
 }
@@ -2528,7 +2528,7 @@ static int wcd938x_rx_hph_mode_get(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
-	ucontrol->value.integer.value[0] = wcd938x->hph_mode;
+	ucontrol->value.enumerated.item[0] = wcd938x->hph_mode;
 
 	return 0;
 }
-- 
2.34.1




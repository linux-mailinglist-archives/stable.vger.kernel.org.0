Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A4F461F01
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350778AbhK2Smk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:42:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45680 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379924AbhK2Ski (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB413B815CC;
        Mon, 29 Nov 2021 18:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B12C53FC7;
        Mon, 29 Nov 2021 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211030;
        bh=Xc4A1o2qoVlIsLcN6bueFUiYIJ55KufYLTpktz16DVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qniX8rXRIdjzmQn7S20WtHdIZneO2RcWJqbxDMY4Ql87WDuTtUaanCxEzyOVfXHUC
         F8JH9h+6S5bgdSZzH4P66awuW8oQtOjZEcqw9/9GOAELMQkwZgqk6wPmqBvZJKYZ8W
         ddpQnWSJezoQE57NZv83pw20sa2Qohtt0gvC32E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/179] ASoC: codecs: lpass-rx-macro: fix HPHR setting CLSH mask
Date:   Mon, 29 Nov 2021 19:17:53 +0100
Message-Id: <20211129181721.545908505@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit cb04d8cd0bb0b82acc34cc73cb33ae77cbfb020d ]

For some reason we ended up using snd_soc_component_write_field
for HPHL and snd_soc_component_update_bits for HPHR, so fix this.

Fixes: af3d54b99764 ("ASoC: codecs: lpass-rx-macro: add support for lpass rx macro")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211116114623.11891-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 196b06898eeb2..07894ec5e7a61 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -2188,7 +2188,7 @@ static int rx_macro_config_classh(struct snd_soc_component *component,
 		snd_soc_component_update_bits(component,
 				CDC_RX_CLSH_DECAY_CTRL,
 				CDC_RX_CLSH_DECAY_RATE_MASK, 0x0);
-		snd_soc_component_update_bits(component,
+		snd_soc_component_write_field(component,
 				CDC_RX_RX1_RX_PATH_CFG0,
 				CDC_RX_RXn_CLSH_EN_MASK, 0x1);
 		break;
-- 
2.33.0




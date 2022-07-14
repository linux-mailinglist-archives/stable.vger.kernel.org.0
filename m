Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99535742AB
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiGNEZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiGNEYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC912A271;
        Wed, 13 Jul 2022 21:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66688B82335;
        Thu, 14 Jul 2022 04:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0958C385A2;
        Thu, 14 Jul 2022 04:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772589;
        bh=21nWqJIuJuPyc3MGE2rDN2XazBAGhO1m2aDnsDAArdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki9TpvZib08382bLyRQ4jbjYhMdxJVkv9X1F0zz6EFrg6E5rvCwqDc/lbo0/QK0iQ
         ttsfH8ow5FbNkeK/p8TafxACjT7jNZACiYgxDDilH1iqAH6heK8EavVLgFqtJW4hni
         zxLxgpMTrTjKr7lauOVHj5svN73P0t3fkP+UFcXT4sb+xGY2Qjk2wwR6eAL0l8sQx0
         Ze1H4ZGa8GRcwOxDylSvyLP7yTrcn7jpwtSzfoQVnfmlF0sK+OyX+1vw5cPMVptk4Y
         rBOVPK5GE8yX7Gi/qqiiJXfosCbvGLYs74sRbfZ5fH+7sICkRFQA7d/6JvX8WSTmvi
         4VcD16t5U74/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, simont@opensource.cirrus.com,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 17/41] ASoC: wm_adsp: Fix event for preloader
Date:   Thu, 14 Jul 2022 00:21:57 -0400
Message-Id: <20220714042221.281187-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 9896c029f0df628c6cb108253d09b1d61f1d4a88 ]

The preloader controls on ADSP should return a value of 1 if the
preloader value was changed, update to correct this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220621102041.1713504-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 9cfd4f18493f..d3ecff3bdef2 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -997,7 +997,7 @@ int wm_adsp2_preloader_put(struct snd_kcontrol *kcontrol,
 		snd_soc_dapm_sync(dapm);
 	}
 
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_preloader_put);
 
-- 
2.35.1


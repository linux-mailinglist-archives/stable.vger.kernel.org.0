Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F6B57426D
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiGNEYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiGNEYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:24:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A38B27B09;
        Wed, 13 Jul 2022 21:22:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2913B82375;
        Thu, 14 Jul 2022 04:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADD3C3411C;
        Thu, 14 Jul 2022 04:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772575;
        bh=iA9/mffzugg5arwehs0PfA8MRLkpYI57QgbLR0O4YSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7uXCoUu05LNZeVf9WvazV0SCXWy/EnwCX1SYtiyC92DKYbHDXr0hJgK/dCLtKiUp
         s2/KBbap9t2fumqVWnUuLQH+PWSCOLVNarC9NV3nU5zIwbYn0HEZT9ssTULNetC5iO
         8GfYew68JiZRYUgUMLZiU54JDr9kkPdsGx6DR3fXkXshhTE20HQkC69EqIw7f01d10
         Eu52gGpCAI31xmYrmin7i1Y9Q9Gh0fdAkIY8HMqqF8YJiW8PkbfrPQtAeREJdPnn4b
         rQzhNiVjzGoxt5bq6gResVxBnvUNU9eLmIztyt3jjNu6G8Tke2osPkZD6eVSokzeT/
         k+rDjbeto0HGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yassine Oudjana <y.oudjana@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.kandagatla@linaro.org, bgoswami@quicinc.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 12/41] ASoC: wcd9335: Remove RX channel from old list before adding it to a new one
Date:   Thu, 14 Jul 2022 00:21:52 -0400
Message-Id: <20220714042221.281187-12-sashal@kernel.org>
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

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit be6dd72edb216f20fc80e426ece9fe9b8aabf033 ]

Currently in slim_rx_mux_put, an RX channel gets added to a new list
even if it is already in one. This can mess up links and make either
it, the new list head, or both, get linked to the wrong entries.
This can cause an entry to link to itself which in turn ends up
making list_for_each_entry in other functions loop infinitely.
To avoid issues, always remove the RX channel from any list it's in
before adding it to a new list.

Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Link: https://lore.kernel.org/r/20220606152226.149164-1-y.oudjana@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 1e60db4056ad..12be043ee9a3 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1289,9 +1289,12 @@ static int slim_rx_mux_put(struct snd_kcontrol *kc,
 
 	wcd->rx_port_value[port_id] = ucontrol->value.enumerated.item[0];
 
+	/* Remove channel from any list it's in before adding it to a new one */
+	list_del_init(&wcd->rx_chs[port_id].list);
+
 	switch (wcd->rx_port_value[port_id]) {
 	case 0:
-		list_del_init(&wcd->rx_chs[port_id].list);
+		/* Channel already removed from lists. Nothing to do here */
 		break;
 	case 1:
 		list_add_tail(&wcd->rx_chs[port_id].list,
-- 
2.35.1


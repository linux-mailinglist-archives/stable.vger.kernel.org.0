Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0712D594311
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349060AbiHOWiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350726AbiHOWg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:36:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAD712F720;
        Mon, 15 Aug 2022 12:50:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF169B8114E;
        Mon, 15 Aug 2022 19:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C06C433C1;
        Mon, 15 Aug 2022 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593018;
        bh=YKHQv8ohmk4Xil86jK0EXwiIzBcc1yD6B4GvV0O1SNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVBxaOOx+BxSLOJlBZjpvb29QowQe3ACJdTjyrg/OiC2Nlg0AvArywQgaapoz0wC/
         mcnHmeAG6neKSGTt+IVZpRv6vxG+dmeKi08dYyruNV+XydOqKx4woBQVctVxFqM/PW
         /nX1zODRh0jrINgQPxRJjxcrsJwl0uRPVvGUk5hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0880/1095] ASoC: mt6359: Fix refcount leak bug
Date:   Mon, 15 Aug 2022 20:04:39 +0200
Message-Id: <20220815180505.762202059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liang He <windhl@126.com>

[ Upstream commit a8d5df69e2ec702d979f7d04ed519caf8691a032 ]

In mt6359_parse_dt() and mt6359_accdet_parse_dt(), we should call
of_node_put() for the reference returned by of_get_child_by_name()
which has increased the refcount.

Fixes: 683530285316 ("ASoC: mt6359: fix failed to parse DT properties")
Fixes: eef07b9e0925 ("ASoC: mediatek: mt6359: add MT6359 accdet jack driver")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220713102013.367336-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359-accdet.c | 1 +
 sound/soc/codecs/mt6359.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/sound/soc/codecs/mt6359-accdet.c b/sound/soc/codecs/mt6359-accdet.c
index 6d3d170144a0..c190628e2905 100644
--- a/sound/soc/codecs/mt6359-accdet.c
+++ b/sound/soc/codecs/mt6359-accdet.c
@@ -675,6 +675,7 @@ static int mt6359_accdet_parse_dt(struct mt6359_accdet *priv)
 			       sizeof(struct three_key_threshold));
 	}
 
+	of_node_put(node);
 	dev_warn(priv->dev, "accdet caps=%x\n", priv->caps);
 
 	return 0;
diff --git a/sound/soc/codecs/mt6359.c b/sound/soc/codecs/mt6359.c
index f8532aa7e4aa..9a9c8555f720 100644
--- a/sound/soc/codecs/mt6359.c
+++ b/sound/soc/codecs/mt6359.c
@@ -2780,6 +2780,7 @@ static int mt6359_parse_dt(struct mt6359_priv *priv)
 
 	ret = of_property_read_u32(np, "mediatek,mic-type-2",
 				   &priv->mux_select[MUX_MIC_TYPE_2]);
+	of_node_put(np);
 	if (ret) {
 		dev_info(priv->dev,
 			 "%s() failed to read mic-type-2, use default (%d)\n",
-- 
2.35.1




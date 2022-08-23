Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D359DBE0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244255AbiHWLhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350510AbiHWLew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13CE910AE;
        Tue, 23 Aug 2022 02:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD16B81B1F;
        Tue, 23 Aug 2022 09:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A9C433D6;
        Tue, 23 Aug 2022 09:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246836;
        bh=PiAYzXHGfc/+OGeL048E+MAGO3HB2dyAx+psoKblKFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1EzGu3PW2ZpoQdHzHx7shkXxvtTnkDxp3nPvuMn0bsI8cQYOSjElQwukMEntE5hiA
         zZHHVR4iMA6bFTom17in7xP6u8DecZhl65c7AAIerCsxN8h/XerAPI6rsRsiXwoCPq
         J0GGWJ25YvmGgKB30zuS3udTbTUEAmu1Y04V1Lgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/389] ASoC: audio-graph-card: Add of_node_put() in fail path
Date:   Tue, 23 Aug 2022 10:25:06 +0200
Message-Id: <20220823080125.127020091@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

[ Upstream commit 65fb8e2ef3531a6e950060fca6e551c923fb0f0e ]

In asoc_simple_parse_dai(), we should call of_node_put() for the
reference returned by of_graph_get_port_parent() in fail path.

Fixes: ae30a694da4c ("ASoC: simple-card-utils: add asoc_simple_card_parse_dai()")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220721144308.1301587-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index 1bc498124689..96aa2c015572 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -149,8 +149,10 @@ static int asoc_simple_parse_dai(struct device_node *ep,
 	 *    if he unbinded CPU or Codec.
 	 */
 	ret = snd_soc_get_dai_name(&args, &dlc->dai_name);
-	if (ret < 0)
+	if (ret < 0) {
+		of_node_put(node);
 		return ret;
+	}
 
 	dlc->of_node = node;
 
-- 
2.35.1




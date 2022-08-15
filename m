Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A1594CEE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344746AbiHPAse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347593AbiHPAp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0926FADCC4;
        Mon, 15 Aug 2022 13:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9DA611FA;
        Mon, 15 Aug 2022 20:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F481C433C1;
        Mon, 15 Aug 2022 20:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596111;
        bh=5UhoXcEIbPk8Dp4swVKTZKdyP4ZLu19tMH5KXU4pwBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gm+WxyFou2i7m7pxvfJtQzmu9gv/6wTyRk/CUUMAEPbQmKSNWr8aW6KqpXHNlBBsG
         V3O3IGJQf0ETxDZ8SV4LBmhG0Krdb91BOw33CZ7IZupbLXltgcoiF4S81VrBekYU4q
         LsREale882QC4Hqe3ZCG/3bHiMdeFsxyYFeT/oUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0941/1157] ASoC: audio-graph-card2.c: use of_property_read_u32() for rate
Date:   Mon, 15 Aug 2022 20:04:57 +0200
Message-Id: <20220815180517.175223922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 817a62108dfacebd548e38451bf0e7eee023e97f ]

Audio Graph Card2 is using of_get_property(), but it should use
of_property_read_u32() to getting rate. Otherwise the setting will be
strange value. This patch fixup it.

Fixes: c3a15c92a67b701 ("ASoC: audio-graph-card2: add Codec2Codec support")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87h741s961.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/audio-graph-card2.c b/sound/soc/generic/audio-graph-card2.c
index d34b29a49268..8e0628e6f2a0 100644
--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -856,7 +856,7 @@ int audio_graph2_link_c2c(struct asoc_simple_priv *priv,
 	struct device_node *port0, *port1, *ports;
 	struct device_node *codec0_port, *codec1_port;
 	struct device_node *ep0, *ep1;
-	u32 val;
+	u32 val = 0;
 	int ret = -EINVAL;
 
 	/*
@@ -880,7 +880,8 @@ int audio_graph2_link_c2c(struct asoc_simple_priv *priv,
 	ports = of_get_parent(port0);
 	port1 = of_get_next_child(ports, lnk);
 
-	if (!of_get_property(ports, "rate", &val)) {
+	of_property_read_u32(ports, "rate", &val);
+	if (!val) {
 		struct device *dev = simple_priv_to_dev(priv);
 
 		dev_err(dev, "Codec2Codec needs rate settings\n");
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46925944E4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349928AbiHOWij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350519AbiHOWgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:36:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663DC60529;
        Mon, 15 Aug 2022 12:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 197FF6125B;
        Mon, 15 Aug 2022 19:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074D0C43148;
        Mon, 15 Aug 2022 19:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592939;
        bh=HVlih1cUQcNP31sy4XJn3sx3uxS7BbAuTUytr980X6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1jTto3K+nUm3sofVPbrxjS6CaWsvCxtqa5XpyffHektFLl/nMan9RgQW9x3KOwsO
         EcmwwMzuBk/1Cs5gcl+sJ5JYXIAEf7DWZY4re1SjsFLxlUbqsY6E40e+b7s+xG3Xwa
         UjsvFxECh6CAVylnHOA6Ucik1m4BhTg7QejX4/WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0869/1095] ASoC: audio-graph-card2.c: use of_property_read_u32() for rate
Date:   Mon, 15 Aug 2022 20:04:28 +0200
Message-Id: <20220815180505.313194658@linuxfoundation.org>
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
index c0f3907a01fd..328af836cf53 100644
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




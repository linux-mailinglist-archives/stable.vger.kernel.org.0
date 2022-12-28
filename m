Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31F16583E8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiL1QxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbiL1Qwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A99E15F19
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:47:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E766157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C55C433D2;
        Wed, 28 Dec 2022 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246032;
        bh=Rp0Vfs28a9n2e460dB6yCVQtP91ApgOF/Vejm3x8e+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wdg80zCsq53KFFlPMVEqb3d58UcIRocNiHlQCPedotVqgXcjFDS0OAx6PXHsBXG2Q
         iNrxb2MbM+AsYb6zw1PPpr8XxMzDLGRNV+h3uoro/nUzbx8ggu36/AbERlUjEIGuVi
         i07Ze0AHuQ0FqELssABJBBPPOFKg+itPRT+Sg3HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1001/1073] ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()
Date:   Wed, 28 Dec 2022 15:43:09 +0100
Message-Id: <20221228144355.327821567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 8ab2d12c726f0fde0692fa5d81d8019b3dcd62d0 ]

The of_get_next_child() returns a node with refcount incremented, and
decrements the refcount of prev. So in the error path of the while loop,
of_node_put() needs be called for cpu_ep.

Fixes: fce9b90c1ab7 ("ASoC: audio-graph-card: cleanup DAI link loop method - step2")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/1670228127-13835-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index b327372f2e4a..4e776c2a38a4 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -485,8 +485,10 @@ static int __graph_for_each_link(struct asoc_simple_priv *priv,
 			of_node_put(codec_ep);
 			of_node_put(codec_port);
 
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(cpu_ep);
 				return ret;
+			}
 
 			codec_port_old = codec_port;
 		}
-- 
2.35.1




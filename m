Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4937CDB5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhELQ5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244090AbhELQmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C35B61D20;
        Wed, 12 May 2021 16:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835832;
        bh=RB8i/R8CAha++dfMpU9Qn3jktxc0X/eibhtZY+TYids=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zK/CPUC7TO354mp09xzBwQ+rLjKN/yrCTCKX86AIrgHNLAOsNA0jQG6TkMSq+t5Y2
         JaL0SGf+LnKSKLImUgoiglSadjS9vrw4Uh+gUNz3LtypdRmRbrCb9z5shYxNmci38W
         w5bcJKKlJHa4pxdtW3IHblu1uUdei/BL52hD0Kos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 503/677] ASoC: simple-card: fix possible uninitialized single_cpu local variable
Date:   Wed, 12 May 2021 16:49:09 +0200
Message-Id: <20210512144854.095864781@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit fa74c223b6fd78a5314b4c61b9abdbed3c2185b4 ]

The 'single_cpu' local variable is assigned by asoc_simple_parse_dai()
and later used in a asoc_simple_canonicalize_cpu() call, assuming the
entire function did not exit on errors.

However the first function returns 0 if passed device_node is NULL,
thus leaving the variable uninitialized and reporting success.

Addresses-Coverity: Uninitialized scalar variable
Fixes: 8f7f298a3337 ("ASoC: simple-card-utils: separate asoc_simple_card_parse_dai()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/20210407092027.60769-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 2 +-
 sound/soc/generic/simple-card.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index 8c5cdcdc8713..e81b5cf0d37a 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -380,7 +380,7 @@ static int graph_dai_link_of(struct asoc_simple_priv *priv,
 	struct device_node *top = dev->of_node;
 	struct asoc_simple_dai *cpu_dai;
 	struct asoc_simple_dai *codec_dai;
-	int ret, single_cpu;
+	int ret, single_cpu = 0;
 
 	/* Do it only CPU turn */
 	if (!li->cpu)
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 75365c7bb393..d916ec69c24f 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -258,7 +258,7 @@ static int simple_dai_link_of(struct asoc_simple_priv *priv,
 	struct device_node *plat = NULL;
 	char prop[128];
 	char *prefix = "";
-	int ret, single_cpu;
+	int ret, single_cpu = 0;
 
 	/*
 	 *	 |CPU   |Codec   : turn
-- 
2.30.2




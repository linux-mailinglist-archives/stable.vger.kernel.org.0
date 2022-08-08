Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF758C0ED
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbiHHB5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243920AbiHHB4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAD0101DD;
        Sun,  7 Aug 2022 18:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7990BCE0F71;
        Mon,  8 Aug 2022 01:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22BDC433C1;
        Mon,  8 Aug 2022 01:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922795;
        bh=x599Q0uNqhEXX/zTlqbs0/t9r9wM0qizRo+Y0uYiNVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvCSqYj1BHs/+9OCFqyDWVUvnXtnRovMHVYLuXnKaAU1mq9g0NQsbvj83MzLNaw1L
         4055+I4DiOTRmWUbat9wa4gtLcp4o3lSNwhR0KnV+7xDufPC5dlOVrXdrbewfneSeG
         gUQZFbXkdaZs8+4RA6MWESVmLDUIzVsW4zZlAqE/35YMEg0XftGe99N6fmgdAGaKUS
         SfGGxlKWS2Tzxw+s9+M07q7n/PJ7xMshX5g1/A+RBRj75hcM6f/vUSUux4+M2F5czV
         pBakJ5/aqr9ztugC6ojYoEfi1mPsU+gENjS17jSbR7rA3w47V2U4w6Z3epPfbJLfPf
         LUTUJe8L/NbaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 07/12] ARM: OMAP2+: display: Fix refcount leak bug
Date:   Sun,  7 Aug 2022 21:39:37 -0400
Message-Id: <20220808013943.316907-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013943.316907-1-sashal@kernel.org>
References: <20220808013943.316907-1-sashal@kernel.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 50b87a32a79bca6e275918a711fb8cc55e16d739 ]

In omapdss_init_fbdev(), of_find_node_by_name() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220617145803.4050918-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 6e7440ef503a..b01b7515b6cc 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -218,6 +218,7 @@ static int __init omapdss_init_fbdev(void)
 	node = of_find_node_by_name(NULL, "omap4_padconf_global");
 	if (node)
 		omap4_dsi_mux_syscon = syscon_node_to_regmap(node);
+	of_node_put(node);
 
 	return 0;
 }
-- 
2.35.1


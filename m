Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C351D4B72ED
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbiBOPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:33:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbiBOPcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:32:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78121AEF21;
        Tue, 15 Feb 2022 07:30:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 148E0615F0;
        Tue, 15 Feb 2022 15:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAEFC340F1;
        Tue, 15 Feb 2022 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939000;
        bh=In4AzKn1wxAe9eTmNKIelQ3WOTNBZ/W4/QZ6HsBrqyA=;
        h=From:To:Cc:Subject:Date:From;
        b=KyR3k5OHxbfoSBmvxipbSSdLMYt+2JVmpvDfxfDnCp9HFfaIgcIH4bwY3T3Oa9Edj
         ya+Z4canotZPCsNvACQjqn4+T3GjyA1n+qHo6T52CECEkr6CVWBLXFalN7suwn0wZS
         CM9vI5zxkWeaT214dgq3bzGSLyNX2tyiKuqIgH1cV+jW+IhBMUBFmx89wy2fNeZNJM
         lrps5LHUQadlzc45J2oQWo52K9ZAqYXiKQ8ipMfC8l8UlCoxPIj35hC9al55A7yPL8
         9nux2bQJ5XFW0Zrz+/hSzOnJGK5BnhzzyrRPjc/8150OvPWeBD7GIyzJAZVIyWUcbj
         KHWiKA1LkwLnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, bcousson@baylibre.com,
        paul@pwsan.com, linux@armlinux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 01/23] ARM: OMAP2+: hwmod: Add of_node_put() before break
Date:   Tue, 15 Feb 2022 10:29:35 -0500
Message-Id: <20220215152957.581303-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 80c469a0a03763f814715f3d12b6f3964c7423e8 ]

Fix following coccicheck warning:
./arch/arm/mach-omap2/omap_hwmod.c:753:1-23: WARNING: Function
for_each_matching_node should have of_node_put() before break

Early exits from for_each_matching_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 9443f129859b2..1fd67abca055b 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -749,8 +749,10 @@ static int __init _init_clkctrl_providers(void)
 
 	for_each_matching_node(np, ti_clkctrl_match_table) {
 		ret = _setup_clkctrl_provider(np);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			break;
+		}
 	}
 
 	return ret;
-- 
2.34.1


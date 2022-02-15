Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660E24B71C3
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbiBOPh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:37:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240801AbiBOPfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CBADFA0;
        Tue, 15 Feb 2022 07:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B192D615FD;
        Tue, 15 Feb 2022 15:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19486C340ED;
        Tue, 15 Feb 2022 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939085;
        bh=76N9Jpv3lPzZqSOgH99gJE2ukwlxN4IW0ahXY5jT7gg=;
        h=From:To:Cc:Subject:Date:From;
        b=clJC6aJCSbIeBDdeHVhy6e/q2O9VhPu6y2UZFAE+UdC9ROeUz+PBDtxqD4AqllBCV
         qNQQO3TRDL06kQMYZhBHckVIWYkxHHrSsrnmDyGvSEBD/37yxSU4XdmN2kHZyoxRBQ
         O9gSBb/42elIQnTxLXTni5KrYBMVOPZwdEBDks1/yQufadB47R5yfNYjcrQu18CohL
         xCCPQSxQrGkB9hH4FY/KWFyuGP2pkMSQX1hcNWeI0QnSNMMscG8llTfI6x5mtc3mRf
         IZcLNnKMr4JICKyy3RogGt49RTJVEqqA3MlERFBoiW6HbTFuE07qRJXdkgwtAeTcc2
         ZC5hcbe7MKy2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, bcousson@baylibre.com,
        paul@pwsan.com, linux@armlinux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 1/5] ARM: OMAP2+: hwmod: Add of_node_put() before break
Date:   Tue, 15 Feb 2022 10:31:18 -0500
Message-Id: <20220215153122.581930-1-sashal@kernel.org>
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
index 9274a484c6a39..f6afd866e4cf9 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -768,8 +768,10 @@ static int _init_clkctrl_providers(void)
 
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


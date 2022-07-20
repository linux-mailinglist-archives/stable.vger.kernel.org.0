Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D25357AD0B
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiGTBaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242273AbiGTB3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4389E76E89;
        Tue, 19 Jul 2022 18:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FD62617B4;
        Wed, 20 Jul 2022 01:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07339C341CA;
        Wed, 20 Jul 2022 01:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279941;
        bh=N/gTGwrjKEzpjWmzHc4Cb83695ndJGSHOXf4/MfYlHw=;
        h=From:To:Cc:Subject:Date:From;
        b=BEiD6Y+fm4p5CQ1DtgzIY6jvIA4kgDro4KBNccjMbA2NJvhaSEde9V9etE6YdtJOX
         bU1etBTvnbnebRtLVmxbhGw1n4zWGsHW2i/YOJ53lQKwQAgQhaiSAb+5D/OSj6d9Lg
         TVpkZdWoIW6ib6DSmjT0SZ/AeEqDyo7LmaNgb/mnkIqiIsTehp5c59Mx2MBgrmPLgg
         UiS+1WnrzRHTv+yhyxwoT5eyaKmCIHW9/S8Iw7vvMsU+XAAaGmkiuqxfNxzxxBte66
         mN7DEFTeK/Q519Zr7XJKinkdMARqWyD6OWP8xANd2Dvh+6ciEee/NL4Ixb661iZ/Na
         e/kPL3iFs+sDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 1/6] ARM: rockchip: Add missing of_node_put() in rockchip_suspend_init()
Date:   Tue, 19 Jul 2022 21:18:52 -0400
Message-Id: <20220720011858.1025523-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit f4470dbfb5ff92804650bc71d115c3f150d430f6 ]

In rockchip_suspend_init(), of_find_matching_node_and_match() will
return a node pointer with refcount incremented. We should use
of_node_put() in fail path or when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220616021713.3973472-1-windhl@126.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-rockchip/pm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-rockchip/pm.c b/arch/arm/mach-rockchip/pm.c
index bee8c8051929..199c1681e8cd 100644
--- a/arch/arm/mach-rockchip/pm.c
+++ b/arch/arm/mach-rockchip/pm.c
@@ -318,7 +318,7 @@ void __init rockchip_suspend_init(void)
 					     &match);
 	if (!match) {
 		pr_err("Failed to find PMU node\n");
-		return;
+		goto out_put;
 	}
 	pm_data = (struct rockchip_pm_data *) match->data;
 
@@ -327,9 +327,12 @@ void __init rockchip_suspend_init(void)
 
 		if (ret) {
 			pr_err("%s: matches init error %d\n", __func__, ret);
-			return;
+			goto out_put;
 		}
 	}
 
 	suspend_set_ops(pm_data->ops);
+
+out_put:
+	of_node_put(np);
 }
-- 
2.35.1


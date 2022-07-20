Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B6457AC8A
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239747AbiGTBWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241090AbiGTBVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:21:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00E36FA1F;
        Tue, 19 Jul 2022 18:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D209B81DE6;
        Wed, 20 Jul 2022 01:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFC8C341CF;
        Wed, 20 Jul 2022 01:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279780;
        bh=ZtW/0VVuXnVd4D9WDVweixR/stTys6Z95/e5OU0s8nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe7FErsw2QNY2bgd8htmJBkAzzBn4XDiVLCaSm0iQtRd8DZXTMF0tk/l+marveK2+
         rRgQPAA0+REktH/tcemn3sSP02lLG85v61IpANv8Ju2KC44SPbEHt2fdQngaUxd1bT
         ZS/zZkuBq2SzHKAWB9mV7CrjhhajA15DJ/5D2Imzy6a4fvyB5jRrJ986W7Jg/uP8QG
         Nd4KNVNU/CxDI/xXMn8ExwKTjV/I3chy+zFUTOpxtwRJgThFuTUvbP9fCI9nFpnfXR
         NXQwF++T05kZGtzu3ntNHp3jtado/dXyfmwxINk5Nzrc+5i80WlkIlw646XwUH111f
         IDjgaRhXwiS/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/25] ARM: rockchip: Add missing of_node_put() in rockchip_suspend_init()
Date:   Tue, 19 Jul 2022 21:15:53 -0400
Message-Id: <20220720011616.1024753-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
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
index 87389d9456b9..30d781d80fe0 100644
--- a/arch/arm/mach-rockchip/pm.c
+++ b/arch/arm/mach-rockchip/pm.c
@@ -311,7 +311,7 @@ void __init rockchip_suspend_init(void)
 					     &match);
 	if (!match) {
 		pr_err("Failed to find PMU node\n");
-		return;
+		goto out_put;
 	}
 	pm_data = (struct rockchip_pm_data *) match->data;
 
@@ -320,9 +320,12 @@ void __init rockchip_suspend_init(void)
 
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


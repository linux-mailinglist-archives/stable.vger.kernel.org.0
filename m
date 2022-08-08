Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5353F58BF17
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiHHBf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242308AbiHHBet (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:34:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC25B874;
        Sun,  7 Aug 2022 18:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DB6FB80E0A;
        Mon,  8 Aug 2022 01:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1205DC433D6;
        Mon,  8 Aug 2022 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922382;
        bh=IVk6LSqpcL/QqL+Fmi/ypollB5miE9Yu22CKICMxIbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXVGI6aQipv5iJNuWcIn4m06NCDPpIjsrF9EmV6mHdCXd5pk+EX7BprYh1tFPzVJb
         RuxS1md4XaC4xF8/CmlL5fNcO21sw1Gu3YuiT0iKvhBYwpuTNhjrQ87M/5tkFpivj2
         EUsfr3FATAd/qoQbd1GVM4BVeotqGsqsb/eHQHyJzYy01P+Al/q/uT/Zo4WYAjGvMG
         LB/gDFO7HRIiNo5t4chAWM1PRwRnkeDRFSVQn0kFoKOWE1ZTKRHQ0s/JFvEPemBR9y
         XkKlPmg+s9bgLuRDyoJqjDLGpPEIa6Re8XAE7padcVS7s/VONyVGAEkHW94kc/oWrk
         oBCIDGspWxYsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 36/58] ARM: OMAP2+: pdata-quirks: Fix refcount leak bug
Date:   Sun,  7 Aug 2022 21:30:54 -0400
Message-Id: <20220808013118.313965-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
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

[ Upstream commit 5cdbab96bab314c6f2f5e4e8b8a019181328bf5f ]

In pdata_quirks_init_clocks(), the loop contains
of_find_node_by_name() but without corresponding of_node_put().

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220618020603.4055792-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 13f1b89f74b8..5b99d602c87b 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -540,6 +540,8 @@ pdata_quirks_init_clocks(const struct of_device_id *omap_dt_match_table)
 
 		of_platform_populate(np, omap_dt_match_table,
 				     omap_auxdata_lookup, NULL);
+
+		of_node_put(np);
 	}
 }
 
-- 
2.35.1


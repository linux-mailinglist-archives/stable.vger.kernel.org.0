Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3642A58BF80
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbiHHBmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243062AbiHHBlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E313D35;
        Sun,  7 Aug 2022 18:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98705B80DCF;
        Mon,  8 Aug 2022 01:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B62C43140;
        Mon,  8 Aug 2022 01:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922518;
        bh=lN24LFKC2NWslvWPfsezsUuZEr7kWkBTZ/LrqMh9pO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCnms4uz4EiYURnsmi7kQLQkZaka4fPqOwu4ZhCVNP7yIc5T9/t8dJlCHTiIGomg+
         DZ+PIk4Arnk4GzkhFSlLh09T8Qq2SurBxd6pCS65rUIFe5Byh0Ff/sVFVhDEELBGMb
         732749T9dPtdWVeUGEI8Ey//l8EhZER54lzt1ZJXMhIY/AkbFsATGzQz5mc5/PIPw9
         2avr9CnH4ctuBjJklJ1RaXii6mvSpPU8LtrCIk7nVhDO6FMxYaHQkFuq1lSZyHBUr4
         b0jYOLEzfUhZn/2wd99TD3NA75/TsEfKm9rYCjHZ+4LfYML5voOeLBFy2okcJlYOY6
         DdJuxY6+mFNzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 35/53] ARM: OMAP2+: pdata-quirks: Fix refcount leak bug
Date:   Sun,  7 Aug 2022 21:33:30 -0400
Message-Id: <20220808013350.314757-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index e7fd29a502a0..af9d8c432af0 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -551,6 +551,8 @@ pdata_quirks_init_clocks(const struct of_device_id *omap_dt_match_table)
 
 		of_platform_populate(np, omap_dt_match_table,
 				     omap_auxdata_lookup, NULL);
+
+		of_node_put(np);
 	}
 }
 
-- 
2.35.1


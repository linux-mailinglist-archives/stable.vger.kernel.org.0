Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4015B4A3C
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiIJVb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiIJVbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:31:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0B7578A1;
        Sat, 10 Sep 2022 14:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A03FA60EC3;
        Sat, 10 Sep 2022 21:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF9EC43470;
        Sat, 10 Sep 2022 21:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844738;
        bh=BNqis8zEoyO3GPe0joWPNzLokGPfL/P4HVQzS+hWMrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9ElXPvwz3+K9g66T2Yb5+KFxDdKsDTW+1olK9aIISgUshgX5QW4IEYia31DSQsAv
         nIrw1gQLzpdp+NpTqRepBJVSSDvEbWzot4VVA0ynuKOpow9LvkYUhCz2qffAGHz3IG
         QhATifB9XdRL7hPXx7FWsuONbbgpUWMDtTBCNeb1y4bxMyjUodfzyyfkPByyi/6RP5
         vVbgoq3g1QSf67OAxIx8N17xfghwdbv48/A2jc2VszLU+DEIZxKRi9OrI3HfG+iX2D
         C9Rvi0fc19pgm2CSkbpt7Dnzx6MF0zhAQvFlZGBGfiBPo2aqtwF9b44H+M5YgQtVEo
         fPMaWEj55dZaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Zhe <yuzhe@nfschina.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 12/14] perf/arm_pmu_platform: fix tests for platform_get_irq() failure
Date:   Sat, 10 Sep 2022 17:18:30 -0400
Message-Id: <20220910211832.70579-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211832.70579-1-sashal@kernel.org>
References: <20220910211832.70579-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yu Zhe <yuzhe@nfschina.com>

[ Upstream commit 6bb0d64c100091e131cd16710b62fda3319cd0af ]

The platform_get_irq() returns negative error codes.  It can't actually
return zero.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Link: https://lore.kernel.org/r/20220825011844.8536-1-yuzhe@nfschina.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmu_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm_pmu_platform.c b/drivers/perf/arm_pmu_platform.c
index ef9676418c9f4..2e1f3680d8466 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -117,7 +117,7 @@ static int pmu_parse_irqs(struct arm_pmu *pmu)
 
 	if (num_irqs == 1) {
 		int irq = platform_get_irq(pdev, 0);
-		if (irq && irq_is_percpu_devid(irq))
+		if ((irq > 0) && irq_is_percpu_devid(irq))
 			return pmu_parse_percpu_irq(pmu, irq);
 	}
 
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5D45B49DC
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiIJVYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiIJVXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:23:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28F45208B;
        Sat, 10 Sep 2022 14:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7808960B4D;
        Sat, 10 Sep 2022 21:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3301EC433D7;
        Sat, 10 Sep 2022 21:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844758;
        bh=oPZrZTAQIjQDJjJfYGVmJfuEiAnbcNj8vaUKQPAYhHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYaUjNBP7BkSsd/pZ98HVYl+e7opjSglBsZJ6ibm12grqXQmcaxf/YMewd6eYSgYS
         +cNC+8+EBqdxnBFFCQQ5T3Hl6Y1PdoQceRqIUz4lH21xoKfmHi0BMZSApehb8AU0DN
         c4Y/FK8XXCLG/6atVRv/vIWnkFFOJopDJB2N/TIxQ3nRxm/9jlOvnjTlYH/GFWfunt
         gtOPSXVxPsWNYMxbHl+yxgXTLtiI6gWIFfJ/Y7AmvHMexvMXHgX5PJE0dRoYcIRzRb
         +Bhylg264oYT+Ao+ZA5rcKOxHjXdbNb8ZlYuCppXPq3j+Wdp8A9bUQiv1lTGnmoUCu
         0nedDIRLhdo0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Zhe <yuzhe@nfschina.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 08/10] perf/arm_pmu_platform: fix tests for platform_get_irq() failure
Date:   Sat, 10 Sep 2022 17:18:59 -0400
Message-Id: <20220910211901.70760-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211901.70760-1-sashal@kernel.org>
References: <20220910211901.70760-1-sashal@kernel.org>
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
index e35cb76c8d104..6eb077db7384d 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -118,7 +118,7 @@ static int pmu_parse_irqs(struct arm_pmu *pmu)
 
 	if (num_irqs == 1) {
 		int irq = platform_get_irq(pdev, 0);
-		if (irq && irq_is_percpu_devid(irq))
+		if ((irq > 0) && irq_is_percpu_devid(irq))
 			return pmu_parse_percpu_irq(pmu, irq);
 	}
 
-- 
2.35.1


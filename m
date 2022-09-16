Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B7B5BAB31
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiIPKM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiIPKMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:12:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8816C1A049;
        Fri, 16 Sep 2022 03:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0BFAB82521;
        Fri, 16 Sep 2022 10:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492E5C433C1;
        Fri, 16 Sep 2022 10:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322982;
        bh=oPZrZTAQIjQDJjJfYGVmJfuEiAnbcNj8vaUKQPAYhHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkf5Ez0l0txV1mZhTYdJfoOnqFl7jMwxC2L7SGDifBqW/e/ukodG1/XnFF59z2nbb
         GDjDuiC2QtMph4AXW+5u01p59Ia4fNUZz8IulG00fIL6fEW51j/Ak8sIQ+MppmkeDC
         biGTznEktEurNCgDpt2C4/BHt9Xfu8sdZd8mQjv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/14] perf/arm_pmu_platform: fix tests for platform_get_irq() failure
Date:   Fri, 16 Sep 2022 12:08:15 +0200
Message-Id: <20220916100443.542088404@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
References: <20220916100443.123226979@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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




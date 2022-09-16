Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C268F5BAA6F
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiIPKPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiIPKOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:14:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72863A924B;
        Fri, 16 Sep 2022 03:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E21E62A1C;
        Fri, 16 Sep 2022 10:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825C3C433C1;
        Fri, 16 Sep 2022 10:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323028;
        bh=BNqis8zEoyO3GPe0joWPNzLokGPfL/P4HVQzS+hWMrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcMUZxXQDFrXTX1LcsCnx0yj+KyzwhdPYPNGHHn7pIQCpztX+87b1iYuFuY6ndvQC
         6waYTCq967/mwrA5LAIlInxDnBff/PKzvPZOUGFRTVVnFs2cMuh8BLPnt2OPUez/C2
         +fTdEYRRFwIK9hEe9Y6LKKZji3Yok+uRDc1iSYDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/24] perf/arm_pmu_platform: fix tests for platform_get_irq() failure
Date:   Fri, 16 Sep 2022 12:08:41 +0200
Message-Id: <20220916100446.090227657@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
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




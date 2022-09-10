Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704C15B4A15
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiIJV0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiIJVYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD8C501A8;
        Sat, 10 Sep 2022 14:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D2A5B80957;
        Sat, 10 Sep 2022 21:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551B6C43142;
        Sat, 10 Sep 2022 21:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844775;
        bh=tSXfzAbEEGzejCMYQW03tijt0WD8X9cB7zVT+7xfYmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WujG9K1twcLk4MGo5BMTs17r+yvt55tHMaxKSUrKe82qOamPLKfO2h2qbGfl0np0o
         72uGJAp7np+HpnE+lwdg9JH9gffJGJjRaqlTsbLkT6/UBXuCdzZ53xRUxmfYj1sMfx
         9FbTLVmxRQPpTo6cFt2Gie83fpYwyY1EdpVN9XTcHVoVSOXzQ+IwTuACd8E9E7ZTMb
         Rsrs162r6L7axXko/PscbyB9fPSDjuspnOPwtJYKNAhyfj5yS9+oXf1qnA1eHGDvUm
         y1Nv8rQkWlLP5ympVj6lWMbUjJ9VDQef3kRSYWxS8GE/pQoPM02a3EvtDcBNZq+lX+
         ZpUrKCSLkT7Hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Zhe <yuzhe@nfschina.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 6/8] perf/arm_pmu_platform: fix tests for platform_get_irq() failure
Date:   Sat, 10 Sep 2022 17:19:19 -0400
Message-Id: <20220910211921.70891-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211921.70891-1-sashal@kernel.org>
References: <20220910211921.70891-1-sashal@kernel.org>
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
index 199293450acfc..0ffa4f45a8391 100644
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


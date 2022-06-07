Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8213540C56
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352366AbiFGSdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352975AbiFGSbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C8317CCB0;
        Tue,  7 Jun 2022 10:56:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB478617A6;
        Tue,  7 Jun 2022 17:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DF0C341C0;
        Tue,  7 Jun 2022 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624599;
        bh=DHhMOTAVSHSY0j7O0/1UO25k14ku7/TFOBskDOIVeLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSK+gGBdlDpYaw6sO0qxWJTCdw3RCOg0XqZhZmlunycuh3vgDUPstNbB1mnXXUmv4
         ZKbiLwbtmTWWv7QF0+5SKr6WvgaNdtJhCrX4gZ/yo/vcscheX1kyoZquGycF5m9qtw
         AO9rpqTpU2VPugMztp87kqIomfXhC9yLpiaYd4e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/667] memory: samsung: exynos5422-dmc: Avoid some over memory allocation
Date:   Tue,  7 Jun 2022 19:00:49 +0200
Message-Id: <20220607164946.265426046@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 56653827f0d7bc7c2d8bac0e119fd1521fa9990a ]

'dmc->counter' is a 'struct devfreq_event_dev **', so there is some
over memory allocation. 'counters_size' should be computed with
'sizeof(struct devfreq_event_dev *)'.

Use 'sizeof(*dmc->counter)' instead to fix it.

While at it, use devm_kcalloc() instead of devm_kzalloc()+open coded
multiplication.

Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/69d7e69346986e2fdb994d4382954c932f9f0993.1647760213.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/samsung/exynos5422-dmc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index 9c8318923ed0..4733e7898ffe 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1322,7 +1322,6 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
  */
 static int exynos5_performance_counters_init(struct exynos5_dmc *dmc)
 {
-	int counters_size;
 	int ret, i;
 
 	dmc->num_counters = devfreq_event_get_edev_count(dmc->dev,
@@ -1332,8 +1331,8 @@ static int exynos5_performance_counters_init(struct exynos5_dmc *dmc)
 		return dmc->num_counters;
 	}
 
-	counters_size = sizeof(struct devfreq_event_dev) * dmc->num_counters;
-	dmc->counter = devm_kzalloc(dmc->dev, counters_size, GFP_KERNEL);
+	dmc->counter = devm_kcalloc(dmc->dev, dmc->num_counters,
+				    sizeof(*dmc->counter), GFP_KERNEL);
 	if (!dmc->counter)
 		return -ENOMEM;
 
-- 
2.35.1




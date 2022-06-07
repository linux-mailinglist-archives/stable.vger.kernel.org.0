Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E46541C11
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382848AbiFGV4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383244AbiFGVw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E052431B1;
        Tue,  7 Jun 2022 12:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A83B8220B;
        Tue,  7 Jun 2022 19:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ABAC385A2;
        Tue,  7 Jun 2022 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629047;
        bh=Lvhq4E20hiCY4U4uXUpM5ihKqDyUNNnEd67JNgqPIjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahq+6Chp5pxtWxZAobEbmJScQdrW4h0JtV3e5oWXMn3AZDCfV2G8t21N7agL0maOZ
         CW5K0quJI5c1BVfF2/rP/FywY0zq6ORD0skaLtGjhiF41R/Plq8JRzQvl21maUhypF
         Y1C7hOaquOAvZBrYsUygIlTLxIDQ8mvF+nA7p3JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Anup Patel <anup@brainfault.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 499/879] cpuidle: psci: Fix regression leading to no genpd governor
Date:   Tue,  7 Jun 2022 19:00:17 +0200
Message-Id: <20220607165017.356200407@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 34be27517cb763ea367da21e3cdee5d1bc40f47f ]

While factoring out the PM domain related code from PSCI domain driver into
a set of library functions, a regression when initializing the genpds got
introduced. More precisely, we fail to assign a genpd governor, so let's
fix this.

Fixes: 9d976d6721df ("cpuidle: Factor-out power domain related code from PSCI domain driver")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-psci-domain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-psci-domain.c b/drivers/cpuidle/cpuidle-psci-domain.c
index 755bbdfc5b82..3db4fca1172b 100644
--- a/drivers/cpuidle/cpuidle-psci-domain.c
+++ b/drivers/cpuidle/cpuidle-psci-domain.c
@@ -52,7 +52,7 @@ static int psci_pd_init(struct device_node *np, bool use_osi)
 	struct generic_pm_domain *pd;
 	struct psci_pd_provider *pd_provider;
 	struct dev_power_governor *pd_gov;
-	int ret = -ENOMEM, state_count = 0;
+	int ret = -ENOMEM;
 
 	pd = dt_idle_pd_alloc(np, psci_dt_parse_state_node);
 	if (!pd)
@@ -71,7 +71,7 @@ static int psci_pd_init(struct device_node *np, bool use_osi)
 		pd->flags |= GENPD_FLAG_ALWAYS_ON;
 
 	/* Use governor for CPU PM domains if it has some states to manage. */
-	pd_gov = state_count > 0 ? &pm_domain_cpu_gov : NULL;
+	pd_gov = pd->states ? &pm_domain_cpu_gov : NULL;
 
 	ret = pm_genpd_init(pd, pd_gov, false);
 	if (ret)
-- 
2.35.1




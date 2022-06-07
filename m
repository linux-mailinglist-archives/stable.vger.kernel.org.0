Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B136541C61
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382527AbiFGV7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382875AbiFGVwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E12223F22D;
        Tue,  7 Jun 2022 12:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20B58B823AE;
        Tue,  7 Jun 2022 19:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84890C385A2;
        Tue,  7 Jun 2022 19:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628989;
        bh=0Fo+vnLS+m2NgyDYTXErJyrh2tt8kExYo9NWHnEnXzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Srv2o0r9w4f2RIWaltIY1ofVM3XKfdCnM25uLFH7y4LabN8xJV+naZNbW276eBOru
         iyRtVDwYm7pOZqenaXN6OY8QvcLjPjQjROvs4jPZOekC9rWsqLZBhy6X5O37kjOZtM
         91lsyCPV4ItfY4n/bc7AOQAYFwF7XEsmuklLh18A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 502/879] PM: domains: Fix initialization of genpds next_wakeup
Date:   Tue,  7 Jun 2022 19:00:20 +0200
Message-Id: <20220607165017.445605712@linuxfoundation.org>
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

[ Upstream commit 622d9b5577f19a6472db21df042fea8f5fefe244 ]

In the genpd governor we walk the list of child-domains to take into
account their next_wakeup. If the child-domain itself, doesn't have a
governor assigned to it, we can end up using the next_wakeup value before
it has been properly initialized. To prevent a possible incorrect behaviour
in the governor, let's initialize next_wakeup to KTIME_MAX.

Fixes: c79aa080fb0f ("PM: domains: use device's next wakeup to determine domain idle state")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 1ee878d126fd..f0e4b0ea93e8 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1997,6 +1997,7 @@ int pm_genpd_init(struct generic_pm_domain *genpd,
 	genpd->device_count = 0;
 	genpd->max_off_time_ns = -1;
 	genpd->max_off_time_changed = true;
+	genpd->next_wakeup = KTIME_MAX;
 	genpd->provider = NULL;
 	genpd->has_provider = false;
 	genpd->accounting_time = ktime_get();
-- 
2.35.1




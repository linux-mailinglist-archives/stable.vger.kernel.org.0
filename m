Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1B253A696
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353598AbiFANyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353698AbiFANyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:54:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E122E8AE48;
        Wed,  1 Jun 2022 06:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36EE7B81AFB;
        Wed,  1 Jun 2022 13:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D241C3411F;
        Wed,  1 Jun 2022 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091598;
        bh=r3DLkc6jEcY3i0/3z56pH0qiShiXBiSeWD+DV9othKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G297vWd24QTYYN8UVhD/TX1OSFHuraIhEjO6QHdxM23UILW+Dd15Mzk1790p5UJXi
         d8ljLl4YFLuwPga5T17I5vCi/eCahcgmB7own6W5OWFF3zciw1JIJryzoRMXC/SXKG
         bekoqvwupBzFHW/fC3UWpqeUv/ADv8LFieZHpXjkCdeaf6DxFqiaW2d9evvf+peUKu
         4+b58QZZ9lr4Ajtiz1ZlykBepn/pSHb/Z4Kud3fqGdOw5xf/bVXTKUX9wmxrlSwOpP
         dXw4j8VwCfUh6DcpWet9zA79DhdTXjscxx8HXaWeN4CGs3jHpo45MwxisQl/+Xn8Bk
         pB8fynyOebNFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Jia-wei Chang <jia-wei.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 28/49] cpufreq: Avoid unnecessary frequency updates due to mismatch
Date:   Wed,  1 Jun 2022 09:51:52 -0400
Message-Id: <20220601135214.2002647-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit f55ae08c89873e140c7cac2a7fa161d31a0d60cf ]

For some platforms, the frequency returned by hardware may be slightly
different from what is provided in the frequency table. For example,
hardware may return 499 MHz instead of 500 MHz. In such cases it is
better to avoid getting into unnecessary frequency updates, as we may
end up switching policy->cur between the two and sending unnecessary
pre/post update notifications, etc.

This patch has chosen allows the hardware frequency and table frequency
to deviate by 1 MHz for now, we may want to increase it a bit later on
if someone still complains.

Reported-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Jia-wei Chang <jia-wei.chang@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 80f535cc8a75..fbaa8e6c7d23 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -28,6 +28,7 @@
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/tick.h>
+#include <linux/units.h>
 #include <trace/events/power.h>
 
 static LIST_HEAD(cpufreq_policy_list);
@@ -1707,6 +1708,16 @@ static unsigned int cpufreq_verify_current_freq(struct cpufreq_policy *policy, b
 		return new_freq;
 
 	if (policy->cur != new_freq) {
+		/*
+		 * For some platforms, the frequency returned by hardware may be
+		 * slightly different from what is provided in the frequency
+		 * table, for example hardware may return 499 MHz instead of 500
+		 * MHz. In such cases it is better to avoid getting into
+		 * unnecessary frequency updates.
+		 */
+		if (abs(policy->cur - new_freq) < HZ_PER_MHZ)
+			return policy->cur;
+
 		cpufreq_out_of_sync(policy, new_freq);
 		if (update)
 			schedule_work(&policy->update);
-- 
2.35.1


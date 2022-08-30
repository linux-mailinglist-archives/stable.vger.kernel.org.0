Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BED5A69BE
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiH3RWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiH3RWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:22:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57344AB063;
        Tue, 30 Aug 2022 10:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B24E8B81C35;
        Tue, 30 Aug 2022 17:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A02AC43470;
        Tue, 30 Aug 2022 17:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880031;
        bh=NyZYEkqcXaZfqxjTZ50hQOYGRdfmSqXY3CvuyG/rMX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRwWmk36+nDBTGPLgqNMuqs3zJMzbscxvy9TxkBp/Otc3dqcswl7gyd/llXRaeB/E
         uU38qC9tKKMPUAxQ/LsxhYQvpIz1mUYk+R1afkmx6s4EfHExexRXJIcchNcRtdWmwx
         Jycczwt0bO8SV/KLXtxRClPs7ajAPRGL3EYcwsMSL7pcHIzJgO0apT3eKKhrEvtDrc
         +YxFkzCwW+GTsxCn099NXovpxl2ULDCBNWsw688TxOGnNRNObejMD2szHp5qwtbOfN
         N+p96RiLVab9wOUA7X9tYpIXNPn+iDjOjShKVDO6S+tz/Ondw8COqcubNh/EvJ3mB3
         RSSXgR5Ry33iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukasz Luba <lukasz.luba@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 23/33] cpufreq: check only freq_table in __resolve_freq()
Date:   Tue, 30 Aug 2022 13:18:14 -0400
Message-Id: <20220830171825.580603-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit 6ca7076fbfaeccce173aeab832d76b9e49e1034b ]

There is no need to check if the cpufreq driver implements callback
cpufreq_driver::target_index. The logic in the __resolve_freq uses
the frequency table available in the policy. It doesn't matter if the
driver provides 'target_index' or 'target' callback. It just has to
populate the 'policy->freq_table'.

Thus, check only frequency table during the frequency resolving call.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2cad427741647..f9fd1b6c15d42 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -532,7 +532,7 @@ static unsigned int __resolve_freq(struct cpufreq_policy *policy,
 
 	target_freq = clamp_val(target_freq, policy->min, policy->max);
 
-	if (!cpufreq_driver->target_index)
+	if (!policy->freq_table)
 		return target_freq;
 
 	idx = cpufreq_frequency_table_target(policy, target_freq, relation);
-- 
2.35.1


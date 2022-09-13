Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDA05B6F31
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiIMOKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiIMOJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF995A152;
        Tue, 13 Sep 2022 07:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE1A6149A;
        Tue, 13 Sep 2022 14:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FCEC433C1;
        Tue, 13 Sep 2022 14:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078134;
        bh=NyZYEkqcXaZfqxjTZ50hQOYGRdfmSqXY3CvuyG/rMX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcQHCHDNPjhzKZixtf8K2ti6SIxcK2BCdS/bxRwZt+32kFMzRkJi3JkL+DE+dH4Bm
         GTJTQYIDDHQupqhlR5BAFbyR+pzWrYJcLhOgDJ4PypkHdwQBSSP4COoz5+062zGNIw
         eY7ZuPMfF570HsscGh+RjwudLBCWNYcwwEM/kxOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 026/192] cpufreq: check only freq_table in __resolve_freq()
Date:   Tue, 13 Sep 2022 16:02:12 +0200
Message-Id: <20220913140411.214707255@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D792D5487B5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352320AbiFMLRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353246AbiFMLPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:15:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12EB248EF;
        Mon, 13 Jun 2022 03:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C156CB80E94;
        Mon, 13 Jun 2022 10:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A47C34114;
        Mon, 13 Jun 2022 10:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116666;
        bh=odwwFRkk68+klX+IXiBeGcqimMANVc67CuJI9VaA7pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGLMRLD2kDrqiNPGcJrt4+ClkEZzegMzYGj0Xl7ZEnI4jES5cHxC4slXRRntBzack
         LMY6mV9dQcYJiDOczs0d3x3X1EYi2RYWjQdgUSMimYqnauGngtQJJ4FJrLPn5/iOTY
         r2t5XO+8MDilgzYU1H1vp+8+8YvjL63ngE2AzySs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/411] Revert "cpufreq: Fix possible race in cpufreq online error path"
Date:   Mon, 13 Jun 2022 12:06:42 +0200
Message-Id: <20220613094932.540761266@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 85f0e42bd65d01b351d561efb38e584d4c596553 ]

This reverts commit f346e96267cd76175d6c201b40f770c0116a8a04.

The commit tried to fix a possible real bug but it made it even worse.
The fix was simply buggy as now an error out to out_offline_policy or
out_exit_policy will try to release a semaphore which was never taken in
the first place. This works fine only if we failed late, i.e. via
out_destroy_policy.

Fixes: f346e96267cd ("cpufreq: Fix possible race in cpufreq online error path")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 7ea07764988e..af9f34804862 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1509,6 +1509,8 @@ static int cpufreq_online(unsigned int cpu)
 	for_each_cpu(j, policy->real_cpus)
 		remove_cpu_dev_symlink(policy, get_cpu_device(j));
 
+	up_write(&policy->rwsem);
+
 out_offline_policy:
 	if (cpufreq_driver->offline)
 		cpufreq_driver->offline(policy);
@@ -1517,9 +1519,6 @@ static int cpufreq_online(unsigned int cpu)
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 
-	cpumask_clear(policy->cpus);
-	up_write(&policy->rwsem);
-
 out_free_policy:
 	cpufreq_policy_free(policy);
 	return ret;
-- 
2.35.1




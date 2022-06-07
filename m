Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B189C541AAD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379789AbiFGVex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379767AbiFGVdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:33:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3215C22CEFD;
        Tue,  7 Jun 2022 12:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814C3B823AF;
        Tue,  7 Jun 2022 19:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E76C385A2;
        Tue,  7 Jun 2022 19:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628656;
        bh=QJPm2YlDollzSuo4wj5sT5ts8zA9rU3NK1m5esGJIOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jovxa03Vr+cgqw3zhq+F0Xm8eMWoRGbBYdedqLwe2Tv8bYK1ppBCdOX5e3yWj7H/F
         Ep6qu3+b2FR5f6cFnJRlcjwrGzS8VCzZA5rcuB7upZe1WopzF9XHeQbbm7pt2ljdli
         YS7aSF4SQbCKM8X4Z3sHrBQWJejwTgSYSl4HtnxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 407/879] Revert "cpufreq: Fix possible race in cpufreq online error path"
Date:   Tue,  7 Jun 2022 18:58:45 +0200
Message-Id: <20220607165014.676893477@linuxfoundation.org>
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
index 233e8af48848..fbaa8e6c7d23 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1534,6 +1534,8 @@ static int cpufreq_online(unsigned int cpu)
 	for_each_cpu(j, policy->real_cpus)
 		remove_cpu_dev_symlink(policy, get_cpu_device(j));
 
+	up_write(&policy->rwsem);
+
 out_offline_policy:
 	if (cpufreq_driver->offline)
 		cpufreq_driver->offline(policy);
@@ -1542,9 +1544,6 @@ static int cpufreq_online(unsigned int cpu)
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




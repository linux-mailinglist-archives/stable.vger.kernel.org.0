Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94108540B74
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351254AbiFGS3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351429AbiFGSQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C558C15FE05;
        Tue,  7 Jun 2022 10:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A31D61732;
        Tue,  7 Jun 2022 17:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C14C34115;
        Tue,  7 Jun 2022 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624167;
        bh=qoPbMV8oPXml9N7dYYeY2+90OzfkkdGHN6XcgA1S0kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpcqDoEi0bn2NFKOADe4XcBWZDekxS3PyoE2Ys7xb6SD+aOB1dCQsOmRV0fd6KjOP
         /uQYmH6zSuORYKxflmlvC1HQMjEpax5zLlrN492hgKnBC/k6kY729BoRsMVe+hgV3M
         KICtGoxMZoHVdVFFhIukFjA+IlLC23uptQLTzIV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/667] cpufreq: Fix possible race in cpufreq online error path
Date:   Tue,  7 Jun 2022 18:58:15 +0200
Message-Id: <20220607164941.686333872@linuxfoundation.org>
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

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit f346e96267cd76175d6c201b40f770c0116a8a04 ]

When cpufreq online fails, the policy->cpus mask is not cleared and
policy->rwsem is released too early, so the driver can be invoked
via the cpuinfo_cur_freq sysfs attribute while its ->offline() or
->exit() callbacks are being run.

Take policy->clk as an example:

static int cpufreq_online(unsigned int cpu)
{
  ...
  // policy->cpus != 0 at this time
  down_write(&policy->rwsem);
  ret = cpufreq_add_dev_interface(policy);
  up_write(&policy->rwsem);

  return 0;

out_destroy_policy:
	for_each_cpu(j, policy->real_cpus)
		remove_cpu_dev_symlink(policy, get_cpu_device(j));
    up_write(&policy->rwsem);
...
out_exit_policy:
  if (cpufreq_driver->exit)
    cpufreq_driver->exit(policy);
      clk_put(policy->clk);
      // policy->clk is a wild pointer
...
                                    ^
                                    |
                            Another process access
                            __cpufreq_get
                              cpufreq_verify_current_freq
                                cpufreq_generic_get
                                  // acces wild pointer of policy->clk;
                                    |
                                    |
out_offline_policy:                 |
  cpufreq_policy_free(policy);      |
    // deleted here, and will wait for no body reference
    cpufreq_policy_put_kobj(policy);
}

Address this by modifying cpufreq_online() to release policy->rwsem
in the error path after the driver callbacks have run and to clear
policy->cpus before releasing the semaphore.

Fixes: 7106e02baed4 ("cpufreq: release policy->rwsem on error")
Signed-off-by: Schspa Shi <schspa@gmail.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cddf7e13c232..502245710ee0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1528,8 +1528,6 @@ static int cpufreq_online(unsigned int cpu)
 	for_each_cpu(j, policy->real_cpus)
 		remove_cpu_dev_symlink(policy, get_cpu_device(j));
 
-	up_write(&policy->rwsem);
-
 out_offline_policy:
 	if (cpufreq_driver->offline)
 		cpufreq_driver->offline(policy);
@@ -1538,6 +1536,9 @@ static int cpufreq_online(unsigned int cpu)
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 
+	cpumask_clear(policy->cpus);
+	up_write(&policy->rwsem);
+
 out_free_policy:
 	cpufreq_policy_free(policy);
 	return ret;
-- 
2.35.1




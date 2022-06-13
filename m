Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCF1549014
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351794AbiFMLRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352484AbiFMLNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6781C35DE3;
        Mon, 13 Jun 2022 03:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D11C560FFD;
        Mon, 13 Jun 2022 10:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86D8C34114;
        Mon, 13 Jun 2022 10:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116580;
        bh=8NG6eTlEV5bUlXtUimdyw2SacvFJBG4XZ3T31zA2rd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3fWc9gBMAtxk6rA47nOxMZhu4l4E24GmsDKCAePVmSaAoHVPepWBjGn78/LpxgFD
         1KgJW5amGPJ7+9+aZk4M0+T9YZraq/7LpFGHcznay0QN7j2A6LMbfVRNQSD7zd4ElA
         bO2+VpL4dFzCOYkw+xqt0mJzpbRSto5f0AgQH4Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/411] cpufreq: Fix possible race in cpufreq online error path
Date:   Mon, 13 Jun 2022 12:06:16 +0200
Message-Id: <20220613094931.766124519@linuxfoundation.org>
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
index af9f34804862..7ea07764988e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1509,8 +1509,6 @@ static int cpufreq_online(unsigned int cpu)
 	for_each_cpu(j, policy->real_cpus)
 		remove_cpu_dev_symlink(policy, get_cpu_device(j));
 
-	up_write(&policy->rwsem);
-
 out_offline_policy:
 	if (cpufreq_driver->offline)
 		cpufreq_driver->offline(policy);
@@ -1519,6 +1517,9 @@ static int cpufreq_online(unsigned int cpu)
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




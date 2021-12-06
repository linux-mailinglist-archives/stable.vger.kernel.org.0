Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAFD469BB9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356992AbhLFPSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35902 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358297AbhLFPQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 757A761309;
        Mon,  6 Dec 2021 15:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7D9C341C2;
        Mon,  6 Dec 2021 15:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803582;
        bh=1XE0mcc/tmYyynTxn2n0wMzyC4wO2YrdfxfsU9Cv+C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d54ys2G5jnMXRCLMLFT1Z8QNLTPHd6IFGWqMN2pWhURQ9T+Ygfljz2uZxZNtwig6I
         /aRNTj3hTMmEDEfIxxV0Dhm9xaLdcyP89kTV/52ir/MarjpEy23wMRzjBFD9VA37+c
         qzcGtxE5jYkiF/ZoIAJQzKpz2T1xxNAMxnsLIu0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 27/70] cpufreq: Fix get_cpu_device() failure in add_cpu_dev_symlink()
Date:   Mon,  6 Dec 2021 15:56:31 +0100
Message-Id: <20211206145552.855681307@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

commit 2c1b5a84669d2477d8fffe9136e86a2cff591729 upstream.

When I hot added a CPU, I found 'cpufreq' directory was not created
below /sys/devices/system/cpu/cpuX/.

It is because get_cpu_device() failed in add_cpu_dev_symlink().

cpufreq_add_dev() is the .add_dev callback of a CPU subsys interface.
It will be called when the CPU device registered into the system.
The call chain is as follows:

  register_cpu()
  ->device_register()
   ->device_add()
    ->bus_probe_device()
     ->cpufreq_add_dev()

But only after the CPU device has been registered, we can get the
CPU device by get_cpu_device(), otherwise it will return NULL.

Since we already have the CPU device in cpufreq_add_dev(), pass
it to add_cpu_dev_symlink().

I noticed that the 'kobj' of the CPU device has been added into
the system before cpufreq_add_dev().

Fixes: 2f0ba790df51 ("cpufreq: Fix creation of symbolic links to policy directories")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -995,10 +995,9 @@ static struct kobj_type ktype_cpufreq =
 	.release	= cpufreq_sysfs_release,
 };
 
-static void add_cpu_dev_symlink(struct cpufreq_policy *policy, unsigned int cpu)
+static void add_cpu_dev_symlink(struct cpufreq_policy *policy, unsigned int cpu,
+				struct device *dev)
 {
-	struct device *dev = get_cpu_device(cpu);
-
 	if (unlikely(!dev))
 		return;
 
@@ -1384,7 +1383,7 @@ static int cpufreq_online(unsigned int c
 	if (new_policy) {
 		for_each_cpu(j, policy->related_cpus) {
 			per_cpu(cpufreq_cpu_data, j) = policy;
-			add_cpu_dev_symlink(policy, j);
+			add_cpu_dev_symlink(policy, j, get_cpu_device(j));
 		}
 
 		policy->min_freq_req = kzalloc(2 * sizeof(*policy->min_freq_req),
@@ -1547,7 +1546,7 @@ static int cpufreq_add_dev(struct device
 	/* Create sysfs link on CPU registration */
 	policy = per_cpu(cpufreq_cpu_data, cpu);
 	if (policy)
-		add_cpu_dev_symlink(policy, cpu);
+		add_cpu_dev_symlink(policy, cpu, dev);
 
 	return 0;
 }



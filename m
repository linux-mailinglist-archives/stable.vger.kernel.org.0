Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFEB468412
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384506AbhLDKdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 05:33:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbhLDKdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 05:33:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FFB7B80B0A
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6115AC341C2;
        Sat,  4 Dec 2021 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638613813;
        bh=G16BFDlpgODdmIcd2oHWvgRBh6ra/4ecUQYzQ412M3o=;
        h=Subject:To:Cc:From:Date:From;
        b=SOnd3lBCQWCXNO+lwlE1TpdG7CSKBQ/X5CXFwVNcpgXb03l1kF7GEKao3hZ4VwXSr
         WK4VHtsI3J2sfuo07+198UgvaDOw1t/rouwWH3347RPC/oxEO2qhzXLXLr7DMAA3m1
         45N29AkZRf3MJM7aPD+uHFbIJ9bQ6TERpPNit6tE=
Subject: FAILED: patch "[PATCH] cpufreq: Fix get_cpu_device() failure in" failed to apply to 4.14-stable tree
To:     wangxiongfeng2@huawei.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org, viresh.kumar@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 04 Dec 2021 11:30:03 +0100
Message-ID: <163861380308@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c1b5a84669d2477d8fffe9136e86a2cff591729 Mon Sep 17 00:00:00 2001
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Date: Mon, 29 Nov 2021 16:02:48 +0800
Subject: [PATCH] cpufreq: Fix get_cpu_device() failure in
 add_cpu_dev_symlink()

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

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e338d2f010fe..22aa2793e4d2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1004,10 +1004,9 @@ static struct kobj_type ktype_cpufreq = {
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
 
@@ -1391,7 +1390,7 @@ static int cpufreq_online(unsigned int cpu)
 	if (new_policy) {
 		for_each_cpu(j, policy->related_cpus) {
 			per_cpu(cpufreq_cpu_data, j) = policy;
-			add_cpu_dev_symlink(policy, j);
+			add_cpu_dev_symlink(policy, j, get_cpu_device(j));
 		}
 
 		policy->min_freq_req = kzalloc(2 * sizeof(*policy->min_freq_req),
@@ -1565,7 +1564,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	/* Create sysfs link on CPU registration */
 	policy = per_cpu(cpufreq_cpu_data, cpu);
 	if (policy)
-		add_cpu_dev_symlink(policy, cpu);
+		add_cpu_dev_symlink(policy, cpu, dev);
 
 	return 0;
 }


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79813469D7A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386504AbhLFP3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386702AbhLFP0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5A7C0698C1;
        Mon,  6 Dec 2021 07:17:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B77261357;
        Mon,  6 Dec 2021 15:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C88C53FD5;
        Mon,  6 Dec 2021 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803846;
        bh=XOa1sU5GhdZPGlaJVdpQfoEu2SMilBqMZDq/aGQ1vRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDIkxtU9tGx4hoL2GiGhzM8HpohghlfRo29nR6iCLcvk9MGlPj3j+S4Iq/OzfvYYC
         5M002H8tawqrY6DQF/1mfR6qqOwCPfe5SDCgpXWUt1h7RqVGxHCf+WMZdhII9xi81x
         g/9bQwQTDj7/uANPL5kOGlCT1eWQGa4dHGazLtMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 035/130] cpufreq: Fix get_cpu_device() failure in add_cpu_dev_symlink()
Date:   Mon,  6 Dec 2021 15:55:52 +0100
Message-Id: <20211206145600.881311151@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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
@@ -1004,10 +1004,9 @@ static struct kobj_type ktype_cpufreq =
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
 
@@ -1391,7 +1390,7 @@ static int cpufreq_online(unsigned int c
 	if (new_policy) {
 		for_each_cpu(j, policy->related_cpus) {
 			per_cpu(cpufreq_cpu_data, j) = policy;
-			add_cpu_dev_symlink(policy, j);
+			add_cpu_dev_symlink(policy, j, get_cpu_device(j));
 		}
 
 		policy->min_freq_req = kzalloc(2 * sizeof(*policy->min_freq_req),
@@ -1553,7 +1552,7 @@ static int cpufreq_add_dev(struct device
 	/* Create sysfs link on CPU registration */
 	policy = per_cpu(cpufreq_cpu_data, cpu);
 	if (policy)
-		add_cpu_dev_symlink(policy, cpu);
+		add_cpu_dev_symlink(policy, cpu, dev);
 
 	return 0;
 }



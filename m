Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EDF40ED38
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240821AbhIPWQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240827AbhIPWQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 18:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A5156108F;
        Thu, 16 Sep 2021 22:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631830489;
        bh=SfeUf1o1pmL3XHvIf2UQMyloUSRw60c7MbSYHN8KiiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lx6ixaedTikoy1s4K1GkBaooBmmmcv6F43EfgNT3UtcwOpT6vfEjiJ6QfbjacdeJV
         qEI7MdLl5qfGD1dLfeBTUJ09Mv8tgyovmzXHq1kfSMuRK6pGidaSZeKQ6NAPgxlvkd
         hyhAsTg5f/amtWu26NA7h5n1gOfGM1j8LPvsRuLslCbql7hplVVeZjPHgVGLKDeP1l
         /CxlQZyXUMGwFg9CtamfAdfNeUfGYpZPcRPCRwE3iHT+o+rYQyuvULSQZjB2k9nuru
         FC+CYKEAN5Km5cAKbsYOTUHDusLAPdERJ4EKcrSL8gjbeEiQVmt2OZWsz4BjAALIuh
         83oNf1DyVTgDQ==
Date:   Thu, 16 Sep 2021 18:14:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kevin Hao <haokexin@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5.13 039/380] cpufreq: schedutil: Use kobject release()
 method to free sugov_tunables
Message-ID: <YUPB2HlDaoLfNrQ2@sashalap>
References: <20210916155803.966362085@linuxfoundation.org>
 <20210916155805.299153663@linuxfoundation.org>
 <6592ddb7-3705-6eab-f54c-3f12dbd58a44@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6592ddb7-3705-6eab-f54c-3f12dbd58a44@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 06:55:49PM +0200, Rafael J. Wysocki wrote:
>On 9/16/2021 5:56 PM, Greg Kroah-Hartman wrote:
>>From: Kevin Hao <haokexin@gmail.com>
>>
>>commit e5c6b312ce3cc97e90ea159446e6bfa06645364d upstream.
>>
>>The struct sugov_tunables is protected by the kobject, so we can't free
>>it directly. Otherwise we would get a call trace like this:
>>   ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x30
>>   WARNING: CPU: 3 PID: 720 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
>>   Modules linked in:
>>   CPU: 3 PID: 720 Comm: a.sh Tainted: G        W         5.14.0-rc1-next-20210715-yocto-standard+ #507
>>   Hardware name: Marvell OcteonTX CN96XX board (DT)
>>   pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
>>   pc : debug_print_object+0xb8/0x100
>>   lr : debug_print_object+0xb8/0x100
>>   sp : ffff80001ecaf910
>>   x29: ffff80001ecaf910 x28: ffff00011b10b8d0 x27: ffff800011043d80
>>   x26: ffff00011a8f0000 x25: ffff800013cb3ff0 x24: 0000000000000000
>>   x23: ffff80001142aa68 x22: ffff800011043d80 x21: ffff00010de46f20
>>   x20: ffff800013c0c520 x19: ffff800011d8f5b0 x18: 0000000000000010
>>   x17: 6e6968207473696c x16: 5f72656d6974203a x15: 6570797420746365
>>   x14: 6a626f2029302065 x13: 303378302f307830 x12: 2b6e665f72656d69
>>   x11: ffff8000124b1560 x10: ffff800012331520 x9 : ffff8000100ca6b0
>>   x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 0000000000000001
>>   x5 : ffff800011d8c000 x4 : ffff800011d8c740 x3 : 0000000000000000
>>   x2 : ffff0001108301c0 x1 : ab3c90eedf9c0f00 x0 : 0000000000000000
>>   Call trace:
>>    debug_print_object+0xb8/0x100
>>    __debug_check_no_obj_freed+0x1c0/0x230
>>    debug_check_no_obj_freed+0x20/0x88
>>    slab_free_freelist_hook+0x154/0x1c8
>>    kfree+0x114/0x5d0
>>    sugov_exit+0xbc/0xc0
>>    cpufreq_exit_governor+0x44/0x90
>>    cpufreq_set_policy+0x268/0x4a8
>>    store_scaling_governor+0xe0/0x128
>>    store+0xc0/0xf0
>>    sysfs_kf_write+0x54/0x80
>>    kernfs_fop_write_iter+0x128/0x1c0
>>    new_sync_write+0xf0/0x190
>>    vfs_write+0x2d4/0x478
>>    ksys_write+0x74/0x100
>>    __arm64_sys_write+0x24/0x30
>>    invoke_syscall.constprop.0+0x54/0xe0
>>    do_el0_svc+0x64/0x158
>>    el0_svc+0x2c/0xb0
>>    el0t_64_sync_handler+0xb0/0xb8
>>    el0t_64_sync+0x198/0x19c
>>   irq event stamp: 5518
>>   hardirqs last  enabled at (5517): [<ffff8000100cbd7c>] console_unlock+0x554/0x6c8
>>   hardirqs last disabled at (5518): [<ffff800010fc0638>] el1_dbg+0x28/0xa0
>>   softirqs last  enabled at (5504): [<ffff8000100106e0>] __do_softirq+0x4d0/0x6c0
>>   softirqs last disabled at (5483): [<ffff800010049548>] irq_exit+0x1b0/0x1b8
>>
>>So split the original sugov_tunables_free() into two functions,
>>sugov_clear_global_tunables() is just used to clear the global_tunables
>>and the new sugov_tunables_free() is used as kobj_type::release to
>>release the sugov_tunables safely.
>>
>>Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
>>Cc: 4.7+ <stable@vger.kernel.org> # 4.7+
>>Signed-off-by: Kevin Hao <haokexin@gmail.com>
>>Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>>Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>---
>>  kernel/sched/cpufreq_schedutil.c |   16 +++++++++++-----
>>  1 file changed, 11 insertions(+), 5 deletions(-)
>>
>>--- a/kernel/sched/cpufreq_schedutil.c
>>+++ b/kernel/sched/cpufreq_schedutil.c
>>@@ -536,9 +536,17 @@ static struct attribute *sugov_attrs[] =
>>  };
>>  ATTRIBUTE_GROUPS(sugov);
>>+static void sugov_tunables_free(struct kobject *kobj)
>>+{
>>+	struct gov_attr_set *attr_set = container_of(kobj, struct gov_attr_set, kobj);
>>+
>>+	kfree(to_sugov_tunables(attr_set));
>>+}
>>+
>>  static struct kobj_type sugov_tunables_ktype = {
>>  	.default_groups = sugov_groups,
>>  	.sysfs_ops = &governor_sysfs_ops,
>>+	.release = &sugov_tunables_free,
>>  };
>>  /********************** cpufreq governor interface *********************/
>>@@ -638,12 +646,10 @@ static struct sugov_tunables *sugov_tuna
>>  	return tunables;
>>  }
>>-static void sugov_tunables_free(struct sugov_tunables *tunables)
>>+static void sugov_clear_global_tunables(void)
>>  {
>>  	if (!have_governor_per_policy())
>>  		global_tunables = NULL;
>>-
>>-	kfree(tunables);
>>  }
>>  static int sugov_init(struct cpufreq_policy *policy)
>>@@ -706,7 +712,7 @@ out:
>>  fail:
>>  	kobject_put(&tunables->attr_set.kobj);
>>  	policy->governor_data = NULL;
>>-	sugov_tunables_free(tunables);
>>+	sugov_clear_global_tunables();
>>  stop_kthread:
>>  	sugov_kthread_stop(sg_policy);
>>@@ -733,7 +739,7 @@ static void sugov_exit(struct cpufreq_po
>>  	count = gov_attr_set_put(&tunables->attr_set, &sg_policy->tunables_hook);
>>  	policy->governor_data = NULL;
>>  	if (!count)
>>-		sugov_tunables_free(tunables);
>>+		sugov_clear_global_tunables();
>>  	mutex_unlock(&global_tunables_lock);
>>
>>
>Please defer adding this one.

I'll drop, let us know when to bring it back.

-- 
Thanks,
Sasha

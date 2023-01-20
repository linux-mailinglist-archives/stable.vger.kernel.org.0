Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEEE674D6F
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 07:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjATGjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 01:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjATGjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 01:39:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D644A221
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 22:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD6B761E2C
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 06:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F12C433D2;
        Fri, 20 Jan 2023 06:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674196744;
        bh=sNh2gxFZAYQ439CmuOlMq4t9QiT0y5N56uMmeXoeAf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nlqql1kW+iDELBF/HbW04bW17TpwM0u3vy4PX1HluC93xDYHofOTDoXLoFAnyjGg+
         WnVFDUXG1lCjZRhhL57EDkPTaK+FR8NtNvLV8/sxVs8qp+mIjL3Eo20iPul2QXCx3P
         6BYHd3wBnQTDT6iR2SEbUv7RsIxkFTnpN5C58h6E=
Date:   Fri, 20 Jan 2023 07:39:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.15] cpufreq: governor: Use kobject release() method to
 free dbs_data
Message-ID: <Y8o3BIHcGt6FIKmY@kroah.com>
References: <20230120042650.3722921-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120042650.3722921-1-haokexin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 20, 2023 at 12:26:50PM +0800, Kevin Hao wrote:
> commit a85ee6401a47ae3fc64ba506cacb3e7873823c65 upstream.
> 
> The struct dbs_data embeds a struct gov_attr_set and
> the struct gov_attr_set embeds a kobject. Since every kobject must have
> a release() method and we can't use kfree() to free it directly,
> so introduce cpufreq_dbs_data_release() to release the dbs_data via
> the kobject::release() method. This fixes the calltrace like below:
> 
>   ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x34
>   WARNING: CPU: 12 PID: 810 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
>   Modules linked in:
>   CPU: 12 PID: 810 Comm: sh Not tainted 5.16.0-next-20220120-yocto-standard+ #536
>   Hardware name: Marvell OcteonTX CN96XX board (DT)
>   pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>   pc : debug_print_object+0xb8/0x100
>   lr : debug_print_object+0xb8/0x100
>   sp : ffff80001dfcf9a0
>   x29: ffff80001dfcf9a0 x28: 0000000000000001 x27: ffff0001464f0000
>   x26: 0000000000000000 x25: ffff8000090e3f00 x24: ffff80000af60210
>   x23: ffff8000094dfb78 x22: ffff8000090e3f00 x21: ffff0001080b7118
>   x20: ffff80000aeb2430 x19: ffff800009e8f5e0 x18: 0000000000000000
>   x17: 0000000000000002 x16: 00004d62e58be040 x15: 013590470523aff8
>   x14: ffff8000090e1828 x13: 0000000001359047 x12: 00000000f5257d14
>   x11: 0000000000040591 x10: 0000000066c1ffea x9 : ffff8000080d15e0
>   x8 : ffff80000a1765a8 x7 : 0000000000000000 x6 : 0000000000000001
>   x5 : ffff800009e8c000 x4 : ffff800009e8c760 x3 : 0000000000000000
>   x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0001474ed040
>   Call trace:
>    debug_print_object+0xb8/0x100
>    __debug_check_no_obj_freed+0x1d0/0x25c
>    debug_check_no_obj_freed+0x24/0xa0
>    kfree+0x11c/0x440
>    cpufreq_dbs_governor_exit+0xa8/0xac
>    cpufreq_exit_governor+0x44/0x90
>    cpufreq_set_policy+0x29c/0x570
>    store_scaling_governor+0x110/0x154
>    store+0xb0/0xe0
>    sysfs_kf_write+0x58/0x84
>    kernfs_fop_write_iter+0x12c/0x1c0
>    new_sync_write+0xf0/0x18c
>    vfs_write+0x1cc/0x220
>    ksys_write+0x74/0x100
>    __arm64_sys_write+0x28/0x3c
>    invoke_syscall.constprop.0+0x58/0xf0
>    do_el0_svc+0x70/0x170
>    el0_svc+0x54/0x190
>    el0t_64_sync_handler+0xa4/0x130
>    el0t_64_sync+0x1a0/0x1a4
>   irq event stamp: 189006
>   hardirqs last  enabled at (189005): [<ffff8000080849d0>] finish_task_switch.isra.0+0xe0/0x2c0
>   hardirqs last disabled at (189006): [<ffff8000090667a4>] el1_dbg+0x24/0xa0
>   softirqs last  enabled at (188966): [<ffff8000080106d0>] __do_softirq+0x4b0/0x6a0
>   softirqs last disabled at (188957): [<ffff80000804a618>] __irq_exit_rcu+0x108/0x1a4
> 
> [ rjw: Because can be freed by the gov_attr_set_put() in
>   cpufreq_dbs_governor_exit() now, it is also necessary to put the
>   invocation of the governor ->exit() callback into the new
>   cpufreq_dbs_data_release() function. ]
> 
> Fixes: c4435630361d ("cpufreq: governor: New sysfs show/store callbacks for governor tunables")
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> Hi,
> 
> The original upstream patch has the Fixes tag, but I have no idea why it
> wasn't picked up by the 5.15 stable kernel.

That is because that is NOT how you mark commits for stable backports.
Please see:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

thanks,

greg k-h

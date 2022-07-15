Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCC95763BD
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiGOOjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiGOOjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:39:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D0874DCD;
        Fri, 15 Jul 2022 07:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A681C61E2D;
        Fri, 15 Jul 2022 14:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF345C34115;
        Fri, 15 Jul 2022 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657895956;
        bh=VltdYe0WjX/UxbmNqL8yxmCyZjm7OUJflDRrQk8nhdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cK9E4l6NjgJ91mQeCrRdrjlOsTjJnFQ0thoPN0sKq7IVM3yAku1PudCfwVQaKiukx
         M4/E8erUen/eXz3nTeGqFJKIArtMB6OqZsjdcLNxWaUlZNmrvB0uB7vcNWT2gfcBSh
         7hsHP+DWRV2kEecVIbnJKVe3touoz7o9Taz0K6i8=
Date:   Fri, 15 Jul 2022 16:39:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     stable@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        xukuohai@huawei.com
Subject: Re: [PATCH 4.19] rcu/tree: Mark functions as notrace
Message-ID: <YtF8EKyR2/ztAYd9@kroah.com>
References: <20220713102009.126339-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713102009.126339-1-zhengyejian1@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 06:20:09PM +0800, Zheng Yejian wrote:
> This patch and problem analysis is based on v4.19 LTS, but v5.4 LTS
> and below seem to be involved.
> 
> Hulk Robot reports a softlockup problem, see following logs:
>   [   41.463870] watchdog: BUG: soft lockup - CPU#0 stuck for 22s!  [ksoftirqd/0:9]
>   [   41.509763] Modules linked in:
>   [   41.512295] CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 4.19.90 #13
>   [   41.516134] Hardware name: linux,dummy-virt (DT)
>   [   41.519182] pstate: 80c00005 (Nzcv daif +PAN +UAO)
>   [   41.522415] pc : perf_trace_buf_alloc+0x138/0x238
>   [   41.525583] lr : perf_trace_buf_alloc+0x138/0x238
>   [   41.528656] sp : ffff8000c137e880
>   [   41.531050] x29: ffff8000c137e880 x28: ffff20000850ced0
>   [   41.534759] x27: 0000000000000000 x26: ffff8000c137e9c0
>   [   41.538456] x25: ffff8000ce5c2ae0 x24: ffff200008358b08
>   [   41.542151] x23: 0000000000000000 x22: ffff2000084a50ac
>   [   41.545834] x21: ffff8000c137e880 x20: 000000000000001c
>   [   41.549516] x19: ffff7dffbfdf88e8 x18: 0000000000000000
>   [   41.553202] x17: 0000000000000000 x16: 0000000000000000
>   [   41.556892] x15: 1ffff00036e07805 x14: 0000000000000000
>   [   41.560592] x13: 0000000000000004 x12: 0000000000000000
>   [   41.564315] x11: 1fffefbff7fbf120 x10: ffff0fbff7fbf120
>   [   41.568003] x9 : dfff200000000000 x8 : ffff7dffbfdf8904
>   [   41.571699] x7 : 0000000000000000 x6 : ffff0fbff7fbf121
>   [   41.575398] x5 : ffff0fbff7fbf121 x4 : ffff0fbff7fbf121
>   [   41.579086] x3 : ffff20000850cdc8 x2 : 0000000000000008
>   [   41.582773] x1 : ffff8000c1376000 x0 : 0000000000000100
>   [   41.586495] Call trace:
>   [   41.588922]  perf_trace_buf_alloc+0x138/0x238
>   [   41.591912]  perf_ftrace_function_call+0x1ac/0x248
>   [   41.595123]  ftrace_ops_no_ops+0x3a4/0x488
>   [   41.597998]  ftrace_graph_call+0x0/0xc
>   [   41.600715]  rcu_dynticks_curr_cpu_in_eqs+0x14/0x70
>   [   41.603962]  rcu_is_watching+0xc/0x20
>   [   41.606635]  ftrace_ops_no_ops+0x240/0x488
>   [   41.609530]  ftrace_graph_call+0x0/0xc
>   [   41.612249]  __read_once_size_nocheck.constprop.0+0x1c/0x38
>   [   41.615905]  unwind_frame+0x140/0x358
>   [   41.618597]  walk_stackframe+0x34/0x60
>   [   41.621359]  __save_stack_trace+0x204/0x3b8
>   [   41.624328]  save_stack_trace+0x2c/0x38
>   [   41.627112]  __kasan_slab_free+0x120/0x228
>   [   41.630018]  kasan_slab_free+0x10/0x18
>   [   41.632752]  kfree+0x84/0x250
>   [   41.635107]  skb_free_head+0x70/0xb0
>   [   41.637772]  skb_release_data+0x3f8/0x730
>   [   41.640626]  skb_release_all+0x50/0x68
>   [   41.643350]  kfree_skb+0x84/0x278
>   [   41.645890]  kfree_skb_list+0x4c/0x78
>   [   41.648595]  __dev_queue_xmit+0x1a4c/0x23a0
>   [   41.651541]  dev_queue_xmit+0x28/0x38
>   [   41.654254]  ip6_finish_output2+0xeb0/0x1630
>   [   41.657261]  ip6_finish_output+0x2d8/0x7f8
>   [   41.660174]  ip6_output+0x19c/0x348
>   [   41.663850]  mld_sendpack+0x560/0x9e0
>   [   41.666564]  mld_ifc_timer_expire+0x484/0x8a8
>   [   41.669624]  call_timer_fn+0x68/0x4b0
>   [   41.672355]  expire_timers+0x168/0x498
>   [   41.675126]  run_timer_softirq+0x230/0x7a8
>   [   41.678052]  __do_softirq+0x2d0/0xba0
>   [   41.680763]  run_ksoftirqd+0x110/0x1a0
>   [   41.683512]  smpboot_thread_fn+0x31c/0x620
>   [   41.686429]  kthread+0x2c8/0x348
>   [   41.688927]  ret_from_fork+0x10/0x18
> 
> Look into above call stack, there is a recursive call in
> 'ftrace_graph_call', and the direct cause of above recursion is that
> 'rcu_dynticks_curr_cpu_in_eqs' is traced, see following snippet:
>     __read_once_size_nocheck.constprop.0
>       ftrace_graph_call    <-- 1. first call
>         ......
>           rcu_dynticks_curr_cpu_in_eqs
>             ftrace_graph_call    <-- 2. recursive call here!!!
> 
> Comparing with mainline kernel, commit ff5c4f5cad33 ("rcu/tree:
> Mark the idle relevant functions noinstr") mark related functions as
> 'noinstr' which implies notrace, noinline and sticks things in the
> .noinstr.text section.
> Link: https://lore.kernel.org/all/20200416114706.625340212@infradead.org/
> 
> But we cannot directly backport that commit, because there seems to be
> many prepatches. Instead, marking the functions as 'notrace' where it is
> 'noinstr' in that commit and mark 'rcu_dynticks_curr_cpu_in_eqs' as
> inline look like it resolves the problem.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  kernel/rcu/tree.c        | 22 +++++++++++-----------
>  kernel/rcu/tree_plugin.h |  4 ++--
>  2 files changed, 13 insertions(+), 13 deletions(-)

Given that no one has noticed this on 4.19 yet, this change is very odd.

What changed to cause this to suddenly happen?  How did you test this
change, and as you did change the function to be __alaways_inline, what
did that cause to have happen?

I would need an ack from the maintainer of this code before I can take
an out-of-tree patch.

thanks,

greg k-h

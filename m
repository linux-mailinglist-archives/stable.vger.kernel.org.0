Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4324BA8B4
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiBQStL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:49:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiBQStK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:49:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F84E51337
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 10:48:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D858561A09
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F21C340E8;
        Thu, 17 Feb 2022 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645123735;
        bh=vqkov8O0035gUn3uLYuzwbpWpo1uSyH67r7Rl61IAKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nU2w2ZgBKF1EbHyG3XtjzxFMGXv1AvLdkZigdgpWsdC5lL7WASj0nCZqwhg+crhaM
         KPkzNvFJOYkKJscrLw/WtAMWSVlET/+oY1qbAV/1cmUUU2hOQvcEaerc0gotm+z/h4
         dnrB0iQKBw7auydxMmhz5vgjXUug+ixNNjHQlTAU=
Date:   Thu, 17 Feb 2022 19:48:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     stable <stable@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 5.10] rcu: Do not report strict GPs for outgoing CPUs
Message-ID: <Yg6YlEJXYns7g2mD@kroah.com>
References: <20220215022319.2036-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215022319.2036-1-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 10:23:19AM +0800, Zhen Lei wrote:
> From: "Paul E. McKenney" <paulmck@kernel.org>
> 
> [ Upstream commit bfb3aa735f82c8d98b32a669934ee7d6b346264d ]
> 
> An outgoing CPU is marked offline in a stop-machine handler and most
> of that CPU's services stop at that point, including IRQ work queues.
> However, that CPU must take another pass through the scheduler and through
> a number of CPU-hotplug notifiers, many of which contain RCU readers.
> In the past, these readers were not a problem because the outgoing CPU
> has interrupts disabled, so that rcu_read_unlock_special() would not
> be invoked, and thus RCU would never attempt to queue IRQ work on the
> outgoing CPU.
> 
> This changed with the advent of the CONFIG_RCU_STRICT_GRACE_PERIOD
> Kconfig option, in which rcu_read_unlock_special() is invoked upon exit
> from almost all RCU read-side critical sections.  Worse yet, because
> interrupts are disabled, rcu_read_unlock_special() cannot immediately
> report a quiescent state and will therefore attempt to defer this
> reporting, for example, by queueing IRQ work.  Which fails with a splat
> because the CPU is already marked as being offline.
> 
> But it turns out that there is no need to report this quiescent state
> because rcu_report_dead() will do this job shortly after the outgoing
> CPU makes its final dive into the idle loop.  This commit therefore
> makes rcu_read_unlock_special() refrain from queuing IRQ work onto
> outgoing CPUs.
> 
> Fixes: 44bad5b3cca2 ("rcu: Do full report for .need_qs for strict GPs")
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  kernel/rcu/tree_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 6ed153f226b3925..244f32e98360fdf 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -628,7 +628,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
>  			set_tsk_need_resched(current);
>  			set_preempt_need_resched();
>  			if (IS_ENABLED(CONFIG_IRQ_WORK) && irqs_were_disabled &&
> -			    !rdp->defer_qs_iw_pending && exp) {
> +			    !rdp->defer_qs_iw_pending && exp && cpu_online(rdp->cpu)) {
>  				// Get scheduler to re-evaluate and call hooks.
>  				// If !IRQ_WORK, FQS scan will eventually IPI.
>  				init_irq_work(&rdp->defer_qs_iw,
> -- 
> 2.26.0.106.g9fadedd
> 

Now queued up, thanks.

greg k-h

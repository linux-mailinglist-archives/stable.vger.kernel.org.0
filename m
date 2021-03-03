Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76D732BC4A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445929AbhCCNsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:48:02 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:11376 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhCCL3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 06:29:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614770890; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=zGllyD3huHikD+ztAVK3+Lep3BJxE04HCiJpfzCmsIQ=; b=YTn09n2NE1AIYn9mQyIInwPZA/6ecpct+j3dGruA7G34qqpbO+zd+IFF92aOuOmmphf6IUcR
 iR5vF41z++m3s+32/t2cnb2cA3ARB6uvNpF/QmcQDHCCPzq4RUcI6oPm6S/3Ii+u4a7Pnbnn
 I1O/B3NQ3oEY0DN23zlkqyds4MM=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 603f6fd07b9e2700a3fa4b7f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 11:15:28
 GMT
Sender: neeraju=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B40BDC433CA; Wed,  3 Mar 2021 11:15:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [192.168.0.101] (unknown [124.123.173.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: neeraju)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22FB2C433C6;
        Wed,  3 Mar 2021 11:15:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 22FB2C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=neeraju@codeaurora.org
Subject: Re: [PATCH 01/13] rcu/nocb: Fix potential missed nocb_timer rearm
To:     paulmck@kernel.org, Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-2-frederic@kernel.org>
 <20210224183709.GI2743@paulmck-ThinkPad-P72>
 <20210224220606.GA3179@lothringen>
 <20210302014829.GK2696@paulmck-ThinkPad-P72>
 <20210302123444.GA97498@lothringen>
 <20210302181729.GN2696@paulmck-ThinkPad-P72>
From:   Neeraj Upadhyay <neeraju@codeaurora.org>
Message-ID: <7c301dfa-0acf-3dc2-733b-5831b2990cb2@codeaurora.org>
Date:   Wed, 3 Mar 2021 16:45:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210302181729.GN2696@paulmck-ThinkPad-P72>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/2/2021 11:47 PM, Paul E. McKenney wrote:
> On Tue, Mar 02, 2021 at 01:34:44PM +0100, Frederic Weisbecker wrote:
>> On Mon, Mar 01, 2021 at 05:48:29PM -0800, Paul E. McKenney wrote:
>>> On Wed, Feb 24, 2021 at 11:06:06PM +0100, Frederic Weisbecker wrote:
>>>> On Wed, Feb 24, 2021 at 10:37:09AM -0800, Paul E. McKenney wrote:
>>>>> On Tue, Feb 23, 2021 at 01:09:59AM +0100, Frederic Weisbecker wrote:
>>>>>> Two situations can cause a missed nocb timer rearm:
>>>>>>
>>>>>> 1) rdp(CPU A) queues its nocb timer. The grace period elapses before
>>>>>>     the timer get a chance to fire. The nocb_gp kthread is awaken by
>>>>>>     rdp(CPU B). The nocb_cb kthread for rdp(CPU A) is awaken and
>>>>>>     process the callbacks, again before the nocb_timer for CPU A get a
>>>>>>     chance to fire. rdp(CPU A) queues a callback and wakes up nocb_gp
>>>>>>     kthread, cancelling the pending nocb_timer without resetting the
>>>>>>     corresponding nocb_defer_wakeup.
>>>>>
>>>>> As discussed offlist, expanding the above scenario results in this
>>>>> sequence of steps:
>>>
>>> I renumbered the CPUs, since the ->nocb_gp_kthread would normally be
>>> associated with CPU 0.  If the first CPU to enqueue a callback was also
>>> CPU 0, nocb_gp_wait() might clear that CPU's ->nocb_defer_wakeup, which
>>> would prevent this scenario from playing out.  (But admittedly only if
>>> some other CPU handled by this same ->nocb_gp_kthread used its bypass.)
>>
>> Ok good point.
>>
>>>
>>>>> 1.	There are no callbacks queued for any CPU covered by CPU 0-2's
>>>>> 	->nocb_gp_kthread.
>>>
>>> And ->nocb_gp_kthread is associated with CPU 0.
>>>
>>>>> 2.	CPU 1 enqueues its first callback with interrupts disabled, and
>>>>> 	thus must defer awakening its ->nocb_gp_kthread.  It therefore
>>>>> 	queues its rcu_data structure's ->nocb_timer.
>>>
>>> At this point, CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.
>>
>> Right.
>>
>>>>> 7.	The grace period ends, so rcu_gp_kthread awakens the
>>>>> 	->nocb_gp_kthread, which in turn awakens both CPU 1's and
>>>>> 	CPU 2's ->nocb_cb_kthread.
>>>
>>> And then ->nocb_cb_kthread sleeps waiting for more callbacks.
>>
>> Yep
>>
>>>> I managed to recollect some pieces of my brain. So keep the above but
>>>> let's change the point 10:
>>>>
>>>> 10.	CPU 1 enqueues its second callback, this time with interrupts
>>>>   	enabled so it can wake directly	->nocb_gp_kthread.
>>>> 	It does so with calling __wake_nocb_gp() which also cancels the
>>>
>>> wake_nocb_gp() in current -rcu, correct?
>>
>> Heh, right.
>>
>>>>> So far so good, but why isn't the timer still queued from back in step 2?
>>>>> What am I missing here?  Either way, could you please update the commit
>>>>> logs to tell the full story?  At some later time, you might be very
>>>>> happy that you did.  ;-)
>>>>>
>>>>>> 2) The "nocb_bypass_timer" ends up calling wake_nocb_gp() which deletes
>>>>>>     the pending "nocb_timer" (note they are not the same timers) for the
>>>>>>     given rdp without resetting the matching state stored in nocb_defer
>>>>>>     wakeup.
>>>
>>> Would like to similarly expand this one, or would you prefer to rest your
>>> case on Case 1) above?
>>
>> I was about to say that we can skip that one, the changelog will already be
>> big enough but the "Fixes:" tag refers to the second scenario, since it's the
>> oldest vulnerable commit AFAICS.
>>
>>>>>> Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
> 
> OK, how about if I queue a temporary commit (shown below) that just
> calls out the first scenario so that I can start testing, and you get
> me more detail on the second scenario?  I can then update the commit.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit 302fd54b9ae98f678624cbf9bf7a4ca88455a8f9
> Author: Frederic Weisbecker <frederic@kernel.org>
> Date:   Tue Feb 23 01:09:59 2021 +0100
> 
>      rcu/nocb: Fix missed nocb_timer requeue
>      
>      This sequence of events can lead to a failure to requeue a CPU's
>      ->nocb_timer:
>      
>      1.      There are no callbacks queued for any CPU covered by CPU 0-2's
>              ->nocb_gp_kthread.  Note that ->nocb_gp_kthread is associated
>              with CPU 0.
>      
>      2.      CPU 1 enqueues its first callback with interrupts disabled, and
>              thus must defer awakening its ->nocb_gp_kthread.  It therefore
>              queues its rcu_data structure's ->nocb_timer.  At this point,
>              CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.
>      
>      3.      CPU 2, which shares the same ->nocb_gp_kthread, also enqueues a
>              callback, but with interrupts enabled, allowing it to directly
>              awaken the ->nocb_gp_kthread.
>      
>      4.      The newly awakened ->nocb_gp_kthread associates both CPU 1's
>              and CPU 2's callbacks with a future grace period and arranges
>              for that grace period to be started.
>      
>      5.      This ->nocb_gp_kthread goes to sleep waiting for the end of this
>              future grace period.
>      
>      6.      This grace period elapses before the CPU 1's timer fires.
>              This is normally improbably given that the timer is set for only
>              one jiffy, but timers can be delayed.  Besides, it is possible
>              that kernel was built with CONFIG_RCU_STRICT_GRACE_PERIOD=y.
>      
>      7.      The grace period ends, so rcu_gp_kthread awakens the
>              ->nocb_gp_kthread, which in turn awakens both CPU 1's and
>              CPU 2's ->nocb_cb_kthread.  Then ->nocb_gb_kthread sleeps
>              waiting for more newly queued callbacks.
>      
>      8.      CPU 1's ->nocb_cb_kthread invokes its callback, then sleeps
>              waiting for more invocable callbacks.
>      
>      9.      Note that neither kthread updated any ->nocb_timer state,
>              so CPU 1's ->nocb_defer_wakeup is still set to RCU_NOCB_WAKE.
>      
>      10.     CPU 1 enqueues its second callback, this time with interrupts
>              enabled so it can wake directly ->nocb_gp_kthread.
>              It does so with calling wake_nocb_gp() which also cancels the
>              pending timer that got queued in step 2. But that doesn't reset
>              CPU 1's ->nocb_defer_wakeup which is still set to RCU_NOCB_WAKE.
>              So CPU 1's ->nocb_defer_wakeup and its ->nocb_timer are now
>              desynchronized.
>      
>      11.     ->nocb_gp_kthread associates the callback queued in 10 with a new
>              grace period, arranges for that grace period to start and sleeps
>              waiting for it to complete.
>      
>      12.     The grace period ends, rcu_gp_kthread awakens ->nocb_gp_kthread,
>              which in turn wakes up CPU 1's ->nocb_cb_kthread which then
>              invokes the callback queued in 10.
>      
>      13.     CPU 1 enqueues its third callback, this time with interrupts
>              disabled so it must queue a timer for a deferred wakeup. However
>              the value of its ->nocb_defer_wakeup is RCU_NOCB_WAKE which
>              incorrectly indicates that a timer is already queued.  Instead,
>              CPU 1's ->nocb_timer was cancelled in 10.  CPU 1 therefore fails
>              to queue the ->nocb_timer.
>      
>      14.     CPU 1 has its pending callback and it may go unnoticed until
>              some other CPU ever wakes up ->nocb_gp_kthread or CPU 1 ever
>              calls an explicit deferred wakeup, for example, during idle entry.
>      
>      This commit fixes this bug by resetting rdp->nocb_defer_wakeup everytime
>      we delete the ->nocb_timer.
>      
>      Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
>      Cc: Stable <stable@vger.kernel.org>
>      Cc: Josh Triplett <josh@joshtriplett.org>
>      Cc: Lai Jiangshan <jiangshanlai@gmail.com>
>      Cc: Joel Fernandes <joel@joelfernandes.org>
>      Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
>      Cc: Boqun Feng <boqun.feng@gmail.com>
>      Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>      Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 44746d8..429491d 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1721,7 +1721,11 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
>   		rcu_nocb_unlock_irqrestore(rdp, flags);
>   		return false;
>   	}
> -	del_timer(&rdp->nocb_timer);
> +
> +	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
> +		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> +		del_timer(&rdp->nocb_timer);
> +	}
>   	rcu_nocb_unlock_irqrestore(rdp, flags);
>   	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
>   	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
> @@ -2350,7 +2354,6 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
>   		return false;
>   	}
>   	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
> -	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
>   	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
>   	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
>   
> 

Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>


Thanks
Neeraj

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member of the Code Aurora Forum, hosted by The Linux Foundation

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC9360014C
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 18:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJPQ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 12:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJPQ1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 12:27:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9301EC71
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665937589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+QCUZkv5M9hvtg8m3TCgsoHZd84T7mZTAK1mcY90w4=;
        b=hoLfFgqGyiELsbBjk8C5tai5hreqVog6HX3NJuIqZyM2fw+6Jh0g3kmQqpGnp9qtJn5iA8
        fVhP7Wbu4ydJk6BHg/Wl6508Kfr4fmykH2wdrOrJhH1X7Nz3SlbBLsGY7QKaK08CQt2lVH
        EcEUr4Vo0+ex7KtObPVqtEV1FghBAA4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-vO3XOPCDMxqSCytnpp3W1A-1; Sun, 16 Oct 2022 12:26:23 -0400
X-MC-Unique: vO3XOPCDMxqSCytnpp3W1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6471029ABA1D;
        Sun, 16 Oct 2022 16:26:23 +0000 (UTC)
Received: from [10.22.8.77] (unknown [10.22.8.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08F0FC56639;
        Sun, 16 Oct 2022 16:26:23 +0000 (UTC)
Message-ID: <778aaa49-9595-00b2-f054-717d871d4e08@redhat.com>
Date:   Sun, 16 Oct 2022 12:26:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: FAILED: patch "[PATCH] tracing: Disable interrupt or preemption
 before acquiring" failed to apply to 5.4-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, boqun.feng@gmail.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org, will@kernel.org
Cc:     stable@vger.kernel.org
References: <166593467012288@kroah.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <166593467012288@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/16/22 11:37, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> Possible dependencies:
>
> c0a581d7126c ("tracing: Disable interrupt or preemption before acquiring arch_spinlock_t")
>
> thanks,
>
> greg k-h

You just have to remove the lockdep_assert_preemption_disabled() line as 
this macro isn't defined in v5.4. It is a debug statement and its 
removal won't have any functional impact.

Cheers,
Longman

>
> ------------------ original commit in Linus's tree ------------------
>
>  From c0a581d7126c0bbc96163276f585fd7b4e4d8d0e Mon Sep 17 00:00:00 2001
> From: Waiman Long <longman@redhat.com>
> Date: Thu, 22 Sep 2022 10:56:22 -0400
> Subject: [PATCH] tracing: Disable interrupt or preemption before acquiring
>   arch_spinlock_t
>
> It was found that some tracing functions in kernel/trace/trace.c acquire
> an arch_spinlock_t with preemption and irqs enabled. An example is the
> tracing_saved_cmdlines_size_read() function which intermittently causes
> a "BUG: using smp_processor_id() in preemptible" warning when the LTP
> read_all_proc test is run.
>
> That can be problematic in case preemption happens after acquiring the
> lock. Add the necessary preemption or interrupt disabling code in the
> appropriate places before acquiring an arch_spinlock_t.
>
> The convention here is to disable preemption for trace_cmdline_lock and
> interupt for max_lock.
>
> Link: https://lkml.kernel.org/r/20220922145622.1744826-1-longman@redhat.com
>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: a35873a0993b ("tracing: Add conditional snapshot")
> Fixes: 939c7a4f04fc ("tracing: Introduce saved_cmdlines_size file")
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d3005279165d..aed7ea6e6045 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1193,12 +1193,14 @@ void *tracing_cond_snapshot_data(struct trace_array *tr)
>   {
>   	void *cond_data = NULL;
>   
> +	local_irq_disable();
>   	arch_spin_lock(&tr->max_lock);
>   
>   	if (tr->cond_snapshot)
>   		cond_data = tr->cond_snapshot->cond_data;
>   
>   	arch_spin_unlock(&tr->max_lock);
> +	local_irq_enable();
>   
>   	return cond_data;
>   }
> @@ -1334,9 +1336,11 @@ int tracing_snapshot_cond_enable(struct trace_array *tr, void *cond_data,
>   		goto fail_unlock;
>   	}
>   
> +	local_irq_disable();
>   	arch_spin_lock(&tr->max_lock);
>   	tr->cond_snapshot = cond_snapshot;
>   	arch_spin_unlock(&tr->max_lock);
> +	local_irq_enable();
>   
>   	mutex_unlock(&trace_types_lock);
>   
> @@ -1363,6 +1367,7 @@ int tracing_snapshot_cond_disable(struct trace_array *tr)
>   {
>   	int ret = 0;
>   
> +	local_irq_disable();
>   	arch_spin_lock(&tr->max_lock);
>   
>   	if (!tr->cond_snapshot)
> @@ -1373,6 +1378,7 @@ int tracing_snapshot_cond_disable(struct trace_array *tr)
>   	}
>   
>   	arch_spin_unlock(&tr->max_lock);
> +	local_irq_enable();
>   
>   	return ret;
>   }
> @@ -2200,6 +2206,11 @@ static size_t tgid_map_max;
>   
>   #define SAVED_CMDLINES_DEFAULT 128
>   #define NO_CMDLINE_MAP UINT_MAX
> +/*
> + * Preemption must be disabled before acquiring trace_cmdline_lock.
> + * The various trace_arrays' max_lock must be acquired in a context
> + * where interrupt is disabled.
> + */
>   static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
>   struct saved_cmdlines_buffer {
>   	unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
> @@ -2412,7 +2423,11 @@ static int trace_save_cmdline(struct task_struct *tsk)
>   	 * the lock, but we also don't want to spin
>   	 * nor do we want to disable interrupts,
>   	 * so if we miss here, then better luck next time.
> +	 *
> +	 * This is called within the scheduler and wake up, so interrupts
> +	 * had better been disabled and run queue lock been held.
>   	 */
> +	lockdep_assert_preemption_disabled();
>   	if (!arch_spin_trylock(&trace_cmdline_lock))
>   		return 0;
>   
> @@ -5890,9 +5905,11 @@ tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
>   	char buf[64];
>   	int r;
>   
> +	preempt_disable();
>   	arch_spin_lock(&trace_cmdline_lock);
>   	r = scnprintf(buf, sizeof(buf), "%u\n", savedcmd->cmdline_num);
>   	arch_spin_unlock(&trace_cmdline_lock);
> +	preempt_enable();
>   
>   	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
>   }
> @@ -5917,10 +5934,12 @@ static int tracing_resize_saved_cmdlines(unsigned int val)
>   		return -ENOMEM;
>   	}
>   
> +	preempt_disable();
>   	arch_spin_lock(&trace_cmdline_lock);
>   	savedcmd_temp = savedcmd;
>   	savedcmd = s;
>   	arch_spin_unlock(&trace_cmdline_lock);
> +	preempt_enable();
>   	free_saved_cmdlines_buffer(savedcmd_temp);
>   
>   	return 0;
> @@ -6373,10 +6392,12 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
>   
>   #ifdef CONFIG_TRACER_SNAPSHOT
>   	if (t->use_max_tr) {
> +		local_irq_disable();
>   		arch_spin_lock(&tr->max_lock);
>   		if (tr->cond_snapshot)
>   			ret = -EBUSY;
>   		arch_spin_unlock(&tr->max_lock);
> +		local_irq_enable();
>   		if (ret)
>   			goto out;
>   	}
> @@ -7436,10 +7457,12 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
>   		goto out;
>   	}
>   
> +	local_irq_disable();
>   	arch_spin_lock(&tr->max_lock);
>   	if (tr->cond_snapshot)
>   		ret = -EBUSY;
>   	arch_spin_unlock(&tr->max_lock);
> +	local_irq_enable();
>   	if (ret)
>   		goto out;
>   
>


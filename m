Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754B6316C61
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 18:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhBJRR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 12:17:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:35790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232683AbhBJRRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 12:17:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612977421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dvw6lO/krvYEguk6lpQWl/lG+Hg8h0QutF3y6sNkrWQ=;
        b=MozZHVfPcbekPoUWP9Z7Okgj9rqa5ORtTxPHPZObd0M48kJ+sZy/VJOqbvp4pN0n+tuMme
        UPqpiOB0eQk8QT5nBRcVegBFhgfF4/+ATagmGytTPUOnlX8OpjCKPovewy7BVr7F6QtDr8
        m8NTz//MsGeH0z+0oJQYZbP4ucU/ECQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3B89AC97;
        Wed, 10 Feb 2021 17:17:00 +0000 (UTC)
Date:   Wed, 10 Feb 2021 18:16:59 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     sergey.senozhatsky@gmail.com, rostedt@goodmis.org,
        john.ogness@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] printk: fix deadlock when kernel panic
Message-ID: <YCQVC6oBKKjtM/yg@alley>
References: <20210210034823.64867-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210034823.64867-1-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2021-02-10 11:48:23, Muchun Song wrote:
> printk_safe_flush_on_panic() caused the following deadlock on our
> server:
> 
> CPU0:                                         CPU1:
> panic                                         rcu_dump_cpu_stacks
>   kdump_nmi_shootdown_cpus                      nmi_trigger_cpumask_backtrace
>     register_nmi_handler(crash_nmi_callback)      printk_safe_flush
>                                                     __printk_safe_flush
>                                                       raw_spin_lock_irqsave(&read_lock)
>     // send NMI to other processors
>     apic_send_IPI_allbutself(NMI_VECTOR)
>                                                         // NMI interrupt, dead loop
>                                                         crash_nmi_callback
>   printk_safe_flush_on_panic
>     printk_safe_flush
>       __printk_safe_flush
>         // deadlock
>         raw_spin_lock_irqsave(&read_lock)
> 
> DEADLOCK: read_lock is taken on CPU1 and will never get released.
> 
> It happens when panic() stops a CPU by NMI while it has been in
> the middle of printk_safe_flush().
> 
> Handle the lock the same way as logbuf_lock. The printk_safe buffers
> are flushed only when both locks can be safely taken. It can avoid
> the deadlock _in this particular case_ at expense of losing contents
> of printk_safe buffers.
> 
> Note: It would actually be safe to re-init the locks when all CPUs were
>       stopped by NMI. But it would require passing this information
>       from arch-specific code. It is not worth the complexity.
>       Especially because logbuf_lock and printk_safe buffers have been
>       obsoleted by the lockless ring buffer.
> 
> Fixes: cf9b1106c81c ("printk/nmi: flush NMI messages on the system panic")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Cc: <stable@vger.kernel.org>

The patch is committed on printk/linux.git, branch for-5.12.

Best Regards,
Petr

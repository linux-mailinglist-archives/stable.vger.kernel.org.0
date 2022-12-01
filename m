Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510FF63F1EB
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 14:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiLANoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 08:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiLANoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 08:44:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6991D1021;
        Thu,  1 Dec 2022 05:44:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07F5962010;
        Thu,  1 Dec 2022 13:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47B5C433D7;
        Thu,  1 Dec 2022 13:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669902292;
        bh=5sRFITPs44j4r5KcAiIfITkBuIoIWOP6e18wJXIjo7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=owJLq6bFIEy6vvDGINrSVr4BkcjrKupAsXEu+OWJWk1BBf1NIvmKqC877C+C9KSMZ
         BnuTVrkkiS7VROWbnvi49Eoucv6qk7Nr7JPi9HCLBbL8YENNfCQ/qSjcXLZI9q4S1Z
         GabyMTN5qpO4y90HaWX3zFM1Fzau0WVUMJh72ey6z7WV99cnnxfBK/bVqa1/xpHY9l
         bkPrCwWfKtjtgsQw7W07iaxZg+u9C+0xJjg/DuY4VERPPPUXO2UqnRbS+qWOjNAnua
         daPVmPW9TzkmyN+hbx2czrcT7VoH/m7iRGqZy7Qp+m8fG4ZXlp8Oh6gec30bjCY07E
         vb6H4oPjbVn5Q==
Date:   Thu, 1 Dec 2022 13:44:46 +0000
From:   Will Deacon <will@kernel.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        David Wang =?utf-8?B?546L5qCH?= <wangbiao3@xiaomi.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH-tip] sched: Fix use-after-free bug in dup_user_cpus_ptr()
Message-ID: <20221201134445.GC28489@willie-the-truck>
References: <20221128014441.1264867-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221128014441.1264867-1-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 27, 2022 at 08:44:41PM -0500, Waiman Long wrote:
> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> restricted on asymmetric systems"), the setting and clearing of
> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> protection. When racing with the clearing of user_cpus_ptr in
> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> double-free in arm64 kernel.
> 
> Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
> cpumask") fixes this problem as user_cpus_ptr, once set, will never
> be cleared in a task's lifetime. However, this bug was re-introduced
> in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
> do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
> do_set_cpus_allowed(). This time, it will affect all arches.
> 
> Fix this bug by always clearing the user_cpus_ptr of the newly
> cloned/forked task before the copying process starts and check the
> user_cpus_ptr state of the source task under pi_lock.
> 
> Note to stable, this patch won't be applicable to stable releases.
> Just copy the new dup_user_cpus_ptr() function over.
> 
> Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
> Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
> CC: stable@vger.kernel.org
> Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/sched/core.c | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)

As per my comments on the previous version of this patch:

https://lore.kernel.org/lkml/20221201133602.GB28489@willie-the-truck/T/#t

I think there are other issues to fix when racing affinity changes with
fork() too.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 8df51b08bb38..f2b75faaf71a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2624,19 +2624,43 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
>  int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
>  		      int node)
>  {
> +	cpumask_t *user_mask;
>  	unsigned long flags;
>  
> +	/*
> +	 * Always clear dst->user_cpus_ptr first as their user_cpus_ptr's
> +	 * may differ by now due to racing.
> +	 */
> +	dst->user_cpus_ptr = NULL;
> +
> +	/*
> +	 * This check is racy and losing the race is a valid situation.
> +	 * It is not worth the extra overhead of taking the pi_lock on
> +	 * every fork/clone.
> +	 */
>  	if (!src->user_cpus_ptr)
>  		return 0;

data_race() ?

>  
> -	dst->user_cpus_ptr = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
> -	if (!dst->user_cpus_ptr)
> +	user_mask = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
> +	if (!user_mask)
>  		return -ENOMEM;
>  
> -	/* Use pi_lock to protect content of user_cpus_ptr */
> +	/*
> +	 * Use pi_lock to protect content of user_cpus_ptr
> +	 *
> +	 * Though unlikely, user_cpus_ptr can be reset to NULL by a concurrent
> +	 * do_set_cpus_allowed().
> +	 */
>  	raw_spin_lock_irqsave(&src->pi_lock, flags);
> -	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
> +	if (src->user_cpus_ptr) {
> +		swap(dst->user_cpus_ptr, user_mask);

Isn't 'dst->user_cpus_ptr' always NULL here? Why do we need the swap()
instead of just assigning the thing directly?

Will

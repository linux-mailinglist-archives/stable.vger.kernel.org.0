Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DCE640460
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 11:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiLBKSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 05:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiLBKSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 05:18:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA4FCC66E;
        Fri,  2 Dec 2022 02:18:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0940B80955;
        Fri,  2 Dec 2022 10:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48B6C433C1;
        Fri,  2 Dec 2022 10:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669976322;
        bh=e8M9us2wlgd06uRL7pLvxq/RDcxr6Ub0xUnPx5dg69Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K6YbS6KD6zo67AdFSsQQv8RDXhTCV8C2eL4d7TrO4lvA+N1Unh6V4zWMraPR4AlRD
         wWM4cp5n7sTZLfxoD6TvRhGrQ2UTxLG0W0d0grU/QGiR5gaPmGBhSbJhFj7l1X/7gw
         ucaKU0WuVLvQHtVv+Scwz0YYrwoPsmVk8VQlfPt+ttAb+Wcpl0G/E4bfghddOFSfXF
         ckMzvLcKUnwYNWPIbZi1r7iKsO200G81FMLz9r0JyKcByrUZNFW5g1CKTEeorUons9
         /xlwUtawkR9qC+cLCIBdCderTFOSrg9g1+Ytljh45MwGOCDcNfTsqmBdC1x0PRPaFg
         QoG3xxTWDleeA==
Date:   Fri, 2 Dec 2022 10:18:35 +0000
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
Message-ID: <20221202101835.GA29522@willie-the-truck>
References: <20221128014441.1264867-1-longman@redhat.com>
 <20221201134445.GC28489@willie-the-truck>
 <330989bf-0015-6d4c-9317-bfc9dba30b65@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <330989bf-0015-6d4c-9317-bfc9dba30b65@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 01, 2022 at 12:03:39PM -0500, Waiman Long wrote:
> On 12/1/22 08:44, Will Deacon wrote:
> > On Sun, Nov 27, 2022 at 08:44:41PM -0500, Waiman Long wrote:
> > > Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> > > restricted on asymmetric systems"), the setting and clearing of
> > > user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> > > dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> > > protection. When racing with the clearing of user_cpus_ptr in
> > > __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> > > double-free in arm64 kernel.
> > > 
> > > Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
> > > cpumask") fixes this problem as user_cpus_ptr, once set, will never
> > > be cleared in a task's lifetime. However, this bug was re-introduced
> > > in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
> > > do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
> > > do_set_cpus_allowed(). This time, it will affect all arches.
> > > 
> > > Fix this bug by always clearing the user_cpus_ptr of the newly
> > > cloned/forked task before the copying process starts and check the
> > > user_cpus_ptr state of the source task under pi_lock.
> > > 
> > > Note to stable, this patch won't be applicable to stable releases.
> > > Just copy the new dup_user_cpus_ptr() function over.
> > > 
> > > Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
> > > Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
> > > CC: stable@vger.kernel.org
> > > Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
> > > Signed-off-by: Waiman Long <longman@redhat.com>
> > > ---
> > >   kernel/sched/core.c | 32 ++++++++++++++++++++++++++++----
> > >   1 file changed, 28 insertions(+), 4 deletions(-)
> > As per my comments on the previous version of this patch:
> > 
> > https://lore.kernel.org/lkml/20221201133602.GB28489@willie-the-truck/T/#t
> > 
> > I think there are other issues to fix when racing affinity changes with
> > fork() too.
> It is certainly possible that there are other bugs hiding somewhere:-)

Right, but I actually took the time to hit the same race for the other
affinity mask field so it seems a bit narrow-minded for us just to fix the
one issue.

> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index 8df51b08bb38..f2b75faaf71a 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -2624,19 +2624,43 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
> > >   int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
> > >   		      int node)
> > >   {
> > > +	cpumask_t *user_mask;
> > >   	unsigned long flags;
> > > +	/*
> > > +	 * Always clear dst->user_cpus_ptr first as their user_cpus_ptr's
> > > +	 * may differ by now due to racing.
> > > +	 */
> > > +	dst->user_cpus_ptr = NULL;
> > > +
> > > +	/*
> > > +	 * This check is racy and losing the race is a valid situation.
> > > +	 * It is not worth the extra overhead of taking the pi_lock on
> > > +	 * every fork/clone.
> > > +	 */
> > >   	if (!src->user_cpus_ptr)
> > >   		return 0;
> > data_race() ?
> Race is certainly possible, but the clearing of user_cpus_ptr before will
> mitigate any risk.

Sorry, I meant let's wrap this access in the data_race() macro and add a
comment so that KCSAN won't report the false positive.

> > > -	dst->user_cpus_ptr = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
> > > -	if (!dst->user_cpus_ptr)
> > > +	user_mask = kmalloc_node(cpumask_size(), GFP_KERNEL, node);
> > > +	if (!user_mask)
> > >   		return -ENOMEM;
> > > -	/* Use pi_lock to protect content of user_cpus_ptr */
> > > +	/*
> > > +	 * Use pi_lock to protect content of user_cpus_ptr
> > > +	 *
> > > +	 * Though unlikely, user_cpus_ptr can be reset to NULL by a concurrent
> > > +	 * do_set_cpus_allowed().
> > > +	 */
> > >   	raw_spin_lock_irqsave(&src->pi_lock, flags);
> > > -	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
> > > +	if (src->user_cpus_ptr) {
> > > +		swap(dst->user_cpus_ptr, user_mask);
> > Isn't 'dst->user_cpus_ptr' always NULL here? Why do we need the swap()
> > instead of just assigning the thing directly?
> 
> True. We still need to clear user_mask. So I used swap() instead of 2
> assignment statements. I am fine to go with either way.

I found it a bit bizarre at first, but on reflection it makes sense.

Will

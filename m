Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD3669DDFB
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 11:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbjBUKhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 05:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjBUKhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 05:37:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A682659D
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 02:37:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EB92B80D5F
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 10:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB40C433EF;
        Tue, 21 Feb 2023 10:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676975826;
        bh=+9/kfZHYPCFgi/RnrxUpDyN+kfh4AyM00nkvsWryEdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Epkh7B84NSeaY5ylW4kuvqy9kJZZke9c+5ry/126/8J3U6izJgTVyqV40y/nk7HIA
         AW/VWXFbQpFVIL5CRP40bpyPvf3toyuIji8toGVG53Y+3t8XUnBVzc5DP0pNYTOie6
         +Yz4VKV90Mvt1Ys5VAPRICw4Mh6oFBYTPg30o6Mk=
Date:   Tue, 21 Feb 2023 11:37:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V1] rcu-tasks: Fix build error
Message-ID: <Y/Sez06gvJbAv7VE@kroah.com>
References: <1676916839-32235-1-git-send-email-quic_c_spathi@quicinc.com>
 <Y/PByBdfz/WPBs2W@kroah.com>
 <72e8a2a5-8729-5551-563a-d8d7c143f527@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72e8a2a5-8729-5551-563a-d8d7c143f527@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 02:57:15PM +0530, Srinivasarao Pathipati wrote:
> 
> On 2/21/2023 12:24 AM, Greg KH wrote:
> > On Mon, Feb 20, 2023 at 11:43:59PM +0530, Srinivasarao Pathipati wrote:
> > > Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
> > > fix below compilation error.
> > > This is applicable to only 5.10 kernels as code got modified
> > > in latest kernels.
> > > 
> > >   In file included from kernel/rcu/update.c:579:0:
> > >   kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
> > >    static void show_rcu_tasks_rude_gp_kthread(void) {}
> > > 
> > > Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
> > > ---
> > >   kernel/rcu/tasks.h | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> > > index 8b51e6a..53ddb4e 100644
> > > --- a/kernel/rcu/tasks.h
> > > +++ b/kernel/rcu/tasks.h
> > > @@ -707,7 +707,7 @@ static void show_rcu_tasks_rude_gp_kthread(void)
> > >   #endif /* #ifndef CONFIG_TINY_RCU */
> > >   #else /* #ifdef CONFIG_TASKS_RUDE_RCU */
> > > -static void show_rcu_tasks_rude_gp_kthread(void) {}
> > > +static inline void show_rcu_tasks_rude_gp_kthread(void) {}
> > >   #endif /* #else #ifdef CONFIG_TASKS_RUDE_RCU */
> > >   ////////////////////////////////////////////////////////////////////////
> > > -- 
> > > 2.7.4
> > > 
> > What commit id caused this problem?
> 
> commit  (8344496e8b49c4122c1808d6cd3f8dc71bccb595 rcu-tasks: Conditionally
> compile show_rcu_tasks_gp_kthreads()) introduced this issue

So this has been around for a very very long time.

Why is this suddenly an issue now, almost 3 years later?  What changed
to cause this to become an issue?

And please put this information in the changelog text.

> This patch added conditional macros for definition of
> show_rcu_tasks_rude_gp_kthread()  but not for dummy definition.
> 
> > And why isn't it an issue in newer kernels, what commit id fixed it and
> > why can't we just take that instead?
> 
> Later code got modified with patch (27c0f1448389 rcutorture: Make
> grace-period kthread report match RCU flavor being tested)  , with this
> there won't be compilation issue.
> 
> This patch is part of below series, Not sure all these can be picked to this
> 5.10 stable branch so fixed issue by simply making function inline.
> 
> if you think it is better to pick this series, please merge to 5.10 branch.
> 
> https://lore.kernel.org/lkml/20201105233900.GA20676@paulmck-ThinkPad-P72/
> 
> [1/4] e1eb075ccf37 rcutorture: Make preemptible TRACE02 enable lockdep
> [2/4] 77dc174103fd rcu-tasks: Convert rcu_tasks_wait_gp() for-loop to
> while-loop
> [3/4] 27c0f1448389 rcutorture: Make grace-period kthread report match RCU
> flavor being tested
> [4/4] 75dc2da5ecd6 rcu-tasks: Make the units of ->init_fract be jiffies

I would need you to test and verify that these actually work properly
and do not cause any regressions and sign off on them before I could
take them.

thanks,

greg k-h

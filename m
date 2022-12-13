Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ECD64B57B
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiLMMyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiLMMyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:54:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120DBCE04;
        Tue, 13 Dec 2022 04:54:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2155B8118D;
        Tue, 13 Dec 2022 12:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF39AC433D2;
        Tue, 13 Dec 2022 12:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670936052;
        bh=a9N4mnDaTBWCBW0Yxm5TccjiatRz/8qHS67WBG5oYaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eockNV7+fQ+JdLOO5+69dcrpzLiBOahjCuIVYVggbXUsqs4LrLxOeWgozJmb7WRJ1
         9/U5WvcXZlYrx5UDpr/XPC6eHvnIyHRCPXpF0Nppmn8lqrhMNdxf6yxB32/zi1rso6
         rMZWlH7mAa68z4LmTcH17yMGY/o0kIo2jJ8zx4JubQKm+1RsoUmCAeb3flGVR+LlWC
         JNPYUQcT2e//ae0OhFyBjSe2ozKo77l/IXf/wYgN4xe63wqwzmMfuBGDdFN1BCLOwK
         mDOjalerc7wfJJoMIu1p/RziAM8PEjMKzGhTlc5MxcNLfd+yKT0EvTx2ehfksOq5iW
         Lku09e7jhsAbQ==
Date:   Tue, 13 Dec 2022 12:54:05 +0000
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
Message-ID: <20221213125404.GD5719@willie-the-truck>
References: <20221128014441.1264867-1-longman@redhat.com>
 <20221201134445.GC28489@willie-the-truck>
 <330989bf-0015-6d4c-9317-bfc9dba30b65@redhat.com>
 <20221202101835.GA29522@willie-the-truck>
 <e9c7a920-4801-59fd-2429-361c54523d8e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9c7a920-4801-59fd-2429-361c54523d8e@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 09:30:56AM -0500, Waiman Long wrote:
> On 12/2/22 05:18, Will Deacon wrote:
> > On Thu, Dec 01, 2022 at 12:03:39PM -0500, Waiman Long wrote:
> > > On 12/1/22 08:44, Will Deacon wrote:
> > > > On Sun, Nov 27, 2022 at 08:44:41PM -0500, Waiman Long wrote:
> > > > > Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> > > > > restricted on asymmetric systems"), the setting and clearing of
> > > > > user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> > > > > dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> > > > > protection. When racing with the clearing of user_cpus_ptr in
> > > > > __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> > > > > double-free in arm64 kernel.
> > > > > 
> > > > > Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
> > > > > cpumask") fixes this problem as user_cpus_ptr, once set, will never
> > > > > be cleared in a task's lifetime. However, this bug was re-introduced
> > > > > in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
> > > > > do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
> > > > > do_set_cpus_allowed(). This time, it will affect all arches.
> > > > > 
> > > > > Fix this bug by always clearing the user_cpus_ptr of the newly
> > > > > cloned/forked task before the copying process starts and check the
> > > > > user_cpus_ptr state of the source task under pi_lock.
> > > > > 
> > > > > Note to stable, this patch won't be applicable to stable releases.
> > > > > Just copy the new dup_user_cpus_ptr() function over.
> > > > > 
> > > > > Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
> > > > > Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
> > > > > CC: stable@vger.kernel.org
> > > > > Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
> > > > > Signed-off-by: Waiman Long <longman@redhat.com>
> > > > > ---
> > > > >    kernel/sched/core.c | 32 ++++++++++++++++++++++++++++----
> > > > >    1 file changed, 28 insertions(+), 4 deletions(-)
> > > > As per my comments on the previous version of this patch:
> > > > 
> > > > https://lore.kernel.org/lkml/20221201133602.GB28489@willie-the-truck/T/#t
> > > > 
> > > > I think there are other issues to fix when racing affinity changes with
> > > > fork() too.
> > > It is certainly possible that there are other bugs hiding somewhere:-)
> > Right, but I actually took the time to hit the same race for the other
> > affinity mask field so it seems a bit narrow-minded for us just to fix the
> > one issue.
> 
> I focused on this particular one because of a double-free bug report from
> David. What other fields have you found to be subjected to data race?

See my other report linked above where we race on 'task_struct::cpus_mask'.

Will

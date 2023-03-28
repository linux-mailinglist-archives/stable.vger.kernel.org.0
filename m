Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C0F6CBF9E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbjC1MsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjC1Mrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:47:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702019ED1;
        Tue, 28 Mar 2023 05:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54067B81CA2;
        Tue, 28 Mar 2023 12:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F6CC433D2;
        Tue, 28 Mar 2023 12:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680007584;
        bh=GuCEmU1vSIWBl2zkABCTKL9E15vkPCNZhOh2vievgec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLZQAhjEw/Z+YtN90zEUp/GOL5ddjdyq9ks67DWjGNEfgCNxc1UzWWn/JrsPQYqGG
         uIs2TtoZl/iy7kBvzUWxo1kapegOOcao12q4YzseMFfxhzbTxwC0BDjZDZ7ux0shi9
         gV1EoaFnoAX54JWEobieF77z/adDkXxAF1If/nvY=
Date:   Tue, 28 Mar 2023 14:46:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhang Qiao <zhangqiao22@huawei.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        stable-commits@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
Subject: Re: Patch "sched/fair: sanitize vruntime of entity being placed" has
 been added to the 4.14-stable tree
Message-ID: <ZCLhnVg5bgFBnIGV@kroah.com>
References: <20230305040248.1787312-1-sashal@kernel.org>
 <cf0108ec-d949-a5ab-7367-f358b6685873@huawei.com>
 <ZAWwIrMQ2EUikr6t@kroah.com>
 <1f8388a8-39cf-080c-4a6d-36b3059544a5@huawei.com>
 <ZAW69nTPaqHHLzON@kroah.com>
 <e0c8a7e2-0560-25a4-ee8f-0eaebd98074a@huawei.com>
 <ZAdXD0c9MSZ5H9ls@kroah.com>
 <899c8be7-fe1a-7dd2-c174-6a8b9934ba39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <899c8be7-fe1a-7dd2-c174-6a8b9934ba39@huawei.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 05:02:21PM +0800, Zhang Qiao wrote:
> 
> 
> 在 2023/3/7 23:23, Greg KH 写道:
> > On Mon, Mar 06, 2023 at 06:51:15PM +0800, Zhang Qiao wrote:
> >>
> >>
> >> 在 2023/3/6 18:05, Greg KH 写道:
> >>> On Mon, Mar 06, 2023 at 05:28:41PM +0800, Zhang Qiao wrote:
> >>>>
> >>>>
> >>>> 在 2023/3/6 17:19, Greg KH 写道:
> >>>>> On Mon, Mar 06, 2023 at 04:31:57PM +0800, Zhang Qiao wrote:
> >>>>>>
> >>>>>>
> >>>>>> 在 2023/3/5 12:02, Sasha Levin 写道:
> >>>>>>> This is a note to let you know that I've just added the patch titled
> >>>>>>>
> >>>>>>>     sched/fair: sanitize vruntime of entity being placed
> >>>>>>>
> >>>>>>> to the 4.14-stable tree which can be found at:
> >>>>>>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >>>>>>>
> >>>>>>> The filename of the patch is:
> >>>>>>>      sched-fair-sanitize-vruntime-of-entity-being-placed.patch
> >>>>>>> and it can be found in the queue-4.14 subdirectory.
> >>>>>>>
> >>>>>>> If you, or anyone else, feels it should not be added to the stable tree,
> >>>>>>> please let <stable@vger.kernel.org> know about it.
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>> commit 38247e1de3305a6ef644404ac818bc6129440eae
> >>>>>>
> >>>>>> Hi,
> >>>>>> This patch has significant impact on the hackbench.throughput [1].
> >>>>>> Please don't backport this patch.
> >>>>>>
> >>>>>> [1] https://lore.kernel.org/lkml/202302211553.9738f304-yujie.liu@intel.com/T/#u
> >>>>>
> >>>>> This link says it made hackbench.throughput faster, not slower, so why
> >>>>> would we NOT want it?
> >>>>
> >>>> Please see this section. In some cases, this patch reset task's vruntime by mistake and
> >>>> will lead to wrong results.
> >>>>
> >>>>
> >>>> On Tue, Feb 21, 2023 at 03:34:16PM +0800, kernel test robot wrote:
> >>>>>
> >>>>> FYI, In addition to that, the commit also has significant impact on the following tests:
> >>>>>
> >>>>> +------------------+--------------------------------------------------+
> >>>>> | testcase: change | hackbench: hackbench.throughput -8.1% regression |
> >>>>> | test machine     | 104 threads 2 sockets (Skylake) with 192G memory |
> >>>>> | test parameters  | cpufreq_governor=performance                     |
> >>>>> |                  | ipc=socket                                       |
> >>>>> |                  | iterations=4                                     |
> >>>>> |                  | mode=process                                     |
> >>>>> |                  | nr_threads=100%                                  |
> >>>>> +------------------+--------------------------------------------------+
> >>>>>
> >>>>> Details are as below:
> >>>
> >>> So one benchmark did better, by a lot, and one did less, by a little?
> >>> Which one matters "more">
> >>>
> >>> So Linus's tree now has a regression?  Or not?  I'm confused.  We are
> >>
> >> Yes, Linus's tree also has a regression, and i have sent a patch[1] for fix this regression.
> >>
> >>
> >> [1]: https://lore.kernel.org/lkml/79850642-ebac-5c23-d32d-b28737dcb91e@huawei.com/
> >>
> >> thanks.
> >> Zhang qiao.
> > 
> > Ok, I've dropped this from all stable queues now.  Please let us know
> > when we can pick it up again and what the fixup commit id in Linus's
> > tree is when it lands there.
> 
> Hi,
> 
> The fixup patch has been merged into Linus's tree, its commit id is:
> a53ce18cacb477dd0513c607f187d16f0fa96f71 ("sched/fair: Sanitize vruntime of entity being migrated")

Wonderful, I have queued both of these up now, thank you for letting me
know.

greg k-h

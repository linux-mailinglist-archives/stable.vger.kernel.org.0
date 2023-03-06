Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4320D6ABABC
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCFKGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjCFKFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:05:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B61DB81;
        Mon,  6 Mar 2023 02:05:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A36CB80D79;
        Mon,  6 Mar 2023 10:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482AEC433EF;
        Mon,  6 Mar 2023 10:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678097144;
        bh=XxmQXF+kNinQdu+Mw9zwBLclnh73yWVgFTDGGO/HBKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GblzFOVdLRX55nCOMwRiOsDKCPu0XXsKGGOnzPrqXEhsw0ur+tWolFCP7LeRXrFMq
         ApKp22jAUUubQgQSW78j4Z6qYbcuNU74BaINmwQVnQKExCzdxGyhaKkeKL1RsogtBq
         dalaK6BZSn+li+CGRFrnwZcNRBpm5YuGXvOHkUyM=
Date:   Mon, 6 Mar 2023 11:05:42 +0100
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
Message-ID: <ZAW69nTPaqHHLzON@kroah.com>
References: <20230305040248.1787312-1-sashal@kernel.org>
 <cf0108ec-d949-a5ab-7367-f358b6685873@huawei.com>
 <ZAWwIrMQ2EUikr6t@kroah.com>
 <1f8388a8-39cf-080c-4a6d-36b3059544a5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f8388a8-39cf-080c-4a6d-36b3059544a5@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 05:28:41PM +0800, Zhang Qiao wrote:
> 
> 
> 在 2023/3/6 17:19, Greg KH 写道:
> > On Mon, Mar 06, 2023 at 04:31:57PM +0800, Zhang Qiao wrote:
> >>
> >>
> >> 在 2023/3/5 12:02, Sasha Levin 写道:
> >>> This is a note to let you know that I've just added the patch titled
> >>>
> >>>     sched/fair: sanitize vruntime of entity being placed
> >>>
> >>> to the 4.14-stable tree which can be found at:
> >>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >>>
> >>> The filename of the patch is:
> >>>      sched-fair-sanitize-vruntime-of-entity-being-placed.patch
> >>> and it can be found in the queue-4.14 subdirectory.
> >>>
> >>> If you, or anyone else, feels it should not be added to the stable tree,
> >>> please let <stable@vger.kernel.org> know about it.
> >>>
> >>>
> >>>
> >>> commit 38247e1de3305a6ef644404ac818bc6129440eae
> >>
> >> Hi,
> >> This patch has significant impact on the hackbench.throughput [1].
> >> Please don't backport this patch.
> >>
> >> [1] https://lore.kernel.org/lkml/202302211553.9738f304-yujie.liu@intel.com/T/#u
> > 
> > This link says it made hackbench.throughput faster, not slower, so why
> > would we NOT want it?
> 
> Please see this section. In some cases, this patch reset task's vruntime by mistake and
> will lead to wrong results.
> 
> 
> On Tue, Feb 21, 2023 at 03:34:16PM +0800, kernel test robot wrote:
> >
> >FYI, In addition to that, the commit also has significant impact on the following tests:
> >
> > +------------------+--------------------------------------------------+
> > | testcase: change | hackbench: hackbench.throughput -8.1% regression |
> > | test machine     | 104 threads 2 sockets (Skylake) with 192G memory |
> > | test parameters  | cpufreq_governor=performance                     |
> > |                  | ipc=socket                                       |
> > |                  | iterations=4                                     |
> > |                  | mode=process                                     |
> > |                  | nr_threads=100%                                  |
> > +------------------+--------------------------------------------------+
> >
> > Details are as below:

So one benchmark did better, by a lot, and one did less, by a little?
Which one matters "more"?


So Linus's tree now has a regression?  Or not?  I'm confused.  We are
just matching what is in Linus's tree, if it's wrong here, in a stable
tree, it should be wrong there too.  If not, please explain why not?

thanks,

greg k-h

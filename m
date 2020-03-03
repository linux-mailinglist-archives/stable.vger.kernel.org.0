Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76D0177AC7
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 16:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgCCPnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 10:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbgCCPnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 10:43:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2102820842;
        Tue,  3 Mar 2020 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583250212;
        bh=nwF+I99zN7Wk2Uailvc3flBi0LQVM61nRAHxKVghkAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UiFUZCNXat4UbAFN7QUUCQulZi5DkDX//nvP0H4xiijjL/oxRyDN2iBNNrNcCJr73
         hPlDmWUUGlkSP6Ll1tQNjSRrwtCT60iLuaZgwfZ/ESgO6etndM3uMNur/2TCzW3zWZ
         dUHwEAnchIOsIFJE9EOnxJDR7dh4kxcwyb5g821I=
Date:   Tue, 3 Mar 2020 16:43:30 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>,
        Sasha Levin <sashal@kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Andrew Forgue <andrewf@apple.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: Fixes for 4.19 stable
Message-ID: <20200303154330.GA372992@kroah.com>
References: <6CF798B4-B68B-4729-A496-2152FC032ABC@apple.com>
 <20200301031128.GK21491@sasha-vm>
 <2f569b8a-329f-8259-d91c-7e526e0d768c@apple.com>
 <CAKfTPtAHpJmEXzBtaeFA+PHDEzZq+0DfG+LABcTRnXCVz=6adQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAHpJmEXzBtaeFA+PHDEzZq+0DfG+LABcTRnXCVz=6adQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 09:03:15AM +0100, Vincent Guittot wrote:
> On Tue, 3 Mar 2020 at 00:13, Vishnu Rangayyan
> <vishnu.rangayyan@apple.com> wrote:
> >
> > Hi Sasha,
> >
> > Not sure of this, looks relevant but I'm no expert on this code.
> > This particular change bef69dd87828 doesn't apply cleanly, need to
> > backport it. I'll do that now and retest on the failing setup and report
> > back.
> >
> > Best
> > Vishnu
> >
> > On 2/29/20 7:11 PM, Sasha Levin wrote:
> > > On Fri, Feb 28, 2020 at 12:13:54PM -0800, Vishnu Rangayyan wrote:
> > >> Hi,
> > >>
> > >> I still see high (upto 30%) ksoftirqd cpu use with 4.19.101+ after
> > >> these 2 back ports went in for 4.19.101
> > >> (had all 4 backports applied earlier to our tree):
> > >>
> > >> commit f6783319737f28e4436a69611853a5a098cbe974 sched/fair: Fix
> > >> insertion in rq->leaf_cfs_rq_list
> > >> commit 5d299eabea5a251fbf66e8277704b874bbba92dc sched/fair: Add
> > >> tmp_alone_branch assertion
> > >>
> > >> perf shows for any given ksoftirqd, with 20k-30k processes on the
> > >> system with high scheduler load:
> > >>  58.88%  ksoftirqd/0  [kernel.kallsyms]  [k] update_blocked_averages
> > >>
> > >> Can we backport these 2 also, confirmed that it fixes this behavior of
> > >> ksoftirqd.
> > >>
> > >> commit 039ae8bcf7a5f4476f4487e6bf816885fb3fb617 upstream
> > >> commit 31bc6aeaab1d1de8959b67edbed5c7a4b3cdbe7c upstream
> > >
> > > Do we also need bef69dd87828 ("sched/cpufreq: Move the
> > > cfs_rq_util_change() call to cpufreq_update_util()") then?
> 
> This patch is not related to the 2 patches above. It removes some
> spurious call to cfs_rq_util_change() and some wrong ordering but this
> is a fixed overhead which is not impacted by the number of cgroups
> unlike the 2 patches above. This patch will not help with the high
> load of update_blocked_averages

Thanks for letting us know, the other two patches are now queued up.

greg k-h

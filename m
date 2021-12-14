Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971E3474024
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 11:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhLNKL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 05:11:57 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:33370 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbhLNKL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 05:11:57 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B2D8A1F3C3;
        Tue, 14 Dec 2021 10:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639476715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EuDfY786amzGy7JMQRnk75qY+ynV1fOZEniZ1gBnf68=;
        b=gwurmXjvB7Kvn/aRvNn1dUFECmD5r+AIk+CXYikqHpWWa0LymQ32WmukpaUqzm4gV9YpFi
        6PFibt2Mj1+NpQI7r9qt7OXTS5RhBbvFrM21y1ZPBFK4bI4QOiiplmjsPYU2P2jvFPF5NX
        S2Lmk6lWpnWFwdjg1hCYizMfwuguNYo=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7944CA3B83;
        Tue, 14 Dec 2021 10:11:55 +0000 (UTC)
Date:   Tue, 14 Dec 2021 11:11:54 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <Ybht6kqwI0aPx3Jr@dhcp22.suse.cz>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
 <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
 <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
 <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
 <YZMq++inSmJegJmj@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZMq++inSmJegJmj@fedora>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 15-11-21 22:52:27, Dennis Zhou wrote:
> On Mon, Nov 15, 2021 at 11:11:44PM +0000, Alexey Makhalov wrote:
> > 
> > 
> > > On Nov 15, 2021, at 4:58 AM, Michal Hocko <mhocko@suse.com> wrote:
> > > 
> > > On Mon 15-11-21 11:04:16, Alexey Makhalov wrote:
> > >> Hi Michal,
> > >> 
> > >>> 
> > >>> I have asked several times for details about the specific setup that has
> > >>> led to the reported crash. Without much success so far. Reproduction
> > >>> steps would be the first step. That would allow somebody to work on this
> > >>> at least if Alexey doesn't have time to dive into this deeper.
> > >>> 
> > >> 
> > >> I didn’t know that repro steps are still not clear.
> > >> 
> > >> To reproduce the panic you need to have a system, where you can hot add
> > >> the CPU that belongs to memoryless NUMA node which is not present and onlined
> > >> yet. In other words, by hot adding CPU, you will add both CPU and NUMA node
> > >> at the same time.
> > > 
> > > There seems to be something different in your setup because memory less
> > > nodes have reportedly worked on x86. I suspect something must be
> > > different in your setup. Maybe it is that you are adding a cpu that is
> > > outside of possible cpus intialized during boot time. Those should have
> > > their nodes initialized properly - at least per init_cpu_to_node. Your
> > > report doesn't really explain how the cpu is hotadded. Maybe you are
> > > trying to do something that has never been supported on x86.
> > Memoryless nodes are supported by x86. But hot add of such nodes not quite
> > done.
> > 
> 
> I need some clarification here. It sounds like memoryless nodes work on
> x86, but hotplug + memoryless nodes isn't a supported use case or you're
> introducing it as a new use case?
> 
> If this is a new use case, then I'm inclined to say this patch should
> NOT go in and a proper fix should be implemented on hotplug's side. I
> don't want to be in the business of having/seeing this conversation
> reoccur because we just papered over this issue in percpu.

The patch still seems to be in the mmotm tree. I have sent a different
fix candidate [1] which should be more robust and cover also other potential
places.

[1] http://lkml.kernel.org/r/20211214100732.26335-1-mhocko@kernel.org
-- 
Michal Hocko
SUSE Labs

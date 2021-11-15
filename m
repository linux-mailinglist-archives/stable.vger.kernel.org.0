Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C859C4504C9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhKONBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:01:48 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:53810 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhKONBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 08:01:32 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 04AAB1FD68;
        Mon, 15 Nov 2021 12:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636981116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r9b85ixm3Wrr84TrrDkg6m5Yn89x2LHBBR5D3/ATIsU=;
        b=cItDF4BLC9Q8h2MyTOTh1IMEeQHVI3vsKo3MRCGdleR+1vB4oa+5MAd0oAQe1P6PKq2lxf
        UWHo+ZtzJB9dA+VoHVmlE2++lbMeFwr5QsPNGdYilc9wfw6pvXwYCxk1HRMLA+muAoQFRK
        GnaLuM75i4oBfB1+LRpxx34vXPYxyNI=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C9A05A3B88;
        Mon, 15 Nov 2021 12:58:35 +0000 (UTC)
Date:   Mon, 15 Nov 2021 13:58:34 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
 <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 15-11-21 11:04:16, Alexey Makhalov wrote:
> Hi Michal,
> 
> > 
> > I have asked several times for details about the specific setup that has
> > led to the reported crash. Without much success so far. Reproduction
> > steps would be the first step. That would allow somebody to work on this
> > at least if Alexey doesn't have time to dive into this deeper.
> > 
> 
> I didn’t know that repro steps are still not clear.
> 
> To reproduce the panic you need to have a system, where you can hot add
> the CPU that belongs to memoryless NUMA node which is not present and onlined
> yet. In other words, by hot adding CPU, you will add both CPU and NUMA node
> at the same time.

There seems to be something different in your setup because memory less
nodes have reportedly worked on x86. I suspect something must be
different in your setup. Maybe it is that you are adding a cpu that is
outside of possible cpus intialized during boot time. Those should have
their nodes initialized properly - at least per init_cpu_to_node. Your
report doesn't really explain how the cpu is hotadded. Maybe you are
trying to do something that has never been supported on x86.

It would be really great if you can provide more information in the
original email thread. E.g. boot time messges and then more details
about the hotplug operation as well (e.g. which cpu, the node
association, how it is injected to the guest etc.).

Thanks!
-- 
Michal Hocko
SUSE Labs

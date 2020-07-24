Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7F322BC59
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 05:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXDIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 23:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXDIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 23:08:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F134B20786;
        Fri, 24 Jul 2020 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595560127;
        bh=Mi81Uejk0h0q25VxMgNb+0huSyrbkp+jl5hwFhOM7Z0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BePtWmcWENl9v0Un95gA1NkIlo1AIrn4iCnulq4SWSlp3W7wd0wplS/5Z8Du5wfTv
         4Bq8wsbGQI1eLG0tcA+Y8Bt0VjyZzx19HW5H1UcFQekAoV76WwecT7n0i6aA+R7Pgq
         zMavmYb/bTO5zXpkM/5oaHTftWqqiqK88KfPBDmU=
Date:   Thu, 23 Jul 2020 20:08:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Wei Yang <richard.weiyang@linux.alibaba.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
Message-Id: <20200723200846.768513d7c122ac11b6e73538@linux-foundation.org>
In-Reply-To: <20200623093018.GA6069@L-31X9LVDL-1304.local>
References: <20200619125923.22602-2-david@redhat.com>
        <20200622082635.GA93552@L-31X9LVDL-1304.local>
        <2185539f-b210-5d3f-5da2-a497b354eebb@redhat.com>
        <20200622092221.GA96699@L-31X9LVDL-1304.local>
        <34f36733-805e-cc61-38da-2ee578ae096c@redhat.com>
        <20200622131003.GA98415@L-31X9LVDL-1304.local>
        <0f4edc1f-1ce2-95b4-5866-5c4888db7c65@redhat.com>
        <20200622215520.wa6gjr2hplurwy57@master>
        <4b7ee49c-9bee-a905-3497-e3addd8896b8@redhat.com>
        <c0b62330-11d3-e628-a811-b54789d8f182@redhat.com>
        <20200623093018.GA6069@L-31X9LVDL-1304.local>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jun 2020 17:30:18 +0800 Wei Yang <richard.weiyang@linux.alibaba.com> wrote:

> On Tue, Jun 23, 2020 at 09:55:43AM +0200, David Hildenbrand wrote:
> >On 23.06.20 09:39, David Hildenbrand wrote:
> >>> Hmm.. I thought this is the behavior for early section, while it looks current
> >>> code doesn't work like this:
> >>>
> >>>        if (section_is_early && memmap)
> >>>                free_map_bootmem(memmap);
> >>>        else
> >>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
> >>>
> >>> section_is_early is always "true" for early section, while memmap is not-NULL
> >>> only when sub-section map is empty.
> >>>
> >>> If my understanding is correct, when we remove a sub-section in early section,
> >>> the code would call depopulate_section_memmap(), which in turn free related
> >>> memmap. By removing the memmap, the return value from pfn_to_online_page() is
> >>> not a valid one.
> >> 
> >> I think you're right, and pfn_valid() would also return true, as it is
> >> an early section. This looks broken.
> >> 
> >>>
> >>> Maybe we want to write the code like this:
> >>>
> >>>        if (section_is_early)
> >>>                if (memmap)
> >>>                        free_map_bootmem(memmap);
> >>>        else
> >>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
> >>>
> >> 
> >> I guess that should be the way to go
> >> 
> >> @Dan, I think what Wei proposes here is correct, right? Or how does it
> >> work in the VMEMMAP case with early sections?
> >> 
> >
> >Especially, if you would re-hot-add, section_activate() would assume
> >there is a memmap, it must not be removed.
> >
> 
> You are right here. I didn't notice it.
> 
> >@Wei, can you send a patch?
> >
> 
> Sure, let me prepare for it.

Still awaiting this, and the v3 patch was identical to this v2 patch.

It's tagged for -stable, so there's some urgency.  Should we just go
ahead with the decently-tested v2?


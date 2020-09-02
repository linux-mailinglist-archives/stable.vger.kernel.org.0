Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86125AC57
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 15:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgIBNvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 09:51:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:45416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgIBNvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 09:51:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DCFC3B609;
        Wed,  2 Sep 2020 13:51:31 +0000 (UTC)
Date:   Wed, 2 Sep 2020 15:51:30 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
Message-ID: <20200902135130.GG4617@dhcp22.suse.cz>
References: <20200127173453.2089565-1-guro@fb.com>
 <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
 <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com>
 <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
 <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
 <20200902112624.GC4617@dhcp22.suse.cz>
 <CA+CK2bA43fZpdDc3WXOaQ_dtmy=wHV7eFQW8k++tbfGwERMrhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bA43fZpdDc3WXOaQ_dtmy=wHV7eFQW8k++tbfGwERMrhg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 02-09-20 08:51:06, Pavel Tatashin wrote:
> > > > Thread #1: memory hot-remove systemd service
> > > > Loops indefinitely, because if there is something still to be migrated
> > > > this loop never terminates. However, this loop can be terminated via
> > > > signal from systemd after timeout.
> > > > __offline_pages()
> > > >       do {
> > > >           pfn = scan_movable_pages(pfn, end_pfn);
> > > >                   # Returns 0, meaning there is nothing available to
> > > >                   # migrate, no page is PageLRU(page)
> > > >           ...
> > > >           ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
> > > >                                             NULL, check_pages_isolated_cb);
> > > >                   # Returns -EBUSY, meaning there is at least one PFN that
> > > >                   # still has to be migrated.
> > > >       } while (ret);
> >
> 
> Hi Micahl,
> 
> > This shouldn't really happen. What does prevent from this to proceed?
> > Did you manage to catch the specific pfn and what is it used for?
> 
> I did.
> 
> > start_isolate_page_range and scan_movable_pages should fail if there is
> > any memory that cannot be migrated permanently. This is something that
> > we should focus on when debugging.
> 
> I was hitting this issue:
> mm/memory_hotplug: drain per-cpu pages again during memory offline
> https://lore.kernel.org/lkml/20200901124615.137200-1-pasha.tatashin@soleen.com

I have noticed the patch but didn't have time to think it through (have
been few days off and catching up with emails). Will give it a higher
priority.

-- 
Michal Hocko
SUSE Labs

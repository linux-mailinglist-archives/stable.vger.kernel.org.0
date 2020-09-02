Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E8125AA31
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 13:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgIBL02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 07:26:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:43666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgIBL01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 07:26:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 46DC0B18C;
        Wed,  2 Sep 2020 11:26:26 +0000 (UTC)
Date:   Wed, 2 Sep 2020 13:26:24 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Pavel Tatashin <pasha.tatashin@soleen.com>,
        Roman Gushchin <guro@fb.com>,
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
Message-ID: <20200902112624.GC4617@dhcp22.suse.cz>
References: <20200127173453.2089565-1-guro@fb.com>
 <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
 <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com>
 <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
 <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 02-09-20 11:53:00, Vlastimil Babka wrote:
> On 8/28/20 6:47 PM, Pavel Tatashin wrote:
> > There appears to be another problem that is related to the
> > cgroup_mutex -> mem_hotplug_lock deadlock described above.
> > 
> > In the original deadlock that I described, the workaround is to
> > replace crash dump from piping to Linux traditional save to files
> > method. However, after trying this workaround, I still observed
> > hardware watchdog resets during machine  shutdown.
> > 
> > The new problem occurs for the following reason: upon shutdown systemd
> > calls a service that hot-removes memory, and if hot-removing fails for
> 
> Why is that hotremove even needed if we're shutting down? Are there any
> (virtualization?) platforms where it makes some difference over plain
> shutdown/restart?

Yes this sounds quite dubious.

> > some reason systemd kills that service after timeout. However, systemd
> > is never able to kill the service, and we get hardware reset caused by
> > watchdog or a hang during shutdown:
> > 
> > Thread #1: memory hot-remove systemd service
> > Loops indefinitely, because if there is something still to be migrated
> > this loop never terminates. However, this loop can be terminated via
> > signal from systemd after timeout.
> > __offline_pages()
> >       do {
> >           pfn = scan_movable_pages(pfn, end_pfn);
> >                   # Returns 0, meaning there is nothing available to
> >                   # migrate, no page is PageLRU(page)
> >           ...
> >           ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
> >                                             NULL, check_pages_isolated_cb);
> >                   # Returns -EBUSY, meaning there is at least one PFN that
> >                   # still has to be migrated.
> >       } while (ret);

This shouldn't really happen. What does prevent from this to proceed?
Did you manage to catch the specific pfn and what is it used for?
start_isolate_page_range and scan_movable_pages should fail if there is
any memory that cannot be migrated permanently. This is something that
we should focus on when debugging.
-- 
Michal Hocko
SUSE Labs

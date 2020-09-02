Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C18125AE17
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 16:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIBO65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 10:58:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:46544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgIBNxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 09:53:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 77D7EB630;
        Wed,  2 Sep 2020 13:53:00 +0000 (UTC)
Date:   Wed, 2 Sep 2020 15:52:58 +0200
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
Message-ID: <20200902135258.GH4617@dhcp22.suse.cz>
References: <20200127173453.2089565-1-guro@fb.com>
 <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
 <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com>
 <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
 <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
 <20200902113204.GD4617@dhcp22.suse.cz>
 <CA+CK2bA6EpfSMZD6egysFqdw0tZFuPAxEJc-rQbJTnjf+u2TGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bA6EpfSMZD6egysFqdw0tZFuPAxEJc-rQbJTnjf+u2TGA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 02-09-20 08:53:49, Pavel Tatashin wrote:
> On Wed, Sep 2, 2020 at 7:32 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Wed 02-09-20 11:53:00, Vlastimil Babka wrote:
> > > >> > > Thread #2: ccs killer kthread
> > > >> > >    css_killed_work_fn
> > > >> > >      cgroup_mutex  <- Grab this Mutex
> > > >> > >      mem_cgroup_css_offline
> > > >> > >        memcg_offline_kmem.part
> > > >> > >           memcg_deactivate_kmem_caches
> > > >> > >             get_online_mems
> > > >> > >               mem_hotplug_lock <- waits for Thread#1 to get read access
> >
> > And one more thing. THis has been brought up several times already.
> > Maybe I have forgoten but why do we take hotplug locks in this path in
> > the first place? Memory hotplug notifier takes slab_mutex so this
> > shouldn't be really needed.
> 
> Good point, it seems this lock can be completely removed from
> memcg_deactivate_kmem_caches

I am pretty sure we have discussed that in the past. But I do not
remember the outcome. Either we have concluded that this is indeed the
case but nobody came up with a patch or we have hit some obscure
issue... Maybe David/Roman rememeber more than I do.

-- 
Michal Hocko
SUSE Labs

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39A4442D0A
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 12:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhKBLrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 07:47:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41008 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhKBLrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 07:47:21 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 789F521763;
        Tue,  2 Nov 2021 11:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635853484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEOvJnRWexgJYfY25q9WuMGbZFJrjSNfEkZHTyzLLJ4=;
        b=IZ7Lp6Mba/cCskET8M5IguvVMzjQ7yUO+F2026/HvGdJsEgmC8DAuRrrE8P5/SsAM+Kykf
        aU1Fq4XFYfSb188i1kPPeCMEHWmTmXnnaPsqryYyMx7r1K5HUY4J2JObf50T1nFapwr8M2
        PrNJSZshO43h5ei2dFfXvlzbzlAbPMs=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 49D6EA3B83;
        Tue,  2 Nov 2021 11:44:44 +0000 (UTC)
Date:   Tue, 2 Nov 2021 12:44:40 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 02-11-21 12:00:57, David Hildenbrand wrote:
> On 02.11.21 11:34, Alexey Makhalov wrote:
[...]
> >> The node onlining logic when onlining a CPU sounds bogus as well: Let's
> >> take a look at try_offline_node(). It checks that:
> >> 1) That no memory is *present*
> >> 2) That no CPU is *present*
> >>
> >> We should online the node when adding the CPU ("present"), not when
> >> onlining the CPU.
> > 
> > Possible.
> > Assuming try_online_node was moved under add_cpu(), let’s
> > take look on this call stack:
> > add_cpu()
> >   try_online_node()
> >     __try_online_node()
> >       hotadd_new_pgdat()
> > At line 1190 we'll have a problem:
> > 1183         pgdat = NODE_DATA(nid);
> > 1184         if (!pgdat) {
> > 1185                 pgdat = arch_alloc_nodedata(nid);
> > 1186                 if (!pgdat)
> > 1187                         return NULL;
> > 1188
> > 1189                 pgdat->per_cpu_nodestats =
> > 1190                         alloc_percpu(struct per_cpu_nodestat);
> > 1191                 arch_refresh_nodedata(nid, pgdat);
> > 
> > alloc_percpu() will go for all possible CPUs and will eventually end up
> > calling alloc_pages_node() trying to use subject nid for corresponding CPU
> > hitting the same state #2 problem as NODE_DATA(nid) is still NULL and nid
> > is not yet online.
> 
> Right, we will end up calling pcpu_alloc_pages()->alloc_pages_node() for
> each possible CPU. We use cpu_to_node() to come up with the NID.

Shouldn't this be numa_mem_id instead? Memory less nodes are odd little
critters crafted into the MM code without wider considerations. From
time to time we are struggling with some fallouts but the primary thing
is that zonelists should be valid for all memory less nodes. If that is
not the case then there is a problem with the initialization code. If
somebody is providing a bogus node to allocate from then this should be
fixed. It is still not clear to me which case are we hitting here.

-- 
Michal Hocko
SUSE Labs

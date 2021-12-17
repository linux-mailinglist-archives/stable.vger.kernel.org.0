Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9466478BD1
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 13:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhLQMxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 07:53:42 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54666 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbhLQMxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 07:53:42 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F08BA1F38A;
        Fri, 17 Dec 2021 12:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639745620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=chHjN797ND/fWNYOCa6oQhkPiSmUyJSSp5Onplxdy0M=;
        b=rffHPxKfDp0iLd4+SR57WdnqQitYHR+bHFUU573KH6FDuJJXXjeSz1512j0Tf3Zl/AHlhU
        zWMw07dB5eM+a42ker2hC3jwrk3tOgN+w6mtzM8rEnDsbJZrNNpSOa1ECySYyYQ1Gb6r4Y
        J0RpBzwD3yNXsC2fFIcryLanZm98zpE=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C5D2AA3B84;
        Fri, 17 Dec 2021 12:53:40 +0000 (UTC)
Date:   Fri, 17 Dec 2021 13:53:40 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbyIVPAc2A2sWO8/@dhcp22.suse.cz>
References: <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
 <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
 <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
 <YbMZsczMGpChaWz0@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YbMZsczMGpChaWz0@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 10-12-21 10:11:14, Michal Hocko wrote:
> On Thu 09-12-21 19:01:03, Alexey Makhalov wrote:
> > 
> > 
> > > On Dec 9, 2021, at 5:29 AM, Michal Hocko <mhocko@suse.com> wrote:
> > > 
> > > On Thu 09-12-21 10:23:52, Alexey Makhalov wrote:
> > >> 
> > >> 
> > >>> On Dec 9, 2021, at 1:56 AM, Michal Hocko <mhocko@suse.com> wrote:
> > >>> 
> > >>> On Thu 09-12-21 09:28:55, Alexey Makhalov wrote:
> > >>>> 
> > >>>> 
> > >>>> [    0.081777] Node 4 uninitialized by the platform. Please report with boot dmesg.
> > >>>> [    0.081790] Initmem setup node 4 [mem 0x0000000000000000-0x0000000000000000]
> > >>>> ...
> > >>>> [    0.086441] Node 127 uninitialized by the platform. Please report with boot dmesg.
> > >>>> [    0.086454] Initmem setup node 127 [mem 0x0000000000000000-0x0000000000000000]
> > >>> 
> > >>> Interesting that only those two didn't get a proper arch specific
> > >>> initialization. Could you check why? I assume init_cpu_to_node
> > >>> doesn't see any CPU pointing at this node. Wondering why that would be
> > >>> the case but that can be a bug in the affinity tables.
> > >> 
> > >> My bad shrinking. Not just these 2, but all possible and not present nodes from 4 to 127
> > >> are having this message.
> > > 
> > > Does that mean that your possible (but offline) cpus do not set their
> > > affinity?
> > > 
> > Hi Michal,
> > 
> > I didn’t quite gut a question here. Do you mean scheduler affinity for offlined/not present CPUs?
> > From the patch, this message should be printed for every possible offlined node:
> > 	for_each_node(nid) {
> > ...
> > 		if (!node_online(nid)) {
> > 			pr_warn("Node %d uninitialized by the platform. Please report with boot dmesg.\n", nid);
> 
> Sure, let me expand on this a bit. X86 initialization code
> (init_cpu_to_node) does
>         for_each_possible_cpu(cpu) {
>                 int node = numa_cpu_node(cpu);
> 
>                 if (node == NUMA_NO_NODE)
>                         continue;
> 
>                 if (!node_online(node))
>                         init_memory_less_node(node);
> 
>                 numa_set_node(cpu, node);
>         }
> 
> which means that a memory less node is not initialized either when
> 	- your offline CPUs are not listed in possible cpus for some
> 	  reason
> 	- or they do not have any node affinity (numa_cpu_node is
> 	  NUMA_NO_NODE).
> 
> Could you check what is the reason in your particular case please?

Did you have time to look into this Alexey?
-- 
Michal Hocko
SUSE Labs

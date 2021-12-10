Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCB646FD6F
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 10:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbhLJJOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 04:14:50 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56928 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbhLJJOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 04:14:50 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C17DE1F3A1;
        Fri, 10 Dec 2021 09:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639127474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KhJyN+cMcqoKCqoaSIJSpiwZgOaAxCPlonD3mfPqH4E=;
        b=G5eOBon2Po90+B17tlWP3jsU/MZv770GOWoBh0E/ucBzVtxvdhitpVzJyc1fx10IB9vWvJ
        uzyLK5OJmu3lOgeK2kCNJPPrLrpgvSV43L88QXa95LDXRSbIjir36yYD7+qF30XqmXAbjK
        0pY0hx9mt8g/6HeXesiwE/JOjt0xsWc=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 65349A3B92;
        Fri, 10 Dec 2021 09:11:14 +0000 (UTC)
Date:   Fri, 10 Dec 2021 10:11:13 +0100
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
Message-ID: <YbMZsczMGpChaWz0@dhcp22.suse.cz>
References: <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
 <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
 <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 09-12-21 19:01:03, Alexey Makhalov wrote:
> 
> 
> > On Dec 9, 2021, at 5:29 AM, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > On Thu 09-12-21 10:23:52, Alexey Makhalov wrote:
> >> 
> >> 
> >>> On Dec 9, 2021, at 1:56 AM, Michal Hocko <mhocko@suse.com> wrote:
> >>> 
> >>> On Thu 09-12-21 09:28:55, Alexey Makhalov wrote:
> >>>> 
> >>>> 
> >>>> [    0.081777] Node 4 uninitialized by the platform. Please report with boot dmesg.
> >>>> [    0.081790] Initmem setup node 4 [mem 0x0000000000000000-0x0000000000000000]
> >>>> ...
> >>>> [    0.086441] Node 127 uninitialized by the platform. Please report with boot dmesg.
> >>>> [    0.086454] Initmem setup node 127 [mem 0x0000000000000000-0x0000000000000000]
> >>> 
> >>> Interesting that only those two didn't get a proper arch specific
> >>> initialization. Could you check why? I assume init_cpu_to_node
> >>> doesn't see any CPU pointing at this node. Wondering why that would be
> >>> the case but that can be a bug in the affinity tables.
> >> 
> >> My bad shrinking. Not just these 2, but all possible and not present nodes from 4 to 127
> >> are having this message.
> > 
> > Does that mean that your possible (but offline) cpus do not set their
> > affinity?
> > 
> Hi Michal,
> 
> I didn’t quite gut a question here. Do you mean scheduler affinity for offlined/not present CPUs?
> From the patch, this message should be printed for every possible offlined node:
> 	for_each_node(nid) {
> ...
> 		if (!node_online(nid)) {
> 			pr_warn("Node %d uninitialized by the platform. Please report with boot dmesg.\n", nid);

Sure, let me expand on this a bit. X86 initialization code
(init_cpu_to_node) does
        for_each_possible_cpu(cpu) {
                int node = numa_cpu_node(cpu);

                if (node == NUMA_NO_NODE)
                        continue;

                if (!node_online(node))
                        init_memory_less_node(node);

                numa_set_node(cpu, node);
        }

which means that a memory less node is not initialized either when
	- your offline CPUs are not listed in possible cpus for some
	  reason
	- or they do not have any node affinity (numa_cpu_node is
	  NUMA_NO_NODE).

Could you check what is the reason in your particular case please?

-- 
Michal Hocko
SUSE Labs

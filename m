Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98B7319FAF
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 14:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhBLNTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 08:19:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:45928 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhBLNTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 08:19:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613135902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DdKEhUPuhqGBAUysfIP1I2yAVIN2YPMmqzhpgnH18iA=;
        b=ZArfTI79Cfq9BQnCodN+yfBRelzlY3xtotzVaP9cXFcIXOl1s5EqKg5dk+qp13v2m87L0b
        3FwdtayPn96A1scACXpo/1rjSoWoKnwT4oGZ7turTE2WfRi/ENrb0B3ti5Zo8yCSwHSW+f
        RGuiC+m1XB9HyJvF6O4kbS1PGYhfaoI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2BADFAC90;
        Fri, 12 Feb 2021 13:18:22 +0000 (UTC)
Date:   Fri, 12 Feb 2021 14:18:20 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <YCaAHI/rFp1upRLc@dhcp22.suse.cz>
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
 <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 12-02-21 11:42:15, David Hildenbrand wrote:
> On 12.02.21 11:33, Michal Hocko wrote:
[...]
> > I have to digest this but my first impression is that this is more heavy
> > weight than it needs to. Pfn walkers should normally obey node range at
> > least. The first pfn is usually excluded but I haven't seen real
> 
> We've seen examples where this is not sufficient. Simple example:
> 
> Have your physical memory end within a memory section. Easy via QEMU, just
> do a "-m 4000M". The remaining part of the last section has fake/wrong
> node/zone info.

Does this really matter though. If those pages are reserved then nobody
will touch them regardless of their node/zone ids.

> Hotplug memory. The node/zone gets resized such that PFN walkers might
> stumble over it.
> 
> The basic idea is to make sure that any initialized/"online" pfn belongs to
> exactly one node/zone and that the node/zone spans that PFN.

Yeah, this sounds like a good idea but what is the poper node for hole
between two ranges associated with a different nodes/zones? This will
always be a random number. We should have a clear way to tell "do not
touch those pages" and PageReserved sounds like a good way to tell that.

> > problems with that. The VM_BUG_ON blowing up is really bad but as said
> > above we can simply make it less offensive in presence of reserved pages
> > as those shouldn't reach that path AFAICS normally.
> 
> Andrea tried tried working around if via PG_reserved pages and it resulted
> in quite some ugly code. Andrea also noted that we cannot rely on any random
> page walker to do the right think when it comes to messed up node/zone info.

I am sorry, I haven't followed previous discussions. Has the removal of
the VM_BUG_ON been considered as an immediate workaround?
-- 
Michal Hocko
SUSE Labs

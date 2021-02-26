Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF596325D76
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 07:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBZGPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 01:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhBZGPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 01:15:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 182F064ECE;
        Fri, 26 Feb 2021 06:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614320099;
        bh=upBgsw9MrC0lpO/fX8N9W+GusLFFDVXbTMTqwXQG7LI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SNMk5g0Q22g4zX8EMpa2/MOBPbFUHtr7OTVjWUFzzgJlURL8Lq6mjJlZUc7S9wJEV
         ptmDv9LycWfr4H8HgKpnS3cJzQcKIPVd7cmbRGeE6F9hJq1JMXfkBqxAEZXRLT+jDo
         OSKaSc4DxIIqGoBMMaAG2Ymmcc7ESmJeaub7nnuh9sS1i0wqA9PWJxjz4x4o490TFE
         Zko74uAvBQOhH8P8xjTlXGL821K1cNYLSx5CVeUCVAWpe4wncHkZKvCwrhLEILAW+N
         m9Hz1RjZhtj84dlzYFhUs1lIxbO4KbnHSA8WaZG0mvEIiGT+Un5R+LRtLH5u1f90gr
         v/iV2CQ2GJLRg==
Date:   Fri, 26 Feb 2021 08:14:47 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <20210226061447.GN1447004@kernel.org>
References: <20210225224351.7356-1-rppt@kernel.org>
 <20210225224351.7356-2-rppt@kernel.org>
 <20210225160851.43b50f0d02f8da958a2b7887@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225160851.43b50f0d02f8da958a2b7887@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 04:08:51PM -0800, Andrew Morton wrote:
> On Fri, 26 Feb 2021 00:43:51 +0200 Mike Rapoport <rppt@kernel.org> wrote:
> 
> > From: Mike Rapoport <rppt@linux.ibm.com>
> 
> >  void __meminit __weak memmap_init_zone(struct zone *zone)
> >  {
> >  	unsigned long zone_start_pfn = zone->zone_start_pfn;
> >  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
> >  	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> > +	static unsigned long hole_pfn = 0;
> 
> static implies that pgdat->node_zones[] is alwyas sorted in ascending
> pfn order.  Always true?

Yes.

-- 
Sincerely yours,
Mike.

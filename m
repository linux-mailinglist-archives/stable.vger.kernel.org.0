Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594EE31C387
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 22:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhBOVZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 16:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhBOVZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 16:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7930B64DF0;
        Mon, 15 Feb 2021 21:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613424292;
        bh=NP7OZUIQV/dje06OdQt5TFb4vM8T/LsPqUZ2gqmBI/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mLNfURDgfVU5V4mSwtJ4K4GTVBCSN8MHS69bE0Yu8ALlAHrDMn9VADZXn2hwGMsXi
         m/1Fko5D9P5r3vA12HEOSGdA6/tnfiwrWGrhmLhzt4nDTpgIFRBiOtt6G4kxwK39N3
         kxqeq+iUoqBCG78EcF9n72X4E3FqbnMBC3qMYSxMBXqFCA9URMxzLOA3hn4BAV3CUb
         Rcns3zFZJSzB4sF2RJKQWEUejb10BJrzL2Ru07ZLHjza8iykuFMgx6/at9cSxQhEpE
         dziA8uWuD/ibQKF3QxlALWP//zGeFQkIB4t5ho4upuPDEEKfm3PBOxdBIOYuNGSyIR
         QXTWUd06bnzMg==
Date:   Mon, 15 Feb 2021 23:24:40 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mel Gorman <mgorman@suse.de>, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <20210215212440.GA1307762@kernel.org>
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
 <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz>
 <20210214180016.GO242749@kernel.org>
 <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 10:00:31AM +0100, Michal Hocko wrote:
> On Sun 14-02-21 20:00:16, Mike Rapoport wrote:
> > On Fri, Feb 12, 2021 at 02:18:20PM +0100, Michal Hocko wrote:
> 
> > We can correctly set the zone links for the reserved pages for holes in the
> > middle of a zone based on the architecture constraints and with only the
> > holes in the beginning/end of the memory will be not spanned by any
> > node/zone which in practice does not seem to be a problem as the VM_BUG_ON
> > in set_pfnblock_flags_mask() never triggered on pfn 0.
> 
> I really fail to see what you mean by correct zone/node for a memory
> range which is not associated with any real node.

We know architectural zone constraints, so we can have always have 1:1
match from pfn to zone. Node indeed will be a guess.
  
> > > I am sorry, I haven't followed previous discussions. Has the removal of
> > > the VM_BUG_ON been considered as an immediate workaround?
> > 
> > It was never discussed, but I'm not sure it's a good idea.
> > 
> > Judging by the commit message that introduced the VM_BUG_ON (commit
> > 86051ca5eaf5 ("mm: fix usemap initialization")) there was yet another
> > inconsistency in the memory map that required a special care.
> 
> Can we actually explore that path before adding yet additional
> complexity and potentially a very involved fix for a subtle problem?

This patch was intended as a fix for inconsistency of the memory map that
is the root cause for triggering this VM_BUG_ON and other corner case
problems. 

The previous version [1] is less involved as it does not extend node/zone
spans.

[1] https://lore.kernel.org/lkml/20210130221035.4169-3-rppt@kernel.org
-- 
Sincerely yours,
Mike.

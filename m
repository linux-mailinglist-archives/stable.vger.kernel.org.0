Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3982711EC
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 05:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgITDdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 23:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITDdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Sep 2020 23:33:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B8C061755;
        Sat, 19 Sep 2020 20:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rbEoBPd1LQU1fkvZkwI1VcuWXjyXmuhm2QDCSgPYM3U=; b=ji/gEq92YsPZpGKm8Y06WLZk+N
        htHK6f+RC1JSFhYfB6/KiqGbskjXyA7CQU4YYRe0UauOS3HvndpTQPBwH4w68RTwBnNpG3Fh++2uu
        q9wdNQnI0o0L0hVkllG9nLAgklKwpgbqoLl2iWrbYwgvncHJQwIzckpgKpxlge5MMTJJISFcqqLR9
        yTjhrGEHzHYkO/SFejU5OYzKe1UiQVllgRstkQvd6CpBFrCdk0gmHdGbmJHzrIuDijpvbMReSDgE/
        9/Kg4XQ2D0+rhQJL08du/AY81H1EKmxdPbr+5IGAtd2qBzMG2VRosj0dtEy/CJ0ey623Wy5DKQYJh
        in0JKyxw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJq5c-0004EC-0Q; Sun, 20 Sep 2020 03:32:36 +0000
Date:   Sun, 20 Sep 2020 04:32:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 04/15] shmem: shmem_writepage() split unlikely i915 THP
Message-ID: <20200920033235.GR32101@casper.infradead.org>
References: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
 <20200919042009.bomzxmrg7%akpm@linux-foundation.org>
 <20200919044408.GL32101@casper.infradead.org>
 <alpine.LSU.2.11.2009182208210.13525@eggly.anvils>
 <20200919161847.GN32101@casper.infradead.org>
 <alpine.LSU.2.11.2009191557320.1018@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2009191557320.1018@eggly.anvils>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 19, 2020 at 05:16:57PM -0700, Hugh Dickins wrote:
> On Sat, 19 Sep 2020, Matthew Wilcox wrote:
> > How about this for a band-aid until we sort that out properly?  Just mark
> > the page as dirty before splitting it so subsequent iterations see the
> > subpages as dirty.
> 
> This is certainly much better than my original, and I've had no problem
> in running with it (briefly); and it's what I'll now keep in my testing
> tree - thanks.  But it is more obviously a hack, or as you put it, a
> band-aid: fit for Linus's tree?
> 
> This issue has only come up with i915 and shmem_enabled "force", nobody
> has been bleeding except me: but if it's something that impedes or may
> impede your own testing, or that you feel should go in anyway, say so and
> I'll push your new improved version to akpm (adding your signoff to mine).

No, it's not impeding my testing; I don't have i915 even compiled into
my kernel.

> > Arguably, we should use set_page_dirty() instead of SetPageDirty,
> 
> My position on that has changed down the years: I went through a
> phase of replacing shmem.c's SetPageDirtys by set_page_dirtys, with
> the idea that its "if (!PageDirty)" is good to avoid setting cacheline
> dirty.  Then Spectre changed the balance, so now I'd rather avoid the
> indirect function call, and go with your SetPageDirty.  But the bdi
> flags are such that they do the same thing, and if they ever diverge,
> then we make the necessary changes at that time.

That makes sense.

> > but I don't think i915 cares.  In particular, it uses
> > an untagged iteration instead of searching for PAGECACHE_TAG_DIRTY.
> 
> PAGECACHE_TAG_DIRTY comes with bdi flags that shmem does not use:
> with one exception, every shmem page is always dirty (since its swap
> is freed as soon as the page is moved from swap cache to file cache);
> unless I'm forgetting something (like the tails in my patch!), the
> only exception is a page allocated to a hole on fault (after which
> a write fault will soon set pte dirty).

Ah, of course.  I keep forgetting that shmem doesn't use the
dirty/writeback bits.

> So I didn't quite get what i915 was doing with its set_page_dirty()s:
> but very probably being a good citizen, marking when it exposed the
> page to changes itself, making no assumption of what shmem.c does.
> 
> It would be good to have a conversation with i915 guys about huge pages
> sometime (they forked off their own mount point in i915_gemfs_init(),
> precisely in order to make use of huge pages, but couldn't get them
> working, so removed the option to ask for them, but kept the separate
> mount point.  But not a conversation I'll be responsive on at present.)

Yes, I have a strong feeling the i915 shmem code is cargo-culted.  There
are some very questionable constructs in there.  It's a little unfair to
expect graphics developers to suddenly become experts on the page cache,
so I've taken this as impetus to clean up our APIs a little (eg moving
find_lock_entry() to mm/internal.h)

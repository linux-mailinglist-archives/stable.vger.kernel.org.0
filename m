Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E972F9D451
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfHZQqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:46:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:40726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729065AbfHZQqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 12:46:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B23DAE47;
        Mon, 26 Aug 2019 16:46:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1DFFCDA98E; Mon, 26 Aug 2019 18:46:47 +0200 (CEST)
Date:   Mon, 26 Aug 2019 18:46:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, Christophe Leroy <christophe.leroy@c-s.fr>,
        erhard_f@mailbox.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix allocation of bitmap pages.
Message-ID: <20190826164646.GX2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>, erhard_f@mailbox.org,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <c3157c8e8e0e7588312b40c853f65c02fe6c957a.1566399731.git.christophe.leroy@c-s.fr>
 <20190826153757.GW2752@twin.jikos.cz>
 <a096d653-8b64-be15-3e81-581536a88e8a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a096d653-8b64-be15-3e81-581536a88e8a@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 06:40:24PM +0300, Nikolay Borisov wrote:
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=204371
> >> Fixes: 69d2480456d1 ("btrfs: use copy_page for copying pages instead of memcpy")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >> ---
> >> v2: Using kmem_cache instead of get_zeroed_page() in order to benefit from SLAB debugging features like redzone.
> > 
> > I'll take this version, thanks. Though I'm not happy about the allocator
> > behaviour. The kmem cache based fix can be backported independently to
> > 4.19 regardless of the SL*B fixes.
> > 
> >> +extern struct kmem_cache *btrfs_bitmap_cachep;
> > 
> > I've renamed the cache to btrfs_free_space_bitmap_cachep
> > 
> > Reviewed-by: David Sterba <dsterba@suse.com>
> 
> Isn't this obsoleted by
> 
> '[PATCH v2 0/2] guarantee natural alignment for kmalloc()' ?

Yeah, but this would add maybe another whole dev cycle to merge and
release. The reporters of the bug seem to care enough to identify the
problem and propose the fix so I feel like adding the btrfs-specific fix
now is a little favor we can afford.

The bug is reproduced on an architecture that's not widely tested so
from practical POV I think this adds more coverage which is desirable.

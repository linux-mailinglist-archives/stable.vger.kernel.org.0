Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D3D14B55C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 14:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgA1Nuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 08:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgA1Nuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:50:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6199206F0;
        Tue, 28 Jan 2020 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219449;
        bh=Frko1RCalVTB2g080Ymc1x24C8gCpYyWDWdZoImvHU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KHw9XH7v+cqHh93/sxnabRex4hUQCHQjU3zDOqy0muVjc7N0dpmnU/lCYMAt55hsd
         WXrdsFvUw5Tvsn0NPlDvypCQrvkvQgUloyEA9g5xJn9j9pD/ChHi5ASToXDv8nL22d
         7rij58owF8omAK7u0Q2papns9kSjOa2FLn/T/OTo=
Date:   Tue, 28 Jan 2020 14:50:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH for 4.19-stable v3 00/24] mm/memory_hotplug: backport of
 pending stable fixes
Message-ID: <20200128135047.GA3065469@kroah.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 10:49:57AM +0100, David Hildenbrand wrote:
> This is the backport of the following fixes for 4.19-stable:
> 
> - d84f2f5a7552 ("drivers/base/node.c: simplify
>   unregister_memory_block_under_nodes()")
> -- Turned out to not only be a cleanup but also a fix
> - 2c91f8fc6c99 ("mm/memory_hotplug: fix try_offline_node()")
> -- Automatic stable backport failed due to missing dependencies.
> - feee6b298916 ("mm/memory_hotplug: shrink zones when offlining memory")
> -- Was marked as stable 5.0+ due to the backport complexity,, but it's also
>    relevant for 4.19/4.14. As I have to backport quite some cleanups
>    already ...
> 
> All tackle memory unplug issues, especially when memory was never
> onlined (or onlining failed), paired with memory unplug. When trying to
> access garbage memmaps we crash the kernel (e.g., because the derviced
> pgdat pointer is broken)
> 
> To minimize manual code changes, I decided to pull in quite some cleanups.
> Still some manual code changes are necessary (indicated in the individual
> patches). Especially missing arm64 hot(un)plug, missing sub-section hotadd
> support, and missing unification of mm/hmm.c and kernel/memremap.c requires
> care.
> 
> Due to:
> - 4e0d2e7ef14d ("mm, sparse: pass nid instead of pgdat to
>   sparse_add_one_section()")
> I need:
> - afe9b36ca890 ("mm/memunmap: don't access uninitialized memmap in
>   memunmap_pages()")
> 
> Please note that:
> - 4c4b7f9ba948 ("mm/memory_hotplug: remove memory block devices
>   before arch_remove_memory()")
> Makes big (e.g., 32TB) machines boot up slower (e.g., 2h vs 10m). There is
> a performance fix in linux-next, but it does not seem to classify as a
> fix for current RC / stable.

If this is that big of a regression, yes, it does classify as a fix and
is ok for the stable trees.  Please let me know what that git id is when
it hits Linus's tree.

> I did quite some testing with hot(un)plug, onlining/offlining of memory
> blocks and memory-less/CPU-less NUMA nodes under x86_64 - the same set of
> tests I run against upstream on a fairly regular basis. I compile-tested
> on PowerPC, arm64, s390x, i386 and sh. I did not test any ZONE_DEVICE/HMM
> thingies.
> 
> The 4.14 backport might take a bit - it would be quite a lot of patches
> to backport and it is not that severely broken, so I am thinking about
> simpler (less invasive) alternatives.

All now queued up, thanks.

greg k-h

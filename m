Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A663A13C80C
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgAOPja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgAOPja (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 10:39:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57038214AF;
        Wed, 15 Jan 2020 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579102769;
        bh=Czm7O4xlrA76ORUQA4ublXLe9QTbxukNjkoQAqDJmZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nt3sz3xJSj5mnpp9aDe3ZF+WlgSkUuOtU04kRrrZklb9nrbF5bEvQ21qvaAvnAuaA
         vMozH967m6RHl7XHo6/gB+n9hmKmsH1rhliKianWeb6neNMgKWjICs661gHh8HIfHE
         lz1xBdjuezfWeOHt7a80i8sysxqhkm0K+mhmIfas=
Date:   Wed, 15 Jan 2020 16:39:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH for 4.19-stable 00/25] mm/memory_hotplug: backport of
 pending stable fixes
Message-ID: <20200115153927.GC3881751@kroah.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 04:33:14PM +0100, David Hildenbrand wrote:
> This is the backport of the following fixes for 4.19-stable:
> 
> - a31b264c2b41 ("mm/memory_hotplug: make
>   unregister_memory_block_under_nodes() never fail")
> -- Turned out to not only be a cleanup but also a fix
> - 2c91f8fc6c99 ("mm/memory_hotplug: fix try_offline_node()")
> -- Automatic stable backport failed due to missing dependencies.
> - feee6b298916 ("mm/memory_hotplug: shrink zones when offlining memory")
> -- Was marked as stable 5.0+ due to the backport complexity,, but it's also
>    relevant for 4.19/4.14. As I have to backport quite some cleanups
>    already ...
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
> 
> I did quite some testing with hot(un)plug, onlining/offlining of memory
> blocks and memory-less/CPU-less NUMA nodes under x86_64 - the same set of
> tests I run against upstream on a fairly regular basis. I compile-tested
> on PowerPC. I did not test any ZONE_DEVICE/HMM thingies.
> 
> Let's see what people think - it's a lot of patches. If we want this,
> then I can try to prepare a similar set for 4.4-stable.

What bug(s) are these trying to fix here?

And why would 4.9 and 4.4 care about them?

thanks,

greg k-h

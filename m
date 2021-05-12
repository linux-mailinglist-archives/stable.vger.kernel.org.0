Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FC037ED84
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245708AbhELUiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358824AbhELSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CC1610F8;
        Wed, 12 May 2021 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620845364;
        bh=pUzFV6x8DwAbivkRdrmFuXxPE7dSIvSWJjXeCNQ3QYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kjQ/7kTctcB1QPMBrfhezJNM42V4SBwt1XwPkweunsoixc6jV5vIeDSbDfmBmj0wB
         jsGT5utAJgsJrywNycmJyhlUTEE3g2LN44u7ELfHxE+511sjML+8qX5uU+B6vXVEDN
         r+f3us6yMaOWR5+CZIykdZJeeKOV8rQc+fi2O9G8=
Date:   Wed, 12 May 2021 20:49:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Glitta <glittao@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 518/530] mm, slub: enable slub_debug static key when
 creating cache with explicit debug flags
Message-ID: <YJwjMglS4/wZ/ieH@kroah.com>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144836.780038842@linuxfoundation.org>
 <dd590c4d-cb37-fd38-3ad7-96f677403b3c@suse.cz>
 <YJv5R0KNH+/EsWfX@kroah.com>
 <003ce4ee-304c-68cb-6871-cf01495438b6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003ce4ee-304c-68cb-6871-cf01495438b6@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 07:25:24PM +0200, Vlastimil Babka wrote:
> On 5/12/21 5:50 PM, Greg Kroah-Hartman wrote:
> > On Wed, May 12, 2021 at 05:35:28PM +0200, Vlastimil Babka wrote:
> >> On 5/12/21 4:50 PM, Greg Kroah-Hartman wrote:
> >> > From: Vlastimil Babka <vbabka@suse.cz>
> >> > 
> >> > [ Upstream commit 1f0723a4c0df36cbdffc6fac82cd3c5d57e06d66 ]
> >> > 
> >> > Commit ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
> >> > introduced a static key to optimize the case where no debugging is
> >> > enabled for any cache.  The static key is enabled when slub_debug boot
> >> > parameter is passed, or CONFIG_SLUB_DEBUG_ON enabled.
> >> > 
> >> > However, some caches might be created with one or more debugging flags
> >> > explicitly passed to kmem_cache_create(), and the commit missed this.
> >> > Thus the debugging functionality would not be actually performed for
> >> > these caches unless the static key gets enabled by boot param or config.
> >> > 
> >> > This patch fixes it by checking for debugging flags passed to
> >> > kmem_cache_create() and enabling the static key accordingly.
> >> > 
> >> > Note such explicit debugging flags should not be used outside of
> >> > debugging and testing as they will now enable the static key globally.
> >> > btrfs_init_cachep() creates a cache with SLAB_RED_ZONE but that's a
> >> > mistake that's being corrected [1].  rcu_torture_stats() creates a cache
> >> > with SLAB_STORE_USER, but that is a testing module so it's OK and will
> >> > start working as intended after this patch.
> >> > 
> >> > Also note that in case of backports to kernels before v5.12 that don't
> >> > have 59450bbc12be ("mm, slab, slub: stop taking cpu hotplug lock"),
> >> > static_branch_enable_cpuslocked() should be used.
> >> > 
> >> > [1] https://lore.kernel.org/linux-btrfs/20210315141824.26099-1-dsterba@suse.com/
> >> > 
> >> > Link: https://lkml.kernel.org/r/20210315153415.24404-1-vbabka@suse.cz
> >> > Fixes: ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
> >> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> > Reported-by: Oliver Glitta <glittao@gmail.com>
> >> > Acked-by: David Rientjes <rientjes@google.com>
> >> > Cc: Christoph Lameter <cl@linux.com>
> >> > Cc: Pekka Enberg <penberg@kernel.org>
> >> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >> > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> >> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> 
> >> Uh, rather not release this to stable without the followup fix:
> >> https://lore.kernel.org/linux-mm/20210504120019.26791-1-vbabka@suse.cz/
> > 
> > Is that in Linus's tree yet?  If so, what is the git id?
> 
> No, it's in mmotm, so no git id yet, but should make it to Linus during 5.13 rc's.

Ok, thanks, now dropped from all 3 queues.

greg k-h

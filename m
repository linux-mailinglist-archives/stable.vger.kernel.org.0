Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFBC37EDA0
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387868AbhELUk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378528AbhELT30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F240261289;
        Wed, 12 May 2021 19:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620847698;
        bh=6iFH/7DBOnYgqfe5St6V+48YFQ+dajzUksv+xrkUsXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NABkE1qMrTm5hp+DTiRo3TkpP2G4mkyJttSzMR8Y22LiC01HWyuV05dDqK/ewus3n
         dd6VOaD5aNtSQURQ8kRp9uz1m5Cc/Ra0UbiJmiXhAcIXiJ7GVgtEZPm16Um0joOpTL
         XPrEGyluk73evRvFoArqhcPZDsYKj2ZA4OdhpuiZPFcjb9hdIXb9mDV0NcuBnx/97O
         dsNeaIj671PKGTfr1d8+6iq5tuVmZHMwBwWzUAZm0+C5ukgFKFQWZdaNDqaxdbkude
         tCrKDhCaSCkjw3MNqG4XbQV7l9mdkWigOI8vBURPgKLVn88AJbe8nb9decD16ghGaH
         UBn/jWgWOOJqg==
Date:   Wed, 12 May 2021 15:28:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Glitta <glittao@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.10 518/530] mm, slub: enable slub_debug static key when
 creating cache with explicit debug flags
Message-ID: <YJwsUBfAmRlpFP+j@sashalap>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144836.780038842@linuxfoundation.org>
 <dd590c4d-cb37-fd38-3ad7-96f677403b3c@suse.cz>
 <YJv5R0KNH+/EsWfX@kroah.com>
 <003ce4ee-304c-68cb-6871-cf01495438b6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <003ce4ee-304c-68cb-6871-cf01495438b6@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 07:25:24PM +0200, Vlastimil Babka wrote:
>On 5/12/21 5:50 PM, Greg Kroah-Hartman wrote:
>> On Wed, May 12, 2021 at 05:35:28PM +0200, Vlastimil Babka wrote:
>>> On 5/12/21 4:50 PM, Greg Kroah-Hartman wrote:
>>> > From: Vlastimil Babka <vbabka@suse.cz>
>>> >
>>> > [ Upstream commit 1f0723a4c0df36cbdffc6fac82cd3c5d57e06d66 ]
>>> >
>>> > Commit ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
>>> > introduced a static key to optimize the case where no debugging is
>>> > enabled for any cache.  The static key is enabled when slub_debug boot
>>> > parameter is passed, or CONFIG_SLUB_DEBUG_ON enabled.
>>> >
>>> > However, some caches might be created with one or more debugging flags
>>> > explicitly passed to kmem_cache_create(), and the commit missed this.
>>> > Thus the debugging functionality would not be actually performed for
>>> > these caches unless the static key gets enabled by boot param or config.
>>> >
>>> > This patch fixes it by checking for debugging flags passed to
>>> > kmem_cache_create() and enabling the static key accordingly.
>>> >
>>> > Note such explicit debugging flags should not be used outside of
>>> > debugging and testing as they will now enable the static key globally.
>>> > btrfs_init_cachep() creates a cache with SLAB_RED_ZONE but that's a
>>> > mistake that's being corrected [1].  rcu_torture_stats() creates a cache
>>> > with SLAB_STORE_USER, but that is a testing module so it's OK and will
>>> > start working as intended after this patch.
>>> >
>>> > Also note that in case of backports to kernels before v5.12 that don't
>>> > have 59450bbc12be ("mm, slab, slub: stop taking cpu hotplug lock"),
>>> > static_branch_enable_cpuslocked() should be used.
>>> >
>>> > [1] https://lore.kernel.org/linux-btrfs/20210315141824.26099-1-dsterba@suse.com/
>>> >
>>> > Link: https://lkml.kernel.org/r/20210315153415.24404-1-vbabka@suse.cz
>>> > Fixes: ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
>>> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>> > Reported-by: Oliver Glitta <glittao@gmail.com>
>>> > Acked-by: David Rientjes <rientjes@google.com>
>>> > Cc: Christoph Lameter <cl@linux.com>
>>> > Cc: Pekka Enberg <penberg@kernel.org>
>>> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>> > Cc: "Paul E. McKenney" <paulmck@kernel.org>
>>> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>
>>> Uh, rather not release this to stable without the followup fix:
>>> https://lore.kernel.org/linux-mm/20210504120019.26791-1-vbabka@suse.cz/
>>
>> Is that in Linus's tree yet?  If so, what is the git id?
>
>No, it's in mmotm, so no git id yet, but should make it to Linus during 5.13 rc's.

I'll drop it for now, thanks!

-- 
Thanks,
Sasha

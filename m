Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D205A1BBADF
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 12:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgD1KNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 06:13:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:54526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbgD1KNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 06:13:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 37C61ABF4;
        Tue, 28 Apr 2020 10:13:39 +0000 (UTC)
Subject: Re: [PATCH 4.14] mm, slub: restore the original intention of
 prefetch_freepointer()
To:     Sven Eckelmann <sven@narfation.org>, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20200426070617.14575-1-sven@narfation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <032b4298-eabc-4c49-3ee7-dc1c002403ed@suse.cz>
Date:   Tue, 28 Apr 2020 12:13:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200426070617.14575-1-sven@narfation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/20 9:06 AM, Sven Eckelmann wrote:
> From: Vlastimil Babka <vbabka@suse.cz>
> 
> commit 0882ff9190e3bc51e2d78c3aadd7c690eeaa91d5 upstream.
> 
> In SLUB, prefetch_freepointer() is used when allocating an object from
> cache's freelist, to make sure the next object in the list is cache-hot,
> since it's probable it will be allocated soon.
> 
> Commit 2482ddec670f ("mm: add SLUB free list pointer obfuscation") has
> unintentionally changed the prefetch in a way where the prefetch is
> turned to a real fetch, and only the next->next pointer is prefetched.
> In case there is not a stream of allocations that would benefit from
> prefetching, the extra real fetch might add a useless cache miss to the
> allocation.  Restore the previous behavior.
> 
> Link: http://lkml.kernel.org/r/20180809085245.22448-1-vbabka@suse.cz
> Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: Daniel Micay <danielmicay@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Matthias Schiffer <mschiffer@universe-factory.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

Regardless of how the discussion of exact root cause turns out, I agree with the 
stable inclusion, consider this as Ack, if it makes sense in that context :)

> ---
> The original problem is explained in the patch description as
> performance problem. And maybe this could also be one reason why it was
> never submitted for a stable kernel.
> 
> But tests on mips ath79 (OpenWrt ar71xx target) showed that it most likely
> related to "random" data bus errors. At least applying this patch seemed to
> have solved it for Matthias Schiffer <mschiffer@universe-factory.net> and
> some other persons who where debugging/testing this problem with him.
> 
> More details about it can be found in
> https://github.com/freifunk-gluon/gluon/issues/1982
> ---
>   mm/slub.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 3c1a16f03b2b..481518c3f61a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -269,8 +269,7 @@ static inline void *get_freepointer(struct kmem_cache *s, void *object)
>   
>   static void prefetch_freepointer(const struct kmem_cache *s, void *object)
>   {
> -	if (object)
> -		prefetch(freelist_dereference(s, object + s->offset));
> +	prefetch(object + s->offset);
>   }
>   
>   static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
> 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEA3A3ED7
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 11:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhFKJPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 05:15:13 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33798 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbhFKJPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 05:15:12 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3235721998;
        Fri, 11 Jun 2021 09:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623402794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+G3rNiOHk3zk/0EyrxwKT4BIDO7RSBdoaLonmAI4lAM=;
        b=bCQ9MwUoiEl86eXlAlLGrRWW71bm2TKp5m/Rb8oPDVagVCd802ePiJkgsQCeOxC89W0xrU
        nbwCiNpoQTAPuR4QOJZK8JQ1ACAYHcAVmFJVRFmcRzqfr6Tq+iOWMVnsYyvUuLYuLxkCi4
        1r91V5dTB9dJKH7FddUNwf10NbqgPX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623402794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+G3rNiOHk3zk/0EyrxwKT4BIDO7RSBdoaLonmAI4lAM=;
        b=zqLYEfI+MYlUx42I9T+KYjRCIyJo/PSta0tII1+MpAU5mwBQ5uoSjcrBBr9ro8DBKOEw5G
        RFA8TLrbWrJNhfDg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 05711118DD;
        Fri, 11 Jun 2021 09:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623402794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+G3rNiOHk3zk/0EyrxwKT4BIDO7RSBdoaLonmAI4lAM=;
        b=bCQ9MwUoiEl86eXlAlLGrRWW71bm2TKp5m/Rb8oPDVagVCd802ePiJkgsQCeOxC89W0xrU
        nbwCiNpoQTAPuR4QOJZK8JQ1ACAYHcAVmFJVRFmcRzqfr6Tq+iOWMVnsYyvUuLYuLxkCi4
        1r91V5dTB9dJKH7FddUNwf10NbqgPX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623402794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+G3rNiOHk3zk/0EyrxwKT4BIDO7RSBdoaLonmAI4lAM=;
        b=zqLYEfI+MYlUx42I9T+KYjRCIyJo/PSta0tII1+MpAU5mwBQ5uoSjcrBBr9ro8DBKOEw5G
        RFA8TLrbWrJNhfDg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id ymvUACopw2BkTQAALh3uQQ
        (envelope-from <vbabka@suse.cz>); Fri, 11 Jun 2021 09:13:14 +0000
Subject: Re: [PATCH v4 2/3] mm/slub: Fix redzoning for small allocations
To:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Christoph Lameter <cl@linux.com>,
        "Lin, Zhenpeng" <zplin@psu.edu>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
References: <20210608183955.280836-1-keescook@chromium.org>
 <20210608183955.280836-3-keescook@chromium.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <e2857753-210c-da73-6e43-0bbd7e0efe80@suse.cz>
Date:   Fri, 11 Jun 2021 11:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608183955.280836-3-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/21 8:39 PM, Kees Cook wrote:
> The redzone area for SLUB exists between s->object_size and s->inuse
> (which is at least the word-aligned object_size). If a cache were created
> with an object_size smaller than sizeof(void *), the in-object stored
> freelist pointer would overwrite the redzone (e.g. with boot param
> "slub_debug=ZF"):
> 
> BUG test (Tainted: G    B            ): Right Redzone overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
> INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
> INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620
> 
> Redzone  (____ptrval____): bb bb bb bb bb bb bb bb    ........
> Object   (____ptrval____): f6 f4 a5 40 1d e8          ...@..
> Redzone  (____ptrval____): 1a aa                      ..
> Padding  (____ptrval____): 00 00 00 00 00 00 00 00    ........
> 
> Store the freelist pointer out of line when object_size is smaller than
> sizeof(void *) and redzoning is enabled.
> 
> Additionally remove the "smaller than sizeof(void *)" check under
> CONFIG_DEBUG_VM in kmem_cache_sanity_check() as it is now redundant:
> SLAB and SLOB both handle small sizes.
> 
> (Note that no caches within this size range are known to exist in the
> kernel currently.)
> 
> Fixes: 81819f0fc828 ("SLUB core")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/slab_common.c | 3 +--
>  mm/slub.c        | 8 +++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index a4a571428c51..7cab77655f11 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -97,8 +97,7 @@ EXPORT_SYMBOL(kmem_cache_size);
>  #ifdef CONFIG_DEBUG_VM
>  static int kmem_cache_sanity_check(const char *name, unsigned int size)
>  {
> -	if (!name || in_interrupt() || size < sizeof(void *) ||
> -		size > KMALLOC_MAX_SIZE) {
> +	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
>  		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
>  		return -EINVAL;
>  	}
> diff --git a/mm/slub.c b/mm/slub.c
> index f91d9fe7d0d8..f58cfd456548 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3734,15 +3734,17 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  	 */
>  	s->inuse = size;
>  
> -	if (((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
> -		s->ctor)) {
> +	if ((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
> +	    ((flags & SLAB_RED_ZONE) && s->object_size < sizeof(void *)) ||
> +	    s->ctor) {
>  		/*
>  		 * Relocate free pointer after the object if it is not
>  		 * permitted to overwrite the first word of the object on
>  		 * kmem_cache_free.
>  		 *
>  		 * This is the case if we do RCU, have a constructor or
> -		 * destructor or are poisoning the objects.
> +		 * destructor, are poisoning the objects, or are
> +		 * redzoning an object smaller than sizeof(void *).
>  		 *
>  		 * The assumption that s->offset >= s->inuse means free
>  		 * pointer is outside of the object is used in the
> 


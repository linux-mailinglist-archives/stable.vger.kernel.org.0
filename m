Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A9728EB3F
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 04:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgJOCgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 22:36:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728524AbgJOCgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 22:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602729368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4nV7WKozM0AOIQ1QdjvaOOj/choWDPKz6rzFA68jkM=;
        b=MhSR2MpzCNiXDOqdobLutmkZ183XaW70Flio+/0eAdt1Dlgww3G4mHxRiMr9iHOxPK7nzz
        ovL3DszLVV8paMYhAwi1Z6JMFX2IG2cP45iw8n3+cHU1RrmcFioDn6WC+6YeND5TX4F4tD
        zDAR+tLbH7qIz0cxR+LkRXNtbNLcwiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-aAUQ-D-8MkOG-RPN0FIymw-1; Wed, 14 Oct 2020 22:36:05 -0400
X-MC-Unique: aAUQ-D-8MkOG-RPN0FIymw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADE69803620;
        Thu, 15 Oct 2020 02:36:03 +0000 (UTC)
Received: from llong.remote.csb (ovpn-120-0.rdu2.redhat.com [10.10.120.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EB8C27CC1;
        Thu, 15 Oct 2020 02:36:02 +0000 (UTC)
Subject: Re: [PATCH] slub: Actually fix freelist pointer vs redzoning
To:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Marco Elver <elver@google.com>, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20201008233443.3335464-1-keescook@chromium.org>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <d712c80b-873f-0007-2300-dca8056ac6fd@redhat.com>
Date:   Wed, 14 Oct 2020 22:36:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20201008233443.3335464-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/20 7:34 PM, Kees Cook wrote:
> It turns out that SLUB redzoning ("slub_debug=Z") checks from
> s->object_size rather than from s->inuse (which is normally bumped to
> make room for the freelist pointer), so a cache created with an object
> size less than 24 would have their freelist pointer written beyond
> s->object_size, causing the redzone to corrupt the freelist pointer.
> This was very visible with "slub_debug=ZF":
>
> BUG test (Tainted: G    B            ): Redzone overwritten
> -----------------------------------------------------------------------------
>
> INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
> INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
> INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620
>
> Redzone (____ptrval____): bb bb bb bb bb bb bb bb               ........
> Object  (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
> Redzone (____ptrval____): 40 1d e8 1a aa                        @....
> Padding (____ptrval____): 00 00 00 00 00 00 00 00               ........
>
> Adjust the offset to stay within s->object_size.
>
> (Note that there appear to be no such small-sized caches in the kernel
> currently.)
>
> Reported-by: Marco Elver <elver@google.com>
> Link: https://lore.kernel.org/linux-mm/20200807160627.GA1420741@elver.google.com/
> Fixes: 89b83f282d8b (slub: avoid redzone when choosing freepointer location)
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   mm/slub.c | 17 +++++------------
>   1 file changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 68c02b2eecd9..979f5da26992 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3641,7 +3641,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>   {
>   	slab_flags_t flags = s->flags;
>   	unsigned int size = s->object_size;
> -	unsigned int freepointer_area;
>   	unsigned int order;
>   
>   	/*
> @@ -3650,13 +3649,6 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>   	 * the possible location of the free pointer.
>   	 */
>   	size = ALIGN(size, sizeof(void *));
> -	/*
> -	 * This is the area of the object where a freepointer can be
> -	 * safely written. If redzoning adds more to the inuse size, we
> -	 * can't use that portion for writing the freepointer, so
> -	 * s->offset must be limited within this for the general case.
> -	 */
> -	freepointer_area = size;
>   
>   #ifdef CONFIG_SLUB_DEBUG
>   	/*
> @@ -3682,7 +3674,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>   
>   	/*
>   	 * With that we have determined the number of bytes in actual use
> -	 * by the object. This is the potential offset to the free pointer.
> +	 * by the object and redzoning.
>   	 */
>   	s->inuse = size;
>   
> @@ -3694,7 +3686,8 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>   		 * kmem_cache_free.
>   		 *
>   		 * This is the case if we do RCU, have a constructor or
> -		 * destructor or are poisoning the objects.
> +		 * destructor, are poisoning the objects, or are
> +		 * redzoning an object smaller than sizeof(void *).
>   		 *
>   		 * The assumption that s->offset >= s->inuse means free
>   		 * pointer is outside of the object is used in the

There is no check to go into this if condition to put free pointer after 
object when redzoning an object smaller than sizeof(void *). In that 
sense, the additional comment isn't correct.

Should we add that check even though we don't have slab objects with 
such a small size in the kernel?

> @@ -3703,13 +3696,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>   		 */
>   		s->offset = size;
>   		size += sizeof(void *);
> -	} else if (freepointer_area > sizeof(void *)) {
> +	} else {
>   		/*
>   		 * Store freelist pointer near middle of object to keep
>   		 * it away from the edges of the object to avoid small
>   		 * sized over/underflows from neighboring allocations.
>   		 */
> -		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
> +		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
>   	}
>   
>   #ifdef CONFIG_SLUB_DEBUG

Other than the above, the patch looks good.

Cheers,
Longman


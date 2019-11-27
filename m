Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2141710A8BE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 03:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfK0C2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 21:28:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfK0C2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 21:28:54 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EAFA2071A;
        Wed, 27 Nov 2019 02:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574821732;
        bh=o87Xp9kLNyQ2J/F2P4vbvZATd05e7RPdFb5EXvsv35c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xKcPIns7scGKRD4BWoeYeDZvUN7dbfFgbFGxtoDq3WZm29TbI571Y2D4NaO/3bbn6
         Ewi5g18JJEmEVMjcuAPCALqHuuNrL28mZCABr8Y2v2q92QbEfzk878G3p5tdUiIyeh
         iNt50D9pJPNe45CALI8t+KNhv+9LRLrjdTpHzyE4=
Date:   Tue, 26 Nov 2019 21:28:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Thibaut Sautereau <thibaut@sautereau.fr>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        glider@google.com, keescook@chromium.org, labbott@redhat.com,
        mm-commits@vger.kernel.org
Subject: Re: [merged]
 mm-slub-init_on_free=1-should-wipe-freelist-ptr-for-bulk-allocations.patch
 removed from -mm tree
Message-ID: <20191127022851.GO5861@sasha-vm>
References: <20191015181442.O6zEw6y50%akpm@linux-foundation.org>
 <20191126203538.GA856@gandi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191126203538.GA856@gandi.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 09:35:38PM +0100, Thibaut Sautereau wrote:
>On Tue, Oct 15, 2019 at 11:14:42AM -0700, akpm@linux-foundation.org wrote:
>>
>> The patch titled
>>      Subject: mm/slub.c: init_on_free=1 should wipe freelist ptr for bulk allocations
>> has been removed from the -mm tree.  Its filename was
>>      mm-slub-init_on_free=1-should-wipe-freelist-ptr-for-bulk-allocations.patch
>>
>> This patch was dropped because it was merged into mainline or a subsystem tree
>>
>> ------------------------------------------------------
>> From: Alexander Potapenko <glider@google.com>
>> Subject: mm/slub.c: init_on_free=1 should wipe freelist ptr for bulk allocations
>>
>> slab_alloc_node() already zeroed out the freelist pointer if init_on_free
>> was on.  Thibaut Sautereau noticed that the same needs to be done for
>> kmem_cache_alloc_bulk(), which performs the allocations separately.
>>
>> kmem_cache_alloc_bulk() is currently used in two places in the kernel, so
>> this change is unlikely to have a major performance impact.
>>
>> SLAB doesn't require a similar change, as auto-initialization makes the
>> allocator store the freelist pointers off-slab.
>>
>> Link: http://lkml.kernel.org/r/20191007091605.30530-1-glider@google.com
>> Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
>> Signed-off-by: Alexander Potapenko <glider@google.com>
>> Reported-by: Thibaut Sautereau <thibaut@sautereau.fr>
>> Reported-by: Kees Cook <keescook@chromium.org>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Laura Abbott <labbott@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  mm/slub.c |   22 ++++++++++++++++------
>>  1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> --- a/mm/slub.c~mm-slub-init_on_free=1-should-wipe-freelist-ptr-for-bulk-allocations
>> +++ a/mm/slub.c
>> @@ -2672,6 +2672,17 @@ static void *__slab_alloc(struct kmem_ca
>>  }
>>
>>  /*
>> + * If the object has been wiped upon free, make sure it's fully initialized by
>> + * zeroing out freelist pointer.
>> + */
>> +static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
>> +						   void *obj)
>> +{
>> +	if (unlikely(slab_want_init_on_free(s)) && obj)
>> +		memset((void *)((char *)obj + s->offset), 0, sizeof(void *));
>> +}
>> +
>> +/*
>>   * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
>>   * have the fastpath folded into their functions. So no function call
>>   * overhead for requests that can be satisfied on the fastpath.
>> @@ -2759,12 +2770,8 @@ redo:
>>  		prefetch_freepointer(s, next_object);
>>  		stat(s, ALLOC_FASTPATH);
>>  	}
>> -	/*
>> -	 * If the object has been wiped upon free, make sure it's fully
>> -	 * initialized by zeroing out freelist pointer.
>> -	 */
>> -	if (unlikely(slab_want_init_on_free(s)) && object)
>> -		memset(object + s->offset, 0, sizeof(void *));
>> +
>> +	maybe_wipe_obj_freeptr(s, object);
>>
>>  	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
>>  		memset(object, 0, s->object_size);
>> @@ -3178,10 +3185,13 @@ int kmem_cache_alloc_bulk(struct kmem_ca
>>  				goto error;
>>
>>  			c = this_cpu_ptr(s->cpu_slab);
>> +			maybe_wipe_obj_freeptr(s, p[i]);
>> +
>>  			continue; /* goto for-loop */
>>  		}
>>  		c->freelist = get_freepointer(s, object);
>>  		p[i] = object;
>> +		maybe_wipe_obj_freeptr(s, p[i]);
>>  	}
>>  	c->tid = next_tid(c->tid);
>>  	local_irq_enable();
>> _
>
>Can this be backported to stable 5.3 please? It's commit 0f181f9fbea8
>upstream. Thanks!

Sure, I'll queue it up for 5.3, thanks!

-- 
Thanks,
Sasha

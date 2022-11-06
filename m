Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35D361E5DD
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 21:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiKFUYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 15:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiKFUYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 15:24:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985D111440;
        Sun,  6 Nov 2022 12:23:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1897D21EC4;
        Sun,  6 Nov 2022 20:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1667766238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIZQvJkOXMu5f5ncgLVznHSCKNS/Jviq7uNbN/RW5Bo=;
        b=FuTiZBSeSwo20pDcxBzlBbULYTF4Fi0Ze9NoVLrAOErRj5OiR2I9jPC7HFZOWeqcRVJwMs
        3MAzIy4+ETCetZlLfMIxzEzE7O3OHoeb/cK8uOO3nPsxKp5XkfwpEELC0DVkaHdR37UulO
        CZemJmItaFTaR7fyHS4I/EBkMRmOVTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1667766238;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIZQvJkOXMu5f5ncgLVznHSCKNS/Jviq7uNbN/RW5Bo=;
        b=B8Y8sZPepMIqwwi83F/Y3Ly+9sVinxFhCmNBRE6RWjB17sMX1zGS7lfWyVJeyu8MqY8iPP
        A/pqKVBucwxxS2AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC0E81376E;
        Sun,  6 Nov 2022 20:23:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8T9XMN0XaGM7eQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Sun, 06 Nov 2022 20:23:57 +0000
Message-ID: <af445171-6d54-8380-fe11-79384d145b2c@suse.cz>
Date:   Sun, 6 Nov 2022 21:23:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] mm/slab_common: Restore passing "caller" for tracing
Content-Language: en-US
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20221105063529.never.818-kees@kernel.org>
 <Y2eQd365DU6Zi9wr@hyeyoo>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y2eQd365DU6Zi9wr@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/6/22 11:46, Hyeonggon Yoo wrote:
> On Fri, Nov 04, 2022 at 11:35:34PM -0700, Kees Cook wrote:
>> The "caller" argument was accidentally being ignored in a few places
>> that were recently refactored. Restore these "caller" arguments, instead
>> of _RET_IP_.
>> 
>> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> 
> Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> 
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>> Cc: linux-mm@kvack.org
>> Fixes: 11e9734bcb6a ("mm/slab_common: unify NUMA and UMA version of tracepoints")
>> Cc: stable@vger.kernel.org
> 
> 
> BTW I think it can be just sent to next release candidate.
> The referred commit was merged in this development cycle.

Yep, dropped the Cc stable for that reason. Pushed to
slab/for-6.1-rc4/fixes and will send a PR to Linus in few days.
Thanks!

>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  mm/slab_common.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 33b1886b06eb..0e614f9e7ed7 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -941,7 +941,7 @@ void *__do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller
>>  
>>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
>>  		ret = __kmalloc_large_node(size, flags, node);
>> -		trace_kmalloc(_RET_IP_, ret, size,
>> +		trace_kmalloc(caller, ret, size,
>>  			      PAGE_SIZE << get_order(size), flags, node);
>>  		return ret;
>>  	}
>> @@ -953,7 +953,7 @@ void *__do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller
>>  
>>  	ret = __kmem_cache_alloc_node(s, flags, node, size, caller);
>>  	ret = kasan_kmalloc(s, ret, size, flags);
>> -	trace_kmalloc(_RET_IP_, ret, size, s->size, flags, node);
>> +	trace_kmalloc(caller, ret, size, s->size, flags, node);
>>  	return ret;
>>  }
>>  
>> -- 
>> 2.34.1
> 
> 
> Thanks for catching this!
> 


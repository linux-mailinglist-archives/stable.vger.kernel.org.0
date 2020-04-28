Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55611BBCAA
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgD1LnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 07:43:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:40266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgD1LnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 07:43:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBDE1ADCE;
        Tue, 28 Apr 2020 11:43:11 +0000 (UTC)
Subject: Re: [PATCH 4.14] mm, slub: restore the original intention of
 prefetch_freepointer()
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     Sven Eckelmann <sven@narfation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20200426070617.14575-1-sven@narfation.org>
 <20200426231426.GM13035@sasha-vm> <11030934.sCltEm0ppq@bentobox>
 <5500acc3-e691-ffae-1a59-6331de07f606@suse.cz>
 <44815f1e-6fcd-6e03-79dc-423898dfe162@universe-factory.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <65dba4d8-62b8-7818-3d9f-d4288f1cf65d@suse.cz>
Date:   Tue, 28 Apr 2020 13:43:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <44815f1e-6fcd-6e03-79dc-423898dfe162@universe-factory.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/20 9:08 PM, Matthias Schiffer wrote:
> On 4/27/20 10:45 AM, Vlastimil Babka wrote:
>> On 4/27/20 9:01 AM, Sven Eckelmann wrote:
>>>>> More details about it can be found in
>>>>> https://github.com/freifunk-gluon/gluon/issues/1982
>> 
>> Hmm, doesn't explain much how the fix was eventually found, but nevermind, good job.
> 
> The fact that the location of the data bus error was so imprecise made me
> suspect that no regular load could be the cause - therefore I looked at
> that prefetch in detail and eventually found your patch.

Ah, great, thanks.

>> 
>> 
>> I think the prefetch my go to an address that would cause a real fetch to page
>> fault. Under normal circumstances that could be only the NULL pointer that
>> terminates a freelist, otherwise the address should be valid.
> 
> For further analysis, I just replaced the prefetch as implemented in 4.14
> (i.e. before applying the patch in question) with a regular load (excluding
> NULL, which would lead to an immediate fault on boot). With the test
> program, I quickly hit a fault, at an address that looks completely bogus
> (i.e. neither NULL nor an address looking like it might be mapped to
> anything). Is this expected with the incorrect prefetch_freepointer()
> implementation of 4.14? Is it possible that prefetch_freepointer() of 4.14
> is even more broken than suspected before? Note that we hit this issue with
> the "names_cache" slab, which has page-sized objects, if that might provide
> any clue...

Thanks for the test and it might indeed be worthwile to chase it down as it's 
really unclear to me what's going on and there might be a worse underlying issue 
that we just mask.
One question, is CONFIG_SLAB_FREELIST_HARDENED enabled in your config? That 
could play a role in seeing addresses that look completely bogus.

Looking closer at prefetch_freepointer() usage from slab_alloc_node() we start with

object = c->freelist;

if that's not NULL, we do

void *next_object = get_freepointer_safe(s, object);

then there's the tricky this_cpu_cmpxchg_double() operation. We can assume that 
if that succeeds, c->freelist == next_object
So, if next_object was already a broken pointer, the next allocation should 
crash, even if we don't crash due to the prefetch.

It's possible next_object is NULL. But then the 4.14 implementation should be 
actually fine, prefetch_freepointer() has "if (object)" condition so it won't 
access (not just prefetch) that NULL. On the contrary, my patch removes that 
condition, as it also didn't exist before commit 2482ddec670fb. So AFAICS it's 
possible to trigger a NULL prefetch after my backport, and apparently the CPU 
doesn't mind that?

What if next_object is not NULL? Then it should be a valid pointer, as stated 
above. With my patch, then it's just prefetched and that's it. 4.14 
implementation will read (not prefetch) the next free pointer in the chain, 
which AFAICT should also be either valid or NULL, and then prefetch that. So 
both implementation. should be prefetching either a valid value, or NULL?
Aha! But we have already put next_object to c->freelist by the 
this_cpu_cmpxchg_double(), so we could have been then interrupted, and the 
interrupt handler or another thread scheduled instead of us on the same CPU have 
now allocated next_object from c->freelist and filled it with its own data, 
overwriting the free pointer. Then we resume execution and indeed can read bogus 
value as a free pointer and try to prefetch it... so that might be the reason.

> In any case, it seems like the "pref" instruction should not be used on
> bogus addresses on the ath79 platform... The exact behaviour is also
> hardware-dependent: On some SoCs, the error would be visible as a data bus
> error, while others just reset without any way to find out what was going
> wrong.

If I knew that, and realized the scenario above is possible, I would have marked 
the patch stable myself. Sorry.

> Matthias
> 

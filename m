Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBB81B9A99
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 10:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgD0Ipi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 04:45:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:39446 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgD0Iph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 04:45:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA287ABCC;
        Mon, 27 Apr 2020 08:45:34 +0000 (UTC)
Subject: Re: [PATCH 4.14] mm, slub: restore the original intention of
 prefetch_freepointer()
To:     Sven Eckelmann <sven@narfation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
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
 <20200426231426.GM13035@sasha-vm> <11030934.sCltEm0ppq@bentobox>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5500acc3-e691-ffae-1a59-6331de07f606@suse.cz>
Date:   Mon, 27 Apr 2020 10:45:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <11030934.sCltEm0ppq@bentobox>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/20 9:01 AM, Sven Eckelmann wrote:
> On Monday, 27 April 2020 01:14:26 CEST Sasha Levin wrote:
>> On Sun, Apr 26, 2020 at 09:06:17AM +0200, Sven Eckelmann wrote:
>> >From: Vlastimil Babka <vbabka@suse.cz>
>> >
>> >commit 0882ff9190e3bc51e2d78c3aadd7c690eeaa91d5 upstream.
> [...]
>> >---
>> >The original problem is explained in the patch description as
>> >performance problem. And maybe this could also be one reason why it was
>> >never submitted for a stable kernel.
>> >
>> >But tests on mips ath79 (OpenWrt ar71xx target) showed that it most likely
>> >related to "random" data bus errors. At least applying this patch seemed to
>> >have solved it for Matthias Schiffer <mschiffer@universe-factory.net> and
>> >some other persons who where debugging/testing this problem with him.
>> >
>> >More details about it can be found in
>> >https://github.com/freifunk-gluon/gluon/issues/1982

Hmm, doesn't explain much how the fix was eventually found, but nevermind, good job.

>> 
>> Interesting... I wonder why this issue has started only now.
> 
> Unfortunately, I don't know the details. So I (actually we) would love to get 
> some feedback from the slub experts. Not that there is another problem which 
> we just don't grasp yet.

I think the prefetch my go to an address that would cause a real fetch to page
fault. Under normal circumstances that could be only the NULL pointer that
terminates a freelist, otherwise the address should be valid.

So that could mean:
1) prefetch() on mips is implemented/compiled wrong?
2) the CPU really has issues with prefetch causing a page fault
3) the prefetch gets reordered between LL/SC and there's some bug similar to
this one described in arch/mips/include/asm/sync.h:

/*
 * Some Loongson 3 CPUs have a bug wherein execution of a memory access (load,
 * store or prefetch) in between an LL & SC can cause the SC instruction to
 * erroneously succeed, breaking atomicity. Whilst it's unusual to write code
 * containing such sequences, this bug bites harder than we might otherwise
 * expect due to reordering & speculation:


> Just some background information about the "why" from freifunk-gluon's 
> perspective:
> 
> OpenWrt 19.07 was released (despite its name) at the beginning of 2020. And it 
> was the first release using kernel 4.14 on the most used target: ar71xx 
> (ath79). The wireless community network firmware projects (freifunk-gluon in 
> this example) updated their frameworks to this OpenWrt release in the last 
> months and just now started to roll it out on their networks.
> 
> And while the wireless community networks around here usually don't track the 
> connected clients, the health of the APs is often tracked on some central 
> system. And some people then just noticed a sudden spike of reboots on their 
> APs. Since ar71xx is (often) the most used architecture at the moment, this 
> could be spotted rather easily if you spend some time looking at graphs.
> 
> Kind regards,
> 	Sven
> 


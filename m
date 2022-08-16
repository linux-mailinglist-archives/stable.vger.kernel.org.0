Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BC9595E5E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbiHPObA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiHPObA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:31:00 -0400
X-Greylist: delayed 26849 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Aug 2022 07:30:58 PDT
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A74BB01C;
        Tue, 16 Aug 2022 07:30:58 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 802E441A42;
        Tue, 16 Aug 2022 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660660256; bh=RXDhD3eaQro8sLd9ZZYd+bWIFJzrClxvA777Nr31aD8=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=TzzCiy3YyjTkASOnEwI6W+tFnN3sJBxL3VLE1Veld95z+1MlpanmIItYE+VmkChOI
         RQZewugcAr7YvLG6MyIulxPeKeudbc1jV/MjHtuxtbmVjYyYF/Cx8kwGyPARWgUOFE
         MhYhKf8+lYLxtgZWnVFG2ogD9Kf6/gyhxJEXJjX07xWtXazHxSa9ibLPZ9MxJzZJBN
         kZ9AqExT5PKNsnfR+wag4icaBgYkbrSgSDQ5P5WoTlpl1yrBTWUajc3b9IFSVUxU6T
         OFFoHV5s1l0eJFIbKwjpGww1vPQIkmW0jpj7w6InqPpLId+AVO51Duj1he/DgIgkhr
         JgrJxQ9GkMQTg==
Message-ID: <c545705f-ee7e-4442-ebfc-64a3baca2836@marcan.st>
Date:   Tue, 16 Aug 2022 23:30:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: es-ES
To:     Will Deacon <will@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
        jirislaby@kernel.org, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Neukum <oneukum@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Asahi Linux <asahi@lists.linux.dev>, stable@vger.kernel.org
References: <20220816070311.89186-1-marcan@marcan.st>
 <20220816140423.GC11202@willie-the-truck>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
In-Reply-To: <20220816140423.GC11202@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/08/2022 23.04, Will Deacon wrote:
>> diff --git a/Documentation/atomic_bitops.txt b/Documentation/atomic_bitops.txt
>> index 093cdaefdb37..d8b101c97031 100644
>> --- a/Documentation/atomic_bitops.txt
>> +++ b/Documentation/atomic_bitops.txt
>> @@ -59,7 +59,7 @@ Like with atomic_t, the rule of thumb is:
>>   - RMW operations that have a return value are fully ordered.
>>  
>>   - RMW operations that are conditional are unordered on FAILURE,
>> -   otherwise the above rules apply. In the case of test_and_{}_bit() operations,
>> +   otherwise the above rules apply. In the case of test_and_set_bit_lock(),
>>     if the bit in memory is unchanged by the operation then it is deemed to have
>>     failed.
> 
> The next sentence is:
> 
>   | Except for a successful test_and_set_bit_lock() which has ACQUIRE
>   | semantics and clear_bit_unlock() which has RELEASE semantics.
> 
> so I think it reads a bit strangely now. How about something like:
> 
> 
> diff --git a/Documentation/atomic_bitops.txt b/Documentation/atomic_bitops.txt
> index 093cdaefdb37..3b516729ec81 100644
> --- a/Documentation/atomic_bitops.txt
> +++ b/Documentation/atomic_bitops.txt
> @@ -59,12 +59,15 @@ Like with atomic_t, the rule of thumb is:
>   - RMW operations that have a return value are fully ordered.
>  
>   - RMW operations that are conditional are unordered on FAILURE,
> -   otherwise the above rules apply. In the case of test_and_{}_bit() operations,
> -   if the bit in memory is unchanged by the operation then it is deemed to have
> -   failed.
> +   otherwise the above rules apply. For the purposes of ordering, the
> +   test_and_{}_bit() operations are treated as unconditional.
>  
> -Except for a successful test_and_set_bit_lock() which has ACQUIRE semantics and
> -clear_bit_unlock() which has RELEASE semantics.
> +Except for:
> +
> + - test_and_set_bit_lock() which has ACQUIRE semantics on success and is
> +   unordered on failure;
> +
> + - clear_bit_unlock() which has RELEASE semantics.
>  
>  Since a platform only has a single means of achieving atomic operations
>  the same barriers as for atomic_t are used, see atomic_t.txt.

Makes sense! I'll send a v2 with that in a couple of days if nothing
else comes up.

>> diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
>> index 3096f086b5a3..71ab4ba9c25d 100644
>> --- a/include/asm-generic/bitops/atomic.h
>> +++ b/include/asm-generic/bitops/atomic.h
>> @@ -39,9 +39,6 @@ arch_test_and_set_bit(unsigned int nr, volatile unsigned long *p)
>>  	unsigned long mask = BIT_MASK(nr);
>>  
>>  	p += BIT_WORD(nr);
>> -	if (READ_ONCE(*p) & mask)
>> -		return 1;
>> -
>>  	old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
>>  	return !!(old & mask);
>>  }
>> @@ -53,9 +50,6 @@ arch_test_and_clear_bit(unsigned int nr, volatile unsigned long *p)
>>  	unsigned long mask = BIT_MASK(nr);
>>  
>>  	p += BIT_WORD(nr);
>> -	if (!(READ_ONCE(*p) & mask))
>> -		return 0;
>> -
>>  	old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
>>  	return !!(old & mask);
> 
> I suppose one sad thing about this is that, on arm64, we could reasonably
> keep the READ_ONCE() path with a DMB LD (R->RW) barrier before the return
> but I don't think we can express that in the Linux memory model so we
> end up in RmW territory every time.

You'd need a barrier *before* the READ_ONCE(), since what we're trying
to prevent is a consumer from writing to the value without being able to
observe the writes that happened prior, while this side read the old
value. A barrier after the READ_ONCE() doesn't do anything, as that read
is the last memory operation in this thread (of the problematic sequence).

At that point, I'm not sure DMB LD / early read / LSE atomic would be
any faster than just always doing the LSE atomic?

- Hector

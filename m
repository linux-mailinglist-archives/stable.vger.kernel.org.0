Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B442359600F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiHPQWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiHPQWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:22:20 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96378786D6;
        Tue, 16 Aug 2022 09:22:18 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 3924C41A42;
        Tue, 16 Aug 2022 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660666936; bh=v9Eb3B2oIUOczoWOpMilc4gFuASbH6f5NiE3832J0GI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=xk494yGeO5UkuZpnlGKL4Nq9gERUn/CyV0L3S9M62tv6t3TPQQaFKl7aW+F+VPjQs
         J6QUP88yR2MiznuQLMSvrWKeTx2/ReGUdOwZK8D7jsqdKzeljMCpL6wv2TeuXRyxr0
         4V1bqb3dG0XT9RpNkB9F+csP/ao0gEVjf0a9g+USUXdkbFgoGpHh6CworlZMGnD/cv
         WA4Bai1qkDK1vJ8mIcjdGqq6mJm6Y/IhUZHvrvUMYg7CMI2ekXAhbeVdHH6ZjEgpth
         1Hyl9rNt++q4bx6l9Z07aUaPmsT2MKK5xLaZJqCsnPkKeKqCbvzxicZEYbOmbQWan0
         r8CB7Gu3o92Yw==
Message-ID: <74559da4-5cd4-7cc4-0303-ab5f6a8b92ae@marcan.st>
Date:   Wed, 17 Aug 2022 01:22:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Content-Language: es-ES
To:     Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tejun Heo <tj@kernel.org>, peterz@infradead.org,
        jirislaby@kernel.org, maz@kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
 <20220816134156.GB11202@willie-the-truck> <YvuvxnfHIRUAuCrD@boqun-archlinux>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <YvuvxnfHIRUAuCrD@boqun-archlinux>
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

On 16/08/2022 23.55, Boqun Feng wrote:
> On Tue, Aug 16, 2022 at 02:41:57PM +0100, Will Deacon wrote:
>> It's worth noting that with the spinlock-based implementation (i.e.
>> prior to e986a0d6cb36) then we would have the same problem on
>> architectures that implement spinlocks with acquire/release semantics;
>> accesses from outside of the critical section can drift in and reorder
>> with each other there, so the conversion looked legitimate to me in
>> isolation and I vaguely remember going through callers looking for
>> potential issues. Alas, I obviously missed this case.
>>
> 
> I just to want to mention that although spinlock-based atomic bitops
> don't provide the full barrier in test_and_set_bit(), but they don't
> have the problem spotted by Hector, because test_and_set_bit() and
> clear_bit() sync with each other via locks:
> 
> 	test_and_set_bit():
> 	  lock(..);
> 	  old = *p; // mask is already set by other test_and_set_bit()
> 	  *p = old | mask;
> 	  unlock(...);
> 				clear_bit():
> 				  lock(..);
> 				  *p ~= mask;
> 				  unlock(..);
> 
> so "having a full barrier before test_and_set_bit()" may not be the
> exact thing we need here, as long as a test_and_set_bit() can sync with
> a clear_bit() uncondiontally, then the world is safe. For example, we
> can make test_and_set_bit() RELEASE, and clear_bit() ACQUIRE on ARM64:
> 
> 	test_and_set_bit():
> 	  atomic_long_fetch_or_release(..); // pair with clear_bit()
> 	  				    // guarantee everything is
> 					    // observed.
> 	  			clear_bit():
> 				  atomic_long_fetch_andnot_acquire(..);
> 	  
> , maybe that's somewhat cheaper than a full barrier implementation.
> 
> Thoughts? Just to find the exact ordering requirement for bitops.

It's worth pointing out that the workqueue code does *not* pair
test_and_set_bit() with clear_bit(). It does an atomic_long_set()
instead (and then there are explicit barriers around it, which are
expected to pair with the implicit barrier in test_and_set_bit()). If we
define test_and_set_bit() to only sync with clear_bit() and not
necessarily be a true barrier, that breaks the usage of the workqueue code.

- Hector

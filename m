Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E605957CD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiHPKPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiHPKO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:14:59 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181FF5A2C4;
        Tue, 16 Aug 2022 01:01:49 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 8E23941A42;
        Tue, 16 Aug 2022 08:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660636907; bh=hdO0VK1BgxthiOSTlr+e1eaO5dfWp+h7FMXRza4Hsq4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=DaLeUy6iahjaMjN9JrVNc57ZozIWEObhc79ETbuWH6F4g2xflaB0R2I9U12Ei7s5z
         c2ZH7+UHYhXpQJr/ul4lQrS49JpL1YF7DD9LwwdH4J5nC8ZbMlz2YlPqtjkybNBjIs
         NsSOqPqMrknOup3Ju2HGcGoQYJ2pptLHhZNC0aP439quZj3TRIADaHsix5DBPMXU53
         ELmGSpq3U830ZMod7U3u/QdZK09aGS4ZGkyip3lnTzJPuVW6UtzLV26E3hyR39MfK1
         RBnjaozfwBmzm+dzR+FXJ11o1uU1z/E9CG2t1asjvQoCksdVzIj+wetB8Lw79d7aAV
         eol3iUbS6rPYQ==
Message-ID: <0c0ba856-a4ba-7133-e751-3a81c82311a9@marcan.st>
Date:   Tue, 16 Aug 2022 17:01:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
 <cd51b422-89f3-1856-5d3b-d6e5b0029085@marcan.st>
 <CAHk-=wjfLT7nL8pV8RWATpjgm0zDtUwT8UMtroqnGcXRjN8tgw@mail.gmail.com>
 <24c88c4f-aea5-1fb7-0ead-95c88629d72b@marcan.st>
 <YvtLsNZEUUytdx+i@gondor.apana.org.au>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <YvtLsNZEUUytdx+i@gondor.apana.org.au>
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

On 2022/08/16 16:48, Herbert Xu wrote:
> On Tue, Aug 16, 2022 at 03:28:50PM +0900, Hector Martin wrote:
>>
>> This is the same reason I argued queue_work() itself needs to have a
>> similar guarantee, even when it doesn't queue work (and I updated the
>> doc to match). If test_and_set_bit() is used in this kind of context
>> often in the kernel, clearly the current implementation/doc clashes with
>> that.
> 
> Kernel code all over the place rely on the fact that test_and_set_bit
> provides a memory barrier.  So this bug that you've discovered is
> not at all isolated to the workqeueue system.  It'll break the kernel
> in lots of places in exactly the same way.

Now I'm surprised this isn't failing all over the place, given that...
these things are annoyingly subtle.

Still would want Will & Peter to chime in, of course.

>> As I said, I don't have any particular beef in this fight, but this is
>> horribly broken on M1/2 right now, so I'll send a patch to change the
>> bitops instead and you all can fight it out over which way is correct :)
> 
> Please do.

Already did, but I just realized I forgot to Cc you. Sorry about that,
hope you can pick it up through the MLs:

https://lore.kernel.org/asahi/20220816070311.89186-1-marcan@marcan.st/T/#u

- Hector

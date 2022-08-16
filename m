Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536CE59566F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiHPJaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiHPJ3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:29:21 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F4DA0616;
        Tue, 16 Aug 2022 00:48:32 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oNrIu-00BXvH-6U; Tue, 16 Aug 2022 17:48:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Aug 2022 15:48:00 +0800
Date:   Tue, 16 Aug 2022 15:48:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hector Martin <marcan@marcan.st>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <YvtLsNZEUUytdx+i@gondor.apana.org.au>
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
 <cd51b422-89f3-1856-5d3b-d6e5b0029085@marcan.st>
 <CAHk-=wjfLT7nL8pV8RWATpjgm0zDtUwT8UMtroqnGcXRjN8tgw@mail.gmail.com>
 <24c88c4f-aea5-1fb7-0ead-95c88629d72b@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24c88c4f-aea5-1fb7-0ead-95c88629d72b@marcan.st>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 03:28:50PM +0900, Hector Martin wrote:
>
> This is the same reason I argued queue_work() itself needs to have a
> similar guarantee, even when it doesn't queue work (and I updated the
> doc to match). If test_and_set_bit() is used in this kind of context
> often in the kernel, clearly the current implementation/doc clashes with
> that.

Kernel code all over the place rely on the fact that test_and_set_bit
provides a memory barrier.  So this bug that you've discovered is
not at all isolated to the workqeueue system.  It'll break the kernel
in lots of places in exactly the same way.

> As I said, I don't have any particular beef in this fight, but this is
> horribly broken on M1/2 right now, so I'll send a patch to change the
> bitops instead and you all can fight it out over which way is correct :)

Please do.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

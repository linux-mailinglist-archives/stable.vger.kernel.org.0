Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC7E5960FA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiHPRV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 13:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbiHPRV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 13:21:59 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC1A7C301;
        Tue, 16 Aug 2022 10:21:57 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 03A7241A42;
        Tue, 16 Aug 2022 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660670515; bh=b4EG0LTa8HIU16A9LTbhnmpSiFXMqiYjr5/PwslTjn8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=NDT/wfyLBeksVX2whoG656IQBELw8GrtdHHV+e91oqOaTh4aoCoJMqrimcMRgCKMm
         jcPpxORLtiwU3jdv6kY4lb55rhK3SnU5u1d+ViIbpE214Gx0s6jL3euXb1ZUcCmhqN
         hP6mAI8e2e2qYlB9F3LLuUKfbb02+QKOr+/idlac/vUYib2MgR6/sPAWyHNQsMJTy4
         M/dk7OBEaK4kb2/93j6+4ny+f0Hd4mctuYhUIj/zJacFroP12Rh3t19U58un/RGvRB
         Zoi8N98LHEmAz3ocSL2lfxyODbctXAaeyrzL81rVK9vPMT1CMn58xSMgum03QxIQ+r
         lfGz7DmjJG3uQ==
Message-ID: <b7a0082b-1bda-9a46-a979-8414d24d7dd2@marcan.st>
Date:   Wed, 17 Aug 2022 02:21:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Content-Language: es-ES
To:     Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, will@kernel.org,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au> <YvvFQwBVh1s23gbR@slm.duckdns.org>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <YvvFQwBVh1s23gbR@slm.duckdns.org>
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

On 17/08/2022 01.26, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 16, 2022 at 12:15:38PM +0800, Herbert Xu wrote:
>> Tejun Heo <tj@kernel.org> wrote:
>>>
>>> Oh, tricky one and yeah you're absolutely right that it makes no sense to
>>> not guarantee barrier semantics when already pending. I didn't even know
>>> test_and_set_bit() wasn't a barrier when it failed. Thanks a lot for hunting
>>> down and fixing this. Applied to wq/for-6.0-fixes.
>>
>> Please revert this as test_and_set_bit was always supposed to be
>> a full memory barrier.  This is an arch bug.
> 
> Alright, reverting.

FYI, Linus applied the alternate fix directly to his tree already, so
this is fixed on M1 either way. However, you may want to pay attention
to the discussion about the subtlety of the workqueue code pairing
test_and_set_bit() not with clear_bit(), but rather atomic_long_set(),
since it *could* imply it is still broken or might be broken in the
future, on other architectures.

- Hector

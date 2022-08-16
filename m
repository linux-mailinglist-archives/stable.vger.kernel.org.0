Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385845954D0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiHPIRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiHPIQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:16:33 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826004B493;
        Mon, 15 Aug 2022 22:37:40 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 8F51B447D8;
        Tue, 16 Aug 2022 05:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660628259; bh=klFJScQtPdSGYcjCrTuLd0vmp+BxBQY7IprafXE1WXI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=UYrY0eQvg03ffFpSW8MPibeWDmSlQ/yIUpjNy0a6r8M5yYDkXuuY2mgbvXGRIvUKV
         GKz0u6P8fP347aqNjdqhKCYZ0hFw97bxhf4/fNsEOEsk0hKwi3mcerFSmxESOJtObT
         ehE5TDjXiRASB0Tulir8a5ysB6oWfFiNPMGbPFaEHIkqpw3cbHaGwhpgxXXTL8zzPZ
         Rk7YU9AniJOpzHeMzqoGsi2OYvQ/6Rcogj3a4cY18e2p+OdyQYoMJRUkxaqMCUj3Q8
         sR2f1ZuFZuhOHeN4Zq5QAjXQLlzT+m6x0uN6nV8Fbd17jp7/ETXkceDCDFThJLdMRQ
         HVN0NlTWFLFlw==
Message-ID: <923f9638-d443-cb8e-104f-41a7f34fa25c@marcan.st>
Date:   Tue, 16 Aug 2022 14:37:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Content-Language: es-ES
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     tj@kernel.org, will@kernel.org, peterz@infradead.org,
        jirislaby@kernel.org, maz@kernel.org, mark.rutland@arm.com,
        boqun.feng@gmail.com, catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <YvsZvwxACuGw3KIt@gondor.apana.org.au>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <YvsZvwxACuGw3KIt@gondor.apana.org.au>
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

On 16/08/2022 13.14, Herbert Xu wrote:
> Hector Martin <marcan@marcan.st> wrote:
>>
>> This has been broken since the dawn of time, and it was incompletely
>> fixed by 346c09f80459, which added the necessary barriers in the work
>> execution path but failed to account for the missing barrier in the
>> test_and_set_bit() failure case. Fix it by switching to
>> atomic_long_fetch_or(), which does have unconditional barrier semantics
>> regardless of whether the bit was already set or not (this is actually
>> just test_and_set_bit() minus the early exit path).
> 
> test_and_set_bit is supposed to contain a full memory barrier.
> If it doesn't then your arch is broken and needs to be fixed.
> 
> Changing this one spot is pointless because such assumptions
> are all over the kernel.

Documentation/atomic_bitops.txt and the asm-generic implementaton
disagree with you, so this isn't quite as simple as "your arch is
broken" :-)

- Hector

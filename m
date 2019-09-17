Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E40B4637
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 06:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfIQEJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 00:09:47 -0400
Received: from ozlabs.org ([203.11.71.1]:42705 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfIQEJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 00:09:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46XV4S1Ck6z9sNk;
        Tue, 17 Sep 2019 14:09:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1568693384;
        bh=kXBG0j7byDkaAKYH5oVlw2beDV/BXPL5/ndrUEghl0k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SDLBkBrQlXkXbEpetXg6hX1y65ETVRLNBTD4tMH+fmjyCYxcpuEXIvt4q2z478nTq
         hQ7OZL3Do61hwPGh2DfjClGQAOD324TdVvapMqGxbnMGlTcKbKafSukmVHX1mjsGI6
         aqZZ12OQRHMsReS3Tgn0Pm6thxQTNgK3bcs8e0cMTy1JkWMMXn/oPlEP/J0KvxObxq
         LrdzDqKCRrrya87Nx/xVnig7fJg0a/peyE6YnC6o1hZYiJ2sGnvznhrWTfoG79NaNV
         OtsnsAxmNLxkQowLc/oyDLfCEXAYCZ4bOq6VB7Ia00IcnTCu3Ta35UIo60812oOKnY
         m/+e48TTbkyfw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kurz <groug@kaod.org>, Sasha Levin <sashal@kernel.org>
Cc:     Paul Mackerras <paulus@ozlabs.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/xive: Fix bogus error code returned by OPAL
In-Reply-To: <20190913131221.3ea88b5a@bahia.lan>
References: <156821713818.1985334.14123187368108582810.stgit@bahia.lan> <20190912073049.CF36B20830@mail.kernel.org> <20190913131221.3ea88b5a@bahia.lan>
Date:   Tue, 17 Sep 2019 14:09:43 +1000
Message-ID: <87sgovsgvs.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kurz <groug@kaod.org> writes:
> On Thu, 12 Sep 2019 07:30:49 +0000
> Sasha Levin <sashal@kernel.org> wrote:
>
>> Hi,
>> 
>> [This is an automated email]
>> 
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: 4.12+
>> 
>> The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143.
>> 
>> v5.2.14: Build OK!
>> v4.19.72: Failed to apply! Possible dependencies:
>>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
>
> This is the only dependency indeed.

But it's a large and intrusive change, so we don't want to backport it
just for this.

>> v4.14.143: Failed to apply! Possible dependencies:
>>     104daea149c4 ("kconfig: reference environment variables directly and remove 'option env='")
>>     21c54b774744 ("kconfig: show compiler version text in the top comment")
>>     315bab4e972d ("kbuild: fix endless syncconfig in case arch Makefile sets CROSS_COMPILE")
>>     3298b690b21c ("kbuild: Add a cache for generated variables")
>>     4e56207130ed ("kbuild: Cache a few more calls to the compiler")
>>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
>>     8f2133cc0e1f ("powerpc/pseries: hcall_exit tracepoint retval should be signed")
>>     9a234a2e3843 ("kbuild: create directory for make cache only when necessary")
>>     d677a4d60193 ("Makefile: support flag -fsanitizer-coverage=trace-cmp")
>>     e08d6de4e532 ("kbuild: remove kbuild cache")
>>     e17c400ae194 ("kbuild: shrink .cache.mk when it exceeds 1000 lines")
>>     e501ce957a78 ("x86: Force asm-goto")
>>     e9666d10a567 ("jump_label: move 'asm goto' support test to Kconfig")
>> 
>
> That's quite a lot of patches to workaround a hard to hit skiboot bug.
> As an alternative, the patch can be backported so that it applies the
> following change:
>
> -OPAL_CALL(opal_xive_allocate_irq,              OPAL_XIVE_ALLOCATE_IRQ);
> +OPAL_CALL(opal_xive_allocate_irq_raw,          OPAL_XIVE_ALLOCATE_IRQ);
>
> to "arch/powerpc/platforms/powernv/opal-wrappers.S"
> instead of "arch/powerpc/platforms/powernv/opal-call.c" .
>
> BTW, this could also be done for 4.19.y .
>
>> 
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>> 
>> How should we proceed with this patch?
>> 
>
> Michael ?

We should do a manual backport for v4.14 and v4.19. Greg do you have
cycles to do that?

cheers

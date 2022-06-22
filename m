Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC6D554086
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 04:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbiFVC12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 22:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiFVC11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 22:27:27 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2603533A17;
        Tue, 21 Jun 2022 19:27:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LSS2d4vzDz4xYD;
        Wed, 22 Jun 2022 12:27:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1655864842;
        bh=7wPtZzilp6XrJMCgGLGRvDuLvLC6U9nqxWFY5hLeiBI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=n41Lv86JCLLl20DlEOzBjcnAn1OC1vElApH2qZCKvox+q4g7enU6aF6epC4RabuDS
         Rf80qAlUnXvfmOUTHpW159oRvnK5yYKSiEYqEP/UobHU9cltf1AIcdbbu2gzssFLhx
         5WPIGJrMz9jMf5ahU23TzAw8NruEH0OHAWbSKtZsigbudrhTroTdqCyx5qrjOkU6HB
         EkAOlRCrXq29ZIRZwOTxOMJraMOmnWXl3GHfadOtpo+MX0IE9N6cBdc9jmyVzn3+zy
         nwXMBQHfXL6UGvYnU49sXOCCjyo/iu3jKfi/7Rc+3TTG6mG/rCVMBDynuOFF9Pe2uy
         60TkysKix9/Eg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
In-Reply-To: <a354de5e-1d07-3759-a55e-a9179890cfaa@csgroup.eu>
References: <20220620124531.78075-1-Jason@zx2c4.com>
 <20220621140849.127227-1-Jason@zx2c4.com>
 <246d8bf0-2bee-7e1b-e0af-408920ece309@csgroup.eu>
 <YrISWLwm8m7OPFom@zx2c4.com>
 <a354de5e-1d07-3759-a55e-a9179890cfaa@csgroup.eu>
Date:   Wed, 22 Jun 2022 12:27:20 +1000
Message-ID: <87bkulzb3r.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:
> Le 21/06/2022 =C3=A0 20:47, Jason A. Donenfeld a =C3=A9crit=C2=A0:
>> On Tue, Jun 21, 2022 at 06:33:11PM +0000, Christophe Leroy wrote:
>>> Le 21/06/2022 =C3=A0 16:08, Jason A. Donenfeld a =C3=A9crit=C2=A0:
>>>> The platform's RNG must be available before random_init() in order to =
be
>>>> useful for initial seeding, which in turn means that it needs to be
>>>> called from setup_arch(), rather than from an init call. Fortunately,
>>>> each platform already has a setup_arch function pointer, which means we
>>>> can wire it up that way. Complicating things, however, is that POWER8
>>>> systems need some per-cpu state and kmalloc, which isn't available at
>>>> this stage. So we split things up into an early phase and a later
>>>> opportunistic phase. This commit also removes some noisy log messages
>>>> that don't add much.
>>>
>>> Regarding the kmalloc(), I have not looked at it in details, but usually
>>> you can use memblock_alloc() when kmalloc is not available yet.
>>=20
>> That seems a bit excessive, especially as those allocations are long
>> lived. And we don't even *need* it that early, but just before
>> random_init(). Michael is running this v5 on the test rig overnight, so
>> we'll learn in the Australian morning whether this finally did the trick
>> (I hope).
>
> The fact that they are long lived make them a good candidate for=20
> memblock_alloc().
>
> But fair enough, if they are not required that early then just do it late=
r.

memblock works but then we trip on ioremap vs early_ioremap.

Fixing that is a bit of a pain as we'd have to stop using of_iomap() and
we'd also need to switch the mappings to ioremap() later in boot.

We'd also have to defer the percpu initialisation.

So it's all just a bit of a pain when we actually only need to get the
hook ready before random_init() which is called much later in boot when
slab/ioremap/percpu are all ready.

cheers

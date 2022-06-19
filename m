Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDB3550A5B
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 13:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbiFSLtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 07:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbiFSLtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 07:49:35 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED2E11C39;
        Sun, 19 Jun 2022 04:49:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LQrfc2KlYz4xD5;
        Sun, 19 Jun 2022 21:49:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1655639368;
        bh=RxqgpkvYXIMqKgyDQ7kwLL5/35pT3XImCLQGG5rSp7I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=TTxx5LR+IzArQZd/kTvFAhLiyYeLJr73ZEgbmcKK06u3S9tRvRsVOftDMJHXjQuTz
         1BnJY2g9UgsjvBrD0s1Cz1mn1r3WjaEB6QRsmk/R96jAUGbPDMvQKJt+j2cF2RJpW5
         2Mw2yumaHbmSVwIzuLB1l3DHvweCEa9KWg7NbGBixRHDfroZjf3UDuD8Swd6YrYkag
         S2NypLZOpqKaCyQvLF+W7YsmhkwL+A66OaDK7JIbmbCOxLjonKNrjS1BEM7KkjrMmR
         sRHPVeYOHYbtx3if6J4NOB+6xwNN6SPtDrlIt5itc8d0Sq42k7oJVK2JxXqs/DbbEt
         XjX0fP9end/oA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v3 2/3] powerpc/powernv: wire up rng during setup_arch
In-Reply-To: <20220611151015.548325-3-Jason@zx2c4.com>
References: <20220611151015.548325-1-Jason@zx2c4.com>
 <20220611151015.548325-3-Jason@zx2c4.com>
Date:   Sun, 19 Jun 2022 21:49:26 +1000
Message-ID: <87czf4c1q1.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:
> The platform's RNG must be available before random_init() in order to be
> useful for initial seeding, which in turn means that it needs to be
> called from setup_arch(), rather than from an init call. Fortunately,
> each platform already has a setup_arch function pointer, which means
> it's easy to wire this up. This commit also removes some noisy log
> messages that don't add much.
>
> Cc: stable@vger.kernel.org
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Fixes: a4da0d50b2a0 ("powerpc: Implement arch_get_random_long/int() for powernv")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/powerpc/platforms/powernv/powernv.h |  2 ++
>  arch/powerpc/platforms/powernv/rng.c     | 18 +++++-------------
>  arch/powerpc/platforms/powernv/setup.c   |  2 ++
>  3 files changed, 9 insertions(+), 13 deletions(-)
>
...
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 824c3ad7a0fa..a5fcb6796b22 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -203,6 +203,8 @@ static void __init pnv_setup_arch(void)
>  	pnv_check_guarded_cores();
>  
>  	/* XXX PMCS */
> +
> +	powernv_rng_init();
>  }

This crashes on power8 because it's too early to call kzalloc() in
rng_create(), and it's also too early to setup the percpu variables in
there.

I'll rework it and post a v4.

cheers

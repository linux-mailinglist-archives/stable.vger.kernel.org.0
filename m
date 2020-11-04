Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5542A5AFC
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 01:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgKDAWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 19:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729021AbgKDAUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 19:20:25 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B775DC0613D1;
        Tue,  3 Nov 2020 16:20:25 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CQnNk40jsz9sT6;
        Wed,  4 Nov 2020 11:20:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1604449222;
        bh=VC+f+ZkJ1S1VxK7q1l35M+IDDfBanUc/kXYdpGzih90=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MOMRL1jgFBdsMZewwd+uVHelnLRMk+W3GE3jbHfafKAZoB6EK3TxyyP1jzowjSVuC
         EeLK+n/2Cy4NRCxid55Vrh2Fb8xTZSRrKk4/uBL4akbGdnSvv6ut/ONKxII4lAFtt8
         sKwAXlTM4H4Jfrjfa4FUnchZR7YYmwSfh2Oub5A+w29z5LkqZSK5llEWs4U6iccZtJ
         VKYF1iL66OAK/KKH4CpMGOmy+8ot+QhXzgL6r+LkRduzIMp8/IV5T536jT1yFf8pPN
         UN2Cp+BxF/UOO5QLR7kzwHNhJSJj5iEemkVNv/i4TfFGd6aTUj580eMaWrphbwWV2N
         4cW3d9I6XmPwQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 056/191] powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
In-Reply-To: <20201103203239.940977599@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org> <20201103203239.940977599@linuxfoundation.org>
Date:   Wed, 04 Nov 2020 11:20:17 +1100
Message-ID: <87361qug5a.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> From: Nicholas Piggin <npiggin@gmail.com>
>
> [ Upstream commit 66acd46080bd9e5ad2be4b0eb1d498d5145d058e ]
>
> powerpc uses IPIs in some situations to switch a kernel thread away
> from a lazy tlb mm, which is subject to the TLB flushing race
> described in the changelog introducing ARCH_WANT_IRQS_OFF_ACTIVATE_MM.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20200914045219.3736466-3-npiggin@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/powerpc/Kconfig                   | 1 +
>  arch/powerpc/include/asm/mmu_context.h | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index f38d153d25861..0bc53f0e37c0f 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -152,6 +152,7 @@ config PPC
>  	select ARCH_USE_BUILTIN_BSWAP
>  	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
>  	select ARCH_WANT_IPC_PARSE_VERSION
> +	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM

This depends on upstream commit:

  d53c3dfb23c4 ("mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race")


Which I don't see in 4.19 stable, or in the email thread here.

So this shouldn't be backported to 4.19 unless that commit is also
backported.

cheers

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370AA1F846E
	for <lists+stable@lfdr.de>; Sat, 13 Jun 2020 19:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgFMR2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jun 2020 13:28:32 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:27111 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgFMR2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Jun 2020 13:28:31 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49kl1Q0G8Fz9tyVJ;
        Sat, 13 Jun 2020 19:28:26 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id V0taFgg7QO5z; Sat, 13 Jun 2020 19:28:25 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49kl1P50Mkz9tyVH;
        Sat, 13 Jun 2020 19:28:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EF0DE8B77C;
        Sat, 13 Jun 2020 19:28:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id sBMC7z0GI5Bp; Sat, 13 Jun 2020 19:28:27 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D512F8B76A;
        Sat, 13 Jun 2020 19:28:26 +0200 (CEST)
Subject: Re: [PATCH] powerpc/fsl_booke/32: fix build with
 CONFIG_RANDOMIZE_BASE
To:     Arseny Solokha <asolokha@kb.kras.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Scott Wood <oss@buserror.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200613162801.1946619-1-asolokha@kb.kras.ru>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <754d31be-730b-8f18-4ead-ba2f303650d0@csgroup.eu>
Date:   Sat, 13 Jun 2020 19:28:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200613162801.1946619-1-asolokha@kb.kras.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 13/06/2020 à 18:28, Arseny Solokha a écrit :
> Building the current 5.8 kernel for a e500 machine with
> CONFIG_RANDOMIZE_BASE set yields the following failure:
> 
>    arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_early_init':
>    arch/powerpc/mm/nohash/kaslr_booke.c:387:2: error: implicit declaration
> of function 'flush_icache_range'; did you mean 'flush_tlb_range'?
> [-Werror=implicit-function-declaration]
> 
> Indeed, including asm/cacheflush.h into kaslr_booke.c fixes the build.
> 
> The issue dates back to the introduction of that file and probably went
> unnoticed because there's no in-tree defconfig with CONFIG_RANDOMIZE_BASE
> set.

I don't get this problem with mpc85xx_defconfig + RELOCATABLE + 
RANDOMIZE_BASE.

Christophe

> 
> Fixes: 2b0e86cc5de6 ("powerpc/fsl_booke/32: implement KASLR infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
> ---
>   arch/powerpc/mm/nohash/kaslr_booke.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
> index 4a75f2d9bf0e..bce0e5349978 100644
> --- a/arch/powerpc/mm/nohash/kaslr_booke.c
> +++ b/arch/powerpc/mm/nohash/kaslr_booke.c
> @@ -14,6 +14,7 @@
>   #include <linux/memblock.h>
>   #include <linux/libfdt.h>
>   #include <linux/crash_core.h>
> +#include <asm/cacheflush.h>
>   #include <asm/pgalloc.h>
>   #include <asm/prom.h>
>   #include <asm/kdump.h>
> 

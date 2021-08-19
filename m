Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DC23F1682
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 11:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbhHSJqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 05:46:21 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:60227 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237542AbhHSJqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 05:46:19 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Gr0J53D8Lz9sWP;
        Thu, 19 Aug 2021 11:45:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hAGfMF3bk9Rp; Thu, 19 Aug 2021 11:45:41 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Gr0J16mshz9sWW;
        Thu, 19 Aug 2021 11:45:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C619E8B834;
        Thu, 19 Aug 2021 11:45:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id zVjoN77zbbiB; Thu, 19 Aug 2021 11:45:37 +0200 (CEST)
Received: from [172.25.230.102] (po15451.idsi0.si.c-s.fr [172.25.230.102])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 890878B835;
        Thu, 19 Aug 2021 11:45:37 +0200 (CEST)
Subject: Re: [PATCH 1/2] powerpc: kvm: rectify selection to PPC_DAWR
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
 <20210819093226.13955-2-lukas.bulwahn@gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <475fa73c-5eef-a60c-c70f-9f6ea7a079d8@csgroup.eu>
Date:   Thu, 19 Aug 2021 11:45:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819093226.13955-2-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 19/08/2021 à 11:32, Lukas Bulwahn a écrit :
> Commit a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
> selects the non-existing config PPC_DAWR_FORCE_ENABLE for config
> KVM_BOOK3S_64_HANDLER. As this commit also introduces a config PPC_DAWR,
> it probably intends to select PPC_DAWR instead.
> 
> Rectify the selection in config KVM_BOOK3S_64_HANDLER to PPC_DAWR.
> 
> The issue was identified with ./scripts/checkkconfigsymbols.py.
> 
> Fixes: a278e7ea608b ("powerpc: Fix compile issue with force DAWR")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>   arch/powerpc/kvm/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> index e45644657d49..aa29ea56c80a 100644
> --- a/arch/powerpc/kvm/Kconfig
> +++ b/arch/powerpc/kvm/Kconfig
> @@ -38,7 +38,7 @@ config KVM_BOOK3S_32_HANDLER
>   config KVM_BOOK3S_64_HANDLER
>   	bool
>   	select KVM_BOOK3S_HANDLER
> -	select PPC_DAWR_FORCE_ENABLE
> +	select PPC_DAWR

That's useless, see https://elixir.bootlin.com/linux/v5.14-rc6/source/arch/powerpc/Kconfig#L267

In arch/powerpc/Kconfig, you already have:

	select PPC_DAWR				if PPC64




>   
>   config KVM_BOOK3S_PR_POSSIBLE
>   	bool
> 

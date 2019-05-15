Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB2B1E85B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 08:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfEOGlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 02:41:45 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:59598 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfEOGlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 02:41:45 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 453lMV1SRhz9vDbb;
        Wed, 15 May 2019 08:41:42 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=DK9rNl/h; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id vcW5mbW1k2cL; Wed, 15 May 2019 08:41:42 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 453lMV0Ghrz9vDbZ;
        Wed, 15 May 2019 08:41:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1557902502; bh=vplXhUCXMUkBbAhZdPnBIWeLAyV9BImQh2VZswTq/p8=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=DK9rNl/hiVMeXYj30ATLH1pH20dhQxionpq/UxS/vT//riqMQvuz/gPRNYuf2U8Ae
         qS9JfvrNTWMBZ+s/mXy4S894wEpamc8nA1oUCT95clV5JI9lJSkZXZhLfwq8RRe6IV
         wySDsUozN27vs0Zd+QUT2LvHmOpaya8JyuFtbF20=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EBB668B7D6;
        Wed, 15 May 2019 08:41:42 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id iln7o7zUWlSr; Wed, 15 May 2019 08:41:42 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BC5188B7D2;
        Wed, 15 May 2019 08:41:42 +0200 (CEST)
Subject: Re: [PATCH] powerpc/lib: fix book3s/32 boot failure due to code
 patching
From:   Christophe Leroy <christophe.leroy@c-s.fr>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg KH <gregkh@linuxfoundation.org>, erhard_f@mailbox.org,
        Michael Neuling <mikey@neuling.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <629c2acb1fcd09c2d2e3352370c3d9853372cf39.1557902321.git.christophe.leroy@c-s.fr>
Message-ID: <b118ac0a-5ccb-2fae-f7a7-d9848b33b205@c-s.fr>
Date:   Wed, 15 May 2019 08:41:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <629c2acb1fcd09c2d2e3352370c3d9853372cf39.1557902321.git.christophe.leroy@c-s.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oops, forgot to tell it's for 4.9. Resending with proper subject.

Le 15/05/2019 à 08:39, Christophe Leroy a écrit :
> [Backport of upstream commit b45ba4a51cde29b2939365ef0c07ad34c8321789]
> 
> On powerpc32, patch_instruction() is called by apply_feature_fixups()
> which is called from early_init()
> 
> There is the following note in front of early_init():
>   * Note that the kernel may be running at an address which is different
>   * from the address that it was linked at, so we must use RELOC/PTRRELOC
>   * to access static data (including strings).  -- paulus
> 
> Therefore init_mem_is_free must be accessed with PTRRELOC()
> 
> Fixes: 1c38a84d4586 ("powerpc: Avoid code patching freed init sections")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=203597
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
> Can't apply the upstream commit as such due to several other unrelated stuff
> like for instance STRICT_KERNEL_RWX which are missing.
> So instead, using same approach as for commit 252eb55816a6f69ef9464cad303cdb3326cdc61d
> ---
>   arch/powerpc/lib/code-patching.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
> index 14535ad4cdd1..c312955977ce 100644
> --- a/arch/powerpc/lib/code-patching.c
> +++ b/arch/powerpc/lib/code-patching.c
> @@ -23,7 +23,7 @@ int patch_instruction(unsigned int *addr, unsigned int instr)
>   	int err;
>   
>   	/* Make sure we aren't patching a freed init section */
> -	if (init_mem_is_free && init_section_contains(addr, 4)) {
> +	if (*PTRRELOC(&init_mem_is_free) && init_section_contains(addr, 4)) {
>   		pr_debug("Skipping init section patching addr: 0x%px\n", addr);
>   		return 0;
>   	}
> 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB421C6D8
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 12:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfENKRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 06:17:34 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55193 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfENKRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 06:17:34 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 453DBx2lqDz9sNK;
        Tue, 14 May 2019 20:17:29 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Greg KH <gregkh@linuxfoundation.org>, erhard_f@mailbox.org,
        Michael Neuling <mikey@neuling.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH stable 4.9] powerpc/lib: fix code patching during early init on PPC32
In-Reply-To: <015040d922a68fa15c81879cc2fc9ed7ac106e60.1557827275.git.christophe.leroy@c-s.fr>
References: <015040d922a68fa15c81879cc2fc9ed7ac106e60.1557827275.git.christophe.leroy@c-s.fr>
Date:   Tue, 14 May 2019 20:17:27 +1000
Message-ID: <87y339s5l4.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> writes:
> [Backport of upstream commit b45ba4a51cde29b2939365ef0c07ad34c8321789]
>
> On powerpc32, patch_instruction() is called by apply_feature_fixups()
> which is called from early_init()
>
> There is the following note in front of early_init():
>  * Note that the kernel may be running at an address which is different
>  * from the address that it was linked at, so we must use RELOC/PTRRELOC
>  * to access static data (including strings).  -- paulus
>
> Therefore init_mem_is_free must be accessed with PTRRELOC()
>
> Fixes: 1c38a84d4586 ("powerpc: Avoid code patching freed init sections")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=203597
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>
> ---
> Can't apply the upstream commit as such due to several of other unrelated stuff
> like STRICT_KERNEL_RWX which are missing for instance.
> So instead, using same approach as for commit 252eb55816a6f69ef9464cad303cdb3326cdc61d

Yeah this looks good to me.

Though should we keep the same subject as the upstream commit this is
sort of a backport of? That might make it simpler for people who are
trying to keep track of things?

ie. "powerpc/lib: fix book3s/32 boot failure due to code patching"

cheers

> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
> index 14535ad4cdd1..c312955977ce 100644
> --- a/arch/powerpc/lib/code-patching.c
> +++ b/arch/powerpc/lib/code-patching.c
> @@ -23,7 +23,7 @@ int patch_instruction(unsigned int *addr, unsigned int instr)
>  	int err;
>  
>  	/* Make sure we aren't patching a freed init section */
> -	if (init_mem_is_free && init_section_contains(addr, 4)) {
> +	if (*PTRRELOC(&init_mem_is_free) && init_section_contains(addr, 4)) {
>  		pr_debug("Skipping init section patching addr: 0x%px\n", addr);
>  		return 0;
>  	}
> -- 
> 2.13.3

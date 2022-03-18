Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34754DD8EE
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbiCRLaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbiCRLaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 07:30:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC661ED055;
        Fri, 18 Mar 2022 04:29:32 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B26241EC0662;
        Fri, 18 Mar 2022 12:29:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1647602966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7cHjZTrO3pszQOYs78HUK2TVdaR3zSuUmPa3P4965TQ=;
        b=VeMn+FV7lsd7524c97/dvErpkObi38LUan9DkmodjZQSeYnUrvs7EaaJuXn0hK/BI/NLtz
        62womwRZey5rcx+VkO/8LsSXpmzNml/SwXDz2Iadftaplf3xGftTClz54F7KSC9VsZD5lo
        KwtZsPVedAcImMNQwD6wjo7iSXsPItg=
Date:   Fri, 18 Mar 2022 12:29:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, hpa@zytor.com,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Unroll string mmio with
 CC_ATTR_GUEST_UNROLL_STRING_IO
Message-ID: <YjRtE30Usxy8PurP@zn.tnic>
References: <20220310112615.31133-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220310112615.31133-1-joro@8bytes.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 12:26:15PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The io specific memcpy/memset functions use string mmio accesses to do
> their work. Under SEV the hypervisor can't emulate these instructions,
> because they read/write directly from/to encrypted memory.
> 
> KVM will inject a page fault exception into the guest when it is asked
> to emulate string mmio instructions for an SEV guest:
> 
> 	BUG: unable to handle page fault for address: ffffc90000065068
> 	#PF: supervisor read access in kernel mode
> 	#PF: error_code(0x0000) - not-present page
> 	PGD 8000100000067 P4D 8000100000067 PUD 80001000fb067 PMD 80001000fc067 PTE 80000000fed40173
> 	Oops: 0000 [#1] PREEMPT SMP NOPTI
> 	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc7 #3
> 
> As string mmio for an SEV guest can not be supported by the
> hypervisor, unroll the instructions for CC_ATTR_GUEST_UNROLL_STRING_IO
> enabled kernels.

What I'm missing in this description is why wasn't it a problem until now?

You mentioned something about libvirt adding TPMs and that causing this
but I'm still unclear as to why exactly this is causing the issue. I'm
guessing SEV guests didn't do string IO but libvirt adding a TPM is
somehow causing them to use them now...

> @@ -56,9 +55,8 @@ void memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
>  	}
>  	rep_movs((void *)to, (const void *) from, n);
>  }
> -EXPORT_SYMBOL(memcpy_toio);
>  
> -void memset_io(volatile void __iomem *a, int b, size_t c)
> +static void string_memset_io(volatile void __iomem *a, int b, size_t c)

You can simply remove that wrapper and use memset() at the callsite.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

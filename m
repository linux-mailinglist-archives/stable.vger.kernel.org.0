Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFA62F73A7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 08:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbhAOHS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 02:18:58 -0500
Received: from mail.skyhub.de ([5.9.137.197]:45254 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbhAOHS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 02:18:57 -0500
Received: from zn.tnic (p200300ec2f0acf000311429e1bff10f2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:cf00:311:429e:1bff:10f2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BF65E1EC0494;
        Fri, 15 Jan 2021 08:18:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610695095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xz7ofcGKLmGhRc+thA4HBQzKkytDaQUoDAqW780BAFI=;
        b=QvT1qX82T2WeF6qqozMXOyPi8GU99oAugRIXZNB+VY7F52SDNcZoHCQloHq8wrcW2ZTMOf
        RYRUnwHGkSp95PGkRGlMbsDKOIkVtSpc2IvMixlfEftdxMdHGpwcTdSugn16y3kV+ILtvK
        KGKNK7eElcsIFlvKcchxiVcSwGr/EI0=
Date:   Fri, 15 Jan 2021 08:18:09 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     jarkko@kernel.org
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        kai.huang@intel.com, haitao.huang@intel.com, seanjc@google.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <20210115071809.GA9138@zn.tnic>
References: <20210115014638.15037-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210115014638.15037-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 03:46:38AM +0200, jarkko@kernel.org wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> The most trivial example of a race condition can be demonstrated with this
> example where mm_list contains just one entry:
> 
> CPU A                   CPU B
> sgx_release()
>                         sgx_mmu_notifier_release()
>                         list_del_rcu()
> sgx_encl_release()
>                         synchronize_srcu()
> cleanup_srcu_struct()
> 
> To fix this, call synchronize_srcu() before checking whether mm_list is
> empty in sgx_release().

To fix what?

Lemme explain one more time: a commit message for a race condition
fix needs to explain in *detail* what the race condition is. And that
explanation needs to be understandable months and years from now.

You have the function call order above, now you have to explain what can
happen. Just how you did here:

https://lkml.kernel.org/r/X/zoarV7gd/LNo4A@kernel.org

> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v4:
> - Rewrite the commit message.
> - Just change the call order. *_expedited() is out of scope for this
>   bug fix.
> v3: Fine-tuned tags, and added missing change log for v2.
> v2: Switch to synchronize_srcu_expedited().
>  arch/x86/kernel/cpu/sgx/driver.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index f2eac41bb4ff..53056345f5f8 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -65,11 +65,16 @@ static int sgx_release(struct inode *inode, struct file *file)
>  
>  		spin_unlock(&encl->mm_lock);
>  
> +		/*
> +		 * The call is need even if the list empty, because sgx_encl_mmu_notifier_release()

"The call is need"?


$ git grep sgx_encl_mmu_notifier_release
$

WTF?

Please be more careful.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

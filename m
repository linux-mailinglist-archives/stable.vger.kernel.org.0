Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62B849CC62
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbiAZOcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:32:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52546 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242194AbiAZOcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:32:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4248B81CEB;
        Wed, 26 Jan 2022 14:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE455C340E3;
        Wed, 26 Jan 2022 14:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643207565;
        bh=gKf9zur6l6kv4MdYfaOpKzS4yNvRurcGXURYpzrdMG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rBnUdQew3vXEXa9GuzBKy2mEi4MS7roxhvTzx/LreGnArMj2bvcSrO3/UDWV91nmK
         zD7Gz+ooqVokYVDxcWuF63eh3BbIKBIj1td211gAC/P2ej+FOTmuzDmgG1eGI4IhJf
         XDWZh88RH+3CdSgmCHtVodUNTZcDe6M+0lBFgQSFpKzSuXamoS1tQxcYdPhq+jtX9p
         ayuldAQic/PPXsWHyDnfd7izDSU5Nrl5WkvMgYppZXRhHWmSxWGA4h1jgEp5yRkEsH
         PY0cirScc9E3e3/99myFmM+77jaVB7BJ0JpEkuM2S2yuZ0WGlx0xMeuuzaES1MJOyz
         Dvsc/EXAj0xCg==
Date:   Wed, 26 Jan 2022 16:32:24 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org, vijay.dhanraj@intel.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] x86/sgx: Silence softlockup detection when releasing
 large enclaves
Message-ID: <YfFbeNSuCeANF+UN@iki.fi>
References: <b5e9f218064aa76e3026f778e1ad0a1d823e3db8.1643133224.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5e9f218064aa76e3026f778e1ad0a1d823e3db8.1643133224.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 10:22:43AM -0800, Reinette Chatre wrote:
> Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
> triggers the softlockup detector.
> 
> Actual SGX systems have 128GB of enclave memory or more.  The
> "unclobbered_vdso_oversubscribed" selftest creates one enclave which
> consumes all of the enclave memory on the system. Tearing down such a
> large enclave takes around a minute, most of it in the loop where
> the EREMOVE instruction is applied to each individual 4k enclave page.
> 
> Spending one minute in a loop triggers the softlockup detector.
> 
> Add a cond_resched() to give other tasks a chance to run and placate
> the softlockup detector.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Softlockup message:
> 
> watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [test_sgx:11502]
> Kernel panic - not syncing: softlockup: hung tasks
> <snip>
> sgx_encl_release+0x86/0x1c0
> sgx_release+0x11c/0x130
> __fput+0xb0/0x280
> ____fput+0xe/0x10
> task_work_run+0x6c/0xc0
> exit_to_user_mode_prepare+0x1eb/0x1f0
> syscall_exit_to_user_mode+0x1d/0x50
> do_syscall_64+0x46/0xb0
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Changes since V1:
> - V1: https://lore.kernel.org/lkml/1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com/
> - Add comment provided by Jarkko.
> 
>  arch/x86/kernel/cpu/sgx/encl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 001808e3901c..48afe96ae0f0 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -410,6 +410,8 @@ void sgx_encl_release(struct kref *ref)
>  		}
>  
>  		kfree(entry);
> +		/* Invoke scheduler to prevent soft lockups. */
> +		cond_resched();
>  	}
>  
>  	xa_destroy(&encl->page_array);
> -- 
> 2.25.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>  (kselftest as sanity check)

BR, Jarkko

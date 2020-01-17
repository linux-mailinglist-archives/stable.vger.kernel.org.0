Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B9A140A5B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 14:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgAQNAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 08:00:50 -0500
Received: from 8bytes.org ([81.169.241.247]:60168 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgAQNAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 08:00:50 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D1DF9327; Fri, 17 Jan 2020 14:00:48 +0100 (CET)
Date:   Fri, 17 Jan 2020 14:00:47 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/CPU/AMD: Ensure clearing of SME/SEV features is
 maintained
Message-ID: <20200117130047.GA3685@8bytes.org>
References: <226de90a703c3c0be5a49565047905ac4e94e8f3.1579125915.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <226de90a703c3c0be5a49565047905ac4e94e8f3.1579125915.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 04:05:16PM -0600, Tom Lendacky wrote:
> If the SME and SEV features are present via CPUID, but memory encryption
> support is not enabled (MSR 0xC001_0010[23]), the features are cleared
> using clear_cpu_cap(). However, if get_cpu_cap() is later called, these
> features will be reset back to present, which is not desired.
> 
> Change from using clear_cpu_cap() to setup_clear_cpu_cap() so that the
> clearing of the features is maintained.
> 
> Cc: <stable@vger.kernel.org> # 4.16.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Joerg Roedel <jroedel@suse.de>

> ---
>  arch/x86/kernel/cpu/amd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 90f75e515876..62c30279be77 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -615,9 +615,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  		return;
>  
>  clear_all:
> -		clear_cpu_cap(c, X86_FEATURE_SME);
> +		setup_clear_cpu_cap(X86_FEATURE_SME);
>  clear_sev:
> -		clear_cpu_cap(c, X86_FEATURE_SEV);
> +		setup_clear_cpu_cap(X86_FEATURE_SEV);
>  	}
>  }
>  
> -- 
> 2.17.1

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D55246EC0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgHQRgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:36:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:63451 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729520AbgHQRfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 13:35:52 -0400
IronPort-SDR: iZ2pkLIWgHb+zSuTuzJMGbddugSrXX70XPqpsjqLko2eejEvPfli81J6y/rN7E6UxP3FtY0SSz
 QVvI0H+0g4iA==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="239586575"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="239586575"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 10:35:49 -0700
IronPort-SDR: dvvwDmsrt5UqQV5AB+zOhs+Tfvhkis/zHiIHAJtkctXled78/ujgaUwhZDPT5n18ytZP9lc6x4
 Z05Ok352CRRA==
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="292499642"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 10:35:49 -0700
Date:   Mon, 17 Aug 2020 10:35:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com, Yang Weijiang <weijiang.yang@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: Use a shorter encoding to clear RAX
Message-ID: <20200817173548.GH22407@linux.intel.com>
References: <20200817172034.26673-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817172034.26673-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 01:20:34PM -0400, Paolo Bonzini wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>

This shouldn't be here without Weijiang's SOB.

> If debug_regs.c is built with newer binutils, the resulting binary is "optimized"
> by the assembler:
> 
> asm volatile("ss_start: "
>              "xor %%rax,%%rax\n\t"
>              "cpuid\n\t"
>              "movl $0x1a0,%%ecx\n\t"
>              "rdmsr\n\t"
>              : : : "rax", "ecx");
> 
> is translated to :
> 
>   000000000040194e <ss_start>:
>   40194e:       31 c0                   xor    %eax,%eax     <----- rax->eax?
>   401950:       0f a2                   cpuid
>   401952:       b9 a0 01 00 00          mov    $0x1a0,%ecx
>   401957:       0f 32                   rdmsr
> 
> As you can see rax is replaced with eax in target binary code.
> This causes a difference is the length of xor instruction (2 Byte vs 3 Byte),
> and makes the hard-coded instruction length check fail:
> 
>         /* Instruction lengths starting at ss_start */
>         int ss_size[4] = {
>                 3,              /* xor */   <-------- 2 or 3?
>                 2,              /* cpuid */
>                 5,              /* mov */
>                 2,              /* rdmsr */
>         };
> 
> Encode the shorter version directly and, while at it, fix the "clobbers"
> of the asm.
> 
> Reported-by: Yang Weijiang <weijiang.yang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> ---
>  tools/testing/selftests/kvm/x86_64/debug_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
> index 8162c58a1234..b8d14f9db5f9 100644
> --- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
> +++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
> @@ -40,11 +40,11 @@ static void guest_code(void)
>  
>  	/* Single step test, covers 2 basic instructions and 2 emulated */
>  	asm volatile("ss_start: "
> -		     "xor %%rax,%%rax\n\t"
> +		     "xor %%eax,%%eax\n\t"
>  		     "cpuid\n\t"
>  		     "movl $0x1a0,%%ecx\n\t"
>  		     "rdmsr\n\t"
> -		     : : : "rax", "ecx");
> +		     : : : "eax", "ebx", "ecx", "edx");
>  
>  	/* DR6.BD test */
>  	asm volatile("bd_start: mov %%dr0, %%rax" : : : "rax");
> -- 
> 2.26.2
> 

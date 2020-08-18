Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E75B2485C6
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 15:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgHRNNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 09:13:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:24130 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbgHRNNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 09:13:35 -0400
IronPort-SDR: L/NiWsOp261toAA83p3LNFrAVLaeAFmuEbMN+hnY8YNzoDqQc+mipTMStXyUNSQ5rMlVCNk9k4
 U1wmz5SnGr2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="154153858"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="154153858"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 06:13:33 -0700
IronPort-SDR: 3B2z/bqLkMdhodrcZ4CfC+QANpEMODAmQBVCiyO0i7uvZxrbHhwOzf7bIfi4RZV4JlkF8xP+9D
 MSmeX3+j2rzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="320082635"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2020 06:13:31 -0700
Date:   Tue, 18 Aug 2020 21:21:11 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Yang Weijiang <weijiang.yang@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: Use a shorter encoding to clear RAX
Message-ID: <20200818132111.GA14817@local-michael-cet-test.sh.intel.com>
References: <20200817172034.26673-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817172034.26673-1-pbonzini@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 01:20:34PM -0400, Paolo Bonzini wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
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
Hi, Paolo,
Should we also change the below expected instruction length(xor) to 2 in
accordance with above change?

int ss_size[4] = {
        3,              /* xor */
        2,              /* cpuid */
        5,              /* mov */
        2,              /* rdmsr */

>  	/* DR6.BD test */
>  	asm volatile("bd_start: mov %%dr0, %%rax" : : : "rax");
> -- 
> 2.26.2

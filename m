Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459751C4E23
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 08:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgEEGPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 02:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgEEGPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 02:15:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4AA206B9;
        Tue,  5 May 2020 06:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588659305;
        bh=6Se8ZEmP6MFrXc+wNFs8CN8XdBYp/uPXYK5DaHmtZaY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k95mwFrx4hUVxnZbC+OE7GkB/kpTM2z9WFvrzILPyHZcQ0Khq68C9GGdIX6jEYtcr
         aNRuPVDY0BNp16u7hFOwEX6h/00/vyyBqMEMYSfX9jq7Y1kvYt1liRspIM1DKaQTcw
         ucy1Ap9Z/GUDeslSXb4RHw2bLxKA12ojAMzzXfmY=
Date:   Tue, 5 May 2020 08:15:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Tobias Urdin <tobias.urdin@binero.com>
Subject: Re: [PATCH 4.19 STABLE 2/2] KVM: VMX: Mark RCX, RDX and RSI as
 clobbered in vmx_vcpu_run()'s asm blob
Message-ID: <20200505061502.GA3874653@kroah.com>
References: <20200505012348.17099-1-sean.j.christopherson@intel.com>
 <20200505012348.17099-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505012348.17099-3-sean.j.christopherson@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 06:23:48PM -0700, Sean Christopherson wrote:
> Save RCX, RDX and RSI to fake outputs to coerce the compiler into
> treating them as clobbered.  RCX in particular is likely to be reused by
> the compiler to dereference the 'struct vcpu_vmx' pointer, which will
> result in a null pointer dereference now that RCX is zeroed by the asm
> blob.
> 
> Add ASM_CALL_CONSTRAINT to fudge around an issue where <something>
> during modpost can't find vmx_return when specifying output constraints.
> 
> Reported-by: Tobias Urdin <tobias.urdin@binero.com>
> Fixes: b4be98039a92 ("KVM: VMX: Zero out *all* general purpose registers after VM-Exit")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 5b06a98ffd4c..54c8b4dc750d 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -10882,7 +10882,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  		".global vmx_return \n\t"
>  		"vmx_return: " _ASM_PTR " 2b \n\t"
>  		".popsection"
> -	      : : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
> +	      : ASM_CALL_CONSTRAINT, "=c"((int){0}), "=d"((int){0}), "=S"((int){0})
> +	      : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
>  		[launched]"i"(offsetof(struct vcpu_vmx, __launched)),
>  		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
>  		[host_rsp]"i"(offsetof(struct vcpu_vmx, host_rsp)),
> -- 
> 2.26.0
> 

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h

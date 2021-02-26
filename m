Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759B9326700
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 19:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhBZSjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 13:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231163AbhBZSju (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 13:39:50 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5692A601FC;
        Fri, 26 Feb 2021 18:35:44 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lFhxm-00G5ts-9K; Fri, 26 Feb 2021 18:35:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 26 Feb 2021 18:35:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, Andrew Scull <ascull@google.com>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Avoid corrupting vCPU context register in
 guest exit
In-Reply-To: <20210226181211.14542-1-will@kernel.org>
References: <20210226181211.14542-1-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f6b11e03ac9f0a4830e0a8f56a91450f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, ascull@google.com, stable@vger.kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-02-26 18:12, Will Deacon wrote:
> Commit 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
> context") tracks the currently running vCPU, clearing the pointer to
> NULL on exit from a guest.
> 
> Unfortunately, the use of 'set_loaded_vcpu' clobbers x1 to point at the
> kvm_hyp_ctxt instead of the vCPU context, causing the subsequent RAS
> code to go off into the weeds when it saves the DISR assuming that the
> CPU context is embedded in a struct vCPU.
> 
> Leave x1 alone and use x3 as a temporary register instead when clearing
> the vCPU on the guest exit path.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Andrew Scull <ascull@google.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest 
> context")
> Suggested-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> This was pretty awful to debug!
> 
>  arch/arm64/kvm/hyp/entry.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index b0afad7a99c6..0c66a1d408fd 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -146,7 +146,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
>  	// Now restore the hyp regs
>  	restore_callee_saved_regs x2
> 
> -	set_loaded_vcpu xzr, x1, x2
> +	set_loaded_vcpu xzr, x2, x3
> 
>  alternative_if ARM64_HAS_RAS_EXTN
>  	// If we have the RAS extensions we can consume a pending error

Grmbl... How comes we have never seen that for the past 5 months,
including on CPUs that implement RAS?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

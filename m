Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F9CFB89
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 16:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfD3OcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 10:32:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfD3OcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 10:32:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Tvoc5h0CpAuyfVOGgbhwHlFTDNcHuoPsXjjuOiBH41E=; b=jeB3q5JZLBsCiiYOHpLnkGk+t
        UGEBAomZuvSMoZSz0KrNA/QmhwSkPveBbBOxvoFgaF3PFX9UZmhWw+sZgQbIeU01mmHy8xr6FKXRV
        QR/FxXlIyl33oX8e4T9U2I5HwPt2xjhniGgB5ma8tF0D4jV71Wuv4Z+qrhaNcCA0PYVlj4pdgY8SP
        QaQ8o7DmdjfmlpMIcdq6mHxvCOdQv/U4LGYPNcniVlDKmv4KYo+8ENgb6wGa4BbE/qZMETIOxB6pt
        kbS329+Ktr5mMO470D/sgW4osRE0SACl04VrJY/w4cCOYUZ3O/iHul9Afth6KP29VwjhJmKweUH9L
        UAoI+nYDg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLTne-00011G-HY; Tue, 30 Apr 2019 14:32:02 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1353F29D226A9; Tue, 30 Apr 2019 16:32:01 +0200 (CEST)
Date:   Tue, 30 Apr 2019 16:32:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Perr Zhang <strongbox8@zoho.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: revert the order of calls in kvm_fast_pio()
Message-ID: <20190430143201.GH2589@hirez.programming.kicks-ass.net>
References: <20190430142423.3393-1-strongbox8@zoho.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430142423.3393-1-strongbox8@zoho.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 10:24:23PM +0800, Perr Zhang wrote:
> In commit 45def77ebf79, the order of function calls in kvm_fast_pio()
> was changed. This causes that the vm(XP,and also XP's iso img) failed
> to boot. This doesn't happen with win10 or ubuntu.
> 
> After revert the order, the vm(XP) succeedes to boot. In addition, the
> change of calls's order of kvm_fast_pio() in commit 45def77ebf79 has no
> obvious reason.

This Changelog fails to explain why the order is important and equally
fails to inform the future reader of that code. So this very same thing
will happen again in 6 months time or thereabout.

> Fixes: 45def77ebf79 ("KVM: x86: update %rip after emulating IO")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Perr Zhang <strongbox8@zoho.com>
> ---
>  arch/x86/kvm/x86.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a0d1fc80ac5a..248753cb94a1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6610,13 +6610,12 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
>  
>  int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in)
>  {
> -	int ret;
> +	int ret = kvm_skip_emulated_instruction(vcpu);
>  
>  	if (in)
> -		ret = kvm_fast_pio_in(vcpu, size, port);
> +		return kvm_fast_pio_in(vcpu, size, port) && ret;
>  	else
> -		ret = kvm_fast_pio_out(vcpu, size, port);
> -	return ret && kvm_skip_emulated_instruction(vcpu);
> +		return kvm_fast_pio_out(vcpu, size, port) && ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_fast_pio);
>  
> -- 
> 2.21.0
> 
> 
> 

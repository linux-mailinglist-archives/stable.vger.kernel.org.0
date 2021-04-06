Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5B355B44
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 20:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhDFSZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 14:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233156AbhDFSZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 14:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A384613CC;
        Tue,  6 Apr 2021 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617733506;
        bh=nuohfrvFb1BoBCbgj68BKRdB+0LzCjUFWnqmxBLvNrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hpU3QUq1XULdAkveCu+wcYB6elbJoZgG7o6bQVMt77gFJpFszdrSAZz4bkNRLSNQO
         5K/Vq0PE4OL2W/+hu2QCuhvaPn5pkwqLRMBFr/dCx/5kwTUlL8QQpOTSIxPW0D6cPQ
         33XaRlCwD7cvg3fxW7IOl9Nh9lNS7FQGUSn2iizw=
Date:   Tue, 6 Apr 2021 20:25:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to
 kvm_tdp_mmu_zap_sp
Message-ID: <YGynf54vwWpyxhz4@kroah.com>
References: <20210406162550.3732490-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406162550.3732490-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 12:25:50PM -0400, Paolo Bonzini wrote:
> Right now, if a call to kvm_tdp_mmu_zap_sp returns false, the caller
> will skip the TLB flush, which is wrong.  There are two ways to fix
> it:
> 
> - since kvm_tdp_mmu_zap_sp will not yield and therefore will not flush
>   the TLB itself, we could change the call to kvm_tdp_mmu_zap_sp to
>   use "flush |= ..."
> 
> - or we can chain the flush argument through kvm_tdp_mmu_zap_sp down
>   to __kvm_tdp_mmu_zap_gfn_range.
> 
> This patch does the former to simplify application to stable kernels.
> 
> Cc: seanjc@google.com
> Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
> Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
> Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Is this for only the stable kernels, or is it addressed toward upstream
merges?

Confused,

greg k-h

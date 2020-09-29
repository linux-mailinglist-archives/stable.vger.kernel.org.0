Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4D27C28D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 12:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgI2KlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 06:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI2KlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 06:41:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 272D9207C4;
        Tue, 29 Sep 2020 10:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601376061;
        bh=rNaQ0jkzua/ZSVQtukFhyfJAt9vpwW0jRgpuzZwcw2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Khgac1fX2SSrooyUSAtNi55jxpsv2xZ1E841ru+i7dnHZCMGFzO2fD5xuihrd/oel
         nvYBKk6CwZlVCBqb1WraxXRaMNLrtfVJRquyUvcWcKI0/mEV54ONfHPgYWQ0PhtRaw
         uF08ce7B9ofhUxw4yghQU8csD+4wgVI7qm+YwwrM=
Date:   Tue, 29 Sep 2020 12:41:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        kernel-team@android.com
Subject: Re: [PATCH stable-4.19 v2] KVM: arm64: Assume write fault on S1PTW
 permission fault on instruction fetch
Message-ID: <20200929104108.GC1029345@kroah.com>
References: <20200929074323.744700-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929074323.744700-1-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 08:43:23AM +0100, Marc Zyngier wrote:
> Commit c4ad98e4b72cb5be30ea282fce935248f2300e62 upstream.
> 
> KVM currently assumes that an instruction abort can never be a write.
> This is in general true, except when the abort is triggered by
> a S1PTW on instruction fetch that tries to update the S1 page tables
> (to set AF, for example).
> 
> This can happen if the page tables have been paged out and brought
> back in without seeing a direct write to them (they are thus marked
> read only), and the fault handling code will make the PT executable(!)
> instead of writable. The guest gets stuck forever.
> 
> In these conditions, the permission fault must be considered as
> a write so that the Stage-1 update can take place. This is essentially
> the I-side equivalent of the problem fixed by 60e21a0ef54c ("arm64: KVM:
> Take S1 walks into account when determining S2 write faults").
> 
> Update kvm_is_write_fault() to return true on IABT+S1PTW, and introduce
> kvm_vcpu_trap_is_exec_fault() that only return true when no faulting
> on a S1 fault. Additionally, kvm_vcpu_dabt_iss1tw() is renamed to
> kvm_vcpu_abt_iss1tw(), as the above makes it plain that it isn't
> specific to data abort.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20200915104218.1284701-2-maz@kernel.org
> ---
>  arch/arm/include/asm/kvm_emulate.h   | 11 ++++++++---
>  arch/arm64/include/asm/kvm_emulate.h |  9 +++++++--
>  arch/arm64/kvm/hyp/switch.c          |  2 +-
>  virt/kvm/arm/mmio.c                  |  2 +-
>  virt/kvm/arm/mmu.c                   |  5 ++++-
>  5 files changed, 21 insertions(+), 8 deletions(-)

Now queued up, thanks.

greg k-h

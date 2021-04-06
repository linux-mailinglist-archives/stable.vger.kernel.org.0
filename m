Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE017355BF8
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 21:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhDFTHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 15:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235663AbhDFTHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 15:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFC4613D4;
        Tue,  6 Apr 2021 19:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617736013;
        bh=FGcYxgeewTXQrOq2RKbgoIlb1cdSsXxVmlWW2aBxIcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=joQfnePUhrGsWfESJz8MdOZXGG00wppBCk0bD0RAOlEZpHTv8CbfoGS3m0cwJZwLE
         /lfK7mjuOzh2HLRPQ40SJpbCMtAQcGz6Zr1tOpqU6xVAWFzxozvHcCYycEPrTw5WLd
         WzLAqA9/Lscg/X/FvHKvrwoc8jr/TxC/F7bDuenQ=
Date:   Tue, 6 Apr 2021 21:06:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to
 kvm_tdp_mmu_zap_sp
Message-ID: <YGyxSpn3stNXd8TU@kroah.com>
References: <20210406162550.3732490-1-pbonzini@redhat.com>
 <YGynf54vwWpyxhz4@kroah.com>
 <d93cb5c8-e54a-6f5a-c660-9d044ff2c743@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d93cb5c8-e54a-6f5a-c660-9d044ff2c743@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 08:35:55PM +0200, Paolo Bonzini wrote:
> On 06/04/21 20:25, Greg KH wrote:
> > On Tue, Apr 06, 2021 at 12:25:50PM -0400, Paolo Bonzini wrote:
> > > Right now, if a call to kvm_tdp_mmu_zap_sp returns false, the caller
> > > will skip the TLB flush, which is wrong.  There are two ways to fix
> > > it:
> > > 
> > > - since kvm_tdp_mmu_zap_sp will not yield and therefore will not flush
> > >    the TLB itself, we could change the call to kvm_tdp_mmu_zap_sp to
> > >    use "flush |= ..."
> > > 
> > > - or we can chain the flush argument through kvm_tdp_mmu_zap_sp down
> > >    to __kvm_tdp_mmu_zap_gfn_range.
> > > 
> > > This patch does the former to simplify application to stable kernels.
> > > 
> > > Cc: seanjc@google.com
> > > Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
> > > Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
> > > Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Is this for only the stable kernels, or is it addressed toward upstream
> > merges?
> > 
> > Confused,
> 
> It's for upstream.  I'll include it (with the expected "[ Upstream commit
> abcd ]" header) when I post the complete backport.  I'll send this patch to
> Linus as soon as I get a review even if I don't have anything else in the
> queue, so (as a general idea) the full backport should be sent and tested on
> Thursday-Friday.

Ah, ok, thanks, got confused there.

greg k-h

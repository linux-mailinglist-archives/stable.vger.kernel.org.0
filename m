Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7439D355BE6
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 20:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhDFS76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 14:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbhDFS76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 14:59:58 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63A1C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 11:59:48 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c17so11093098pfn.6
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 11:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/K/k7TMA0dim45MUt35sdwItRBULQE49yHai9MnD1o=;
        b=KzmcnGjurr5EEPEluehzMcYb2wZZDh8gpR5aFdc2gPNCZhYvrxHbISKeCPlLNRFxS9
         CMB/peeYBZORNXtSyfCZtbWA0FOztd+t2tmSePqLeQ1zcjwtZl/2pDj9LPA+GJGMZw4G
         h4XS89UU36vddvcTKG7ff18HjenYr0SbCgh5T6lj79/rzadvUosYaZDtUb8t4InD7X98
         Wsf4r+xpGTeipqLaCXZ408dzon6D9fD86lcKNReq3vzdRDFtDh7ft10q12HOmOvHFtDe
         EjetBvNwCY2IPS0TLRcdf0TGnXoYBH6K49vGgfGJ8QIxuDO6NSheZrGTkH66TQUSg+oN
         Enig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o/K/k7TMA0dim45MUt35sdwItRBULQE49yHai9MnD1o=;
        b=EzDQs5a4y15DbcA/YBoCHrfVg9tTuh0Tfk2ttJ1bCrMUatrd8Nw8GVMg9MfzRBtOTg
         7Qlaz5OVuShQRz66RoMecuxcB2PW2CPgzE0IwXfWPLwhHZ8TCTjx3qCh6puaGICuQgHA
         uMEbxtD9lBz7qrBbMCHdrCETj6uAUlPaVGxuLiiDpA8YtgyvIlPOLpaNGDeAYdYMt5t6
         Mnpjn7VQ5vQ26t8Dwn3Ch0tISyRgbFMGqNQHTq+rhED4eLe3j0Z3dRsld9FvhGpvp+Tk
         CCVHWuuPu1tNVLt4OxGuNA3sKtubvUqyAE3i0IhqJd/x51pRuynPqX+33AoroFdC23AL
         POoA==
X-Gm-Message-State: AOAM533W1cNfAoBliJgbv6KwvdQPEH3CzCJE6Ouge2MITOtnrrK8rXxe
        nZLtqkaxsmnIWuqwIXeWd6ZljA==
X-Google-Smtp-Source: ABdhPJyIk5vGhXdq5zQumhsts0/ms82m7PMKls76aAMgOHLCSFmyTEgoaXIvPjhMxKbNVnZrFVtveA==
X-Received: by 2002:a62:1c93:0:b029:1fd:2216:fb45 with SMTP id c141-20020a621c930000b02901fd2216fb45mr28502785pfc.13.1617735588287;
        Tue, 06 Apr 2021 11:59:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id hi21sm3087454pjb.36.2021.04.06.11.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 11:59:47 -0700 (PDT)
Date:   Tue, 6 Apr 2021 18:59:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to
 kvm_tdp_mmu_zap_sp
Message-ID: <YGyvoF3WO4yjIuug@google.com>
References: <20210406162550.3732490-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406162550.3732490-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021, Paolo Bonzini wrote:
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

Eh, that and passing flush down the stack is pointless because kvm_tdp_mmu_zap_sp()
will never yield.  If you want to justify |= over passing flush, it probably
makes sense to link to the discussion that led to me changing from passing flush
to accumulating the result (well, tried to, doh).

https://lkml.kernel.org/r/20210319232006.3468382-3-seanjc@google.com

> Cc: seanjc@google.com
> Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
> Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
> Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 486aa94ecf1d..951dae4e7175 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5906,7 +5906,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>  				      lpage_disallowed_link);
>  		WARN_ON_ONCE(!sp->lpage_disallowed);
>  		if (is_tdp_mmu_page(sp)) {
> -			flush = kvm_tdp_mmu_zap_sp(kvm, sp);
> +			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
>  		} else {
>  			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>  			WARN_ON_ONCE(sp->lpage_disallowed);
> -- 
> 2.26.2
> 

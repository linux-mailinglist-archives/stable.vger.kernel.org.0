Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5525C48F30B
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 00:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiANXiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 18:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiANXiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 18:38:06 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AF6C06161C
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 15:38:06 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id c5so3974592pgk.12
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 15:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5h5KW4o46F/BOoZ9jZiHOhEB91/Ng8hkHr0tKrKtw94=;
        b=HrZNVbWCSC62vfwQ+kNKzyKNkkiKBkVik1c/H/BDuST+PVoX7iIosSZoxuodafUSTk
         picPXmAlK0TpMvkRD7Zezg1T5w3BpnNROgqKP4zoCgD/8FLy0HJV/AcwCr0O7HrCDm2m
         BLrv1hQJ4h1dwm0cb+6thk7ImhtToBe/e6CpNzAUuKUaNplxyC+4bIamatziLpzHTV0n
         EasJfyUdfW0TMLk58kbafZB+GjHD//+d/8UHD4aof/Km6VZ5BgkMoQikm6yx8z97OI1d
         6n6vCGVpTAUfH1HjV2IzPfaLcqwGxNawVptI19m/lteXB2jfZ8wmGr+lO1AbudB3unKd
         9U+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5h5KW4o46F/BOoZ9jZiHOhEB91/Ng8hkHr0tKrKtw94=;
        b=lYKEaUzvKxq3O2juii6qabqNwj3r2STqmpe6xUjFuwqWdAKMpjmxJge7x3Yzs3HlEP
         qK8wiooJNwMjO4WHSkAZoThb68XWY3SKGqykw303pBqUwuZadNEYdzdoSyE7mrhN75DD
         COMsM2AXSzy/V0IcX+eaYKTbtcMCBjIRxNLb7/bv1yBpjMim6gm4WD7ojzLHlDC37/n1
         jk/SafxVsz7OS7G3NlMVc/TfWoaUmzZaiPaWPwQ+C7z5bXR4HsMJj7SP1pZUQg17T+Hj
         CZCxtYAqKE1C7EybyXCSa3MgYo7WNthLwqQQslOEl719roZ1Z5bPE2BVU4Y3riOPoYui
         7MuQ==
X-Gm-Message-State: AOAM531Fw7wwlRIb4jhsgEC8fGXY3osY1lgWuhPUVUdM/mkUZiy9Ast+
        mZVpmoDWEjx0IaFr38iRry1zNw==
X-Google-Smtp-Source: ABdhPJw2oo9z1vd4bGieGnAe3sYWNQyiVMVnSCncdpKDWqd/7Xz7QVkGQ8yxbFYi82YLI4Muzea0Tg==
X-Received: by 2002:a63:3d8a:: with SMTP id k132mr9929412pga.577.1642203485565;
        Fri, 14 Jan 2022 15:38:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f13sm6790272pfv.98.2022.01.14.15.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:38:04 -0800 (PST)
Date:   Fri, 14 Jan 2022 23:38:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Fix write-protection of PTs mapped
 by the TDP MMU
Message-ID: <YeIJWZ62q3rybAP2@google.com>
References: <20220113233020.3986005-1-dmatlack@google.com>
 <20220113233020.3986005-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113233020.3986005-2-dmatlack@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022, David Matlack wrote:
> When the TDP MMU is write-protection GFNs for page table protection (as
                      ^^^^^^^^^^^^^^^^
                      write-protecting

> opposed to for dirty logging, or due to the HVA not being writable), it
> checks if the SPTE is already write-protected and if so skips modifying
> the SPTE and the TLB flush.
> 
> This behavior is incorrect because the SPTE may be write-protected for
> dirty logging. This implies that the SPTE could be locklessly be made

Spurious "be" between could and locklessly.

Hmm, it doesn't imply anything, the behavior of MMU-writable is quite explicit.
If the bug occurs, then _that_ implies the SPTE was write-protected for dirty
logging, otherwise MMU-Writable would have been '0' due to HOST-Writable also
being '0'.

I think what you're trying to say is:

  This behavior is incorrect because it fails to check if the SPTE is
  write-protected for page table protection, i.e. fails to check that
  MMU-writable is '0'.  If the SPTE was write-protected for dirty logging
  but not page table protection, the SPTE could locklessly be made
  writable, and vCPUs could still be running with writable mappings
  cached in their TLB.

> writable on the next write access, and that vCPUs could still be running
> with writable SPTEs cached in their TLB.

Nit, it's technically the mapping, not the SPTE itself, that's cached in the TLB.

> Fix this by only skipping setting the SPTE if the SPTE is already
> write-protected *and* MMU-writable is already clear.

Might also be worth adding:

  Note, technically checking only MMU-writable would suffice, as a SPTE
  cannot be writable without MMU-writable being set, but check both to
  be paranoid and because it arguably yields more readable code.

Pedantry aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Fixes: 46044f72c382 ("kvm: x86/mmu: Support write protection for nesting in tdp MMU")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7b1bc816b7c3..bc9e3553fba2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1442,12 +1442,12 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>  
> -		if (!is_writable_pte(iter.old_spte))
> -			break;
> -
>  		new_spte = iter.old_spte &
>  			~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
>  
> +		if (new_spte == iter.old_spte)
> +			break;
> +
>  		tdp_mmu_set_spte(kvm, &iter, new_spte);
>  		spte_set = true;
>  	}
> 
> base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
> -- 
> 2.34.1.703.g22d0c6ccf7-goog
> 

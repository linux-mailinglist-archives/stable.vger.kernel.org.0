Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26C6383AE7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbhEQROa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbhEQRO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 13:14:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66836C061756
        for <stable@vger.kernel.org>; Mon, 17 May 2021 10:13:09 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v13so3519456ple.9
        for <stable@vger.kernel.org>; Mon, 17 May 2021 10:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M/sJfrKD4zzN+FpkbNq+tDQbmfklImAcKPr5tpIb1Lo=;
        b=F0PHWYxG0UoVB4Khdzlw7AbIjMWQsItxAo5icaEqJoi/jwej23LV6YoI/27tQ35Wg/
         9nndmKoip1Q2jnxPqgQ0C1Jc09tT2R3t8wOnAmLo5jy1m/5Iw8dstrQlTaH8BNmNdQhb
         aJiIPGAbsvCTxfRXHC70Occ2+KvrkTy3IQAxlUHycxRw9JrOni731jtUCWLWChiLgGaK
         Lgcd6fRG/dib+6XzBe/3yIgMzDlteqhiEfTFITrFHuMfOohejmvaoAQL6IF63YAJ69/l
         Z4LIRyfRvM3R25I3OTPS4T3IsGwDh2gZyYg/oa5lD5BzmmK/qtvmOmsjIOPMA3q7pPy7
         UXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M/sJfrKD4zzN+FpkbNq+tDQbmfklImAcKPr5tpIb1Lo=;
        b=oqQVBsbMBWdtIyhMDtcQx2Hm1o2EdY6VXzbsC1xrc5NBBRAZlmGA/epOlmYr0AjNcX
         70cSGPgJt+39eez9tQV27NYRTBRuIFOEY+UiIdqBUbGgQOis4bVAUv8fXOFWVfZvWmf5
         DC3nv6VHuz4ikkosOZZMR5FEYRclB4eoJ+esSDKx9YG9X3p5lh2BA3gzKXwf7Yu2yDBS
         ByNc9cLUOsL9KY/tbvSatXUIHBnDTjabz+5HkDwEhgDFQEl6Sy9mMfDNysKMOBZz8lAy
         GK9JlG4prpD4Ig7nhkTFCJMMfAPONo17aIstAt2QlcLvqo885WokwZuG54Oay1gmIAHN
         AUfQ==
X-Gm-Message-State: AOAM532S8s1XB6uwXAK2N4KMZG95xanNtHWXqwZvmkDxDC4Pp+cwx59w
        5gZVSLuqb8nqoHSkmd3w5RJQeuJY5igeXQ==
X-Google-Smtp-Source: ABdhPJxw0WBthR13O83ZAxmMOwdS6ib47q2eTqCRf6OR9Im1lBIfKBz7jgMP5GVe9SENWLxl1QFtIw==
X-Received: by 2002:a17:90a:3c8d:: with SMTP id g13mr486242pjc.13.1621271588737;
        Mon, 17 May 2021 10:13:08 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m6sm7341993pfc.133.2021.05.17.10.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 10:13:08 -0700 (PDT)
Date:   Mon, 17 May 2021 17:13:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jack Wang <jinpu.wang@ionos.com>, sashal@kernel.org,
        stable@vger.kernel.org, Yu Zhang <yu.c.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove the defunct update_pte() paging hook
Message-ID: <YKKkIJFb4SnpOA/9@google.com>
References: <20210514113853.37957-1-jinpu.wang@ionos.com>
 <YJ6HZfCvpt3ucpOO@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ6HZfCvpt3ucpOO@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021, Greg KH wrote:
> On Fri, May 14, 2021 at 01:38:53PM +0200, Jack Wang wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > commit c5e2184d1544f9e56140791eff1a351bea2e63b9 upstream
> > 
> > Remove the update_pte() shadow paging logic, which was obsoleted by
> > commit 4731d4c7a077 ("KVM: MMU: out of sync shadow core"), but never
> > removed.  As pointed out by Yu, KVM never write protects leaf page
> > tables for the purposes of shadow paging, and instead marks their
> > associated shadow page as unsync so that the guest can write PTEs at
> > will.
> > 
> > The update_pte() path, which predates the unsync logic, optimizes COW
> > scenarios by refreshing leaf SPTEs when they are written, as opposed to
> > zapping the SPTE, restarting the guest, and installing the new SPTE on
> > the subsequent fault.  Since KVM no longer write-protects leaf page
> > tables, update_pte() is unreachable and can be dropped.
> > 
> > Reported-by: Yu Zhang <yu.c.zhang@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Message-Id: <20210115004051.4099250-1-seanjc@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > (jwang: backport to 5.4 to fix a warning on AMD nested Virtualization)
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> > We hit a warning in  WARNING: CPU: 62 PID: 29302 at arch/x86/kvm/mmu.c:2250 nonpaging_update_pte+0x5/0x10 [kvm]
> > on AMD Opteron(tm) Processor 6386 SE with kernel 5.4.113, it seems nested L2 is running, I notice a similar bug
> > report on https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1884058.
> > 
> > I did test with kvm-unit-tests on both Intel Broadwell/Skylake, AMD Opteron, no
> > regression, basic VM tests work fine too on 5.4 kernel.
> > the commit c5e2184d1544f9e56140791eff1a351bea2e63b9 can be cherry-picked cleanly
> > to kernel 5.10+.

Ah, drat.  The WARN fires because update_pte() comes from the current MMU context,
and older kernels are missing a check to ensure the current MMU context is
"compatible" with the target shadow page's context.

That bug was inadvertantly fixed by commit a102a674e423 ("KVM: x86/mmu: Don't drop
level/direct from MMU role calculation"), but I didn't tag that for stable because
I incorrectly thought that adding a check on the "direct" role was a nop.  From
that changelog:

    While doing so, stop ignoring "direct".  The field is effectively ignored
    anyways because kvm_mmu_pte_write() is only reached with an indirect mmu
    and the loop only walks indirect shadow pages, but double checking "direct"
    literally costs nothing.

Specifically, the "kvm_mmu_pte_write() is only reached with an indirect mmu" part
fails to account for the case where where the VM has one or more indirect MMUs
_and_ a direct MMU (the current MMU context).

All that said, ripping out this code works too, and is preferable since the code
is dead for its intended purpose, i.e. reaching the update_pte() code can only
be a random, unwanted collision.

> Now queued up, thanks.

Belated thumbs up, thanks!

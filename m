Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B17383B13
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbhEQRTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243008AbhEQRTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 13:19:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB86C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 10:17:54 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f1so7830280edt.4
        for <stable@vger.kernel.org>; Mon, 17 May 2021 10:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bux5YyR3T+P2ms2mMgQbzCAg4CsD6QkJJUzqFO56Ls8=;
        b=W/KIidyDaCPNEOEaIrD0hvIbmNNObKD+HCjzSKcrILjzWmQpCmeNdmrTe/Q3L2Jr/3
         PEk7E6wpNmNjDQeGQy/iNFCz7Zwzgjx6qyme3SBiV0Iwpy5Gc3xUSV8BiiwDCXHtLfFe
         XGWfSj9YTFnoCwzZtROUdzYpobmSWgPbCtF1/sSyOmx7A0C/AVlCOC1/IJyBjtzbaAj7
         sb/JZ9ZFGkJ0qeXjlw4VLRp1a3xdRrkXE+59+AvdfnirbDrpaVgHFV5qj+Yz1sBh4B51
         DLecg4N+LW8pqT7E2yJ7FxyZounkwS9zTBX8ZV9XLDuxroFazLMDGsfR6ET75jfX3Wwi
         h78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bux5YyR3T+P2ms2mMgQbzCAg4CsD6QkJJUzqFO56Ls8=;
        b=flZLi3SAiaZcYw3vkzsiQeqbA4kayholtXEx6AWKhGeiqCh2iPYOnRtrStCBeHccai
         R1RSWmfbOqaDJpmthcJKXRxt+pAS/Ke8mwkcW7LZ5hBL+D62iFYd/sanZSeXmfczHTFt
         hGCUrRvQ9ni62Nn3KoDFWUVK+D708yy3ozmqTahcPC62jdUkEaWg14+cGIcAHxMXqfQ0
         2FbnppLw1fg3r8EIc6atKt+u89mcvNqov41myTec9oUlVSMCmkvdBcQbU1xacFo8Pjhq
         z45nngOrszqM9t8rnIVsR2mgpXetLpLYjlM5mB2k8qvE6tAmLQ4kFcyyGPIem/x/0R71
         sG3A==
X-Gm-Message-State: AOAM532A2EjGwOimavIShkMmWkSTI9V4p+MW6DkQgqapIC4n9dIcBRnI
        bHuW558jfAUL2imMb/1YiO7WL4qNDAU5nS4OLhnQtw==
X-Google-Smtp-Source: ABdhPJwC762wGVwTM6BotQZSTWh8Li3PHAnv+IdndmypErdME6KDWeuy2q4LWUNd84mW1fVJlBNDMuoQfzuLnsRGhZQ=
X-Received: by 2002:a50:eb08:: with SMTP id y8mr1322762edp.89.1621271872962;
 Mon, 17 May 2021 10:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210514113853.37957-1-jinpu.wang@ionos.com> <YJ6HZfCvpt3ucpOO@kroah.com>
 <YKKkIJFb4SnpOA/9@google.com>
In-Reply-To: <YKKkIJFb4SnpOA/9@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 17 May 2021 19:17:42 +0200
Message-ID: <CAMGffEmrA38fKpNYHf9xBqzzEEYv1MuVrq38dHuBTVbFKtDbfg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove the defunct update_pte() paging hook
To:     Sean Christopherson <seanjc@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Yu Zhang <yu.c.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 7:13 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 14, 2021, Greg KH wrote:
> > On Fri, May 14, 2021 at 01:38:53PM +0200, Jack Wang wrote:
> > > From: Sean Christopherson <seanjc@google.com>
> > >
> > > commit c5e2184d1544f9e56140791eff1a351bea2e63b9 upstream
> > >
> > > Remove the update_pte() shadow paging logic, which was obsoleted by
> > > commit 4731d4c7a077 ("KVM: MMU: out of sync shadow core"), but never
> > > removed.  As pointed out by Yu, KVM never write protects leaf page
> > > tables for the purposes of shadow paging, and instead marks their
> > > associated shadow page as unsync so that the guest can write PTEs at
> > > will.
> > >
> > > The update_pte() path, which predates the unsync logic, optimizes COW
> > > scenarios by refreshing leaf SPTEs when they are written, as opposed to
> > > zapping the SPTE, restarting the guest, and installing the new SPTE on
> > > the subsequent fault.  Since KVM no longer write-protects leaf page
> > > tables, update_pte() is unreachable and can be dropped.
> > >
> > > Reported-by: Yu Zhang <yu.c.zhang@intel.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > Message-Id: <20210115004051.4099250-1-seanjc@google.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > (jwang: backport to 5.4 to fix a warning on AMD nested Virtualization)
> > > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > > ---
> > > We hit a warning in  WARNING: CPU: 62 PID: 29302 at arch/x86/kvm/mmu.c:2250 nonpaging_update_pte+0x5/0x10 [kvm]
> > > on AMD Opteron(tm) Processor 6386 SE with kernel 5.4.113, it seems nested L2 is running, I notice a similar bug
> > > report on https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1884058.
> > >
> > > I did test with kvm-unit-tests on both Intel Broadwell/Skylake, AMD Opteron, no
> > > regression, basic VM tests work fine too on 5.4 kernel.
> > > the commit c5e2184d1544f9e56140791eff1a351bea2e63b9 can be cherry-picked cleanly
> > > to kernel 5.10+.
>
> Ah, drat.  The WARN fires because update_pte() comes from the current MMU context,
> and older kernels are missing a check to ensure the current MMU context is
> "compatible" with the target shadow page's context.
>
> That bug was inadvertantly fixed by commit a102a674e423 ("KVM: x86/mmu: Don't drop
> level/direct from MMU role calculation"), but I didn't tag that for stable because
> I incorrectly thought that adding a check on the "direct" role was a nop.  From
> that changelog:
>
>     While doing so, stop ignoring "direct".  The field is effectively ignored
>     anyways because kvm_mmu_pte_write() is only reached with an indirect mmu
>     and the loop only walks indirect shadow pages, but double checking "direct"
>     literally costs nothing.
>
> Specifically, the "kvm_mmu_pte_write() is only reached with an indirect mmu" part
> fails to account for the case where where the VM has one or more indirect MMUs
> _and_ a direct MMU (the current MMU context).
>
> All that said, ripping out this code works too, and is preferable since the code
> is dead for its intended purpose, i.e. reaching the update_pte() code can only
> be a random, unwanted collision.
>
> > Now queued up, thanks.
>
> Belated thumbs up, thanks!
Hi Sean!

Thanks for checking and detailed implaination.

Regards!
Jack Wang

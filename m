Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2F146FFE
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 18:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAWRrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 12:47:42 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:39919 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWRrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 12:47:42 -0500
Received: by mail-vk1-f194.google.com with SMTP id t129so1225380vkg.6
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 09:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Et+LlALPC760oEaRKFNCAz514PMTpmENsjL59cORzxs=;
        b=Yg8WNVHpsQMcCvRhz3/dXR6PXPJY0KcG3v22GFQFEr+PJVg9hMZ4bvlywMwtQmtaz4
         w/QMYp4bBgOnV5ltO0fM+DrFOT2DJPBtRJAUAqrGTjfg7anSY/tSyrywIw1KiUMECYUO
         7xo8lXzri4JuvaqX0SBzfYPJT+Ph/TVID2bECWCi9gU0kk+IhztVbcDtGvOgao+Xj5/O
         ojQDYehkgGIyQ4N3tf7j30XXUXcYWcykarDx87/pbrbCsh/JcK8DGega++OS9XUJ3Erf
         1OOdjciGIxbE0skEDX8OoyVV4p0jA9fJJqZ7aRwio/C5DFBvH/iT0GhA/LVQLdtxt1a6
         QFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Et+LlALPC760oEaRKFNCAz514PMTpmENsjL59cORzxs=;
        b=KPRnEXQF3/R/Q2K9zxr+0ZbTeH0U0MaErhde13tL6kRy+Q1DjwMeTD5T1rDst1wGZM
         Gm+MAVZozz+muRaQ4byNzlio2Klk4Mex8wdFNhniTDUh6WIFfugU+RM83gV//k/q1bR2
         mvPn/a4yc9H4ILSEnOBPSnsU0tZUbJ16WKOHIzBtc5ahWxF/gSUzrE2769K7ERnAWGCf
         aTm0cOwXPJQf//oTh7wJNuvpFPbmMsyF59Ihjxb5Ixa6xq6sASHTjwbJyJFsJuW6Ju9O
         2GX8Pr4LOnzTAeUrJce7+IVL/eiemYSOlUjhTD0jMiEVLse99E2EmXDRo/8WVWhxViej
         paNQ==
X-Gm-Message-State: APjAAAUrAUO+9ne9T2HcQr76Cy7xiIRIQK8nHAT91hhp5whsOFAXbkI6
        VeUyKIP8QXKWsYDzpxiYVU6aHIXoHAW++zJ+SgsOUQ==
X-Google-Smtp-Source: APXvYqwfTatdEjDSunaT13x4k7lhQ2MYD/2QP+0OJQj1cHdRpQBCSZo2x/ojkpyKiwJE/khU0AODgZc9burCbevj9Og=
X-Received: by 2002:a1f:db81:: with SMTP id s123mr10783192vkg.45.1579801660728;
 Thu, 23 Jan 2020 09:47:40 -0800 (PST)
MIME-Version: 1.0
References: <1579769442-13698-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1579769442-13698-1-git-send-email-pbonzini@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 23 Jan 2020 09:47:28 -0800
Message-ID: <CANgfPd-jqh+BFhFdiNNfx+dS69v02kGucWX=6yMOgUMquHddXA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 12:50 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The SPTE_MMIO_MASK overlaps with the bits used to track MMIO
> generation number.  A high enough generation number would overwrite the
> SPTE_SPECIAL_MASK region and cause the MMIO SPTE to be misinterpreted.
>
> Likewise, setting bits 52 and 53 would also cause an incorrect generation
> number to be read from the PTE, though this was partially mitigated by the
> (useless if it weren't for the bug) removal of SPTE_SPECIAL_MASK from
> the spte in get_mmio_spte_generation.  Drop that removal, and replace
> it with a compile-time assertion.
>
> Fixes: 6eeb4ef049e7 ("KVM: x86: assign two bits to track SPTE kinds")
> Reported-by: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 57e4dbddba72..b9052c7ba43d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -418,22 +418,24 @@ static inline bool is_access_track_spte(u64 spte)
>   * requires a full MMU zap).  The flag is instead explicitly queried when
>   * checking for MMIO spte cache hits.
>   */
> -#define MMIO_SPTE_GEN_MASK             GENMASK_ULL(18, 0)
> +#define MMIO_SPTE_GEN_MASK             GENMASK_ULL(17, 0)
>
>  #define MMIO_SPTE_GEN_LOW_START                3
>  #define MMIO_SPTE_GEN_LOW_END          11
>  #define MMIO_SPTE_GEN_LOW_MASK         GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
>                                                     MMIO_SPTE_GEN_LOW_START)
>
> -#define MMIO_SPTE_GEN_HIGH_START       52
> -#define MMIO_SPTE_GEN_HIGH_END         61
> +#define MMIO_SPTE_GEN_HIGH_START       PT64_SECOND_AVAIL_BITS_SHIFT
> +#define MMIO_SPTE_GEN_HIGH_END         62
>  #define MMIO_SPTE_GEN_HIGH_MASK                GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
>                                                     MMIO_SPTE_GEN_HIGH_START)
> +
>  static u64 generation_mmio_spte_mask(u64 gen)
>  {
>         u64 mask;
>
>         WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
> +       BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
>
>         mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
>         mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
> @@ -444,8 +446,6 @@ static u64 get_mmio_spte_generation(u64 spte)
>  {
>         u64 gen;
>
> -       spte &= ~shadow_mmio_mask;
> -
>         gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
>         gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
>         return gen;
> --
> 1.8.3.1
>

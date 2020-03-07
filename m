Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C05417CEE4
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 16:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgCGPDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 10:03:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGPDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 10:03:38 -0500
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D2222075B
        for <stable@vger.kernel.org>; Sat,  7 Mar 2020 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583593417;
        bh=gb+O6z+9Bp+875fdIg1OajoBwMGiyVEXOzXUFw4o4j4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U7olKMgOCMIcDQr5xxy2ln7zt7vri1p5Wm43iRVBTnuDReATLV/mEwYGQyMlRhdtB
         iW+fy0kGwfBantX7l57vHro/6qk+bBhNbhU+qK23EC31X2iYDlWI/HKpkvDMIBUyVc
         HcJL52xfTHOWFk1keNbp4cG8BOdbsGYKB+Fm7n+0=
Received: by mail-wr1-f44.google.com with SMTP id a25so1959089wrd.0
        for <stable@vger.kernel.org>; Sat, 07 Mar 2020 07:03:37 -0800 (PST)
X-Gm-Message-State: ANhLgQ0/ffiyhJs8j4IdeWJvrJUwEkzj1T3hQy8D53Wx9v8idObsgz3e
        UEI8PBwVrjYM4k8Kyuu8yYMY8NVSCtuTkwXlckjdHQ==
X-Google-Smtp-Source: ADFU+vveIuzEq5Kwfs56DpUeADDUUUk9qCufveZZV2SZfwZgsMCl8i/GUS2tNZ3Z1YpOEYC9VC9XuCHOmMuyOdBsoAE=
X-Received: by 2002:adf:b641:: with SMTP id i1mr10119012wre.18.1583593415752;
 Sat, 07 Mar 2020 07:03:35 -0800 (PST)
MIME-Version: 1.0
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org>
In-Reply-To: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 7 Mar 2020 07:03:24 -0800
X-Gmail-Original-Message-ID: <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
Message-ID: <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 6, 2020 at 6:26 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> The ABI is broken and we cannot support it properly.  Turn it off.
>
> If this causes a meaningful performance regression for someone, KVM
> can introduce an improved ABI that is supportable.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/kernel/kvm.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 93ab0cbd304e..e6f2aefa298b 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -318,11 +318,26 @@ static void kvm_guest_cpu_init(void)
>
>                 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
>
> -#ifdef CONFIG_PREEMPTION
> -               pa |= KVM_ASYNC_PF_SEND_ALWAYS;
> -#endif
>                 pa |= KVM_ASYNC_PF_ENABLED;
>
> +               /*
> +                * We do not set KVM_ASYNC_PF_SEND_ALWAYS.  With the current
> +                * KVM paravirt ABI, the following scenario is possible:
> +                *
> +                * #PF: async page fault (KVM_PV_REASON_PAGE_NOT_PRESENT)
> +                *  NMI before CR2 or KVM_PF_REASON_PAGE_NOT_PRESENT
> +                *   NMI accesses user memory, e.g. due to perf
> +                *    #PF: normal page fault
> +                *     #PF reads CR2 and apf_reason -- apf_reason should be 0
> +                *
> +                *  outer #PF reads CR2 and apf_reason -- apf_reason should be
> +                *  KVM_PV_REASON_PAGE_NOT_PRESENT
> +                *
> +                * There is no possible way that both reads of CR2 and
> +                * apf_reason get the correct values.  Fixing this would
> +                * require paravirt ABI changes.
> +                */
> +

Upon re-reading my own comment, I think the problem is real, but I
don't think my patch fixes it.  The outer #PF could just as easily
have come from user mode.  We may actually need the NMI code (and
perhaps MCE and maybe #DB too) to save, clear, and restore apf_reason.
If we do this, then maybe CPL0 async PFs are actually okay, but the
semantics are so poorly defined that I'm not very confident about
that.

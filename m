Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B770213191C
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgAFUQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:16:56 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45625 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgAFUQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:16:53 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so49902760ioi.12
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ad1Ao2TlSfLCNigJ6Pa+3nawhinGXzkpiWfEgqcNlkE=;
        b=Tx133DbulEz48pvKM16QrOTa6SZ28yS4BBeei2HnoOx+0KVySJgiNWMTLHVNcbxMqs
         +uzP9l3dy899SpHobHnByiwalfHz4eThgOlxnvMCV1GO5KJViLO/Yx47cRhfzuYfWq7W
         nSvVHrkyVWVmKOf8scyQmojf2UkxHBnkOsKsPrGkoju1JDAMgXefnp9f0eJ0HmKH7G70
         c4NSG2PXorEyu0HFzENfdo7Mf2U5DXvN46b2g7TDNb8XfcAltl9bmlnHIUTRZblFQvTb
         p2js4weuJx6rCjiwnnfjOZuFlwFBFkTcHFspYJQ+WczeLq4SrTWmOgqbzFQxxn8/95UJ
         06VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ad1Ao2TlSfLCNigJ6Pa+3nawhinGXzkpiWfEgqcNlkE=;
        b=qCxASetdFubCA0VUxoaNt4Ege4wYmMi0lrs/CsvJ+siQ/4I+ZT84tGyAOiq+r0GD1d
         hPCVrWrB7dILzblRXfQA7m9JtNNLaRwSaZK/vq8J5PdGfPIcmWjIBjlFsOrh4IJ/yIbC
         yJvJS/yUY+2kSWZwa7AqyFmZQC4rn6wFdKvT6ZshgoUpLtx+D7KnoYEmlgLhZkIQ3Xug
         SZcb9DMiNLBNEnbBrZHWqu+Sb42GnsznwikuXzQjBOh7JoARGh7uDbCMqzoL5oTSPYvl
         AwBEe5t5ymlSt4Su7DxT0SAVPySdkr9GFFQL2VwfitZsFVo+3AT7pKLkWnTn8XnWED2t
         tJGA==
X-Gm-Message-State: APjAAAXGzxNbki7N69NSvuL9MK/6SJvvxtnj5oEV4OL2bD0Gr4BtbIl+
        rJBPZWz0yRaYAnLo8h6/Ug+CKwqwMmTeKNOsOlYmug==
X-Google-Smtp-Source: APXvYqwwxRjaUDXqnO8pwICqhkfTcFjemZ9i/gfqccux/oxs4oMkZdlQpoikYKZZolo7WWtBG/O8CGjdGya5UKFV970=
X-Received: by 2002:a5d:9953:: with SMTP id v19mr70376880ios.118.1578341812201;
 Mon, 06 Jan 2020 12:16:52 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-3-pomonis@google.com>
 <314f6d96-b75f-e159-d94d-1d30a5140e40@de.ibm.com> <CALMp9eTOD6r13sPZ3skz_YkSFn2ZKbsr5zbLP9LgzjpHnsebkQ@mail.gmail.com>
 <73a7a1ce-7e68-7b15-70eb-7b6217af5e1a@de.ibm.com>
In-Reply-To: <73a7a1ce-7e68-7b15-70eb-7b6217af5e1a@de.ibm.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:16:41 -0800
Message-ID: <CALMp9eQ5S1oD6YtEp-peX+iLRbX5bhRVTrD4DamAsDJtwe7yOA@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data()
 from Spectre-v1/L1TF attacks
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Marios Pomonis <pomonis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 9:47 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 12.12.19 18:44, Jim Mattson wrote:
> > On Thu, Dec 12, 2019 at 9:31 AM Christian Borntraeger
> > <borntraeger@de.ibm.com> wrote:
> >>
> >>
> >>
> >> On 11.12.19 21:47, Marios Pomonis wrote:
> >>> This fixes Spectre-v1/L1TF vulnerabilities in kvm_hv_msr_get_crash_data()
> >>> and kvm_hv_msr_set_crash_data().
> >>> These functions contain index computations that use the
> >>> (attacker-controlled) MSR number.
> >>>
> >>> Fixes: commit e7d9513b60e8 ("kvm/x86: added hyper-v crash msrs into kvm hyperv context")
> >>>
> >>> Signed-off-by: Nick Finco <nifi@google.com>
> >>> Signed-off-by: Marios Pomonis <pomonis@google.com>
> >>> Reviewed-by: Andrew Honig <ahonig@google.com>
> >>> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

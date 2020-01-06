Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A99131937
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgAFUTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:19:24 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44860 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgAFUTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:19:24 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so49952010iof.11
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZB6+nZpdQdrQFOUezOO+7mxpT7FzTcRrUIFGcgCSmbk=;
        b=i1+dxrn9BwWzBAeJV6afkXOmypBNmAdOB+MN0+uPEwO4tqMBko7kiVkXUabAiq/ryY
         scWsv83FexYHtha29B/rSOy2G6vr01E7gtVoQV9iKwaqofCJYPXWTm0elmL6mtpLgTho
         lRpgbEn8HhvfNgnScOhVlIVNFFnXdJsfyixF2JNW4I9eRGti+9UHcwY0+2nLtiZFBhZq
         NCRVgS4qd+LFAYtEBLVQRHVqJFQP6kgf5nU4jQ5icMM0keUykv268+d69Qtb+UgpH4ur
         fY/YrpuXoruqx1aEjWp30pWNrcxTpzDDu6MMwnEm860W41k4TzD4Wc+e46dLoHWdcj9x
         vn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZB6+nZpdQdrQFOUezOO+7mxpT7FzTcRrUIFGcgCSmbk=;
        b=RhbhpEmGWh9Li2A0fB4+3903mWYZ1kh7hYvICRLLtcjH1SsfswsPtiPaD1CEl6A2Fs
         fXIU1l0N1tq6VY8h2vmm3EJNXKJM6sTK14tjhU58fYvAgPVh1r/sGUEBxMz8rkVJgaKp
         rkryhJvOR4FRxK1PzGzaAOWRd7UwAgkqVQjAOaxb3kOZqgDWuQhpZJkNm8gtCjfiJG3u
         HqBlBcW/toqZqL536s6bROw/hvnoOV1CmE00zhHBFx89bmLLZPgOvn6BZNi7E2fVqFWT
         3IVe+xiZa6Sgl4VZFLdT8TwOHdmvXk+SV4WDXgujlLjx8W2xDJlaG30+pDmOCOrOlcSt
         /qFQ==
X-Gm-Message-State: APjAAAWFnHzfnRKTNbytx99Z6K+ew2zcWRpwLOiQ/ieUjDm2PT5ATuUu
        mgAf7hrGh76XNF0ajbfgxeFhlbuRcx491MJ7NrlI8g==
X-Google-Smtp-Source: APXvYqz1ADI5pUttsTRFE4tG04m0tcxRUNOV6z/qiW+UMBRbGaQW2wU9EW1eJF1Qghs9D9XaNiAgZu7XxW6hZ4ZQb9Y=
X-Received: by 2002:a02:cd3b:: with SMTP id h27mr80920656jaq.18.1578341963368;
 Mon, 06 Jan 2020 12:19:23 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-11-pomonis@google.com>
In-Reply-To: <20191211204753.242298-11-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:19:12 -0800
Message-ID: <CALMp9eT5HVhtCKOKaBxkaVUVs+uQ908Z2coM3n6j9aMU33=HGw@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] KVM: x86: Protect memory accesses from
 Spectre-v1/L1TF attacks in x86.c
To:     Marios Pomonis <pomonis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Dec 11, 2019 at 12:49 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes Spectre-v1/L1TF vulnerabilities in
> vmx_read_guest_seg_selector(), vmx_read_guest_seg_base(),
> vmx_read_guest_seg_limit() and vmx_read_guest_seg_ar().
> These functions contain index computations based on the
> (attacker-influenced) segment value.
>
> Fixes: commit 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

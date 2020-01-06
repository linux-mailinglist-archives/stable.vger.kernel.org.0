Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12258131928
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgAFUSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:18:07 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46209 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgAFUSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:18:06 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so49969658ioi.13
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HntsUTCq9EJcXqpEDDbtnISyYD528YUbA0G+2iMAdkg=;
        b=IgURydL7ZmFcZ617oC7Fzty/+XRo10VzsVQOERs0Cjc68xMclG93vGJdGKjPZ0ONzK
         nUW4Q1M5ML236KuMtdi9T6w6jc6mD8e8rnVpjVU/44csfaitVnF38N48GI/K83aswm8l
         t6lf1NzaEU3EyM3ZotPzTbogCuTL9Snt4I+2p5ebBfsrOS87g96DM9PiD4oCSxjm7wrC
         aA/1Mi41ualxuvZxsf804wyTaXZxwP6ki6w3Kl234GS89AjNjyzgtd0gYcVQ1ZOd8atg
         cdJ3ufjp22V6jMod2PKF01h8YZU98kpXg38ZA/l1DbdP5sV9BqjGlla0o2v5lrf5t25q
         6+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HntsUTCq9EJcXqpEDDbtnISyYD528YUbA0G+2iMAdkg=;
        b=Y2PYQ3lQzDFOk5X8r2GGWK7HWsrBU8xvwQX/V3edVUv+3ahkWNqPVr/tbFtxNZS+J8
         oc+c+ZPYiDvbjf22sBMwFKyPEo9j/LVMkzHhh2gmxMaUQOQHqDPsGqpLwzmdFaIufKhz
         lECNOeAXgLNZ/tm3my1fWXjI7wTKjVLzoSbmAWoXRR0QNm56Nvqmly82sh5oEq3Y9Fe0
         DaPXOVUOjFrRqPMdYIT0zC+s+PR2ZLT35hES1Dgkrci22BR8an9y7A+QxrswBuybesjv
         o6Zb3nkeN6lPFRM7rb3O066CrZtC8AEa0qNuJ9mAb3ud9skh/LjVVaaT09sz8IF5v1hY
         fBxg==
X-Gm-Message-State: APjAAAVXh3dY0ntS2TceKZ4mnCyDPod32rPI4qHD/8zyl3YIGXerxDrk
        TzhZe+YGFkVzJwulGhzAc7+Cg1LM5B7TG9hLd8HqOg==
X-Google-Smtp-Source: APXvYqzdj0DXif/5YJj6CweBZv8KDa9rjRJILE7oJcw7GrLAu4IfLN+YndEbhWFFOAW1jcm3U9IjK2DrgvQEPZPOVRI=
X-Received: by 2002:a6b:740c:: with SMTP id s12mr30497900iog.108.1578341885911;
 Mon, 06 Jan 2020 12:18:05 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-7-pomonis@google.com>
In-Reply-To: <20191211204753.242298-7-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:17:55 -0800
Message-ID: <CALMp9eQNHf61n4uuiAKWaZbD4jBAj4hUVeBtbpJA4xi7=3E=cQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: x86: Protect kvm_lapic_reg_write() from
 Spectre-v1/L1TF attacks
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

On Wed, Dec 11, 2019 at 12:48 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes a Spectre-v1/L1TF vulnerability in kvm_lapic_reg_write().
> This function contains index computations based on the
> (attacker-controlled) MSR number.
>
> Fixes: commit 0105d1a52640 ("KVM: x2apic interface to lapic")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1439131933
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgAFUTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:19:03 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:43565 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgAFUTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:19:03 -0500
Received: by mail-il1-f193.google.com with SMTP id v69so43594891ili.10
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=On8S/jqcqhWm1gA75kni93hxDaFgmyxXA8OYLeg6pRw=;
        b=pj5xEWC2k1f0PDOEDl4ycNhV9/3mEeqCFoZlQ6jKJtbe77lzXp8pzFq26ztwSG9V+V
         Kq/A6Em27Lt9MrhZKAC3Nw+qJogSJDU9M+w73gCuds+KJEOjYORSWyCbiG2QNVIx8nAX
         MZk0LhnqI+m2EvlcOCUkv20bX9qw8Cv39Bbtnby/EMmb+Sz8+HwI13s1a8U7X01f3Hq1
         Dxc9ndFQw4DlH2N3jG1H/6eSOiNhnSd90uRIh8ZzcvSAmwqHzqDwPOL5T3ZPKWp5y7bf
         QZqCDDlB3FxjzOcqPePxq8ksuPYFPL0YS0AO41kD+eoBlTCpPDcnrZYkyCnkzbl5sgLy
         OJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=On8S/jqcqhWm1gA75kni93hxDaFgmyxXA8OYLeg6pRw=;
        b=TyBdVqEz81vUUOxiGJ2AM4RwdUdVUzLbAFXjBhSIOErrFDxhvEQJDFom3EJtAI/HpP
         rx5+AFRQsAIDUe/koHVEif5hjnNjqahoM6REgqD7cQc+OsS7kTjb3ODfEwFUvtTO2LM4
         RpKx274MUzw2rXasawNxDRqwJ5ME+I7yufPYmYcLfGL+8ynH/GgB4w9/NH//l4B1Vp1a
         iRVtxp/ZyzVMQy57ML4UT4fcILPVcB+eouicjXTgqepUGZ3TkEMXAlRW1SlMb1X/5jXM
         9x0l63o0/IAYDttr8xTbGsAFM8lLtNKqPaZtmvVW2R6wEVv+QwSfk8P71jXrEc3iEABR
         XNjQ==
X-Gm-Message-State: APjAAAV8MZ8fmciGh908LzA48D77/GOut/Tbch/0ZDil9QxEbgKV5x2O
        MSUpBrbYv9cL1l0eeVMOgCKIpy4j0X8JyluJWYi4uQ==
X-Google-Smtp-Source: APXvYqw/uA456NSw77dxi0HDBubRLZXT5catRpIZeEV7h/AuDPtK8k5E+UuB/HK9diCwlWzkyenxKNoQyTYwehnh+ls=
X-Received: by 2002:a92:3b98:: with SMTP id n24mr67439328ilh.108.1578341942677;
 Mon, 06 Jan 2020 12:19:02 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-10-pomonis@google.com>
In-Reply-To: <20191211204753.242298-10-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:18:51 -0800
Message-ID: <CALMp9eRTLMM17nVvGD9P38uP=886hgck1YabpnPXqyuFb1n0Jg@mail.gmail.com>
Subject: Re: [PATCH v2 09/13] KVM: x86: Protect MSR-based index computations
 from Spectre-v1/L1TF attacks in x86.c
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
> This fixes a Spectre-v1/L1TF vulnerability in set_msr_mce() and
> get_msr_mce().
> Both functions contain index computations based on the
> (attacker-controlled) MSR number.
>
> Fixes: commit 890ca9aefa78 ("KVM: Add MCE support")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

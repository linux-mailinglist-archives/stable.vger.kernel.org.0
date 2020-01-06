Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0431131931
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgAFUSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:18:44 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45845 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgAFUSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:18:43 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so49908051ioi.12
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hkwe6gCS0xXqcJJZW7uqlIoLqLcdTHhaPPV9HPAYJLA=;
        b=gzPxF6SbVaL+Q8f/0OUvPd4pGrCNyy3H+vkMlNxMyCFUACVPB22nhw7CW+mRIGgQ3f
         iC/gReQLeeGDSkKhUL37T9WNE1pL2ItXr276QwD6tCmTBAGhmLXzZTke6Rq8dBQPbOHq
         P5o62eK2UKq5jUxXseiTHaOP8geIypRCmKPQj6H9KHMS6YF57YEvwpqJXxoL5z6ZOBex
         Z9YIgLKj8/hR5kERIkkZaVIjpk1LMDFe3p+QzwUwunXpcu6N3vh4PfuAXJjn3a4nc4Xy
         RNBTgCyIIgQd5AcUrywwLVopwZUUIFlXZn4zuvAsYeWLWZRJcDncl4bs0NOmvEA3fG1Q
         Z0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hkwe6gCS0xXqcJJZW7uqlIoLqLcdTHhaPPV9HPAYJLA=;
        b=mVB7PHwlE9keE3MslBqi0MMzD1pHc509Yiza5j0zkl5MsfOK6PZMSQnKBMYflNUOLC
         I6Vzls5dJoUSM++++9HKmAAG1pDPTeWo6y5tCK/ZOVXF78Tp0HLpPGMNpLRI1CfJHz+C
         bz/+SC3zuU/e9fGbeOz3bJTzm/8vr9eJjl5zm84c16Jv9+N+KoUkIEryogTUysjDUyf1
         RDnFTvwpFyPFIGc6sQDITr7tN1Ss1UJgxWGEsFet1KBju6hX7Qbzc5F0EmbQ7oICm3+t
         inCvCOZDPMrgw0L+Q/ebXORtQXk8dqzBM6yORrFkaW4NAeMH4DeSE31Ti5UbliAPW4bS
         niOQ==
X-Gm-Message-State: APjAAAXDE9l+w6YG06bJyzMBZ54lWEM78MD6k8adGBlBUmtcOVt8WIa9
        Nb4WineuTLizEo7I2uBSoKAuHBNDp1sp5BklVVV9pw==
X-Google-Smtp-Source: APXvYqwB+24zHP/102YfQQE2qR7LjHh4cFem6VFU5fpXWOGl6aX54N0y+TTrv4usjFmDM3ZnakpCtAKCtgDHWQpd+Xo=
X-Received: by 2002:a5d:8cda:: with SMTP id k26mr45673841iot.26.1578341922908;
 Mon, 06 Jan 2020 12:18:42 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-9-pomonis@google.com>
In-Reply-To: <20191211204753.242298-9-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:18:31 -0800
Message-ID: <CALMp9eQmWB9WZaD=n5rTZEzWkjBx_emTn3zaVxk7YrwBGv2VrQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/13] KVM: x86: Protect MSR-based index computations
 in pmu.h from Spectre-v1/L1TF attacks
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
> This fixes a Spectre-v1/L1TF vulnerability in the get_gp_pmc() and
> get_fixed_pmc() functions.
> They both contain index computations based on the (attacker-controlled)
> MSR number.
>
> Fixes: commit 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support vPMU function dispatch")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

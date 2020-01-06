Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1810E131917
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgAFUQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:16:12 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:36883 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgAFUQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:16:12 -0500
Received: by mail-io1-f66.google.com with SMTP id k24so19598205ioc.4
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 12:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3GDssrbOe7NhLbjc31VdhTYmJ4APDSoT1K50tZqydr0=;
        b=MyzLiAmqcB1hgGyIZ2kA3LgpI/ZSjANJzdcs1E5c5RVxxQpmwsDvEnjbnSPf9jbIaW
         aZNpmuz3zw/Z5pUWgUqycvYCSe9haPGYbOfusaBHGgskL1dn/gdIuMkH/QAyWiqepbOQ
         c5sxvDp55U/n1xAMz7p66SDcczWPcU8K9P0u3Fz0pCxmXjd9qEOHeSgngs6MKjOXjDeV
         /Zy3JIpe6USdeCiSjEpNFWN5kUIwJBp0BlHVQHLIdIhny5pNstWpDTQ200QnGdA7PQ9T
         y/8mJlAL5lwTCg/LPC8HLJ1SD1ccAwJ9MMZBjsqtvgzohBC0B6jB2CCZzwYJMQBTK26c
         ekXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3GDssrbOe7NhLbjc31VdhTYmJ4APDSoT1K50tZqydr0=;
        b=N5tq6WQ3/0EbzyYdUBlGgA0t5wQy2Fww/3i+MMuab4XLwNz0w+gLd4DoJMlti6+TFY
         x2KO38CT8TsfCL0DU2Vyvhwlvl+CBMgKlt0fnM7pnwWjmw24a9D4hBNY1u2/bt3P7/EE
         IVkOt3C9ZPi7fFRLBJrGX1Vsj9DSPv+djNvcLUxgeg3dP6i2jbxOeBvbxRrP2W0GeKq6
         OdrTPjZaps8arbCHEIzY05FA2gz8lNt12jbg2ODZmstSGbdqyfiqy33RJrOMRjsrpUfO
         XTPd/DyfSuEYw2atH2e6kHYD2UWKkMG1JRH3vljq5cO7HBUvD7eA35hugXSgHWqFBaQG
         TUlQ==
X-Gm-Message-State: APjAAAXcfQGFCTA+qg0p35nyeijTNgCfOY1X7soSkY3Zu3YOj2Qt/uPQ
        1R0PI9JUXkLAUA01QxqJWPwXlfnfsH5qitmbwavNhw==
X-Google-Smtp-Source: APXvYqwR3dKEBj0osCR3tSkV2tqMs2o30CYmbwv2DVudSSvgXPx/sQElULEAO3+ccHMeZ91xIWFF4B+jFbSXGtFy/ig=
X-Received: by 2002:a6b:740c:: with SMTP id s12mr30491676iog.108.1578341771601;
 Mon, 06 Jan 2020 12:16:11 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-2-pomonis@google.com>
In-Reply-To: <20191211204753.242298-2-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:16:00 -0800
Message-ID: <CALMp9eQhU5WdDi5h+stS7oCmJSOXrGBhEAGx0mdPvjHV35R9=w@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: x86: Protect x86_decode_insn from
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
> This fixes a Spectre-v1/L1TF vulnerability in x86_decode_insn().
> kvm_emulate_instruction() (an ancestor of x86_decode_insn()) is an exported
> symbol, so KVM should treat it conservatively from a security perspective.
>
> Fixes: commit 045a282ca415 ("KVM: emulator: implement fninit, fnstsw, fnstcw")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

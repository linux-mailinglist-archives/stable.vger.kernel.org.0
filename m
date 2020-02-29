Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706AC1748D1
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 20:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgB2TA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 14:00:58 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:39607 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbgB2TA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 14:00:58 -0500
Received: by mail-il1-f193.google.com with SMTP id w69so5822997ilk.6
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 11:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OPm3hrGauL8biCEinhFnHGuE8NuHgMpT90ceO6W2+s4=;
        b=QJRcbgBgFWGY+IrI2mhQ7YcO+C450KRWfGWjarnZjMkLID6dMBo3yjnc+lQd0ydDFn
         Klpp6Lriyv205JzqPsR25dMpi5rZ4lQ2RpeJeqCd19TrmhuTHzLDDTb5Nq/8PMZMN9Wn
         ugiLU+5PnffMZMQ26oBpkrsEmuM5q72VpN9VNh4jrHvx7liqcf5GMjVURgiRgRjV5FA2
         4ZXZKXSKZQnNOBnvBSiF0uqAwELvZbZjFgLwrwfB6WvEmoZGbcqZQGaotUqc1I0tMNOK
         3golkHykUqQeytTOq9wxrN+T+s2keqAK8gMUmLBCp9A8HSp6ARkP+5O0d0I3bDPu+sMM
         C0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OPm3hrGauL8biCEinhFnHGuE8NuHgMpT90ceO6W2+s4=;
        b=beNf3YwFfVOUNi440QDCxfLf3CCKLGxr7FUMPMjzn9wyx3GJN844x26uSgDd6y6ZjO
         vvt23oayposkWIpSNSCSr2a7RPNpjy+946hRH6Jx6zQg0AhdNVU7naj7x5LVx02myjeI
         d9Ohw6g3DhZ4lqnM4EM4NF80p6kTeczJg89kh9CpUYC8ptOluFktDorNqBwaGaxWdG0o
         c9+EceJqcg4fmqvqOH+mWluAXdvCjkub9m97m9C4t9HRKEVmTEeOUuV9S4EJrz9jcAx3
         lkDqzxIzVI6UI2bc5Krx9l0gAILf3OtcyoU0qNgJYi6pbPsEmKgJXbfixJPhC3e0DbVI
         /j/w==
X-Gm-Message-State: APjAAAU9rQ/eryg4mdNbecUISIPRfkEKtDKcS2/8WKoEbuI0DzoRqKzC
        Z6yYc4YS4PVnXXp6EtO9aokIAVUflH5c7pJXXQufbA==
X-Google-Smtp-Source: APXvYqzrtg94iuKISLZUq15kVQq0EevQ7IO9b8IvdausgoC11wtDjBdvYeDl00RI2xRJ3xxCbc1E/KnknBPk4DBeVq8=
X-Received: by 2002:a92:981b:: with SMTP id l27mr9968372ili.118.1583002855957;
 Sat, 29 Feb 2020 11:00:55 -0800 (PST)
MIME-Version: 1.0
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com> <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
 <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
In-Reply-To: <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 29 Feb 2020 11:00:44 -0800
Message-ID: <CALMp9eRETy1RLWHWKtFHqpcpFHbQKtPgJHDD_N+LPzaUPx-Jvg@mail.gmail.com>
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest mode
To:     Oliver Upton <oupton@google.com>
Cc:     Jan Kiszka <jan.kiszka@web.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 29, 2020 at 10:33 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Jan,
>
> On Sat, Feb 29, 2020 at 10:00 AM Jan Kiszka <jan.kiszka@web.de> wrote:
> > Is this expected to cause regressions on less common workloads?
> > Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-Linux
> > gets a triple fault on load_current_idt() in start_secondary(). Only
> > bisected so far, didn't debug further.
>
> I'm guessing that Jailhouse doesn't use 'descriptor table exiting', so
> when KVM gets the corresponding exit from L2 the emulation burden is
> on L0. We now refuse the emulation, which kicks a #UD back to L2. I
> can get a patch out quickly to address this case (like the PIO exiting
> one that came in this series) but the eventual solution is to map
> emulator intercept checks into VM-exits + call into the
> nested_vmx_exit_reflected() plumbing.

If Jailhouse doesn't use descriptor table exiting, why is L0
intercepting descriptor table instructions? Is this just so that L0
can partially emulate UMIP on hardware that doesn't support it?

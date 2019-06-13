Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DC5449A2
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 19:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfFMRZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 13:25:11 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39117 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfFMRZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 13:25:11 -0400
Received: by mail-io1-f66.google.com with SMTP id r185so18688013iod.6
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 10:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3k1ewQshQXWU0zPqm6pMO1N4JQ6ELHz1NxT8KKHaxU=;
        b=PRI840OEIYdnMjVzyvdNG6jNrPT6PG0274LwvS4xl/F1GKW4tkG8ElrE5nEv/v4d2h
         pdQhlRr6ijJYmX/ulTIqX8hEPfoZ+w81aUCCipbv93f0FPopFfSjx1B2Y/A96iqRtIGX
         lpmt+uy2fpEpDKCZLGMdaA4FiVQKVM43zHgam29l432+DKFE2tusOg58mk22UzkTO+JI
         sfrv93+aQ7s/YOHOgNvH9R0SWUnTHVoLBWEMF0ZlfHiF1ZaBhJYKX+cXd/qDMljGYRXp
         ltes+z8RFDcNwoohT/UqVtbVXS07ZVS8G6m9AftlABKcMwgGQbaKVjEeRixEa2CLnusI
         sGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3k1ewQshQXWU0zPqm6pMO1N4JQ6ELHz1NxT8KKHaxU=;
        b=cM6429hNRDSAO3BZ1BtXJQHllLh5OQwI1nA9FDtZ3+VwJyeVAqUO5eKqqnNpTCxp3S
         Oc0Y8FAYQRI1gAvGs34dIEiarZx5PY/XIPS2kz3FyH7RKKwiAdnSchyBqSzIWvy9A6fA
         fXaUmMOlzNUBctt+DF9RUjOUU/Xk/rXSu+oaFefVOClT8K61IWRQgplwLizQ6aAEfX6d
         f1DnJxqvNonjyjEZZ5wlxkLuCIVfeb5bCaJO/rgsH1G01qQ44g6S4zgp91yIvePCVyco
         4LmhVWe0h91cS5obXk1BDCfRMdjhaF2erAjBeAf5+drwptDTuY1rotPO76W1uCrfmcZf
         /zeg==
X-Gm-Message-State: APjAAAU3a84ZQdiHK6z4pq+gay82RzxxWIJmiC+B+6ge/Q8EqB800Jvl
        Btb0zX6kbcVEs5p8kuv+yXFYmGkkCBa1j6zpYcaOGQ==
X-Google-Smtp-Source: APXvYqz+be35Z7WOf3tL1YUmH7TuwYnypRlKk1tb+7pCTUCRVz7FVgMNC+q7mps6ZQu5ZnQDIb0tXv/jgzCnqf68NDg=
X-Received: by 2002:a5d:94d7:: with SMTP id y23mr55512163ior.296.1560446710333;
 Thu, 13 Jun 2019 10:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com> <1560445409-17363-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1560445409-17363-2-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Jun 2019 10:24:58 -0700
Message-ID: <CALMp9eQ9_nkK35T2vS+=ujiRAO2kiYJcZLUFSeizWmAc89zjXg@mail.gmail.com>
Subject: Re: [PATCH 01/43] KVM: VMX: Fix handling of #MC that occurs during VM-Entry
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 10:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> A previous fix to prevent KVM from consuming stale VMCS state after a
> failed VM-Entry inadvertantly blocked KVM's handling of machine checks
> that occur during VM-Entry.
>
> Per Intel's SDM, a #MC during VM-Entry is handled in one of three ways,
> depending on when the #MC is recognoized.  As it pertains to this bug
> fix, the third case explicitly states EXIT_REASON_MCE_DURING_VMENTRY
> is handled like any other VM-Exit during VM-Entry, i.e. sets bit 31 to
> indicate the VM-Entry failed.
>
> If a machine-check event occurs during a VM entry, one of the following occurs:
>  - The machine-check event is handled as if it occurred before the VM entry:
>         ...
>  - The machine-check event is handled after VM entry completes:
>         ...
>  - A VM-entry failure occurs as described in Section 26.7. The basic
>    exit reason is 41, for "VM-entry failure due to machine-check event".
>
> Explicitly handle EXIT_REASON_MCE_DURING_VMENTRY as a one-off case in
> vmx_vcpu_run() instead of binning it into vmx_complete_atomic_exit().
> Doing so allows vmx_vcpu_run() to handle VMX_EXIT_REASONS_FAILED_VMENTRY
> in a sane fashion and also simplifies vmx_complete_atomic_exit() since
> VMCS.VM_EXIT_INTR_INFO is guaranteed to be fresh.
>
> Fixes: b060ca3b2e9e7 ("kvm: vmx: Handle VMLAUNCH/VMRESUME failure properly")

I'm never going to live down that subject line, am I? :-)

Reviewed-by: Jim Mattson <jmattson@google.com>

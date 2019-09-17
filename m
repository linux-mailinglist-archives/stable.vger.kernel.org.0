Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4887B50E0
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 16:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfIQO7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 10:59:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42479 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbfIQO7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 10:59:04 -0400
Received: by mail-io1-f68.google.com with SMTP id n197so8286738iod.9
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 07:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4N/btWkhdRtAkLwnNEi3JvgTHWUB7am8sFUWn4QTMHo=;
        b=Vl+iO5Psm3owdP69GO+WOZQtnoLDGAdiMyy8AlEs6zj4KE57ayqKDns6d5FrJn5ROq
         IGhwt1lh/vRUdyTt+CFCXnyKqmikSQqVhZXIEOj2KHwNr6k0Xuwx51HzaNHP8+vLH9rn
         QxW4R+EVLL/5PivNA1qKPwAUzPWQ2jRsKoE9rxXNAtD8q3PcuUO9CR38EFV/4XMqqSnF
         W7PTBHS/61nGVwhiw6EBQvCwO9ZxJq7pnVSmcp/9howaygFWPLKfe/DeMe9slMlkiwXm
         f4jbaxLXZjDlgut4uJnT0u08GS7ZjP/PxosvoKtce/aPB6MMWEEQ8LBRv5MQpTwzzR6s
         w6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4N/btWkhdRtAkLwnNEi3JvgTHWUB7am8sFUWn4QTMHo=;
        b=dLHYP0FQSvU4NwIk0Vgp++qNorYqEb/82CI1hIM3ehJTLGbXD+o2EL99dtRhI63S0P
         ktuGPeDKxL9RX445aaNJ55INyzBiGe16PhRYmBq9cE8x5hsTrVt9D700Vl+SsQ2YtTjG
         Z+FgE256qy4RxqwOAYs0qctie0uEmV/skxfVa0iWwF41grI0Ga3EGvRgIi4kOJLy64Am
         pKio9Z24d/q8U7nO+1DFMfPz9ipWHbRk9lFxOswM5xnH6pMroFezmO2mWEJCtAQPGHHA
         EfYHOfYJKD1TLnABym+7odhtBjwbqB+9TI7kOf+yECZnOhP6T+CEridMHhD/Udf/Ou+L
         qYtg==
X-Gm-Message-State: APjAAAXKvn8RdjMe1SwQsQPj70NFpN4cr2xFiJxYTIy4Oh0wGpv2D9Od
        VS464t/coGiJ+IeRL4pV36UOJZlPLOHBijXgiynIJg==
X-Google-Smtp-Source: APXvYqz9DvHQNg9JiUWZur8kh4NHVWmxIc5OJSKjAK0NEC6eFvWeXKcUfTuQH1pek1NBrEZiHfP0dJlLdiC+XjpI0K0=
X-Received: by 2002:a05:6602:115:: with SMTP id s21mr3306650iot.122.1568732342359;
 Tue, 17 Sep 2019 07:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 17 Sep 2019 07:58:51 -0700
Message-ID: <CALMp9eSNTvHsSn55iNfF1tUAdAihz_2d5-Hac1H6TnvHyos-SQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: Fix coalesced mmio ring buffer out-of-bounds access
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org,
        Matt Delco <delco@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 17, 2019 at 1:16 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Reported by syzkaller:
>
>         #PF: supervisor write access in kernel mode
>         #PF: error_code(0x0002) - not-present page
>         PGD 403c01067 P4D 403c01067 PUD 0
>         Oops: 0002 [#1] SMP PTI
>         CPU: 1 PID: 12564 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
>         RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]
>         Call Trace:
>          __kvm_io_bus_write+0x91/0xe0 [kvm]
>          kvm_io_bus_write+0x79/0xf0 [kvm]
>          write_mmio+0xae/0x170 [kvm]
>          emulator_read_write_onepage+0x252/0x430 [kvm]
>          emulator_read_write+0xcd/0x180 [kvm]
>          emulator_write_emulated+0x15/0x20 [kvm]
>          segmented_write+0x59/0x80 [kvm]
>          writeback+0x113/0x250 [kvm]
>          x86_emulate_insn+0x78c/0xd80 [kvm]
>          x86_emulate_instruction+0x386/0x7c0 [kvm]
>          kvm_mmu_page_fault+0xf9/0x9e0 [kvm]
>          handle_ept_violation+0x10a/0x220 [kvm_intel]
>          vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
>          vcpu_enter_guest+0x4dc/0x18d0 [kvm]
>          kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
>          kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
>          do_vfs_ioctl+0xa2/0x690
>          ksys_ioctl+0x6d/0x80
>          __x64_sys_ioctl+0x1a/0x20
>          do_syscall_64+0x74/0x720
>          entry_SYSCALL_64_after_hwframe+0x49/0xbe
>         RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]
>
> Both the coalesced_mmio ring buffer indexs ring->first and ring->last are
> bigger than KVM_COALESCED_MMIO_MAX from the testcase, array out-of-bounds
> access triggers by ring->coalesced_mmio[ring->last].phys_addr = addr;
> assignment. This patch fixes it by mod indexs by KVM_COALESCED_MMIO_MAX.
>
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134b2826a00000
>
> Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/coalesced_mmio.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5294abb..cff1ec9 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -73,6 +73,8 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
>
>         spin_lock(&dev->kvm->ring_lock);
>
> +       ring->first = ring->first % KVM_COALESCED_MMIO_MAX;
> +       ring->last = ring->last % KVM_COALESCED_MMIO_MAX;

I don't think this is sufficient, since the memory that ring points to
is shared with userspace. Userspace can overwrite your corrected
values with illegal ones before they are used. Not exactly a TOCTTOU
issue, since there isn't technically a 'check' here, but the same
idea.

>         if (!coalesced_mmio_has_room(dev)) {
>                 spin_unlock(&dev->kvm->ring_lock);
>                 return -EOPNOTSUPP;
> --
> 2.7.4
>

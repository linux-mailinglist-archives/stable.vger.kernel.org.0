Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E87156C42
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 20:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgBITji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 14:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbgBITji (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 14:39:38 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82E720726;
        Sun,  9 Feb 2020 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581277177;
        bh=wU42Tgt2V0Z8x9ESyprhLD3NsVdYryiyoMb4KPajXiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ut0ooK4ACIgN6LGRsYCD5Js9/kYI203tHGpaL6fVaFZUq5dXNjLnacEqtTXS0Hder
         FfC1GPT8bnuvrdlmIPJrQy3lHN/bjbjUtWLqH64AgO3gj6KFqXFQxbOxBK9C5woN/a
         5LpVcQV9K+UyJDJ1mnvz9PWwUxETCzZWEhfYyVm0=
Date:   Sun, 9 Feb 2020 14:39:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Fix potential put_fpu() w/o
 load_fpu() on MPX" failed to apply to 4.14-stable tree
Message-ID: <20200209193934.GU3584@sasha-vm>
References: <158125096467128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158125096467128@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:22:44PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From f958bd2314d117f8c29f4821401bc1925bc2e5ef Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Mon, 9 Dec 2019 12:19:31 -0800
>Subject: [PATCH] KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX
> platform
>
>Unlike most state managed by XSAVE, MPX is initialized to zero on INIT.
>Because INITs are usually recognized in the context of a VCPU_RUN call,
>kvm_vcpu_reset() puts the guest's FPU so that the FPU state is resident
>in memory, zeros the MPX state, and reloads FPU state to hardware.  But,
>in the unlikely event that an INIT is recognized during
>kvm_arch_vcpu_ioctl_get_mpstate() via kvm_apic_accept_events(),
>kvm_vcpu_reset() will call kvm_put_guest_fpu() without a preceding
>kvm_load_guest_fpu() and corrupt the guest's FPU state (and possibly
>userspace's FPU state as well).
>
>Given that MPX is being removed from the kernel[*], fix the bug with the
>simple-but-ugly approach of loading the guest's FPU during
>KVM_GET_MP_STATE.
>
>[*] See commit f240652b6032b ("x86/mpx: Remove MPX APIs").
>
>Fixes: f775b13eedee2 ("x86,kvm: move qemu/guest FPU switching out to vcpu_run")
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

The conflict is because we didn't have fd2325612c14 ("KVM: Move
vcpu_load to arch-specific kvm_arch_vcpu_ioctl_get_mpstate") on older
kernels. I've fixed it and queued for 4.14.

-- 
Thanks,
Sasha

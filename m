Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF65B1B2252
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 11:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgDUJH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 05:07:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34601 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgDUJH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 05:07:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id j1so10137497wrt.1;
        Tue, 21 Apr 2020 02:07:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e9M3SgY+JXKYkmqckqVYeqrbYWYRHeQQ32itAPSHGxA=;
        b=KD+O9gPftH4hZsjHZpU5YQq2CVnqp2cb/RyeW7P06uoHwJiK6IBX+GDcP2MKiInDiK
         BcgjIUWvdzjCRtI14thIzEM2aInA6xH2P338rfwSC0JfRVkgKnYo2nkvpL8DTKaZVzxe
         5oCIY2Q230T9yEzbmFtiLSUORuFtv62ovJd4yotqLympaClpcIsR084yMpMMLjQ+BP0t
         w5VEL1wYYjon6oLjxYLo/OYtIhgQ3xb2Vx4gy22c5TlV3ekdth4KQV0KBm0IcTAfzPSH
         x0/5hje9oFVYW6SduNGe2pTOwvjpfmpVNe4wy1Ysk2S8UZtH89A0iVZArhCgG9JzCfJx
         jEDQ==
X-Gm-Message-State: AGi0PuZ6E7vPYKdbf2wSAnZBvx2QvUZqM/fVVLz+eINiwh91hYw+UY1S
        JtW3cy4ToE7QlCF24cniVqg=
X-Google-Smtp-Source: APiQypKoPztP+dsq7B7A/Dk7MfawvyuXGNJNQfCISOZ0yeL6dYxTT2lfazmmFGdciTV/sM9J2xZlFw==
X-Received: by 2002:adf:8149:: with SMTP id 67mr25866316wrm.60.1587460046053;
        Tue, 21 Apr 2020 02:07:26 -0700 (PDT)
Received: from debian (44.142.6.51.dyn.plus.net. [51.6.142.44])
        by smtp.gmail.com with ESMTPSA id z8sm2948821wrr.40.2020.04.21.02.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 02:07:25 -0700 (PDT)
Date:   Tue, 21 Apr 2020 10:07:23 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     bp@alien8.de, haiyangz@microsoft.com, hpa@zytor.com,
        kys@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        sthemmin@microsoft.com, tglx@linutronix.de, x86@kernel.org,
        mikelley@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/hyperv: Suspend/resume the VP assist page for
 hibernation
Message-ID: <20200421090723.wfv24b54uvft5d4m@debian>
References: <1587437171-2472-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587437171-2472-1-git-send-email-decui@microsoft.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 07:46:11PM -0700, Dexuan Cui wrote:
> Unlike the other CPUs, CPU0 is never offlined during hibernation, so in the
> resume path, the "new" kernel's VP assist page is not suspended (i.e. not
> disabled), and later when we jump to the "old" kernel, the page is not
> properly re-enabled for CPU0 with the allocated page from the old kernel.
> 
> So far, the VP assist page is used by hv_apic_eoi_write(), and is also
> used in the case of nested virtualization (running KVM atop Hyper-V).
> 
> For hv_apic_eoi_write(), when the page is not properly re-enabled,
> hvp->apic_assist is always 0, so the HV_X64_MSR_EOI MSR is always written.
> This is not ideal with respect to performance, but Hyper-V can still
> correctly handle this according to the Hyper-V spec; nevertheless, Linux
> still must update the Hyper-V hypervisor with the correct VP assist page
> to prevent Hyper-V from writing to the stale page, which causes guest
> memory corruption and consequently may have caused the hangs and triple
> faults seen during non-boot CPUs resume.
> 
> Fix the issue by calling hv_cpu_die()/hv_cpu_init() in the syscore ops.
> Without the fix, hibernation can fail at a rate of 1/300 ~ 1/500.
> With the fix, hibernation can pass a long-haul test of 2000 runs.
> 
> In the case of nested virtualization, disabling/reenabling the assist
> page upon hibernation may be unsafe if there are active L2 guests.
> It looks KVM should be enhanced to abort the hibernation request if
> there is any active L2 guest.
> 
> Fixes: 05bd330a7fd8 ("x86/hyperv: Suspend/resume the hypercall page for hibernation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Applied to hyperv-fixes. Thanks.

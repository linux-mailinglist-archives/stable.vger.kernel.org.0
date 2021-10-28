Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C52043E116
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 14:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhJ1Mm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 08:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhJ1Mm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 08:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635424801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BilMP89d5ejwGExRisJLsaqgEV5K1hYN/wwdRA5k/bw=;
        b=AX9Vw8LX7atLr3QjzuVpfzeVUtjav32uDSMWbvzOTmhkRJ+1tx4kyF5hLW1IV5wQiu2A7z
        dS70CO5q3kNx/PxqAF5WyQc5pDIfsYHTTXtwk1O5x2D72HxnFYgpQTl1B54WeDYfLn62R3
        ym0zGWHN1SUebHnqFGAY//+1aw3aZro=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-wywsC157NpegyodhPR3QOQ-1; Thu, 28 Oct 2021 08:39:59 -0400
X-MC-Unique: wywsC157NpegyodhPR3QOQ-1
Received: by mail-wm1-f72.google.com with SMTP id g195-20020a1c20cc000000b0032e418cd7a9so575029wmg.4
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 05:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BilMP89d5ejwGExRisJLsaqgEV5K1hYN/wwdRA5k/bw=;
        b=Dr55Kr/f54VMBHA6hJJ4nHN4U+uniseeacSnLuk8ppgzgAbQOezZ2ZaNVjlKuS1pdP
         RUQOmAgz5KDqdOu2WK2pVJqAUzD+gzXrXJ8/9gagcBdOgzjCWpjag2qjfbFURzjvqcBx
         U6C0UWTy/5BFs2opqU/HMfgBHmfATWeKHPxWUlbP4M04aCd3EQ20cYyJ+GOZxBQ+aWUL
         sg2z+P+cITKW8MaplADqI4IjQpu9vYWgRMUnk0a0zoakFkiN8ayvsAbEZ92iiC/dhSQ9
         W/W0ZGXCVpXWFFWJS3t2UWRvKZuMXTjqnCRwW9wmTQaheenjDICLLWtdhSE2PYA3GsPZ
         loOw==
X-Gm-Message-State: AOAM531L3l5Z/4avLB/46fxmKkqRjK7tauXxUhI3hXhSGUJ1iPf4StAS
        G6GMyXUXQ6LzSW56sCchBBWTyd29YD/gGet2jQmr1cazHHJoRy0TospsJEvW7nzUBedr4mkNret
        FYcJw5Z8SqcCnMovn
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr4091574wme.186.1635424798267;
        Thu, 28 Oct 2021 05:39:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpBmS3oMhxO4yW4Qb9VQGEeYaL6u24h46UykydIOpW7bcXe3uHXi4ooalXiK9fBVtsvOBkuw==
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr4091549wme.186.1635424798001;
        Thu, 28 Oct 2021 05:39:58 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.14.190])
        by smtp.gmail.com with ESMTPSA id h14sm6603444wmq.34.2021.10.28.05.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 05:39:57 -0700 (PDT)
Message-ID: <641e823b-ed22-1e3f-6ce5-eeb09e8f947f@redhat.com>
Date:   Thu, 28 Oct 2021 14:39:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] KVM: PPC: Tick accounting should defer vtime
 accounting 'til after IRQ handling
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org
References: <20211027142150.3711582-1-npiggin@gmail.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20211027142150.3711582-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/10/2021 16:21, Nicholas Piggin wrote:
> From: Laurent Vivier <lvivier@redhat.com>
> 
> Commit 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest
> context before enabling irqs") moved guest_exit() into the interrupt
> protected area to avoid wrong context warning (or worse). The problem is
> that tick-based time accounting has not yet been updated at this point
> (because it depends on the timer interrupt firing), so the guest time
> gets incorrectly accounted to system time.
> 
> To fix the problem, follow the x86 fix in commit 160457140187 ("Defer
> vtime accounting 'til after IRQ handling"), and allow host IRQs to run
> before accounting the guest exit time.
> 
> In the case vtime accounting is enabled, this is not required because TB
> is used directly for accounting.
> 
> Before this patch, with CONFIG_TICK_CPU_ACCOUNTING=y in the host and a
> guest running a kernel compile, the 'guest' fields of /proc/stat are
> stuck at zero. With the patch they can be observed increasing roughly as
> expected.
> 
> Fixes: e233d54d4d97 ("KVM: booke: use __kvm_guest_exit")
> Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
> Cc: <stable@vger.kernel.org> # 5.12
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> [np: only required for tick accounting, add Book3E fix, tweak changelog]
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Since v2:
> - I took over the patch with Laurent's blessing.
> - Changed to avoid processing IRQs if we do have vtime accounting
>    enabled.
> - Changed so in either case the accounting is called with irqs disabled.
> - Added similar Book3E fix.
> - Rebased on upstream, tested, observed bug and confirmed fix.
> 
>   arch/powerpc/kvm/book3s_hv.c | 30 ++++++++++++++++++++++++++++--
>   arch/powerpc/kvm/booke.c     | 16 +++++++++++++++-
>   2 files changed, 43 insertions(+), 3 deletions(-)
> 

Tested-by: Laurent Vivier <lvivier@redhat.com>

Checked with mpstat that time is accounted to %guest while a stress-ng test is running in 
the guest. Checked there is no warning in the host kernellogs.

Thanks,
Laurent


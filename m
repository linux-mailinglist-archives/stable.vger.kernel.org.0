Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C40F37A155
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 10:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhEKIF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 04:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhEKIFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 04:05:25 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43486C06175F
        for <stable@vger.kernel.org>; Tue, 11 May 2021 01:04:18 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id l25-20020a4a35190000b029020a54735152so75488ooa.4
        for <stable@vger.kernel.org>; Tue, 11 May 2021 01:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vqWqlRo1t8unIB3Z/gPDCFXryTe+VxOxmZbywII60x4=;
        b=RsARpI9kPbe8fGR56PQ4skYG8c9j7c835d7rOcGai/qr7PmvAFxTBwMPg0n2VNOOJ5
         KkP+xqxkTWNxfq5af47pwFhxQ+gI535/8Hg4Py+5tIBUnpVpw+uUqHNdiGy1We0e6P7C
         U3pDYJNh9iAbAGww3qtuHQ2C6EI76iWRqwRdduT/OiYZNMX9ZOvWrl/LOZQlW9gSIr1c
         Lza0R/5guKEDeTbh4LO7VrsbCV1JlyXIRO9IliK93CHvkIlqHwTidtABkP6MtO1RLgI8
         0futdZOP85C/BHdhcmoHGmhTFD1t2/pn5mxbgN3B6aATye6KVk+2Hm+OkS0WCKlV7WAR
         mPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqWqlRo1t8unIB3Z/gPDCFXryTe+VxOxmZbywII60x4=;
        b=CEF1f9V9cqTZgcKVvIQU0NgKCH+FrvfewyLRJAVkf0cqcGTPneACSOG0FVa6tZjK9i
         cxZW5jOLSJGh+i5Dh+kHPYHn3ReGq+F1d27VbqtuBGvRxXwmRaWSKq/j2UWBzN5VZw+u
         LOY8tziEfvoL8RC7fjMH2497ChdvdJg/+8Oj3QLRjXVPHa/bizNhRjZ5AYoKvqmazF4M
         UnRqeKcTQ6yI6/3NXiwgzln+/Fyy82OPJpLPSbGspsEvkQ6YgXAdFFKUaqak4zwy1XrS
         VqxOTmtK7PQn6FaC7PmS66v8fJUeJmU6R+FLI8vn24hQ8XDkdZUlXIMdbTonk+Ui3Qv3
         xFow==
X-Gm-Message-State: AOAM532bgGctmVyuzol1gTB9Fmg45iMV9pRmybSNZQJ6fI10RZxWyvw6
        VbraPntYovp3j24Vtht2dgLPpCZ/9OQLfMq9s3uycw==
X-Google-Smtp-Source: ABdhPJwiG5f14ptUggSSt+hUanG2tnouIAtbpU1JD68oO5A0s7qMCGnueWGVnCFx9fN6AZ33rumu5oXEfhtT2qh7sVs=
X-Received: by 2002:a4a:ea2b:: with SMTP id y11mr285770ood.42.1620720257457;
 Tue, 11 May 2021 01:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210510094915.1909484-1-maz@kernel.org> <20210510094915.1909484-3-maz@kernel.org>
In-Reply-To: <20210510094915.1909484-3-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 11 May 2021 09:03:40 +0100
Message-ID: <CA+EHjTzcfmt4mxh05a_P+nheQ_A2FuXhpgvKXuV5__pZP0SxkA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Commit pending PC adjustemnts before
 returning to userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

> KVM: arm64: Commit pending PC adjustemnts before returning to userspace

s/adjustments/adjustments

On Mon, May 10, 2021 at 10:49 AM Marc Zyngier <maz@kernel.org> wrote:
>
> KVM currently updates PC (and the corresponding exception state)
> using a two phase approach: first by setting a set of flags,
> then by converting these flags into a state update when the vcpu
> is about to enter the guest.
>
> However, this creates a disconnect with userspace if the vcpu thread
> returns there with any exception/PC flag set. In this case, the exposed
> context is wrong, as userpsace doesn't have access to these flags
> (they aren't architectural). It also means that these flags are
> preserved across a reset, which isn't expected.
>
> To solve this problem, force an explicit synchronisation of the
> exception state on vcpu exit to userspace. As an optimisation
> for nVHE systems, only perform this when there is something pending.

I've tested this with a few nvhe and vhe tests that exercise both
__kvm_adjust_pc call paths (__kvm_vcpu_run and
kvm_arch_vcpu_ioctl_run), and the tests ran as expected.  I'll do the
same for v2 when you send it out.

Cheers,
/fuad

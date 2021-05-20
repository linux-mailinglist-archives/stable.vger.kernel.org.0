Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33642389FA9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhETITB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:19:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45248 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhETITB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 04:19:01 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621498659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=danNVP1F0DwY+87MeHMDjfV5BL9uYyFA1fdtztnvKsc=;
        b=lCwnkQaIMZ7H9ktIE/e4nsmYKE0r5HGbmayXdWegmAqgQf5gmw3BM9VA6OUZWhEzDPCnLU
        /vToIYQEUaXBDZ2SlNvYIUfWUZBctduUY9KtCTn1dA3PpM+VpbNa7XStSi4a8dM5QipPXR
        rPQBY9zIPpm1JkqJ0Box07z8kFeqyb7eAIt41o367m8cg4aN/oacwnKHnKlmZskm31Puro
        OMrFvhkr/dxM6FRArlrdAbxeZACLNR1fKVdSD1Y3AJSX3MWb9XrM5BmN9lF4YoeEBnIN64
        iFkSsJPPybtE/Pe8xbbUZbNAkgCBFNBf9kb7PQDohzyv98c6xU7hT6L+fBsWaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621498659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=danNVP1F0DwY+87MeHMDjfV5BL9uYyFA1fdtztnvKsc=;
        b=pMAZ9u3mh47ELbQufp/CXDBk/O8yyMA8PRCwz4mlakugExfBwT+xod1NS/RvpFgbNeeBjT
        75IeiaFu/0H2fWAw==
To:     Imran Khan <imran.f.khan@oracle.com>, mingo@redhat.com,
        bp@alien8.de
Cc:     x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC PATCH] x86/apic: Fix BUG due to multiple allocation of legacy vectors.
In-Reply-To: <20210519233928.2157496-1-imran.f.khan@oracle.com>
References: <20210519233928.2157496-1-imran.f.khan@oracle.com>
Date:   Thu, 20 May 2021 10:17:39 +0200
Message-ID: <8735uhddjw.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Imran,

On Wed, May 19 2021 at 23:39, Imran Khan wrote:
> During activation of secondary CPUs, lapic_online is
> invoked to initialize vectors. While lapic_online
> installs legacy vectors on all CPUs, it does not set
> the corresponding bits in per CPU bitmap maintained
> under irq_matrix.
> This may result in these legacy vectors getting allocated
> by irq_matrix_alloc and if that happens subsequent invocation
> of apic_update_vector will cause BUG like the one shown below:
>
> [  154.738226] kernel BUG at arch/x86/kernel/apic/vector.c:172!

please trim the backtrace. It's not really relevant for understanding
the problem.

> This patch marks these legacy vectors as assigned in irq_matrix

git grep 'This patch' Documentation/process/

> so that corresponding bits in percpu bitmaps get set and these
> legacy vectors don't get reallocted.

This is just wrong.

True legacy interrupts (PIC delivery) are marked as system vectors. See
lapic_assign_legacy_vector(). That prevents them from being allocated.

> [  154.858092] CPU: 22 PID: 3569 Comm: ifup-eth Not tainted 5.8.0-20200716.x86_64 #1

I have no idea what this 5.8.0-magic-date kernel is.

Have you verified that this problem exists with upstream?

Thanks,

        tglx

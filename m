Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160292D3976
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 05:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgLIELL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 23:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbgLIELK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 23:11:10 -0500
X-Gm-Message-State: AOAM531dum8dcwRfYOOpISU0HBDTbIJxCEJ6of34WswpZ77gWKSXGU5d
        hcg8tWy8ORh29HvOYJlZvBjVVU31ZI+NqLzb7n152w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607487030;
        bh=1CAej7bL9bby2x2lbxE0YLEucpVIZk0Cp12eMTAWnCU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T/DygCw7+m4Ndk0b8X9tDQ1sje9jMArw8hFPLVfZvxK/6X/WoAzDv/Hc6oCC/69fZ
         5JCSklUkI3lFSOrMehZ+rLBY/z4M8rtWz8s8IwGVWhOlVi+rci7YqYIscbDakpiwvy
         HQvraMymhvcL0NIpR6l6sL77A3NzQtdDuoTgbR3iwPp+KOKt4AwHWWIWVILOwbrf3p
         xjE4eUoQ8neBifqOxjQye9olx4DbQWzralHENI+EhuyU8dV4y0XhyIPhPGPReMExxo
         3jnGPTjTlljwp3xDwX0LmfPqGolfuf3k0/mKxLNqcZDVdDyUZq8Yc7FXt8+Lh4xiFu
         3qBciJaBGzzCA==
X-Google-Smtp-Source: ABdhPJx8f+RdbaGI81UADW9xFSnrqCz4FjdPIOcomxSWAkAjhPQCAYJn9IG1EvCe9Bf6Ry8jGeQG8Y3nOpcc7KN9/Lc=
X-Received: by 2002:a1c:630b:: with SMTP id x11mr567584wmb.138.1607487028407;
 Tue, 08 Dec 2020 20:10:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607058304.git.luto@kernel.org> <5afc7632be1422f91eaf7611aaaa1b5b8580a086.1607058304.git.luto@kernel.org>
In-Reply-To: <5afc7632be1422f91eaf7611aaaa1b5b8580a086.1607058304.git.luto@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 8 Dec 2020 20:10:17 -0800
X-Gmail-Original-Message-ID: <CALCETrULOhzyTjd+K5ByeRZ2Sn2-EjpaMJd2DosZ-V1X5DUojA@mail.gmail.com>
Message-ID: <CALCETrULOhzyTjd+K5ByeRZ2Sn2-EjpaMJd2DosZ-V1X5DUojA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] x86/membarrier: Get rid of a dubious optimization
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 3, 2020 at 9:07 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> sync_core_before_usermode() had an incorrect optimization.  If we're
> in an IRQ, we can get to usermode without IRET -- we just have to
> schedule to a different task in the same mm and do SYSRET.
> Fortunately, there were no callers of sync_core_before_usermode()
> that could have had in_irq() or in_nmi() equal to true, because it's
> only ever called from the scheduler.
>
> While we're at it, clarify a related comment.
>

Fixes: ac1ab12a3e6e ("lockin/x86: Implement sync_core_before_usermode()")

> Cc: stable@vger.kernel.org
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

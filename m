Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D932D3981
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 05:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgLIEQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 23:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbgLIEQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 23:16:10 -0500
X-Gm-Message-State: AOAM531CFwy4co2FfzPq6w73Ys5p0NjfzM/XtLKdJSjkHmZfGo2BjS5d
        Ov2zxshJO1576k//6vh5S8YCHyB+bHxwIAOSjPesxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607487330;
        bh=WVZZyujKBZ8MrXIPzt5GqcfrE6/AP6BAHMosOQpe5JQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CNoV7VcWjnaCFxSrdpHZZu3AwpleQBhop9286yfoJ0Ayv1am87QThzsxUzNvadtzT
         39HC8oZoqMdh42/1xHY/CFSVXI6Eze9h2zrbd+HsErj8eJHI8PB3ljRvLGLclkpTuD
         j6U7c8yESXjwJkzJYLFLZ5tQoG8oZW3JB47GtC00TUgRZiGwCe5qZVTauJ3rXj/CFs
         TTkcaUm0WQMCLxtfU6x0M2AgTEcPMeGNK8MSd/nGshG6hz23uHTdVtz0kcQAr/lYPh
         fZEJbJqaxzQ8pQQmF/1QMVieS81+Kt0fePjd8UJAH4Gu2u64n9gVqKFPGjhgUA0tFx
         mjuypBAyzo3pA==
X-Google-Smtp-Source: ABdhPJxa4NZDEiiJOzu6zh/rpVgMx/QhZRETCZdr+NYA3DORyV3I3J27xnB6rjEq1FQPUn0kVY+2LVGQbA89zSGzlls=
X-Received: by 2002:adf:e98c:: with SMTP id h12mr384398wrm.75.1607487328317;
 Tue, 08 Dec 2020 20:15:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607058304.git.luto@kernel.org> <250ded637696d490c69bef1877148db86066881c.1607058304.git.luto@kernel.org>
In-Reply-To: <250ded637696d490c69bef1877148db86066881c.1607058304.git.luto@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 8 Dec 2020 20:15:17 -0800
X-Gmail-Original-Message-ID: <CALCETrX1TDAhJypd04iMoNSo=aNK5dbxCu_kNj3i=3AdeWNz6Q@mail.gmail.com>
Message-ID: <CALCETrX1TDAhJypd04iMoNSo=aNK5dbxCu_kNj3i=3AdeWNz6Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] membarrier: Execute SYNC_CORE on the calling thread
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
> membarrier()'s MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE is documented
> as syncing the core on all sibling threads but not necessarily the
> calling thread.  This behavior is fundamentally buggy and cannot be used
> safely.  Suppose a user program has two threads.  Thread A is on CPU 0
> and thread B is on CPU 1.  Thread A modifies some text and calls
> membarrier(MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE).  Then thread B
> executes the modified code.  If, at any point after membarrier() decides
> which CPUs to target, thread A could be preempted and replaced by thread
> B on CPU 0.  This could even happen on exit from the membarrier()
> syscall.  If this happens, thread B will end up running on CPU 0 without
> having synced.
>
> In principle, this could be fixed by arranging for the scheduler to
> sync_core_before_usermode() whenever switching between two threads in
> the same mm if there is any possibility of a concurrent membarrier()
> call, but this would have considerable overhead.  Instead, make
> membarrier() sync the calling CPU as well.
>
> As an optimization, this avoids an extra smp_mb() in the default
> barrier-only mode.

Fixes: 70216e18e519 ("membarrier: Provide core serializing command,
*_SYNC_CORE")

also:

> +               /*
> +                * For regular membarrier, we can save a few cycles by
> +                * skipping the current cpu -- we're about to do smp_mb()
> +                * below, and if we migrate to a different cpu, this cpu
> +                * and the new cpu will execute a full barrier in the
> +                * scheduler.
> +                *
> +                * For CORE_SYNC, we do need a barrier on the current cpu --

s/CORE_SYNC/SYNC_CORE/

--Andy

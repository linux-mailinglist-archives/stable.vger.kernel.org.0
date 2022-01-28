Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B23E49FD05
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 16:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiA1Po0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 10:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiA1PoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 10:44:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C939C061714;
        Fri, 28 Jan 2022 07:44:25 -0800 (PST)
Date:   Fri, 28 Jan 2022 16:44:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643384664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y2SzC0yUOVfIVcM+MxRaqK8qU1jwTL1syaAIVFYo+U0=;
        b=QmtA4LlqGWJnBQPatE0PIf4JTssg9DE3CLbOwclIVW7Q1YDxY7tgqPjedICyozn/IfzzAY
        /V3FBVO8KCerpCOqeTj4XV13IW1fj2nRVKkxkIMW+ezTwnl62bjHqjMrFgauK+5MKicKT7
        xpiPoFgsl1u8Zxr9fDgefE9cvpaDZjxyXEXroTTCClMI3gVxpA24V4a4LFPoefrVZLvn76
        /MaLeY1d/5RWW9K5Wn8/Y2fEqAMGSw4C7J6Nw6YZQvkVCq72GoUy3/dM9AmOXRJRDPudnT
        zf4skOdSgPEmRXTwzY5Tmj2ITU7IRr6ax1WEfB7DlOS9Be+8XW5zreTufwgZ2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643384664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y2SzC0yUOVfIVcM+MxRaqK8qU1jwTL1syaAIVFYo+U0=;
        b=AiQa3oW5xtiOzJegxYWsSUSqEfGfhVkkPMhXBQLQymtKKBxh0sqBtHgpoEweIlpXYnvyra
        NRj2/1jFMMf/bgCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] random: remove batched entropy locking
Message-ID: <YfQPVp8TULSq3V+l@linutronix.de>
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
 <20220128153344.34211-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220128153344.34211-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-01-28 16:33:44 [+0100], Jason A. Donenfeld wrote:
> From: Andy Lutomirski <luto@kernel.org>
> 
> We don't need spinlocks to protect batched entropy -- all we need
> is a little bit of care. This should fix up the following splat that
> Jonathan received with a PROVE_LOCKING=y/PROVE_RAW_LOCK_NESTING=y
> kernel:

NO. Could we please look at my RANDOM patches first?
This affects PREEMPT_RT. There is no need to stuff this in and tag it
stable.

I can repost my rebased patched if there no objection.
This patch invokes extract_crng() with disabled interrupts so we didn't
gain anything IMHO.

Sebastian

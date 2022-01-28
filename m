Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D8949FD14
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 16:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349680AbiA1Psi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 10:48:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349674AbiA1Psg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 10:48:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCBAE61EAF;
        Fri, 28 Jan 2022 15:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04082C340E0;
        Fri, 28 Jan 2022 15:48:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kLRYDf9A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1643384911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=afS3WGdnGZ/VkOZ9tM3e4D9ZLBZhJx51UxfbNvv5dVY=;
        b=kLRYDf9AvET+nOKJMWCRZiMjVRTA9e+RZa039YYQbod5VAwz+SBrmIHoDbMd9eCixUNDFK
        GioAOYVs0AbECGWq478QgcRvmI2KQikVnA8Jb90tP4eDKLUrJkPC+s1LLpovHBQvrSzASL
        nyLZ3oATdbdjlizufAcctom6sebHTis=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8acf7f8a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 28 Jan 2022 15:48:30 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id i10so19645195ybt.10;
        Fri, 28 Jan 2022 07:48:30 -0800 (PST)
X-Gm-Message-State: AOAM5314+J7WpIL02GrP1qHhAnqbGW5ASMjPb1tjDTI79NsaBjrup/+P
        M05Iyhu+d8LhxmI+xUiRIsMOUyGVOc+bjXkZmu0=
X-Google-Smtp-Source: ABdhPJwLQ60clurEPTZzzpoZk727685/gP25/VhCSEi8LvcIcXO9SmQsDz6gEjQ705/XdbOU+I4lYWxtrFHY2yUowkg=
X-Received: by 2002:a25:ace0:: with SMTP id x32mr13836935ybd.255.1643384908760;
 Fri, 28 Jan 2022 07:48:28 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
 <20220128153344.34211-1-Jason@zx2c4.com>
In-Reply-To: <20220128153344.34211-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 28 Jan 2022 16:48:17 +0100
X-Gmail-Original-Message-ID: <CAHmME9pe2BEJV4WiZNHmDmH_XK621Qqr1JCBdgTNZmr4JGBA4w@mail.gmail.com>
Message-ID: <CAHmME9pe2BEJV4WiZNHmDmH_XK621Qqr1JCBdgTNZmr4JGBA4w@mail.gmail.com>
Subject: Re: [PATCH] random: remove batched entropy locking
To:     Andy Lutomirski <luto@amacapital.net>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andy,

On Fri, Jan 28, 2022 at 4:34 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Andy - could you take a look at this and let me know if it's still
> correct after I've ported it out of your series and into a standalone
> thing here? I'd prefer to hold off on moving forward on this until I
> receive our green light. I'm also still a bit uncertain about your NB:
> comment regarding the acceptable race. If you could elaborate on that
> argument, it might save me a few cycles with my thinking cap on.
[...]
> +       position = READ_ONCE(batch->position);
> +       /* NB: position can change to ARRAY_SIZE(batch->entropy_u64) out
> +        * from under us -- see invalidate_batched_entropy().  If this,
> +        * happens it's okay if we still return the data in the batch. */
> +       if (unlikely(position + 1 > ARRAY_SIZE(batch->entropy_u64))) {
>                 extract_crng((u8 *)batch->entropy_u64);
> -               batch->position = 0;
> +               position = 0;

So the argument for this is something along the lines of -- if the
pool is invalidated _after_ the position value is read, in the worst
case, we read old data, and then we set position to value 1, so the
remaining reads _also_ are of invalidated data, and then eventually
this depletes and we get newly extracted data? So this means that in
some racey situations, we're lengthening the window during which
get_random_u{32,64}() returns bad randomness, right?

Couldn't that race be avoided entirely by something like the below?

Jason

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 50c50a59847e..664f1a7eb293 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2082,14 +2082,15 @@ u64 get_random_u64(void)
  u64 ret;
  unsigned long flags;
  struct batched_entropy *batch;
- unsigned int position;
+ unsigned int position, original;
  static void *previous;

  warn_unseeded_randomness(&previous);

  local_irq_save(flags);
  batch = this_cpu_ptr(&batched_entropy_u64);
- position = READ_ONCE(batch->position);
+try_again:
+ original = position = READ_ONCE(batch->position);
  /* NB: position can change to ARRAY_SIZE(batch->entropy_u64) out
  * from under us -- see invalidate_batched_entropy().  If this
  * happens it's okay if we still return the data in the batch. */
@@ -2098,6 +2099,8 @@ u64 get_random_u64(void)
  position = 0;
  }
  ret = batch->entropy_u64[position++];
+ if (unlikely(cmpxchg(&batch->position, original, batch) != original))
+ goto try_again;
  WRITE_ONCE(batch->position, position);
  local_irq_restore(flags);
  return ret;

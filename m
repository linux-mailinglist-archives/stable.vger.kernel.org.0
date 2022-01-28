Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE13449FD27
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 16:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349705AbiA1PyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 10:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243235AbiA1PyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 10:54:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDF2C061714;
        Fri, 28 Jan 2022 07:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 802E760EE2;
        Fri, 28 Jan 2022 15:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9402CC340EA;
        Fri, 28 Jan 2022 15:54:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EKRHKL+b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1643385259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IrsMD9OsKnJJ5L2qqq1WV5CMlphc6Ingdz/kQiF3QcQ=;
        b=EKRHKL+bbc7MI4YgCyb3InTqglzkXHpilwRMb/jA71BbCD70Izf+VA5yL9jE+xB445nS1p
        4+zpnSDTATTfRj9nno35fxSKgUf6Or1nY0EAW4lU0de7DdYokzkfe6lq3LmfEgWr1zfwuL
        JeimoivF/QDg0F3i3ewBtUFLkh/SqOc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 416aa0ab (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 28 Jan 2022 15:54:19 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id r65so19629923ybc.11;
        Fri, 28 Jan 2022 07:54:18 -0800 (PST)
X-Gm-Message-State: AOAM532RgbxPWqXkNTV0V/ZU6LNoshsHoZbOhJVxZ/kFTO9WXgR79kT4
        e6T9IGz/Lad19yVjcXqa+iB6b2ereOeE9AOrwUU=
X-Google-Smtp-Source: ABdhPJwQEp72NgKzBtMW8AWhE5kN/yjyXnCzJm7PZHhYkzLlNhnifjowLdZ+skVQ3dDAKPtVT+GCbcsj5iIZNIhTMNc=
X-Received: by 2002:a25:bd08:: with SMTP id f8mr5998167ybk.121.1643385257209;
 Fri, 28 Jan 2022 07:54:17 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
 <20220128153344.34211-1-Jason@zx2c4.com> <YfQPVp8TULSq3V+l@linutronix.de>
In-Reply-To: <YfQPVp8TULSq3V+l@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 28 Jan 2022 16:54:06 +0100
X-Gmail-Original-Message-ID: <CAHmME9pmdeLBKJbTaVQv-z9J81qKA=R4uoZ1DeXABy6Lt3bXuA@mail.gmail.com>
Message-ID: <CAHmME9pmdeLBKJbTaVQv-z9J81qKA=R4uoZ1DeXABy6Lt3bXuA@mail.gmail.com>
Subject: Re: [PATCH] random: remove batched entropy locking
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sebastian,

On Fri, Jan 28, 2022 at 4:44 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> NO. Could we please look at my RANDOM patches first?
> I can repost my rebased patched if there no objection.

I did, and my reply is here:
https://lore.kernel.org/lkml/CAHmME9pzdXyD0oRYyCoVUSqqsA9h03-oR7kcNhJuPEcEMTJYgw@mail.gmail.com/

I was hoping for a series that addresses these issues. As I mentioned
before, I'm not super keen on deferring that processing in a
conditional case and having multiple entry ways into that same
functionality. I don't think that's worth it, especially if your
actual concern is just userspace calling RNDADDTOENTCNT too often
(which can be safely ratelimited). I don't think that thread needs to
spill over here, though, so feel free to follow up with a v+1 on that
series and I'll happily take a look. Alternatively, if you'd like to
approach this by providing a patch for Jonathan's issue, that makes
sense too. So far, the things in front of me are: 1) your patchset
from last month that has unresolved issues, and 2) Andy's thing, which
maybe will solve the problem (or it won't?). A third alternative from
you would be most welcome too.

Jason

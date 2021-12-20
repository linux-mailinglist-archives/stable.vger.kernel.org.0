Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C38347B554
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 22:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhLTVpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 16:45:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37386 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhLTVpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 16:45:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF48561312;
        Mon, 20 Dec 2021 21:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C27C36AE8;
        Mon, 20 Dec 2021 21:45:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KpsP/GlJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1640036726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aA2Bl8evLjGGLtxFv2VrCQNlAHwiK5GW7WhSRj3VUIA=;
        b=KpsP/GlJbL0+yzA2Iher3Hy8QlOOiE2ft46o2FA5DyalTUS+Oei0RX8pZq/t+tEHUz0LCU
        ZERubS26ayyaxpXk2PiehOxPLhSynEKQ0GmCdYyFx7qawrTbNdQjnL/j2DGtjCOhO3jy62
        E0I65Q79GtCBMnKgjYvqJA/CQHR8Ik4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c6b62022 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 20 Dec 2021 21:45:26 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id x32so32731086ybi.12;
        Mon, 20 Dec 2021 13:45:26 -0800 (PST)
X-Gm-Message-State: AOAM530g3R+OR3GtxjFXT8KQUwS+uoBCapdMjvAi+2KifKLYqeTNfI85
        15W6Bf19fnYWpogQC1aTQcWUoFshsiVr+Aa7YLA=
X-Google-Smtp-Source: ABdhPJxLKGQm5lMId5634PD84twG9X59MZjnL5UC/sVtnNLiFgqyWB1zG3BW3zDC83GJRsOF0suJiDM4LnT2II2osC0=
X-Received: by 2002:a25:d393:: with SMTP id e141mr192518ybf.255.1640036725620;
 Mon, 20 Dec 2021 13:45:25 -0800 (PST)
MIME-Version: 1.0
References: <20211219025139.31085-1-ebiggers@kernel.org> <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
 <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1> <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
 <20211220183140.GC641268@paulmck-ThinkPad-P17-Gen-1> <YcDM2cpwiGCb56Gp@quark> <20211220190004.GD641268@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20211220190004.GD641268@paulmck-ThinkPad-P17-Gen-1>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Dec 2021 22:45:15 +0100
X-Gmail-Original-Message-ID: <CAHmME9rv9RZai-0diV6kdc9yfXRog29QiStEzDpC9v25OWY81Q@mail.gmail.com>
Message-ID: <CAHmME9rv9RZai-0diV6kdc9yfXRog29QiStEzDpC9v25OWY81Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for crng_node_pool
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On Mon, Dec 20, 2021 at 8:00 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> This assumes that the various crng_node_pool[i] pointers never change
> while accessible to readers (and that some sort of synchronization applies
> to the values in the pointed-to structure).  If these pointers do change,
> then there also needs to be a READ_ONCE(pool[nid]) in select_crng(), where
> the value returned from this READ_ONCE() is both tested and returned.
> (As in assign this value to a temporary.)
>
> But if the various crng_node_pool[i] pointers really are constant
> while readers can access them, then the cmpxchg_release() suffices.
> The loads from pool[nid] are then data-race free, and because they
> are unmarked, the compiler is prohibited from hoisting them out from
> within the "if" statement.  The address dependency prohibits the
> CPU from reordering them.

Right, this is just an initialization-time allocation and assignment,
never updated or freed again after.

> So READ_ONCE() should be just fine.  Which answers Jason's question.  ;-)

Great. So v2 of this patch can use READ_ONCE then. Thanks!

> Looking at _extract_crng(), if this was my code, I would use READ_ONCE()
> in the checks, but that might be my misunderstanding boot-time constraints
> or some such.  Without some sort of constraint, I don't see how the code
> avoids confusion from reloads of crng->init_time if two CPUs concurrently
> see the expiration of CRNG_RESEED_INTERVAL, but I could easily be missing
> something that makes this safe.  (And this is irrelevant to this patch.)

Indeed init_time seems to race via the crng_reseed path, and
READ_ONCE()ing that seems reasonable. The other setters of it --
initialize_{primary,secondary} -- are in the boot path.

Jason

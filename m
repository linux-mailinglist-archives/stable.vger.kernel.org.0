Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA03823C2DA
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 03:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgHEBCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 21:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgHEBCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 21:02:40 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89624C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 18:02:39 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id v12so15389642ljc.10
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 18:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hs9W9L5qpq2R+TvR0kUnYEwJzpiFvPtYd1/wFxmYVBk=;
        b=Kx953I5bRL4bVidV0oKIvBtGTnSGPKxsodb54W6hxL4/CYqPdJIljl56vxXkep72Xw
         P4OD/p48jGd/W5M33jhVmYcuxxZzj6WiWMVm0LupsFNF3jz6B9bRa1+GqGb/FOKNdNoz
         61DOhhRiURE/XsRaMXMf4VljeWPfXRfMzqvNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hs9W9L5qpq2R+TvR0kUnYEwJzpiFvPtYd1/wFxmYVBk=;
        b=oL3RY8NTsZgdG0B35ljjEemixBkW4sHojLpRAIzFAK2EtBQ8+RyIUWdzqLHeNT9KOy
         vx43uFeVAniLO3Rx62ptmnSYUleXdnYDqg+XCHL+9d0PSjDk3MQS0trqMz7/GVJ78Myu
         as8/xD+CDOFybQdEzujdL/DU70Ufen8gfmpFdBLJNBi9TLuOx22EatH1sVhOG2tordNI
         bxDON6t5S4imHIQatNh2t6wD04orPSuuvF1oKb6jkBmjmk9LCAbb1pqafSh1d7qPIYCT
         wEFzuYTOFRdXUQ9frM72xK5Ysa7UwygwNLHVSExdxWaL0zTInT7RUDBAuqvcluvg4l+r
         woSQ==
X-Gm-Message-State: AOAM530whNYSZMWKZ1QY3KrsEWccLGssErm1lc9vM5EIq7eEMN/7831N
        7beIOBDlJblYbm/fUQ3mKfCB5kgH340=
X-Google-Smtp-Source: ABdhPJwR7kC4s3Ml+qqDMNjTXGGgGHQAncGMteLE0TJayJ8vMWq+6+hN6pSFflIGxGxVAUTlJgsmGg==
X-Received: by 2002:a2e:9bcd:: with SMTP id w13mr198258ljj.189.1596589357370;
        Tue, 04 Aug 2020 18:02:37 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id t18sm143371ljc.126.2020.08.04.18.02.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 18:02:35 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id w25so10264658ljo.12
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 18:02:34 -0700 (PDT)
X-Received: by 2002:a2e:545:: with SMTP id 66mr210542ljf.285.1596589354467;
 Tue, 04 Aug 2020 18:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
In-Reply-To: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Aug 2020 18:02:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiKiE1RvJ9mRYg5y94eC5RVmw+GHmy9B9zHZkZo0w0sNA@mail.gmail.com>
Message-ID: <CAHk-=wiKiE1RvJ9mRYg5y94eC5RVmw+GHmy9B9zHZkZo0w0sNA@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 4, 2020 at 5:52 PM Marc Plumb <lkml.mplumb@gmail.com> wrote:
>
> TL;DR This change takes the seed data from get_random_bytes and broadcasts it to the network, thereby destroying the security of dev/random. This change needs to be reverted and redesigned.

This was discussed.,

It's theoretical, not practical.

The patch improves real security, and the fake "but in theory" kind is
meaningless and people should stop that kind of behavior.

                Linus

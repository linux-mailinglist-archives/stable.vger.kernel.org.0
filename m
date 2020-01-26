Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F2C149C58
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 19:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAZSiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 13:38:54 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33977 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgAZSix (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 13:38:53 -0500
Received: by mail-yw1-f65.google.com with SMTP id b186so3719922ywc.1
        for <stable@vger.kernel.org>; Sun, 26 Jan 2020 10:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i69aVqNtUh0aH4/EUSRDvf/FER9Hz68ISkhaUxUzTl0=;
        b=rMfvEh8T4b186lRHcWlnCCdlJg9db7RjBiyF5TCaQz1NcahGJQ7eCMmDE/JxwOTl7b
         LHizr5TWq5uqwSzp8Xk0MsEgWlBAejc5L0ULiKQk/ZD9n2y0doi/z55xP00bj3yv3Ava
         L1t7HDea0d8F2i15NqsG2tcjSbJpeFciT4k6Js5l0jnPrIJaQ1FOAirbv1uves9uyh2Z
         o3144kE6biOVCtOgZVGZn6xIrQgN6laceEyhtJJnAEV5rVe9ujeKKBx7s3pYa1nxQgzf
         K2Sjc9L5ypLwirkXI9cgkeeANEbDCpTBHHhXM+dSdh4vjzNWV6apbmPXhJ3d+idb2OX+
         959g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i69aVqNtUh0aH4/EUSRDvf/FER9Hz68ISkhaUxUzTl0=;
        b=GolzSIEjW/f7gBBcGFlXSX8irLwIe7OH2nhizcUmJaig5iQhRjq6cMba7buF74d/Ci
         WW4KjDZ0M2WqKSdd6S2BIjPCEN8INOi2MNdj1gxPe5BzdvRuA26jNxUcFrhxrWdimgW9
         eZS51f131x98ueRjDwPpP21lKs3nky8Hqmz1Mfky5owy6oE/cRrfl92JsUcnCWYH0bIY
         T2ERbYQ+QN3xUqSOJLZT10C4OrufUwD5dHpSlKhVWP6toBUhIE74RpXFvDUcyqdDJwWR
         rTye1hbA2YHhd5PIFkbXuw9nicx5v8DSHPDYeVyhtEPHqtSg5Z/vBlUP37YWCXYS6G/g
         Im0g==
X-Gm-Message-State: APjAAAUxKuhMowql4CoJ82BeCBP3Z5TbX8359MPUvw1wshb/r2Ire7z/
        DBYFao1uQH9/5NHmGpOtgQ7wRsukCyRbHYVw0irsCw==
X-Google-Smtp-Source: APXvYqyWhEZHHYbOhHnC3t0Y6vH6sqNyRu0S2xuvfX0uCPx5pSn6uW89RhMOwvFd1iBNaWGKbGJxIM0/hZDazU7SBIc=
X-Received: by 2002:a81:53d7:: with SMTP id h206mr8970498ywb.92.1580063932400;
 Sun, 26 Jan 2020 10:38:52 -0800 (PST)
MIME-Version: 1.0
References: <20200124093047.008739095@linuxfoundation.org> <20200124093207.912523612@linuxfoundation.org>
 <20200126182917.GA26911@amd>
In-Reply-To: <20200126182917.GA26911@amd>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 26 Jan 2020 10:38:41 -0800
Message-ID: <CANn89iKTYMT8T5tOPmk0j4emHt2gCbJD9Dpjf=5LR88zC1tu4A@mail.gmail.com>
Subject: Re: [PATCH 4.19 625/639] packet: fix data-race in fanout_flow_is_huge()
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 26, 2020 at 10:29 AM Pavel Machek <pavel@denx.de> wrote:
>
>
> > -     po->rollover->history[prandom_u32() % ROLLOVER_HLEN] = rxhash;
> > +     victim = prandom_u32() % ROLLOVER_HLEN;
> > +
> > +     /* Avoid dirtying the cache line if possible */
> > +     if (READ_ONCE(history[victim]) != rxhash)
> > +             WRITE_ONCE(history[victim], rxhash);
> > +
>
> Replacing simple asignment with if() is ... not nice and with all the
> "volatile" magic in _ONCE macros may not be win for
> everyone. [Actually, I don't think this is win here. This is not
> exactly hot path, is it?


This is a critical hot path, eg under DDOS attack.

>
> If this is going to get more common, should we get
> WRITE_ONCE_NONDIRTY() macro hiding the uglyness?
>

Sure, but we do not add macros for stable patches, usually.

Honestly, WRITE_ONCE_NONDIRTY() looks ugly to me.

Note that the KCSAN race might be solved in another way when
data_race() is available.

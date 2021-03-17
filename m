Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385F233E8CA
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 06:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCQFKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 01:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCQFKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 01:10:32 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A52C06174A;
        Tue, 16 Mar 2021 22:10:21 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id w11so13932805iol.13;
        Tue, 16 Mar 2021 22:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNLwJfGbNynxup/obYAsvOvgiuDkV2f8BaYfNVcffPM=;
        b=YAk5/MfvHIGS7MkYlXyTvIO+qdfu8BBV+rneab67kW/2ZCQackKZeZZf/DIr8CjCDV
         Bh8Blj3fvftJ4EoSWw+oilpWj4kX1mTWL1qYvc7dBQKEwQVAIgZD8Qb5+KXMT1/ufKl3
         iowZhk7htmgM4tsh9ebKCEts0EkobI4Xxc5WlIK10GIRTKq+sZfZxHCFPqI0lOs5CHrM
         191XwZsobT3genR1BokEcQsONxxg8TTTdDo7g0gt/9DVj7OkGQH/CRoed76wnAlfc3S0
         X3j4Hemwqt5CeefXjUwHCDg3bZza2IOMaa2mJLLzePbRiN7k5wsN15tH0EUxbabhDP4m
         8MoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNLwJfGbNynxup/obYAsvOvgiuDkV2f8BaYfNVcffPM=;
        b=rEUe75pXG79bbLJBf0gn9cb1DktJ8L9nFbF8oRLPPR2865cIf4oEBDjJsDEZRvjQR9
         iANg3LFwWxFR+2rxY8EgSVfinzHk10Q7h8ppx9fV2qF0VlIx9khMHsnvcz6rQvp9hHoC
         0YlHxMKKxMs6VaeC+G1rtgi02g9AnSCGvJVnh48hwWgOhorUZ/mh4tApU+6LbPx568if
         Zp/gDjHoFdr0z2BIPAGBfZtVzyWVh87spT00vPvV3NK5q4ydryNXymdMlFZza7krcqyR
         tV4Gk6Fr2WzFttyMBCgRjgeqCCPd7RHlCsGebtZmi5HFTHOjAqRkH7hitMviFjdihujJ
         eWoA==
X-Gm-Message-State: AOAM531aw9mgyzIOJc82Z8Nr7ANvsPPMHBIfD8VD/q7H8B45y8Ycz+pD
        2//QJEi5wnuDkGYUJF5n5zNowRHzaNhH5ojk4PM=
X-Google-Smtp-Source: ABdhPJypXsjxePYqCHgTaK6qLrOWAykSLOcbTfiGgwTA+1EUVIL1Js3JhmAO71gdE78+I+htFFWVRj3cmUZ0MLeWdx0=
X-Received: by 2002:a05:6638:11c8:: with SMTP id g8mr1629159jas.38.1615957820860;
 Tue, 16 Mar 2021 22:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com> <20210312151934.GA4209@alpha.franken.de>
In-Reply-To: <20210312151934.GA4209@alpha.franken.de>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Tue, 16 Mar 2021 22:10:09 -0700
Message-ID: <CALCv0x1AEZanNsVcNuUrbHuLyWYNegEVuye9Gso-Ou9xX8JEAg@mail.gmail.com>
Subject: Re: [PATCH] MIPS: fix memory reservation for non-usermem setups
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Mike Rapoport <rppt@kernel.org>,
        Youling Tang <tangyouling@loongson.cn>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

On Fri, Mar 12, 2021 at 7:19 AM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> On Sun, Mar 07, 2021 at 11:40:30AM -0800, Ilya Lipnitskiy wrote:
> > From: Tobias Wolf <dev-NTEO@vplace.de>
> >
> > Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
> > issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
> > not. As the prerequisite of custom memory map has been removed, this results
> > in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
> > platform.
>
> and where is the problem here ?
Turns out this was already attempted to be upstreamed - not clear why
it wasn't merged. Context:
https://lore.kernel.org/linux-mips/6504517.U6H5IhoIOn@loki/

I hope the thread above helps you understand the problem.

>
> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
> good idea.                                                [ RFC1925, 2.3 ]
Ilya

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2F2319290
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBKSy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhBKSxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 13:53:54 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B045C0613D6
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 10:53:14 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r38so4523571pgk.13
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 10:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=xpndM70yEhgRGe+KrDE0IH979jxYXm9ttbsYqDRk0G8=;
        b=E06KTUuHa1N69lin9dfmfYrh3O7liQ7sjr9V4elOQ0pI9DtEuIM5pG2uYR0na8s/M6
         y1xZbYr2CEvGVbC36Tob7tY+JTq4jDUSnRPaiBUr+DKoYI+5ba5OITaRwuNTJOTAPFSG
         Aovxw10AMACoyXiGbcmoGniQfdbGRwP+Kg0gM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=xpndM70yEhgRGe+KrDE0IH979jxYXm9ttbsYqDRk0G8=;
        b=Lnxqh2bX6g9MgpEnoptehFn6MOkNpNw8BuwBoyM7r27NKgQqLYfkXyVDYbtkvh1UgW
         5jqZ9fSmLOZhgY7ains9EAkLHRJ1Uza4p88cCic9gyGn0qqcLTFsWwyrAH7HJ40edBwg
         E8rSs8VoUIAoZxesr5Jn7jLpMYhoeCMUeBuTHfGyiXnHC4qkZwhmzHXMcTTGw/YHc+hy
         dsT31l27CC2S8BmwswcagaM83FsLuaGjmHhQEVS13AbO5DyhJaWmXqIQbrCUaMJCTctE
         jHxxe9blZ8JYBa51R7wfaBdAPVUQ80WALUpw8vdYcYSkBbjNuDq/fJ7h260NiCXLn6I4
         iIhQ==
X-Gm-Message-State: AOAM530aXvJBKgJhK0SI3T6IUZ5x12nM3NG6GI46xkfwc98kJFpXgM+T
        Ge2CmEyWmmknhKm1RbqW4E1P3txbqP+kAg==
X-Google-Smtp-Source: ABdhPJw8Blpx5814w0cjHHgcrzerf/Iogn69/ocypYsIcg51r8DSqgTTrtUWGhhJ72/bqO6V3z8odA==
X-Received: by 2002:a65:654e:: with SMTP id a14mr9560819pgw.265.1613069593951;
        Thu, 11 Feb 2021 10:53:13 -0800 (PST)
Received: from chromium.org ([2620:15c:202:201:f038:5688:cf3c:eca2])
        by smtp.gmail.com with ESMTPSA id t17sm6812101pfc.43.2021.02.11.10.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 10:53:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YCU9zoiw8EZktw5U@kroah.com>
References: <20201207170533.10738-1-mark.rutland@arm.com> <202012081319.D5827CF@keescook> <X9DkdTGAiAEfUvm5@kroah.com> <161300376813.1254594.5196098885798133458@swboyd.mtv.corp.google.com> <YCU9zoiw8EZktw5U@kroah.com>
Subject: Re: [PATCH] lkdtm: don't move ctors to .rodata
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 11 Feb 2021 10:53:10 -0800
Message-ID: <161306959090.1254594.16358795480052823449@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg Kroah-Hartman (2021-02-11 06:23:10)
> On Wed, Feb 10, 2021 at 04:36:08PM -0800, Stephen Boyd wrote:
> > Quoting Greg Kroah-Hartman (2020-12-09 06:51:33)
> > > On Tue, Dec 08, 2020 at 01:20:56PM -0800, Kees Cook wrote:
> > > > On Mon, Dec 07, 2020 at 05:05:33PM +0000, Mark Rutland wrote:
> > > > > [    0.969110] Code: 00000003 00000000 00000000 00000000 (0000000=
0)
> > > > > [    0.970815] ---[ end trace b5339784e20d015c ]---
> > > > >=20
> > > > > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > > >=20
> > > > Oh, eek. Why was a ctor generated at all? But yes, this looks good.
> > > > Greg, can you pick this up please?
> > > >=20
> > > > Acked-by: Kees Cook <keescook@chromium.org>
> > >=20
> > > Now picked up, thanks.
> > >=20
> >=20
> > Can this be backported to 5.4 and 5.10 stable trees? I just ran across
> > this trying to use kasan on 5.4 with lkdtm and it blows up early. This
> > patch applies on 5.4 cleanly but doesn't compile because it's missing
> > noinstr. Here's a version of the patch that introduces noinstr on 5.4.97
> > so this patch can be picked to 5.4 stable trees.
>=20
> Why 5.10?  This showed up in 5.8, so how would it be needed there?
>=20

Sorry for the confusion. Can commit 655389666643 ("vmlinux.lds.h: Create
section for protection against instrumentation") and commit 3f618ab33234
("lkdtm: don't move ctors to .rodata") be backported to 5.4.y and only
commit 3f618ab3323407ee4c6a6734a37eb6e9663ebfb9 be backported to 5.10.y?

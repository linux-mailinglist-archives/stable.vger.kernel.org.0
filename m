Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FD03560C6
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 03:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbhDGB2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 21:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241671AbhDGB2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 21:28:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B26E2613B8;
        Wed,  7 Apr 2021 01:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617758888;
        bh=PowQgY+FTn7JM/00BcajwX6+VQTJ+Mq/Og64k1ejIYM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oawohLPY3rZO4TNrFbk8FmWv6PzyjaMC4J7e+sQIpqgoI0GkaNAlhoj91CEDjlWZd
         l0knWgGylEfNaFkrgrGj2kHbJ9yFkcNtc7nrgKK/v+2zGwzQ4b+qGekhG7jvlak0c6
         F5RzQ886bVLWZk2We/ZhKf9uI9oo3c7Tz8rWMiKDb8ZPYyDJx2+fzdG3QqPh9Ef2z4
         iCD7/OSU5FHajIOCwv2+3n8YrFrRlbXMWRup2LNKi/qCyVN6ZyRRMHArwzWpPsVrK2
         O30+plUPoXOHBCaF1Zki9Vw+4gwr38InbEuW31hDreCn2yafTIIm/bMV9bi7hQktqO
         XVABjY/ool/Fw==
Received: by mail-io1-f51.google.com with SMTP id k25so10686989iob.6;
        Tue, 06 Apr 2021 18:28:08 -0700 (PDT)
X-Gm-Message-State: AOAM531Guzp++j9bAUjBiVcGjq3O/mjiKJDI3A/Kh4eUdbYfQGHcHlg8
        EQowm5/JV3bIk1XLpeJyM75Epiqqj0DZQPWFEgc=
X-Google-Smtp-Source: ABdhPJyXBZLf9DhJU2QHoeSBAEYxnoq5v6SR1fhDOQKnwqaJDWCv0pXFlRZZZmRbOZNYVUCqbpW+07lvPyH23iky6zk=
X-Received: by 2002:a02:6a09:: with SMTP id l9mr920069jac.57.1617758887925;
 Tue, 06 Apr 2021 18:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210406112404.2671507-1-chenhuacai@loongson.cn>
 <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com> <3e27d0e0-4494-7a94-e0d7-046fb8898603@wanyeetech.com>
 <alpine.DEB.2.21.2104062343250.65251@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2104062343250.65251@angie.orcam.me.uk>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Wed, 7 Apr 2021 09:27:55 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7V2ykFqCv8n8pYs1ujbUYNy5UqPu21VPyj_Qzx5y8upQ@mail.gmail.com>
Message-ID: <CAAhV-H7V2ykFqCv8n8pYs1ujbUYNy5UqPu21VPyj_Qzx5y8upQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Zhou Yanjie <zhouyu@wanyeetech.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        stable <stable@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Maciej,

On Wed, Apr 7, 2021 at 6:22 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> On Tue, 6 Apr 2021, Zhou Yanjie wrote:
>
> > So it seems not a compiler problem.
>
>  This code is rather broken in an obvious way, starting from:
>
>         unsigned long long __n;                                         \
>                                                                         \
>         __high = *__n >> 32;                                            \
>         __low = __n;                                                    \
>
> where `__n' is used uninitialised.  Since this is my code originally I'll
> look into it; we may want to reinstate `do_div' too, which didn't have to
> be removed in the first place.
I think we can reuse the generic do_div().

>
>  Also commit e8e4eb0fbeda ("asm-generic/div64: Fix documentation of
> do_div() parameter") was an incomplete documentation fix.
>
>  Huacai, thanks for your investigation!  Please be more careful in
> verifying your future submissions however.
Sorry, I thought there is only one bug in div64.h, but in fact there
are three...

Huacai
>
>   Maciej

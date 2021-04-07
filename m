Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3956B35606B
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 02:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhDGAlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 20:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233744AbhDGAlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 20:41:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D28461106;
        Wed,  7 Apr 2021 00:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617756065;
        bh=ClfmhSxWsk2cvFKRhp/WqP8w8St2XoJv2CR6bDgN1SM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bbApIkNrYoBTwLYLbw6W6N2X28kn8G9wOs9khtCxflccrxBwIiwndVbCU7lgxS2YX
         FW+X6ky4GyeoCTaBICvrE3w5Ev2EupFK/fM28cGMbaqRbTXMPix4AKfP/hvZDwcpWH
         6lS4SoYbgh50hiiVY8lpuClVWXv5KcfIo8JH2bRk9FKIhNxj43VjmtUa9J1KZrJXxR
         +JNE6wpWP+njmqAIUlUE5c3cbOrUGdElOVlVk0ztZpAi1qroWIuUc2UC7XZd9rUwXK
         P5nKguOgFXf9IGClBnlZMbUX97bLcoLQjUFlMk/ybP4HwiphMR440Huhdg7CGmvwEc
         g96D0rdIMJwBQ==
Received: by mail-il1-f172.google.com with SMTP id o15so10635607ilf.11;
        Tue, 06 Apr 2021 17:41:05 -0700 (PDT)
X-Gm-Message-State: AOAM532JFxWqZrwMI/GjYPY951rya/XfeD9CY0gsKPjxN8R1s11EyP+M
        D/un5ZFhT3bspZkjInPyV1iSOhH1AU1dnZsk4kc=
X-Google-Smtp-Source: ABdhPJypL60bLSiVBYRkgz6k+jGhpTouYi/kRkIhWLvBEzqbSvey65r0AwUlOKS60OJ1skP2UynKOKOa+EGod3SXbhE=
X-Received: by 2002:a92:cb86:: with SMTP id z6mr718436ilo.35.1617756065098;
 Tue, 06 Apr 2021 17:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210406112404.2671507-1-chenhuacai@loongson.cn> <20210406130629.GE9505@alpha.franken.de>
In-Reply-To: <20210406130629.GE9505@alpha.franken.de>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Wed, 7 Apr 2021 08:40:53 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7-e_Nt-yEYo1d+fTMpVaqGYfY7Q29H-2F-4aPXBUMz-Q@mail.gmail.com>
Message-ID: <CAAhV-H7-e_Nt-yEYo1d+fTMpVaqGYfY7Q29H-2F-4aPXBUMz-Q@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "open list:MIPS" <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Thomas,


On Tue, Apr 6, 2021 at 9:18 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> On Tue, Apr 06, 2021 at 07:24:03PM +0800, Huacai Chen wrote:
> > Only 32bit kernel need __div64_32(), but commit c21004cd5b4cb7d479514d4
> > ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.") makes it depend
> > on 64bit kernel by mistake. This patch fix this longstanding error.
> >
> > Fixes: c21004cd5b4cb7d479514d4 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >  arch/mips/include/asm/div64.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
> > index dc5ea5736440..d199fe36eb46 100644
> > --- a/arch/mips/include/asm/div64.h
> > +++ b/arch/mips/include/asm/div64.h
> > @@ -11,7 +11,7 @@
> >
> >  #include <asm-generic/div64.h>
> >
> > -#if BITS_PER_LONG == 64
> > +#if BITS_PER_LONG == 32
>
> are you sure this will make a difference ? asm-generic/div64.h checks
> for __div64_32, which is not defined before including it here.
Sorry for my carelessness, the #include should be after __div64_32,
and there are other bugs in this file, I will send a new version.

Huacai
>
> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
> good idea.                                                [ RFC1925, 2.3 ]

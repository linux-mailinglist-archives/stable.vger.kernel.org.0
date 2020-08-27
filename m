Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551A4254D18
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 20:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgH0Sav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgH0Sau (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 14:30:50 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DE8C06121B
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 11:30:50 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mw10so3039864pjb.2
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 11:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3fcEiNsK377lJ2U8rpSs38iDBS2ZV98GwCjqRo1vxUY=;
        b=kxRn8GVthzhJNiLIz156XdWb3wvc3qTHVG9KcCKr+IO7FagquqdJ1dWSYNWNdmt0Vf
         p+fSBDp8sDifTZp1vPQDf2PNCSKwwftZSz0EfVY8VBi13qDFdgWXoHCLtGslwTzzIVmO
         iJJxRN4WrxzQChuKCzRqiBoaJ0EcTbYK/N9VM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3fcEiNsK377lJ2U8rpSs38iDBS2ZV98GwCjqRo1vxUY=;
        b=q2TLju1PGFjFXY3R4Ve/SidA0RKaY1UXHjchX9v51sqauJo68M5JYLWgiUstjiOSrf
         D1ky7PO5r5CNQmR3Ydtus41qSPxi/WvOUr8LHU3nwbXXaQYZQ1acodbDfMR3Hx5Q2HYh
         eAgJ2Pj4M2mSWT1PBjdP+lNMsVFPg85Ct+nwfIeMgZN2v+4XXEnFda4Kkx1TCiXqj9BJ
         aXVJnpE02gH7xhLL7LPWwRje1ER9WpXnb5NpaWku3fANwn1/M10YMrcgRwrbAqWvMs5x
         Pb9CdS7EOy6ez1bZ/Tvr7dXMsQvVM0tR54bn0DQoz3jGneZe1nUQvdAeVH/zU+GwwVws
         Os+Q==
X-Gm-Message-State: AOAM530ZK4fvrnz8nVyzrzn4r/F2U0ah1M032CvJUiV9iEde4dwzH8bp
        scH8KCv5jJDeCaiQZYXVXEFo5A==
X-Google-Smtp-Source: ABdhPJxKzsjx666MA955Hh/7QaQiVKOQT26Dg2evOJ5w+/mVexkWKFYPBarCeIf40FclUKYXIp0zDg==
X-Received: by 2002:a17:90a:c704:: with SMTP id o4mr150099pjt.146.1598553050196;
        Thu, 27 Aug 2020 11:30:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k5sm3139734pgk.78.2020.08.27.11.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 11:30:48 -0700 (PDT)
Date:   Thu, 27 Aug 2020 11:30:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
Message-ID: <202008271126.2C397BF6D@keescook>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook>
 <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 11:59:24AM +0300, Andy Shevchenko wrote:
> strcpy() is not a bad API for the cases when you know what you are
> doing. A problem that most of the developers do not know what they are
> doing.
> No need to split everything to bad and good by its name or semantics,
> each API has its own pros and cons and programmers must use their
> brains.

I equate "unsafe" or "fragile" with "bad". There's no reason to use our
brains for remembering what's safe or not when we can just remove unsafe
things from the available APIs, and/or lean on the compiler to help
(e.g. CONFIG_FORTIFY_SOURCE).

Most of the uses of strcpy() in the kernel are just copying between two
known-at-compile-time NUL-terminated character arrays. We had wanted to
introduce stracpy() for this, but Linus objected to yet more string
functions. So for now, I'm aimed at removing strlcpy() completely first,
then look at strcpy() -> strscpy() for cases where target size is NOT
compile-time known, and then to convert the kernel's strcpy() into
_requiring_ that source/dest lengths are known at compile time.

And then tackle strncpy(), which is a mess.

-- 
Kees Cook

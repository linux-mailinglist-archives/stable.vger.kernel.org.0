Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F052253A85
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 01:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHZXAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 19:00:49 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:58738 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbgHZXAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 19:00:48 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 07QN0NgL010554;
        Thu, 27 Aug 2020 08:00:23 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 07QN0NgL010554
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1598482823;
        bh=sACWlafBGUgCIkfb1+UQoBai0rXGJ0Q7gCQT2fF8M2M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fXobgc/qmGs4jiZd5F2ZRYLNWbwCnMbOoAHaNawvCu3J3ONitwW+/OulF7UlsldNd
         u4agZjeB4yyoiwvWPjXewANZx0VxBul2/7xEw0Zjx8apWdrUR8Mj4ViruIL2SjtiVz
         8x2NE7WnzDnG+11JkQPViszSvgdP7m9IgqbuVeFiVu+L0k86PgBQMBsz3dP0//Ya9I
         af2LVJ/zrBCtfPDk/GTI772Z0GnYi3gmGzp9UD774A0UAhs90uqjNl17DzdRCkhalu
         dhJ6A4CljyKVEw3mqZizGO3s26aXXWftTWPmoCIkh5b917ppL/vq9ahrVLOJFhZ4vo
         j+9TmuP5v/HJw==
X-Nifty-SrcIP: [209.85.210.170]
Received: by mail-pf1-f170.google.com with SMTP id d22so1940928pfn.5;
        Wed, 26 Aug 2020 16:00:23 -0700 (PDT)
X-Gm-Message-State: AOAM532b7QREDxxzORDWYwHE+UmpUR2Ec9ehiuVFI+YJK8cDistzyTfh
        101MIJaceP6HVg3GDsW8EZWloKAhZ7qeW2NvJAM=
X-Google-Smtp-Source: ABdhPJwOb56Zv/T8wt+zsLdXiiLmYDNs/du0GD7DK8PG09w2g5wysISheYHnmVPmlUdt+UDWHt04XMWYW+5tMApWEWw=
X-Received: by 2002:a63:3309:: with SMTP id z9mr11967515pgz.7.1598482822744;
 Wed, 26 Aug 2020 16:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com> <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
In-Reply-To: <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 27 Aug 2020 07:59:45 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
Message-ID: <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Joe Perches <joe@perches.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 1:58 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Wed, Aug 26, 2020 at 9:57 AM Joe Perches <joe@perches.com> wrote:
> >
> > On Thu, 2020-08-27 at 01:49 +0900, Masahiro Yamada wrote:
> > > I do not have time to keep track of the discussion fully,
> > > but could you give me a little more context why
> > > the usage of stpcpy() is not recommended ?
> > >
> > > The implementation of strcpy() is almost the same.
> > > It is unclear to me what makes stpcpy() unsafe..
>
> https://lore.kernel.org/lkml/202008150921.B70721A359@keescook/
>
> >
> > It's the same thing that makes strcpy unsafe:
> >
> > Unchecked buffer lengths with no guarantee src is terminated.
>


OK, then stpcpy(), strcpy() and sprintf()
have the same level of unsafety.


strcpy() is used everywhere.

I am not convinced why only stpcpy() should be hidden.




-- 
Best Regards
Masahiro Yamada

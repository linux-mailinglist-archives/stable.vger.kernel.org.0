Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79ADB2474CE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbgHQTPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbgHQTPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:15:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FCCC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:15:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f9so8107737pju.4
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tmBgqfU+29UH3A8gIAUsMUZvU1W2cHudzSZ0yYhvH2g=;
        b=aX4E0LFgDJUJNb9coXJEVWiFmcjetcbxAVRPFlHU+DPwMWC+xVxGVFwkAMuaLx8U84
         po7x1kjGihO1o2YsEEtX4D5mdlIDO5HlKqYEVeRBXBKxpG/GAuuxSuPH95iP77RlnFmG
         LfNgJRnCT9dWldE3WzaTTcQFgdaUSAl3IuBpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tmBgqfU+29UH3A8gIAUsMUZvU1W2cHudzSZ0yYhvH2g=;
        b=AEUbiH3xTUWAb/2f52UCS+fyZtBvvDAIiW9i+nkDtZalLAG+pM51dfNVnsw5GSOs8Y
         N/FH3nV/dsNNug3oOVpbVy7XGtir8Yl6yCxTfO08+rVv3yo4aiTkwGBSaCrYcnVpXUkJ
         EMAegGIyEokHVkNLvW7WI4DbknP/mewMuIHLS7LZ1hsaVCC+h9mluxglrtsJT+i0NwaC
         fMXD5foSfEvDw+N6KNZ+TWt4AGXPLoQ+/8d3H3gXj6BLylIolx08mdX83KaFKP4ZTYaY
         o+gSsvnZa9Rdt0IAX3fpBXVtF4F0m4Xr3xcLydm1V+vh0hIRavTTShM8lebPhuJAA332
         mVqA==
X-Gm-Message-State: AOAM533yXkowTcSummUYHpjqB6kvMdpZw9VsZhqQBx2OQXlu7QIFwaHV
        x1HRaDTxlYizOchmQTqRwM93wQ==
X-Google-Smtp-Source: ABdhPJw8/sMKSS0IvyS3CfDbpG7kKz1MmBn08NvHr5WPVkZ+puU1nQqC5SLXkU6uzhSgG0dVNngF+g==
X-Received: by 2002:a17:902:7293:: with SMTP id d19mr12778333pll.303.1597691724086;
        Mon, 17 Aug 2020 12:15:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q5sm18109334pgv.1.2020.08.17.12.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:15:21 -0700 (PDT)
Date:   Mon, 17 Aug 2020 12:15:20 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Message-ID: <202008171213.CBCFF5D67@keescook>
References: <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
 <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
 <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
 <20200816001917.4krsnrik7hxxfqfm@google.com>
 <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
 <20200816150217.GA1306483@rani.riverdale.lan>
 <CABCJKucsXufD6rmv7qQZ=9kLC7XrngCJkKA_WzGOAn-KfcObeA@mail.gmail.com>
 <CAKwvOd=Ns4_+amT8P-7yQ56xUdDmL=1zDUThF-OmFKhexhJPdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=Ns4_+amT8P-7yQ56xUdDmL=1zDUThF-OmFKhexhJPdg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 11:36:49AM -0700, Nick Desaulniers wrote:
> That said, this libcall optimization/transformation (sprintf->stpcpy)
> does look useful to me.  Kees, do you have thoughts on me providing
> the implementation without exposing it in a header vs using
> -fno-builtin-stpcpy?  (I would need to add the missing EXPORT_SYMBOL,
> as pointed out by 0day bot and on the github thread).  I don't care
> either way; I'd just like your input before sending a V+1.  Maybe
> better to just not implement it and never implement it?

I think I would ultimately prefer -fno-builtin-stpcpy, but for now,
sure, an implementation without a header (and a biiig comment above it
detailing why and a reference to the bug) would be fine by me.

-- 
Kees Cook

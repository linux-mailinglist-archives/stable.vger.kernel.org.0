Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD1225ED84
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 11:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgIFJ5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 05:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgIFJ5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Sep 2020 05:57:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0818EC061573
        for <stable@vger.kernel.org>; Sun,  6 Sep 2020 02:57:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o16so5248053pjr.2
        for <stable@vger.kernel.org>; Sun, 06 Sep 2020 02:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q2SILnBIEirH4TWtGi68qehLBgXZt7pRjYM7YYT/J/Q=;
        b=X/xXQA7KjAXlhHEWXtOlnmdlGYZ82PRDubSws+IHO5QuygN1YWTfsEWWv5SLWMWDE1
         Po5lZUgnbS0tbOeomPRm7XYLcg35w4L1+nNrgCib6qYMo6e4JEWDdZk+eszaLhzSrMhJ
         BZ6VjPROaq5Pw50YFfMq9Jl1iU4vcVRqNX9sY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q2SILnBIEirH4TWtGi68qehLBgXZt7pRjYM7YYT/J/Q=;
        b=pY2im7owYpelV/+BmB2lJeImCSkZIcwoaHLVOtYitSiaGwLn0z91vBWQIs1vqn3C+X
         HIGKCgTD/bnTEEk05fiw7EoKV6Fvluxj5havXo2XZT5mWcDrN9qMviAdx1n0+Bcq/U/k
         aL9CsuPFpvTYcblD+eyGvZYH8879M+7nd2PQh8RT+u89MPZmmOqIXQOefX9xoc2pejn0
         pxwSAbmoxQK+RlLvJUwdhISV1SQTMf0SVrN4scaLFfM5bfnMPNcohCWciMSRt1j10CJS
         j1rqgGcW+753jX3sQMJLu/jEpnKWo1d/6eIwt7WruhxXWtutnU2BK6qW9rKEZ78oEY2z
         M2NA==
X-Gm-Message-State: AOAM531qcSCRhkFIuOXyfWONRWq5HmC8bQStXfsk1Pf5nNLPqda1T1yi
        8HxSFIoEumMQo5ql27WwaLbujA==
X-Google-Smtp-Source: ABdhPJzkAJnCDVOKe7i/BgUKdpebHEmdjzLYkAdn6d/5GqTI6KIttjhyn3LSssnVUAOi2/4uPdrgXA==
X-Received: by 2002:a17:902:ee03:b029:d0:89f1:9e2b with SMTP id z3-20020a170902ee03b02900d089f19e2bmr13926305plb.7.1599386250044;
        Sun, 06 Sep 2020 02:57:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w185sm12900952pfc.36.2020.09.06.02.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 02:57:28 -0700 (PDT)
Date:   Sun, 6 Sep 2020 02:57:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
Message-ID: <202009060256.7CE5620A56@keescook>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQvQBhjYgSkvm-dVyNz2Jd2C2qAtfyRk-rngEDfjkc38g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQvQBhjYgSkvm-dVyNz2Jd2C2qAtfyRk-rngEDfjkc38g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 12:58:35AM +0900, Masahiro Yamada wrote:
> On Tue, Aug 25, 2020 at 10:58 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> > [...]
> > +/**
> > + * stpcpy - copy a string from src to dest returning a pointer to the new end
> > + *          of dest, including src's %NUL-terminator. May overrun dest.
> > + * @dest: pointer to end of string being copied into. Must be large enough
> > + *        to receive copy.
> > + * @src: pointer to the beginning of string being copied from. Must not overlap
> > + *       dest.
> > + *
> > + * stpcpy differs from strcpy in a key way: the return value is the new
> > + * %NUL-terminated character. (for strcpy, the return value is a pointer to
> > + * src.
> 
> 
> return a pointer to src?
> 
> "man 3 strcpy" says:
> 
> The strcpy() and strncpy() functions return
> a pointer to the destination string *dest*.

Agreed; that's a typo.

-- 
Kees Cook

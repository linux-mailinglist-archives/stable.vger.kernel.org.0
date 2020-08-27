Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EE2254EE7
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 21:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgH0Tls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 15:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgH0Tlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 15:41:47 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD12C06121B
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 12:41:47 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o68so455343pfg.2
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 12:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n1Qwu/XvsgELXtbnoKiEGwTeI5Cm7GPhhnM6wHJRuAQ=;
        b=hH+kc7t4rkHW2B7yQQSI0nNjyISC8NRr+mxd0KVyt6ZqqWRtSniCXaOfWKparL+r0B
         RQB9WF3XkF4mSC0UeF3l8FszJN93YjT5GdTHcXULz4ypWC1HaxEHkRZcT2jTQSWZRRxm
         bLbpCbJ4jPEfFbP4SqN+QjIWa8JpqEk8Q82lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n1Qwu/XvsgELXtbnoKiEGwTeI5Cm7GPhhnM6wHJRuAQ=;
        b=Wwf3lC9JgHXz7o36bWKfw5mmKrYRzq4GKFsO855GbFEBPMhib/R3H/QciArw4Rh0XZ
         4ZPuA31OqVx9GfHUYDJUMZFOWdOUrLQADd7CPdH2J+tJqyfTVadKFJeyLVKtC9ozky18
         OLM4DHQUamOnMYb+Uj+eoHl1u227LbFjuf5tQ28OEpav+bynOFgobOcXZVGo7wveNI/I
         RXNebCD1as2D5ESYGJJO5G4R3Myh0+gQQeXT6mD9VmmljLh0yWj9YG+iEExXH9mz5T8H
         f3H+ldNYCsEMXd56g0CSB9KjkV1jGiAxEu0byWqKrb//kZTOjEsaOjd8Q7IiohW1gfUc
         hggw==
X-Gm-Message-State: AOAM533sd+YoJMmoJBKZjf1a8H1NXADMmU/aXMpWZ/Z2Fk7T6Ur3DO9J
        QLsfbIPE2hz+6OiGykoMxLjvjw==
X-Google-Smtp-Source: ABdhPJyOrJY3pQq1L2iejXSIkVKIwmtSPctwcc4JQlhf6KuiGFvcU76N2UM8y/G1wZWIaI/bHQdQNg==
X-Received: by 2002:a62:3583:: with SMTP id c125mr17402856pfa.1.1598557307051;
        Thu, 27 Aug 2020 12:41:47 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n68sm3453245pfn.145.2020.08.27.12.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 12:41:46 -0700 (PDT)
Date:   Thu, 27 Aug 2020 12:41:45 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joe Perches <joe@perches.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
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
Message-ID: <202008271240.8D47596B0@keescook>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook>
 <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
 <202008271126.2C397BF6D@keescook>
 <98787c53f0577952be3f0ec0f7e58d618a165c33.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98787c53f0577952be3f0ec0f7e58d618a165c33.camel@perches.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 12:37:03PM -0700, Joe Perches wrote:
> On Thu, 2020-08-27 at 11:30 -0700, Kees Cook wrote:
> 
> > Most of the uses of strcpy() in the kernel are just copying between two
> > known-at-compile-time NUL-terminated character arrays. We had wanted to
> > introduce stracpy() for this, but Linus objected to yet more string
> > functions.
> 
> https://lore.kernel.org/kernel-hardening/24bb53c57767c1c2a8f266c305a670f7@sk2.org/T/
> 
> I still think stracpy is a good idea.
> 
> Maybe when the strcpy/strlcpy uses are removed
> it'll be more acceptable.
> 
> And here's a cocci script to convert most of them.
> https://lore.kernel.org/kernel-hardening/b9bb5550b264d4b29b2b20f7ff8b1b40d20def6a.camel@perches.com/

Yeah, thanks again for that. Most of this is very mechanical. (strncpy is not, unfortunately)

-- 
Kees Cook

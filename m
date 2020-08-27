Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A7253BE1
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 04:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgH0Cdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 22:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0Cds (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 22:33:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8F1C0612A2
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 19:33:48 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m71so2318171pfd.1
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 19:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x1FlPbUtnes2qpBqooOcQ2o2d41W/mH568giujPfLVI=;
        b=VTsTUaMyrMj7HlpV8WjY9eaJs9bbslyL/CMOWABNQiMOMxZQVnhtIV7v7m7WC0iGHG
         Qd+0/hNkV31AEpGQNr4lzlSAqaJYt1Xp6MqTHPXAv8OOma7V40Hy2H6h2mAxYPlikbZh
         69kf7ajL0MFOS+EvUVKANFuWShEOp+JAZqDco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x1FlPbUtnes2qpBqooOcQ2o2d41W/mH568giujPfLVI=;
        b=l1CKl6jQGNDN3wooK7bJtTCpmLOtznAgZjqwSTUAvitJBlSSPG99cWo/pAcdWd0Uo8
         b7/ajpJgpOoNA1Z51O/UUfaV971KagB0VXAJrBP4b8IRBrZYxo/G2HR8RU7EDZt3rxaW
         /RfHa+AdGDh82Cfh84NeicC2mMQelm4u2EODLdrwMIoJ2zIHB7L2zJKf2yKdOuF64tze
         dsunyej1dg6WEOVH1EGA2CcmHIijwVKZtYv4OAWDwDzpWt2jzAH9EYKvD9bUHdEA3kmU
         V6Nqo4qmpQbDw+gTfR9N8nKEZdah6+f0nc9Esp83paOwMs1uZseKLcdlaLnuAFcjYOte
         pzIQ==
X-Gm-Message-State: AOAM533RRXfHoFZZfHPKMsYO1vucnK9k/IHiK8X1QefQq7aI6F5CF376
        bXAcL2UMYEm6v6rA5syE+x4DaA==
X-Google-Smtp-Source: ABdhPJxo49wRKyhwgJZQXq4XKNwknZcjy90W5IsV6wiIB6JdRjRcNWuJs1Grn2t/TJvPNTEPt6r3iA==
X-Received: by 2002:a63:36c6:: with SMTP id d189mr12091053pga.392.1598495627669;
        Wed, 26 Aug 2020 19:33:47 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v134sm572683pfc.101.2020.08.26.19.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 19:33:46 -0700 (PDT)
Date:   Wed, 26 Aug 2020 19:33:45 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joe Perches <joe@perches.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
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
Message-ID: <202008261932.FF4E5C0@keescook>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook>
 <77428f28620d4e5ecad1556396f2b0f8f0daef41.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77428f28620d4e5ecad1556396f2b0f8f0daef41.camel@perches.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 04:57:41PM -0700, Joe Perches wrote:
> On Wed, 2020-08-26 at 16:38 -0700, Kees Cook wrote:
> > On Thu, Aug 27, 2020 at 07:59:45AM +0900, Masahiro Yamada wrote:
> []
> > > OK, then stpcpy(), strcpy() and sprintf()
> > > have the same level of unsafety.
> > 
> > Yes. And even snprintf() is dangerous because its return value is how
> > much it WOULD have written, which when (commonly) used as an offset for
> > further pointer writes, causes OOB writes too. :(
> > https://github.com/KSPP/linux/issues/105
> > 
> > > strcpy() is used everywhere.
> > 
> > Yes. It's very frustrating, but it's not an excuse to continue
> > using it nor introducing more bad APIs.
> > 
> > $ git grep '\bstrcpy\b' | wc -l
> > 2212
> > $ git grep '\bstrncpy\b' | wc -l
> > 751
> > $ git grep '\bstrlcpy\b' | wc -l
> > 1712
> > 
> > $ git grep '\bstrscpy\b' | wc -l
> > 1066
> > 
> > https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy
> > https://github.com/KSPP/linux/issues/88
> > 
> > https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> > https://github.com/KSPP/linux/issues/89
> > 
> > https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> > https://github.com/KSPP/linux/issues/90
> > 
> > We have no way right now to block the addition of deprecated API usage,
> > which makes ever catching up on this replacement very challenging.
> 
> These could be added to checkpatch's deprecated_api test.
> ---
>  scripts/checkpatch.pl | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 149518d2a6a7..f9ccb2a63a95 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -605,6 +605,9 @@ foreach my $entry (@mode_permission_funcs) {
>  $mode_perms_search = "(?:${mode_perms_search})";
>  
>  our %deprecated_apis = (
> +	"strcpy"				=> "strscpy",
> +	"strncpy"				=> "strscpy",
> +	"strlcpy"				=> "strscpy",
>  	"synchronize_rcu_bh"			=> "synchronize_rcu",
>  	"synchronize_rcu_bh_expedited"		=> "synchronize_rcu_expedited",
>  	"call_rcu_bh"				=> "call_rcu",
> 
> 

Good idea, yeah. We, unfortunately, need to leave strncpy() off this
list for now because it's not *strictly* deprecated (see the notes in
bug report[1]), but the others can be.

[1] https://github.com/KSPP/linux/issues/89

-- 
Kees Cook

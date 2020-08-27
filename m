Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DDA254D03
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 20:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgH0S0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 14:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgH0S0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 14:26:06 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A355C06121B
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 11:26:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q1so3032234pjd.1
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 11:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6BMddBDrBrgDUNUGomrW0m42cqLSjUvpHNc8p74VZyA=;
        b=FXdPBAw9pl5olpn9n/EuSa1Q6dDDnRWXMgUGfWwLqiAYTjNRr5LcjcwGH1PD32Ch7f
         pMVoRLLABmJLdweawfmYq3DhOwNyN7VkRzr9UrHC//O8xNk1JqPEA84vLqQOEJASA8xx
         3sOafGdHa03NSgi6z9D8xEgwX6FDGJauD148M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6BMddBDrBrgDUNUGomrW0m42cqLSjUvpHNc8p74VZyA=;
        b=Gro8lSLfFBzKqDMzVyR7AtR+TKaF3KHdBkn2D/5ElqORSd+IqQ1MSoJFK3wpi8myE8
         Ftq6VAV83UQrUGK8nxJFvrmGR9Lip6uNszwM088U/ClnxCvlE89MwrVN35QDS1Yi7V8U
         tl7BoCvmUl+DPcsPmF6Xx7WFHL86PQ0Eoe9HLsw4BOjDqHlIEclTw0wEx7jZsTCP0K/A
         pZ5uSeo2cTg9A5cJzB/rfICcRwIOj3j4xDqfpST5OXNnqb5cIyJeYFkQiGB4viJNNQOV
         JnzXhBqNf90xUiwxPXlkf/JoIuaeTJspORhKoZlfPmMSUEt/rM1TV0TYtfpwUsH1kurt
         Pg9A==
X-Gm-Message-State: AOAM533lTCwzurLnfs18scC/bX5ts7pThVYP/jNLds51ONSOOohYgPa5
        rX02wKl5p0thLkeQtxG/PaFSvw==
X-Google-Smtp-Source: ABdhPJzu9HB96VpOGD+toJHHY5zOKqYeaeMpM3VyoTlj+93xXg4m4tB8ChYdxW0vmq2yKtIttIKfaQ==
X-Received: by 2002:a17:90a:fb4e:: with SMTP id iq14mr103434pjb.133.1598552766044;
        Thu, 27 Aug 2020 11:26:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a25sm3370253pfk.151.2020.08.27.11.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 11:26:05 -0700 (PDT)
Date:   Thu, 27 Aug 2020 11:26:04 -0700
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
Message-ID: <202008271124.37242A14@keescook>
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook>
 <77428f28620d4e5ecad1556396f2b0f8f0daef41.camel@perches.com>
 <202008261932.FF4E5C0@keescook>
 <e84ea9d311fe082af8a1afe2aba48303ffbb1bf1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e84ea9d311fe082af8a1afe2aba48303ffbb1bf1.camel@perches.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 07:42:17PM -0700, Joe Perches wrote:
> On Wed, 2020-08-26 at 19:33 -0700, Kees Cook wrote:
> > On Wed, Aug 26, 2020 at 04:57:41PM -0700, Joe Perches wrote:
> > > On Wed, 2020-08-26 at 16:38 -0700, Kees Cook wrote:
> > > > On Thu, Aug 27, 2020 at 07:59:45AM +0900, Masahiro Yamada wrote:
> > > []
> > > > > OK, then stpcpy(), strcpy() and sprintf()
> > > > > have the same level of unsafety.
> > > > 
> > > > Yes. And even snprintf() is dangerous because its return value is how
> > > > much it WOULD have written, which when (commonly) used as an offset for
> > > > further pointer writes, causes OOB writes too. :(
> > > > https://github.com/KSPP/linux/issues/105
> > > > 
> > > > > strcpy() is used everywhere.
> > > > 
> > > > Yes. It's very frustrating, but it's not an excuse to continue
> > > > using it nor introducing more bad APIs.
> > > > 
> > > > $ git grep '\bstrcpy\b' | wc -l
> > > > 2212
> > > > $ git grep '\bstrncpy\b' | wc -l
> > > > 751
> > > > $ git grep '\bstrlcpy\b' | wc -l
> > > > 1712
> > > > 
> > > > $ git grep '\bstrscpy\b' | wc -l
> > > > 1066
> > > > 
> > > > https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy
> > > > https://github.com/KSPP/linux/issues/88
> > > > 
> > > > https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> > > > https://github.com/KSPP/linux/issues/89
> > > > 
> > > > https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> > > > https://github.com/KSPP/linux/issues/90
> > > > 
> > > > We have no way right now to block the addition of deprecated API usage,
> > > > which makes ever catching up on this replacement very challenging.
> > > 
> > > These could be added to checkpatch's deprecated_api test.
> > > ---
> > >  scripts/checkpatch.pl | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > index 149518d2a6a7..f9ccb2a63a95 100755
> > > --- a/scripts/checkpatch.pl
> > > +++ b/scripts/checkpatch.pl
> > > @@ -605,6 +605,9 @@ foreach my $entry (@mode_permission_funcs) {
> > >  $mode_perms_search = "(?:${mode_perms_search})";
> > >  
> > >  our %deprecated_apis = (
> > > +	"strcpy"				=> "strscpy",
> > > +	"strncpy"				=> "strscpy",
> > > +	"strlcpy"				=> "strscpy",
> > >  	"synchronize_rcu_bh"			=> "synchronize_rcu",
> > >  	"synchronize_rcu_bh_expedited"		=> "synchronize_rcu_expedited",
> > >  	"call_rcu_bh"				=> "call_rcu",
> > > 
> > > 
> > 
> > Good idea, yeah. We, unfortunately, need to leave strncpy() off this
> > list for now because it's not *strictly* deprecated (see the notes in
> > bug report[1]), but the others can be.
> 
> OK, but it is in Documentation/process/deprecated.rst
> 
> strncpy() on NUL-terminated strings

"... on NUL-terminated strings". It's "valid" to use it on known-size
(either external or by definition) NUL-padded buffers (e.g. NLA_STRING).

-- 
Kees Cook

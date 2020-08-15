Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5FF2452D2
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgHOVzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgHOVwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:52:25 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02ADC0A3BE6
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 09:34:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so5989922pgf.0
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 09:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zJX37WRUVbMU5pJLki7rAUhX9uBKXYYVUdVs+LildKI=;
        b=IpPDEUCjv38MHmQCN4xlwtZPYWyGXgrzrlene0jwicF8nC6bOQLRDf6JsqAZXPcSHM
         Ia3GGX+Ri5jyykiM54fdWTzoYRRHzlFZhHRbnarJjgroY1BTzFbBGDfFhk0imqbjsO8m
         594cDxoJl1B4YBWdYONF4W0lkqmH+sF0aDmCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zJX37WRUVbMU5pJLki7rAUhX9uBKXYYVUdVs+LildKI=;
        b=NbdR6bEetSoFBEOf2uMWVzpjAQZa7MN8cs3/mX5bDMokBFrw8V3+qAfkJ05iTJrHHH
         4RM7iZwW3SuZEr4K71H8PoPyYPXD4XkjpRc8fIZ9hcUEMv3wCriST4lA8lc67k6kjAbI
         7jkhm77VJe85LEEqKzN4qg+cqmtrZjlUeUiST6M0QfLYVLgdGySVcJGORFnbGp62JiTq
         tbhQabKIJx+YUQKoNu385+28fSsSC1AlYey1rDAy0swDCZSllOHD3wYmbi7JcctGkOuU
         UtdJWmy73ASINDdtt1NFY8QzfJy/fN4w4Rl817rjprdwhQVNarGKPV7Q1W92dHfceGjt
         BUHQ==
X-Gm-Message-State: AOAM530pdGPWi+Hqd+WBaJXTblNoideerJONA9aBnvSixRtiFtr9e1jI
        dkTvyXeRiVgDhCbCDJRLi1KvGA==
X-Google-Smtp-Source: ABdhPJwxkXH54KOfuvV0sE3T/mUrFUJnBitO40SmY2gNDM+3Db0P2007Ysnhlcqr0odkVg6XM30umg==
X-Received: by 2002:a63:4a4c:: with SMTP id j12mr5198869pgl.115.1597509257153;
        Sat, 15 Aug 2020 09:34:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f27sm12433808pfk.217.2020.08.15.09.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 09:34:16 -0700 (PDT)
Date:   Sat, 15 Aug 2020 09:34:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Message-ID: <202008150921.B70721A359@keescook>
References: <20200815014006.GB99152@rani.riverdale.lan>
 <20200815020946.1538085-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815020946.1538085-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings.  Calling `sprintf` with overlapping arguments
> was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
> 
> `stpcpy` is just like `strcpy` except it returns the pointer to the new
> tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
> one statement.

O_O What?

No; this is a _terrible_ API: there is no bounds checking, there are no
buffer sizes. Anything using the example sprintf() pattern is _already_
wrong and must be removed from the kernel. (Yes, I realize that the
kernel is *filled* with this bad assumption that "I'll never write more
than PAGE_SIZE bytes to this buffer", but that's both theoretically
wrong ("640k is enough for anybody") and has been known to be wrong in
practice too (e.g. when suddenly your writing routine is reachable by
splice(2) and you may not have a PAGE_SIZE buffer).

But we cannot _add_ another dangerous string API. We're already in a
terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. This
needs to be addressed up by removing the unbounded sprintf() uses. (And
to do so without introducing bugs related to using snprintf() when
scnprintf() is expected[4].)

-Kees

[1] https://github.com/KSPP/linux/issues/88
[2] https://github.com/KSPP/linux/issues/89
[3] https://github.com/KSPP/linux/issues/90
[4] https://lore.kernel.org/lkml/20200810092100.GA42813@2f5448a72a42/

-- 
Kees Cook

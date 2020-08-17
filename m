Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2202474E9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392211AbgHQTQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392113AbgHQTQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:16:44 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678E6C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:16:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x25so8710259pff.4
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iGRzfPyw7ESx9wXeagb3xJwksI9OtPsVQy2m4SGV5Xo=;
        b=AOzQ2918L26XOqNuhI39UDWiFl/NgEDi3gEqKcXm3SjCQrlCrHzQxyDSNBU4MoqN6P
         hbt6hn1pjWmdyPvmuxZjEyngCGtz3/+LXbmmkYLhR8X/zsnHL+lm13Oud9WWBnuyL5DQ
         Rit2cIThg2WcXHH36RfxlFSgTAvF1/H288vBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iGRzfPyw7ESx9wXeagb3xJwksI9OtPsVQy2m4SGV5Xo=;
        b=TfNink7FIUI3ki6xIYvD6373A4UOBoyELFYW68/kE/wQEWZu1uNB5xwLvNTB99bTbh
         x+Q02DQKQEhj8tZg3Swxc23j6/sLZCV4b33q51aMNGsdNisenX5VNOppzPvtco5U9vie
         5PMuYJ7xGToXWZ7CWCbSwqWjoLreUYBC/nJhi5bS0xReUyp/ulUAg8H/Au/6AUJHRE+B
         6/TfLcSFNa1J8rd5a1TBVs6T5ngzjxhDNAN1ea05yRh16OPTZDPjun5FGeJ/Z4eZbEvu
         qFqFK8+xKP9U+st2IeqCNqtKNFdEd3Dq99d1gh1MpXawMcl+KQxlCIJ7RIatdk1XCqha
         q4Iw==
X-Gm-Message-State: AOAM533rvTYO+c1LRcIzO8Nh/rmMmj+FE8WiGMD/oT+JKDJ7e968xJRd
        qQYz7RljxyyJJX8F2AtHoGLyxQ==
X-Google-Smtp-Source: ABdhPJwx6+0uQ9KiWoyCEx/3rDJPN+0vrjL39vxdhLZ+1kK3upxTaoDjH7lVLlGZ1b6tyDYJ3RYrfg==
X-Received: by 2002:a63:ff5f:: with SMTP id s31mr4115897pgk.333.1597691799926;
        Mon, 17 Aug 2020 12:16:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s4sm20767427pfh.128.2020.08.17.12.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:16:38 -0700 (PDT)
Date:   Mon, 17 Aug 2020 12:16:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Message-ID: <202008171216.945D6D7D11@keescook>
References: <202008150921.B70721A359@keescook>
 <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
 <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
 <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
 <20200816001917.4krsnrik7hxxfqfm@google.com>
 <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
 <20200816150217.GA1306483@rani.riverdale.lan>
 <CABCJKucsXufD6rmv7qQZ=9kLC7XrngCJkKA_WzGOAn-KfcObeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKucsXufD6rmv7qQZ=9kLC7XrngCJkKA_WzGOAn-KfcObeA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 10:14:43AM -0700, Sami Tolvanen wrote:
> I just confirmed that adding -fno-builtin-stpcpy to KBUILD_CFLAGS does
> work with LTO as well.

Oh, I read this out of order; sorry! Yes, if -fno-builtin-stpcpy works,
let's use that instead. Doesn't that solve it too?

-- 
Kees Cook

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68905B3213
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 10:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiIIIof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 04:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiIIIod (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 04:44:33 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9E2140F5
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 01:44:31 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id k80so1637384ybk.10
        for <stable@vger.kernel.org>; Fri, 09 Sep 2022 01:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=UxHqcjqLV5SMzyyvdPn90TGI1ZaTqe/aoS8WhMGAgLo=;
        b=sw9SXPNgEqTzFEbub1fMIikW5XRHX3LXyotY2uUKcbNka3uMRULDKd2+TtJU9JhNsY
         HuRyRmzy75Vl795pPEj7Snw+41oN5Vj2TSr/I+MajIzPkaarOdZNazWvUr0P6Q2gXg23
         /eaTrmPP+f8iXnq3Ad2kFaC4PWXlDf10Zb9eSYkDI+Ke8zXfheTbaYDe7QxQcuuo8H8I
         JDc1wga/VBWxbOPuVo/H5bPeQ3ad4yNhMM/jqc4LUHGUiJCFuLTMJZEtBeRyvN3yA6kR
         5RPxxKX4BULHj0BKRJFwnYqFK/P5B3n6yVQbxK8G5FpaZ7374oOeYy5ksTOUcd/2wN3B
         p+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=UxHqcjqLV5SMzyyvdPn90TGI1ZaTqe/aoS8WhMGAgLo=;
        b=fbkXsHYXayRKSxetDuyxRqReXHnwO/OyN/cy/0ZfYNUPKZ3/qKkGvzkzASecHCwGkn
         eW4AtyeBtzdMKmEOUkAJCjopmax2anqe9+8dSD97zxck8m72e+VNs2dZOGn9/JPW7eWi
         QVAoqMrdrbvLZKqEYkFopX8Mq+PCNsA/n7r88V34o6exN7pm64y1tRaTFw99JyXg8pzX
         EPhvU63z0pj/OEP39x/TanKXvqGwcZXFtRDcFLPNCJqtKJnVZHhRw2ZRWUv5IXNXhzeL
         PhQRq892u7Vb6AR/0fpO8T9DbhvmZ3KN3bzFCIve1RYUpU2cE+w9HAE64l4C54OjEfZ8
         82YQ==
X-Gm-Message-State: ACgBeo0Qe86LssPmVpyDAVsXqYj+AOaI9x80BGB3wOeMyH2Jujc0/6K8
        Ld6NPjWgttKKhPOky1L0VQzNF5fHibkcSzf4r0IYZA==
X-Google-Smtp-Source: AA6agR50LVYT/iKxeiXfZ1bnFnp7Ke4DBBdARvNMANKD4ACstbuhW0lSj6LRta+0KeY8t2U7vFcCdnQLIe3Imfh2cWQ=
X-Received: by 2002:a25:d686:0:b0:6a8:e9a8:54f7 with SMTP id
 n128-20020a25d686000000b006a8e9a854f7mr10920047ybg.611.1662713070956; Fri, 09
 Sep 2022 01:44:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220909073840.45349-1-elver@google.com> <20220909073840.45349-2-elver@google.com>
 <CACT4Y+Zuf+ynzSbboTAN0_VLedeVErO6qm49H4YzuR1e8EgJUQ@mail.gmail.com>
In-Reply-To: <CACT4Y+Zuf+ynzSbboTAN0_VLedeVErO6qm49H4YzuR1e8EgJUQ@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Fri, 9 Sep 2022 10:43:54 +0200
Message-ID: <CANpmjNOz9bomQv=Zem6kw9xamhp1yPKf3iCrVvhkzHxE2pcp0A@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] kcsan: Instrument memcpy/memset/memmove with newer Clang
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Sept 2022 at 10:38, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Fri, 9 Sept 2022 at 09:38, Marco Elver <elver@google.com> wrote:
> >
> > With Clang version 16+, -fsanitize=thread will turn
> > memcpy/memset/memmove calls in instrumented functions into
> > __tsan_memcpy/__tsan_memset/__tsan_memmove calls respectively.
> >
> > Add these functions to the core KCSAN runtime, so that we (a) catch data
> > races with mem* functions, and (b) won't run into linker errors with
> > such newer compilers.
> >
> > Cc: stable@vger.kernel.org # v5.10+
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> > v2:
> > * Fix for architectures which do not provide their own
> >   memcpy/memset/memmove and instead use the generic versions in
> >   lib/string. In this case we'll just alias the __tsan_ variants.
> > ---
> >  kernel/kcsan/core.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >
> > diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
> > index fe12dfe254ec..4015f2a3e7f6 100644
> > --- a/kernel/kcsan/core.c
> > +++ b/kernel/kcsan/core.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/percpu.h>
> >  #include <linux/preempt.h>
> >  #include <linux/sched.h>
> > +#include <linux/string.h>
> >  #include <linux/uaccess.h>
> >
> >  #include "encoding.h"
> > @@ -1308,3 +1309,41 @@ noinline void __tsan_atomic_signal_fence(int memorder)
> >         }
> >  }
> >  EXPORT_SYMBOL(__tsan_atomic_signal_fence);
> > +
> > +#ifdef __HAVE_ARCH_MEMSET
> > +void *__tsan_memset(void *s, int c, size_t count);
> > +noinline void *__tsan_memset(void *s, int c, size_t count)
> > +{
> > +       check_access(s, count, KCSAN_ACCESS_WRITE, _RET_IP_);
>
> These can use large sizes, does it make sense to truncate it to
> MAX_ENCODABLE_SIZE?

Hmm, good point - that way it can still set up watchpoints on them.
I'll do a v3.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B6C21C6BC
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 01:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgGKXdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 19:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGKXdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jul 2020 19:33:46 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30838C08C5DE
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 16:33:46 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c30so8895262qka.10
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 16:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7z7xL3EKlTOURA9bJmOChBRDZVPEDiiwDdwRoGoh3tU=;
        b=qIl9b9zmh8XbF0q286w8Bb/Rp5f+QT1YVrRvjp3Y9+n1lXT15pyXWbNXNkzL0XJ6mA
         OKDXVRfdHQb173yeYwpNkVXRqypw5lYX9Y0PSvjbeMceKFi6++/t3q2LLKlk2cPos5jW
         4gCYisSVRcsDinG3Oz8HOfKRGyBGwziTFY1Kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7z7xL3EKlTOURA9bJmOChBRDZVPEDiiwDdwRoGoh3tU=;
        b=WIYwS+ZI5KqNh5m/ISDeMSWx9ywjGB3luFsR9LLyCkie2KI5Qati8zYnr6T3yupp1h
         FUXhTz720NE4PRkk5VgJOpp7zxxDHOMcdxavRijwrvDOnDoT3vaKiljZFiCrs0jS2SEE
         XIJWDHkua46TVOwlozl2CZZI+nNNruCwZZhx6S2OeCgbAyMkHnRhKK6/jfCwQhGyYczJ
         yOTggokH6DOZzDxXZP0XoA6qBJL1hhxh/5gojDb9HRPpqi9hYApLkOtNySWbUBaCi2V0
         ITr2SD9vqXb/QY2+l6FWejazbqDbkrZY7UVeAaifR3It/avbFPDJGSQXYBi3mbLqj4uQ
         v5oQ==
X-Gm-Message-State: AOAM531JmetJUQlZexl6zpikDB9vnuBYCnBFbRcUFgqxmpEsCGSx87Q5
        jHENtGJLN5DbysfgOJekOhw19A==
X-Google-Smtp-Source: ABdhPJzBXhmcVKPBjv4vWy1ZtmSU6d30YNUnZS4J3IZmJkvxaNowyVwLPDWdMWEwfihLoLS8ivO2Zw==
X-Received: by 2002:a37:c40a:: with SMTP id d10mr50674650qki.110.1594510425183;
        Sat, 11 Jul 2020 16:33:45 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:cad3:ffff:feb3:bd59])
        by smtp.gmail.com with ESMTPSA id e23sm12603012qkl.55.2020.07.11.16.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 16:33:44 -0700 (PDT)
Date:   Sat, 11 Jul 2020 19:33:44 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        William Kucharski <william.kucharski@oracle.com>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
Message-ID: <20200711233344.GB2608903@google.com>
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
 <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
 <CA+G9fYusSSrc5G_pZV6Lc-LjjkzQcc3EsLMo+ejSzvyRcMgbqw@mail.gmail.com>
 <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 11, 2020 at 11:12:58AM -0700, Linus Torvalds wrote:
> On Sat, Jul 11, 2020 at 10:27 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > I have started bisecting this problem and found the first bad commit
> 
> Thanks for the effort. Bisection is often a great tool to figure out
> what's wrong.
> 
> Sadly, in this case:
> 
> > commit 9f132f7e145506efc0744426cb338b18a54afc3b
> > Author: Joel Fernandes (Google) <joel@joelfernandes.org>
> > Date:   Thu Jan 3 15:28:41 2019 -0800
> >
> >     mm: select HAVE_MOVE_PMD on x86 for faster mremap
> 
> Yeah, that's just the commit that enables the code, not the commit
> that introduces the fundamental problem.
> 
> That said, this is a prime example of why I absolutely detest patch
> series that do this kind of thing, and are several patches that create
> new functionality, followed by one patch to enable it.
> 
> If you can't get things working incrementally, maybe you shouldn't do
> them at all. Doing a big series of "hidden work" and then enabling it
> later is wrong.
> 
> In this case, though, the real patch that did the code isn't that kind
> of "big series of hidden work" patch series, it's just the (single)
> previous commit 2c91bd4a4e2e ("mm: speed up mremap by 20x on large
> regions").
> 
> So your bisection is useful, it's just that it really points to that
> previous commit, and it's where this code was introduced.

Right, I think I should have squashed the enabling of the config, and the
introduction of the feature in the same patch, but as you pointed that
probably would not have made a difference with this bisect since this a
single patch.

> It's also worth noting that that commit doesn't really *break*
> anything, since it just falls back to the old behavior when it warns.

Agreed, I am also of the opinion that the patch is likely surface an existing
issue and not introducing a new one.

> So to "fix" your test-case, we could just remove the WARN_ON.
>
> But the WARN_ON() is still worrisome, because the thing it tests for
> really _should_ be true.

I'll get some tracing in an emulated i386 environment going and try to figure
out exactly what is going on before the warning triggers. thanks for the other
debug hints in this thread!

thanks,

 - Joel

 - Joel


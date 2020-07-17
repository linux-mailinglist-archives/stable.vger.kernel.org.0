Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1093D2235E7
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgGQH3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 03:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgGQH33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 03:29:29 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929AFC061755;
        Fri, 17 Jul 2020 00:29:29 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j10so6925331qtq.11;
        Fri, 17 Jul 2020 00:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mLChhkkm0b+TcGslIoNpge2LNzljcXENkja9YaOyDFI=;
        b=AuyJsg9n5JoeUqrQOWF2aN8tCVUZwOLo+QP4vwtT9hj9S4kfJaQzyi4p175ZcrAaNN
         bx1vS2zUGYSMMZVsWpCCobmmRuXkoumr/uV8NtivOnRR/QplBVJ9RNSrN4/568qjKEv6
         8B/5BCMtYwl7pfQoJuH+bf4RY2JKUf2ZbT3qLbaQ+HspqJt/0fZedbTYgDnrGY1qkbB2
         W4BZ7f/QxhZeN9nYmr3v9x+i4G/WlM69J45HWNLqaFvsDan9LS5mPxKau/JFk36uTTcI
         c0HjlAp/9+qj8jHjJ3Tm4R30CoImwKLFbKiyX6/1o/0VWNNhGtyV0JMu0XcIMbh95Rqd
         DXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mLChhkkm0b+TcGslIoNpge2LNzljcXENkja9YaOyDFI=;
        b=YA3teFsyq58iLKEN0l1fpR311WsQ998ERlMYpomJkw9xJM86CDSpH6GSbjUehThpsW
         DjJeGIHfA7ZxXgUfc7q3QbPb51ENaLXdMSJXoVIyqgzz6tKV21BZV4rnvFmPp7kpW8RN
         /fdWCieGWRo7FpMwcprm2j89WjKB13hv/4X0AMDkSEixxwzoHZeAi1eF1CofjBiOBwr4
         bwJHK94a/8XT8Scj/YVQ5dtHSlk3kuGNe/FTZTiMGmrdVszz0eTNoVf6m0A7wUk58KkC
         IUqQUuaD+szNlJBil1oJosmGZ3dlBwo4liJATzpD6YJs/G4hYgtxMdylo7vOMSbmYnJd
         54sQ==
X-Gm-Message-State: AOAM531D7yekWcGopmtFbf/UrqpZwhxLqr4iSUfjVtCk3w21fkjGLi6E
        3BcAdWmwSi6Oi7jauelt0MFNczswY6sLhFKaaWQ=
X-Google-Smtp-Source: ABdhPJziixgd56ZvRi+F8Kf6fojTvIxqKFNW7APUzyaDkpth0ViJdo7U3bWUx0v9ZVJhf0he4zQc++fiB2R5T/6tFPE=
X-Received: by 2002:aed:22ef:: with SMTP id q44mr8639180qtc.333.1594970968809;
 Fri, 17 Jul 2020 00:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
 <332d620b-bfe3-3b69-931b-77e3a74edbfd@suse.cz> <CAAmzW4NbG0fCtU2mV83pRamUeOEqKKxGTpQK2zuDxzmoF2FVrg@mail.gmail.com>
 <6f18d999-4518-31ce-4cea-9b5b89a577ad@suse.cz>
In-Reply-To: <6f18d999-4518-31ce-4cea-9b5b89a577ad@suse.cz>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Fri, 17 Jul 2020 16:29:17 +0900
Message-ID: <CAAmzW4MLc8bmkYW1q1fL_WRFQHksX-oy9tS-s9Kb-A=ZEeGETQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020=EB=85=84 7=EC=9B=94 16=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 4:45, V=
lastimil Babka <vbabka@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 7/16/20 9:27 AM, Joonsoo Kim wrote:
> > 2020=EB=85=84 7=EC=9B=94 15=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 5:2=
4, Vlastimil Babka <vbabka@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >> >  /*
> >> >   * get_page_from_freelist goes through the zonelist trying to alloc=
ate
> >> >   * a page.
> >> > @@ -3706,6 +3714,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigne=
d int order, int alloc_flags,
> >> >       struct pglist_data *last_pgdat_dirty_limit =3D NULL;
> >> >       bool no_fallback;
> >> >
> >> > +     current_alloc_flags(gfp_mask, &alloc_flags);
> >>
> >> I don't see why to move the test here? It will still be executed in th=
e
> >> fastpath, if that's what you wanted to avoid.
> >
> > I want to execute it on the fastpath, too. Reason that I moved it here
> > is that alloc_flags could be reset on slowpath. See the code where
> > __gfp_pfmemalloc_flags() is on. This is the only place that I can apply
> > this option to all the allocation paths at once.
>
> But get_page_from_freelist() might be called multiple times in the slowpa=
th, and
> also anyone looking for gfp and alloc flags setup will likely not examine=
 this
> function. I don't see a problem in having it in two places that already d=
eal
> with alloc_flags setup, as it is now.

I agree that anyone looking alloc flags will miss that function easily. Oka=
y.
I will place it on its original place, although we now need to add one
more place.
*Three places* are gfp_to_alloc_flags(), prepare_alloc_pages() and
__gfp_pfmemalloc_flags().

Thanks.

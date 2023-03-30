Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A006D0F71
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjC3Tzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjC3Tzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:55:36 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927FC10252
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:55:34 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id j7so25012350ybg.4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680206133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCcB5OY8SQyKSb7z+4YaRuPUYL+j2up2EUbXt0Mw2dI=;
        b=s0h7rvKGInOi0krE3W8LR7VJ4S4A7z47vZbouVSzXWKE9OjUtQB8Kt/A8uBBIsuYGg
         4OuHcmQ4+Q4F1sDHKG50ARafeyCKVXEeGq498f2n0uv3uMtsJe7LztATHDsOfRm0/Uv3
         qBEgbeb3R3H6vPV2spHKFSswGjl0VxrnrilRHlDX4iyrlduGRh+HZ052Ab6z9K8z8vmK
         rSDI8ZX7m+n9V4wmKZOrZoNCzwkLWJ8PTOJBCUonW3k5MJRT6IJxOmwtin//hOXolTMo
         VG23NIaNap7GNfw+Ghsn50qUCERUmmyivY8RTvZvz2qsDe5q2fUUPL2UXjXx/KTDJFpL
         /2nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680206133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCcB5OY8SQyKSb7z+4YaRuPUYL+j2up2EUbXt0Mw2dI=;
        b=u/tHd7BdblUEEOFcAaP67oc57SkgkuIJpArEwnIiIxXqQnMuPIWlvFDvOVplA5/ePy
         2h7AFwuUsm5q414ka2NwUrV1br72GluaCV7Nvmr73lbGv1mwc9nczXRTovUmWzI+C8cR
         m/qVZc/u2RIQV8BhDEw4zQwmiQVqyGV/bEueisHNFatL+Q7SHJwiaZE6s13zW3qYEpoR
         3/AU1L0akiZIzqz9y6TmythyLdjM7LRoG+0yRc/S/ucuQJLl+da572DLc/INcOBHWXu5
         wXtGSThyu91H1qc3MOY/AN6bQJRfh8dPspuMyB0m9aHbzxKEVZqNdNBT1tFQ+oDJ4nLv
         qMCQ==
X-Gm-Message-State: AAQBX9f/0R9ys//I3SBrbCCoHaThWTGsWCWMoCHjzXHyzzn1Ts/A08qC
        x+iOA9NecwcM6NevH9BZ8NXgzW5RgSNUbifPryXy4w==
X-Google-Smtp-Source: AKy350Yojbn7iVVCaWAHI4hTk9wpIP45sSlDaCmOwbzyJh+Ki2GMk2GhBn+Uos49hMtA/f8mHTBe8kqwB+IBkWttIPw=
X-Received: by 2002:a05:6902:154e:b0:b77:d2db:5f8f with SMTP id
 r14-20020a056902154e00b00b77d2db5f8fmr15921642ybu.12.1680206133587; Thu, 30
 Mar 2023 12:55:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230330133822.66271-1-mathieu.desnoyers@efficios.com> <20230330124230.9f3d4f63374eb15a3b990ff8@linux-foundation.org>
In-Reply-To: <20230330124230.9f3d4f63374eb15a3b990ff8@linux-foundation.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 30 Mar 2023 12:55:22 -0700
Message-ID: <CALvZod5E649XyBC+NLkHTJJWWoWh+Uuhegw=4_4MQGxok5VpXw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: Fix memory leak on mm_init error handling
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 12:42=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 30 Mar 2023 09:38:22 -0400 Mathieu Desnoyers <mathieu.desnoyers@e=
fficios.com> wrote:
>
> > commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> > introduces a memory leak by missing a call to destroy_context() when a
> > percpu_counter fails to allocate.
> >
> > Before introducing the per-cpu counter allocations, init_new_context()
> > was the last call that could fail in mm_init(), and thus there was no
> > need to ever invoke destroy_context() in the error paths. Adding the
> > following percpu counter allocations adds error paths after
> > init_new_context(), which means its associated destroy_context() needs
> > to be called when percpu counters fail to allocate.
> >
> > ...
> >
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1171,6 +1171,7 @@ static struct mm_struct *mm_init(struct mm_struct=
 *mm, struct task_struct *p,
> >  fail_pcpu:
> >       while (i > 0)
> >               percpu_counter_destroy(&mm->rss_stat[--i]);
> > +     destroy_context(mm);
> >  fail_nocontext:
> >       mm_free_pgd(mm);
> >  fail_nopgd:
>
> Is there really a leak?  I wasn't able to find a version of
> init_new_context() which performs allocation.
>

There are more than 20 archs defining this function and I couldn't
check each one of them. I think we can assume there might be new
allocation in the future.

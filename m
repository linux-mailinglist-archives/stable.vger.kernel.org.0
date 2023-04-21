Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FF66EB078
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 19:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjDURUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 13:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjDURUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 13:20:53 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E1BB76F
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 10:20:52 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f182f35930so193275e9.1
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 10:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682097650; x=1684689650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoANvRP3wG421x09FuFePYSeF3qyxJZTGGqj7xA90Ec=;
        b=ErAUgtcEifV2rrs6rJkzVAjqJD2tvODs84obJMMQScurxFwFXHzT38L88TcgY6VXlL
         AWNnYdip1isi62ToMTUTXkNB/yGn+HcRMxmvoXqr7u05YHQzAu7JA/6xdyqEaGrBHQSl
         bMeUbvI4CFr1Lydm847ys1M9fZdzZNimpc1Kr4v6c87uoufAakEdnsV/Y5VcMNOPSx/n
         jNQS9W+AqsWJ2Z/Do3RLQf7kkLzzM8B336cNGB43e3ToGMjutOdVz7ILf+IVKbtvA6Nc
         t2wKzJwAjcxwT97MDs1NgUIr03KkKzEZMNbf0AEkHblgljmF6URrdulD9GvD8yzAh9ls
         Vtaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682097650; x=1684689650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eoANvRP3wG421x09FuFePYSeF3qyxJZTGGqj7xA90Ec=;
        b=CR2Rj08rZZClFUN4zkSSbtBmQqXN0UMbgjra0zIAPl9IoGv5hI6u9+vtoC8OaGpp5O
         79pdI8ObXqZS4Tv/h9LX8Gz91o/B/N21/S+ngEATLpgSLMTMr95WE4CsLnkxP2HTT3oU
         IuNYRLvG1yL223N9my/c99SuVvS7nAn4aLLE3qX27fiaQE2aExWlKd16xQPTLY7Y5uhA
         b7SIL2laqEu5m1ZObZHPqB2+8ACCvJM7A2CzjxCckDSgQ2+dwChCGzw69fSPurYccjUs
         eRA3nl5Y2Pn0MK4FQ3EXrUogH7/xNgNdC/huT1cb8/CGrzHVSElrfIQMU53kWIqBtP9i
         yBkA==
X-Gm-Message-State: AAQBX9cD9XtwQp8ZrvACrZDO43iiaxvpIkCcSp1kgHHhL3m6NpXHJwh/
        fa8gMNrEMbDyKlqz9n06cyGPAUnn9wESs9VyWowTOg==
X-Google-Smtp-Source: AKy350Z1IPBbWNP2uJwNYPOhXY4WLqaEGXl3CnXxu+y6Ed8aMqlmmorLyzWOVHVRPfRruHmNhT2WjIZfTWq/7f21k7k=
X-Received: by 2002:a05:600c:4f42:b0:3f1:6839:74a1 with SMTP id
 m2-20020a05600c4f4200b003f1683974a1mr1119wmq.6.1682097650270; Fri, 21 Apr
 2023 10:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230420210945.2313627-1-pcc@google.com> <ZEKAZZLeqY/Vvu+z@arm.com>
In-Reply-To: <ZEKAZZLeqY/Vvu+z@arm.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Fri, 21 Apr 2023 10:20:38 -0700
Message-ID: <CAMn1gO7Kf39nTjrggPmk+biUa9A7sQ7JG8ZNfeH5yQzmQA=+rw@mail.gmail.com>
Subject: Re: [PATCH] arm64: Also reset KASAN tag if page is not PG_mte_tagged
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     andreyknvl@gmail.com,
        =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= 
        <Qun-wei.Lin@mediatek.com>,
        =?UTF-8?B?R3Vhbmd5ZSBZYW5nICjmnajlhYnkuJop?= 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        =?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?= 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Apr 21, 2023 at 5:24=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Thu, Apr 20, 2023 at 02:09:45PM -0700, Peter Collingbourne wrote:
> > Consider the following sequence of events:
> >
> > 1) A page in a PROT_READ|PROT_WRITE VMA is faulted.
> > 2) Page migration allocates a page with the KASAN allocator,
> >    causing it to receive a non-match-all tag, and uses it
> >    to replace the page faulted in 1.
> > 3) The program uses mprotect() to enable PROT_MTE on the page faulted i=
n 1.
>
> Ah, so there is no race here, it's simply because the page allocation
> for migration has a non-match-all kasan tag in page->flags.
>
> How do we handle the non-migration case with mprotect()? IIRC
> post_alloc_hook() always resets the page->flags since
> GFP_HIGHUSER_MOVABLE has the __GFP_SKIP_KASAN_UNPOISON flag.

Yes, that's how it normally works.

> > As a result of step 3, we are left with a non-match-all tag for a page
> > with tags accessible to userspace, which can lead to the same kind of
> > tag check faults that commit e74a68468062 ("arm64: Reset KASAN tag in
> > copy_highpage with HW tags only") intended to fix.
> >
> > The general invariant that we have for pages in a VMA with VM_MTE_ALLOW=
ED
> > is that they cannot have a non-match-all tag. As a result of step 2, th=
e
> > invariant is broken. This means that the fix in the referenced commit
> > was incomplete and we also need to reset the tag for pages without
> > PG_mte_tagged.
> >
> > Fixes: e5b8d9218951 ("arm64: mte: reset the page tag in page->flags")
>
> This commit was reverted in 20794545c146 (arm64: kasan: Revert "arm64:
> mte: reset the page tag in page->flags"). It looks a bit strange to fix
> it up.

It does seem strange but I think it is correct because that is when
the bug (resetting tag only if PG_mte_tagged) was introduced. The
revert preserved the bug because it did not account for the migration
case, which means that it didn't account for migration+mprotect
either.

> > diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> > index 4aadcfb01754..a7bb20055ce0 100644
> > --- a/arch/arm64/mm/copypage.c
> > +++ b/arch/arm64/mm/copypage.c
> > @@ -21,9 +21,10 @@ void copy_highpage(struct page *to, struct page *fro=
m)
> >
> >       copy_page(kto, kfrom);
> >
> > +     if (kasan_hw_tags_enabled())
> > +             page_kasan_tag_reset(to);
> > +
> >       if (system_supports_mte() && page_mte_tagged(from)) {
> > -             if (kasan_hw_tags_enabled())
> > -                     page_kasan_tag_reset(to);
>
> This should work but can we not do this at allocation time like we do
> for the source page and remove any page_kasan_tag_reset() here
> altogether?

That would be difficult because of the number of different ways that
the page can be allocated. That's why we also decided to reset it here
in commit e74a68468062.

Peter

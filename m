Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8026F43D61D
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 23:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhJ0V7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 17:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhJ0V7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 17:59:43 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4566C061348;
        Wed, 27 Oct 2021 14:57:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z20so16448091edc.13;
        Wed, 27 Oct 2021 14:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CQvz9TZ32Kb1GiUC4FEdq67vGwshSMFaVjEepIS/INM=;
        b=RoO9FhMQ8yYJoBfZ0JQBmnbifXJac/BkLqpWrskN56Rbm1FWLdlVQfNAqhe2ajS8CH
         CZYVCQ7/SwIM8BPMXCO5gjDKL+GJxyWXj6Dw+8wHhv6vA0lJpqkRraY2z2hcE/NrMP1n
         vP4i71PWu1LeZVIS3XjlEUyabkuvTCBRxsCtKz4IBTq0ZoLSMidRCRwQuaGOHu3rKg9Y
         w068GC8MwKfinEIf/doBe4Kv4Oow+r0cwghH9Alq6u3FGzu9iAaMFQd37vYdhGqVZbtq
         m+GAyUMcjgMuVzn1wu/qsPtW+lsf0n6ny1K1MPbqVFpt07DAp83QUEc7gvwjVqgLdhtn
         TT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CQvz9TZ32Kb1GiUC4FEdq67vGwshSMFaVjEepIS/INM=;
        b=R48r/2uKkK8VT8V2FiDtfJxeQdCHciA8PnfQ1e9QTaSErXq9aJtcAvU4HWPHuGJzYr
         rfpiHBa10xa/XRMRFaM/FNf/mSFHipdTAQyAP1hDR4SW4LZUPlBoLPZYMqBKRxy8UTJ7
         fQjnFl7lLgqeBi3YfnI3ox+wNZmIYEzmjfQmA/Mxh28/rWjwPY3mWxPLhyJsnwhtvlut
         3PibhQXgLvXjcRBpOCJPA0D4ei3oAYbIj6ku50A5+OX7e1ATDnOjZD/UfO0pPSyUyxJM
         5Sr6buxoEJWKJjdWg4hqWB6HfGodAfIIyqBMqyUTSGOyLa4rwScLHA7+HqK125VKFUKy
         fLng==
X-Gm-Message-State: AOAM531aCbVrrpZLsRawo/6A4oF+I0FKBEEKWL8qGtpXrP1Q5j5YcC+d
        jgKD5eoQ8oP45kkoSkWFXb4vAOVGwRMN1G6mo8c=
X-Google-Smtp-Source: ABdhPJy5Nn9hv5MsR/7yZbB39z5wO1SNl60QIQ1yDLfDZ+UfKPZ5n64Ov/EgNY5rwTCyZlMKH1d3hWr4bYZqap1MQ8U=
X-Received: by 2002:a17:906:3f83:: with SMTP id b3mr227956ejj.233.1635371836131;
 Wed, 27 Oct 2021 14:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211027195221.3825-1-shy828301@gmail.com> <C8C6E50C-D300-40D4-AA5C-490F673BADFE@fb.com>
 <CAHbLzkqTW9U3VvTu1Ki5v_cLRC9gHW+znBukg_ycergE0JWj-A@mail.gmail.com> <20211027135328.001e4582a9535e8e4be785bb@linux-foundation.org>
In-Reply-To: <20211027135328.001e4582a9535e8e4be785bb@linux-foundation.org>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 27 Oct 2021 14:57:04 -0700
Message-ID: <CAHbLzkpPuM=R3=4wCY_pVzJMaHqm=JYff-+7nVWg-pzjsr+2zw@mail.gmail.com>
Subject: Re: [PATCH] mm: khugepaged: skip huge page collapse for special files
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Song Liu <songliubraving@fb.com>, Hugh Dickins <hughd@google.com>,
        "sunhao.th@gmail.com" <sunhao.th@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andrea.righi@canonical.com" <andrea.righi@canonical.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 1:53 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 27 Oct 2021 13:44:37 -0700 Yang Shi <shy828301@gmail.com> wrote:
>
> > > > --- a/mm/khugepaged.c
> > > > +++ b/mm/khugepaged.c
> > > > @@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
> > > >       if (!transhuge_vma_enabled(vma, vm_flags))
> > > >               return false;
> > > >
> > > > -     /* Enabled via shmem mount options or sysfs settings. */
> > > > -     if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
> > > > +     if (vma->vm_file)
> > > >               return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
> > > >                               HPAGE_PMD_NR);
> > >
> > > Am I misreading this? If we return here for vma->vm_file, the following
> > > logic (shmem_file(), etc.) would be skipped, no?
> >
> > Oh, yes, you are right. My mistake.
> >
> > Andrew,
> >
> > Could you please apply the below fix?
>
> um, how well tested are these changes?

I has this fix on my test machine, but somehow forgot to fold it into
the original patch. The whole fix was tested by opening /dev/nullb0
readonly and mapping with PROT_EXEC, the THP was not collapsed
anymore.

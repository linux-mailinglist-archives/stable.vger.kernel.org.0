Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC6532EF3E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhCEPnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhCEPnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 10:43:23 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA62C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 07:43:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o6so2261056pjf.5
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 07:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qTbQ4CYrvEtOKN3sK9Cdx0Ymm+PDCdjrJdMZxf0RYq0=;
        b=lwmLF3IOiErjUcagy+4Ncf8810NXSVX+conGSxCWmNt/riBnUgVJQZVMWcg3vcnxXv
         6f6wcdEu/uIoZ0KcuP0/IjGSQ0QpIdsVeQ1JJ6TE4O1dOXtmLxvyjHSp7cqN2hvewarc
         Yw0aNC9TY9kky0pPSGWvkHljTp486c72ju0FrI7R92ojx4ZGsWQ6e/gRElVirmLIK+WQ
         hWwIyIUyssBSxqzgh8oLFNsccj6aO2DCnM77KkbqIjeUEpI0IdPH6Obwp9dF09e1z4C4
         8mlYPiPar785lv8uIL/0PMEEX7f7XAOvkdDyLc4UEfHY9daDyNe/L7+4tET/s1eLH4aT
         Nd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qTbQ4CYrvEtOKN3sK9Cdx0Ymm+PDCdjrJdMZxf0RYq0=;
        b=tlaWTaNybixL4GuA5i24AlN9AY7kQ+DbWPtrfNIiXe+YNYpgWdC6XwnXvfnd//wcur
         mn7bhdsBJE5UD5k+6rrZ7qCovNWcPeAQyU4VytoUWpnvO+ZcqyYNaY/bTDj9wUNeFM5V
         +RkNNNOhHSXHoH3wgbZbvcBb5C7rBlUr5Gnt4EOFZBxkwWvKfR19SW8Cq8IxlE0ICTLB
         D2PyLrDppLe6JiSJn7G4jBqYmH/CBSCpzu2TxPtHTLSfMpDocmDgqLyKe8j499w3XUk+
         m5IIVIroC91mhCCpg/25vRwIPTUq6OF++oWE4WMExdOrKdqKJ11sujFhuOPO+kkguT8e
         JMQQ==
X-Gm-Message-State: AOAM530fV4rEAONl/6Atbe2SgymoU9x48YOylG7D60MozkgNAswkvb40
        5b19U92CCe9zUVCfZhPm305FwFxTsHiWvC2rBe8gnQ==
X-Google-Smtp-Source: ABdhPJzdb3CY0QwcYOqHImrSnnH70zbmg63DQ3nvCH+FSGncxT3ZHCijk26cQodq50iP8kPOOhtL3hkAiA5TAMpm3G4=
X-Received: by 2002:a17:902:7898:b029:e4:182f:e31d with SMTP id
 q24-20020a1709027898b02900e4182fe31dmr9028328pll.13.1614959002581; Fri, 05
 Mar 2021 07:43:22 -0800 (PST)
MIME-Version: 1.0
References: <1aa83e48627978de8068d5e3314185f3a0d7a849.1614302398.git.andreyknvl@google.com>
 <20210303152355.fa7c3bcb02862ceefea5ca45@linux-foundation.org>
In-Reply-To: <20210303152355.fa7c3bcb02862ceefea5ca45@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Fri, 5 Mar 2021 16:43:11 +0100
Message-ID: <CAAeHK+yVG0-36TUpH8EkQ7r1DHNGTHuOfLfKBKO3aDtCV0RnRQ@mail.gmail.com>
Subject: Re: [PATCH] kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 4, 2021 at 12:23 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 26 Feb 2021 02:25:37 +0100 Andrey Konovalov <andreyknvl@google.com> wrote:
>
> > Currently, kasan_free_nondeferred_pages()->kasan_free_pages() is called
> > after debug_pagealloc_unmap_pages(). This causes a crash when
> > debug_pagealloc is enabled, as HW_TAGS KASAN can't set tags on an
> > unmapped page.
> >
> > This patch puts kasan_free_nondeferred_pages() before
> > debug_pagealloc_unmap_pages().
> >
> > Besides fixing the crash, this also makes the annotation order consistent
> > with debug_pagealloc_map_pages() preceding kasan_alloc_pages().
> >
>
> This bug exists in 5.12, does it not?
>
> If so, is cc:stable appropriate and if so, do we have a suitable Fixes:
> commit?

Sure:

Fixes: 94ab5b61ee16  ("kasan, arm64: enable CONFIG_KASAN_HW_TAGS")
Cc: <stable@vger.kernel.org>

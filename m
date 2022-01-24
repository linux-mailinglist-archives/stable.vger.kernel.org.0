Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF27A4986A3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbiAXRZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiAXRZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 12:25:46 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1443AC06173B;
        Mon, 24 Jan 2022 09:25:46 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id w7so20412514ioj.5;
        Mon, 24 Jan 2022 09:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xryK/mEgi9MgM4urrErNLEfDy5dITW8r2qeFkYk3a0c=;
        b=qei7F8QNutg9V2rXEzUW7gnZppcqvD7+oKb9evsAApMMCgAScr35oSnti9hkeqMIEu
         lb9CT69JKpgXHKiIKO5QvzDPsluVr0r00TQSeYQCVgpFBJ0k8qZSBCBgv+MqNfldTbZd
         Mi1O1wWBWNEqBadRKGMfzz6Ffd/LNi9pYYxiWvsXGE2A1pO7/cpCMeuE7bugLS+3HG2n
         7oG+s8OJnfP1j1MQEpeRUOj/mSglD/aIFWL3IRhHY0WpePTJgnegdHqYvifCVCO3qVlS
         qp/s5GjoANHv+3RoF9pol4gZAtTaHGK06ywBdWBLXvgEYzZxnIsU4dh7wouWhlc9018q
         N6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xryK/mEgi9MgM4urrErNLEfDy5dITW8r2qeFkYk3a0c=;
        b=nTOiRDiezEN7l0yy3HjarNIov4vU0dUbEP3DKcfRMEUBUN6aweXyggJhce48jiLbAw
         HsWeTzQuFHxtoQQkkzN7NbTqIcvICgh+ECaVQMhNIOpXZzgxRhax+WF496kbFPuzLhfw
         CrQVe3SdcJ+JnV/XN3077uPmV+8yuJY3Efha7y/J+LeR+HAqW2SMCw8bAoSO7EKAsn2d
         F+Dmbmy2gPcbUATj9V0E/ODPszxWAmpQCj3CbBQv4V2hh4KXTp6BeI/f8iqXmTHbakc4
         EiZaoMweekVzalbm/CduKOKovX6RkgNu/o8ALaJ3N3XqiZzKzwICY0AuB73MFH63SVNa
         6C0w==
X-Gm-Message-State: AOAM530Rk28G6i6nY32I0GVAkL/UdoEto+bK5eslH7TGZvPK4Ip9QHbf
        2yaSjxcTrOpek3mF86rVSNhoJGuVbN/lTbGUJTM=
X-Google-Smtp-Source: ABdhPJzR+lLTq4j43wUwhYZcdWFOEBfVtN2enYkw/321gz3RwwgrQbOyjjt20T0R02kxJiMgNhiL4h88dgoJc7A+xPA=
X-Received: by 2002:a05:6602:1646:: with SMTP id y6mr8654444iow.99.1643045145518;
 Mon, 24 Jan 2022 09:25:45 -0800 (PST)
MIME-Version: 1.0
References: <20220120020148.1632253-1-pcc@google.com> <CA+fCnZeC5K+YoFbMg30Gasyq6AXp5WFCxagrsftkT+mJPuBZkQ@mail.gmail.com>
In-Reply-To: <CA+fCnZeC5K+YoFbMg30Gasyq6AXp5WFCxagrsftkT+mJPuBZkQ@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Mon, 24 Jan 2022 18:25:34 +0100
Message-ID: <CA+fCnZfQ557MGc33jpSu9+ctUyXOaHR+tzsScPa3jZdkDiLjvA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: use compare-exchange operation to set KASAN page tag
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 6:22 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>
> On Thu, Jan 20, 2022 at 3:02 AM Peter Collingbourne <pcc@google.com> wrote:
> >
> > It has been reported that the tag setting operation on newly-allocated
> > pages can cause the page flags to be corrupted when performed
> > concurrently with other flag updates as a result of the use of
> > non-atomic operations. Fix the problem by using a compare-exchange
> > loop to update the tag.
> >
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
> > Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
> > Cc: stable@vger.kernel.org
> > ---
> > v3:
> > - use try_cmpxchg() as suggested by Peter Zijlstra on another
> >   patch
> >
> > v2:
> > - use READ_ONCE()
> >
> >  include/linux/mm.h | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index c768a7c81b0b..87473fe52c3f 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1531,11 +1531,18 @@ static inline u8 page_kasan_tag(const struct page *page)
> >
> >  static inline void page_kasan_tag_set(struct page *page, u8 tag)
> >  {
> > -       if (kasan_enabled()) {
> > -               tag ^= 0xff;
> > -               page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
> > -               page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
> > -       }
> > +       unsigned long old_flags, flags;
> > +
> > +       if (!kasan_enabled())
> > +               return;
> > +
> > +       tag ^= 0xff;
> > +       old_flags = READ_ONCE(page->flags);
> > +       do {
> > +               flags = old_flags;
> > +               flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
> > +               flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
> > +       } while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
> >  }
> >
> >  static inline void page_kasan_tag_reset(struct page *page)
> > --
> > 2.34.1.703.g22d0c6ccf7-goog
> >
>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
>
> FWIW, try_cmpxchg() doesn't seem to be doing annotated atomic accesses
> when accessing old_flags, so using READ_ONCE() in page_kasan_tag_set()
> seems pointless after all.

Ah, nevermind. For a second I thought that try_cmpxchg() is actually
accessing page->flags through its second argument.

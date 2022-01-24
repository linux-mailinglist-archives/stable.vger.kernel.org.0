Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24874498525
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243890AbiAXQq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243904AbiAXQq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:46:56 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23303C061744
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:46:56 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id m6so53163261ybc.9
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9bMjbO8pE/Eeqks/NLjs54biBVGg3hGkaC+WJylhww=;
        b=aceonQOCFKz/mF3lO2ptSIoQGHfRhUesPyruSS8TFD4M0aQ/N0z1QosJzjBipUM0/B
         xkkvskU/mcgH49k2OcLpSzg9ITJPDM5wDF5Lg4lxSYBlOjzVuadQTtZQGv1j05KMqIfC
         XFq1QUZhE8h32t27LlslMlNgArRbzAcRscESBSYkDV2QSAFbNu7/y3tlrxYmugjCJpmZ
         I6+Fg7zK8z/23M2n8ydYNN2W0OzVD6cP0Uhfrsm+WJvhoQuix0xX8rrGAySKmrAVZJ7o
         9c0WUBn9JiSPrv3LJU8iOiAb1LRnBJ/fpPwTQdSNrWunVSBoBcIx++2AHaRHIgvBkV8T
         QTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9bMjbO8pE/Eeqks/NLjs54biBVGg3hGkaC+WJylhww=;
        b=x3yDyiVFIQFizppur5O5MA5dU1Rgz06wQ9nnO4zm504XVFTK/lNXMLObM5fMVqH29Y
         59FSDdQT/bMfoMayZOGet8GgHA1mRnikAZcRayWHSt4CFRnKttubinvCTAPRrf89YHf1
         OQCeJTIRaeZ5Tz8c0O+NT1zqUFB5tvwXKmSnw+RVOhjgrvBFkcjfsV5JzUyuNlK9cR+B
         ssTC7W2S7SC9OASbJBNCcLc9sPZZX7+aOXu6JKpbgIDpgcLnx++yiejL4tNwaX+gIXPl
         sWpvjgjgWwMBOlfMsCR6OMDOOOzwhZQSNegzBgnjNBIYpasRKgSh1lmzfVDtIuUMMB8t
         cYXw==
X-Gm-Message-State: AOAM532QC9VCly+l+ZsdJaiMk2zgF8T012StBbaRxHelj5yVI1Bn7wch
        o49OyjFGi3rubrHgzB5hrPmp0UVviT/xx+Tqq5R5M5NEnQA6jg==
X-Google-Smtp-Source: ABdhPJwnom0q6R8v/exQZAGKf39qbHX/WDAqCzU74hVlnqFWIRQb3A7tYXzXgXQrDE9z1vYpyWPKv11UR7sixmPhPOo=
X-Received: by 2002:a25:d617:: with SMTP id n23mr25340718ybg.488.1643042814481;
 Mon, 24 Jan 2022 08:46:54 -0800 (PST)
MIME-Version: 1.0
References: <Ye7BluXgj+5i9VUb@decadent.org.uk> <Ye7EZaQh/nYk4Oz+@kroah.com>
In-Reply-To: <Ye7EZaQh/nYk4Oz+@kroah.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Mon, 24 Jan 2022 08:46:43 -0800
Message-ID: <CAJuCfpEA=Wwd2=fn2aNark8+CqXwY90ibpbd6HF1WzcrUSdOPQ@mail.gmail.com>
Subject: Re: [PATCH 4.14,4.19] mips,s390,sh,sparc: gup: Work around the "COW
 can break either way" issue
To:     Greg KH <greg@kroah.com>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 7:23 AM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jan 24, 2022 at 04:11:18PM +0100, Ben Hutchings wrote:
> > In Linux 4.14 and 4.19 these architectures still have their own
> > implementations of get_user_pages_fast().  These also need to force
> > the write flag on when taking the fast path.
> >
> > Fixes: 407faed92b4a ("gup: document and work around "COW can break either way" issue")
> > Fixes: 5e24029791e8 ("gup: document and work around "COW can break either way" issue")
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  arch/mips/mm/gup.c  | 9 ++++++++-
> >  arch/s390/mm/gup.c  | 9 ++++++++-
> >  arch/sh/mm/gup.c    | 9 ++++++++-
> >  arch/sparc/mm/gup.c | 9 ++++++++-
> >  4 files changed, 32 insertions(+), 4 deletions(-)
>
> Thanks, now queued up.

Thanks for catching this. I completely missed the extra uses in the
previous versions.

>
> greg k-h

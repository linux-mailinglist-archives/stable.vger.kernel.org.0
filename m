Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE904C208C
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 01:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiBXAVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 19:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiBXAVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 19:21:50 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701CE57B3C
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:21:21 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id t22so488739vsa.4
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ucQ1DTIJLBq5JuNolG9KsICDWacOn6WqXrjGTHgRbY=;
        b=Za6VIVnsDF95qecvmFHieKfp30boPKOB6V/kqjA7sDYaNkTOS9shtROcEdhKuUiGeQ
         WZcpXy1qd0tL4L2VW5RBDiBq+HTJCLJa54aiJQpBdzrc0MOjRjeVjTJ4PcCnGO6shiBj
         7vw9Yh9gf1LvUf5+RKNKxXUyPLs5irZ1F7Yqk4HC9VTvYjjvrd2OvOBN47cN9D04XjTz
         q7H35oIVNjaSbzoPf77EWtJ3v0wX5VhVHutj2PLukue0E0PLL1QSB72d6JWmnavNTU+h
         fBb/5fETbgp38XLUZ2Cxc+gp0SBg9z0Gb3KHGCfg3I0HHminNAOvOZPEUCslqYBCyIry
         80XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ucQ1DTIJLBq5JuNolG9KsICDWacOn6WqXrjGTHgRbY=;
        b=AvOaCsR52jpFSAurfZ2cVrOSIVlOLH8Vp7OGJMaOxLrsAOzKIqM87lVvYUhx9f60Pw
         lzcnsXVx66LWcFgdhTUP+PpLb2eE+cSTEQhz2b70v2S34Nnw05kPgH4ndizXqrZwXGwE
         xFzknv66Z2z9A25FivMN3r2wPcu7tKwGurMf4S1tiE6h1OVNaCEf083tfs/FKccgC8EU
         7ULgWnbUZDzrLufGny9mgyMwD7d+SBNCb6VfUy4hylYJUhBoXVnqkn81BbLf5Ivj8UL9
         m3GOMQt7AoYAQAxWpEIzmSW062o/AWwDndO0ShyvK6enubyg9VTFsCs3k3xYKoKSPLuC
         PKYQ==
X-Gm-Message-State: AOAM533Ox08K9aZDR8FaJr5jO4bgpKsXlqLwjfqIgGoAz8SNbVw/Pbv8
        Qk669TdvkkkBfN3V4TrTmRoIk6rCAa6krXEzjaA5tg==
X-Google-Smtp-Source: ABdhPJxg4WD8p/h/YealQ4a344YFkyDUBXzqwn0B7MRxC+bjfuaxX7E04calQVpmufW4DG1pNyZtm+VetDPdSg/br2U=
X-Received: by 2002:a67:ca1b:0:b0:30b:9d28:1ce5 with SMTP id
 z27-20020a67ca1b000000b0030b9d281ce5mr96888vsk.61.1645662080375; Wed, 23 Feb
 2022 16:21:20 -0800 (PST)
MIME-Version: 1.0
References: <20220219012643.892158-1-pcc@google.com> <CANpmjNMfemciY2Qn7aZ1Z0EvTA21CqZ6zei+dncGMedWr0-6cQ@mail.gmail.com>
In-Reply-To: <CANpmjNMfemciY2Qn7aZ1Z0EvTA21CqZ6zei+dncGMedWr0-6cQ@mail.gmail.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Wed, 23 Feb 2022 16:21:09 -0800
Message-ID: <CAMn1gO563a+GZrob6XpgZhhTgy9drjSA+LUpBHBkojHteVc7NA@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix more unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
To:     Marco Elver <elver@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "# 3.4.x" <stable@vger.kernel.org>
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

On Mon, Feb 21, 2022 at 3:20 AM Marco Elver <elver@google.com> wrote:
>
> On Sat, 19 Feb 2022 at 02:26, Peter Collingbourne <pcc@google.com> wrote:
> >
> > This is a followup to commit f649dc0e0d7b ("kasan: fix unit tests
> > with CONFIG_UBSAN_LOCAL_BOUNDS enabled") that fixes tests that fail
> > as a result of __alloc_size annotations being added to the kernel
> > allocator functions.
> >
> > Link: https://linux-review.googlesource.com/id/I4334cafc5db600fda5cebb851b2ee9fd09fb46cc
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Cc: <stable@vger.kernel.org> # 5.16.x
> > Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
> > ---
> >  lib/test_kasan.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> > index 26a5c9007653..3bf8801d0e66 100644
> > --- a/lib/test_kasan.c
> > +++ b/lib/test_kasan.c
> > @@ -177,7 +177,8 @@ static void kmalloc_node_oob_right(struct kunit *test)
> >   */
> >  static void kmalloc_pagealloc_oob_right(struct kunit *test)
> >  {
> > -       char *ptr;
> > +       /* See comment in kasan_global_oob_right. */
> > +       char *volatile ptr;
> >         size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
>
> I think more recently we've been using OPTIMIZER_HIDE_VAR() to hide
> things from the compiler. Does OPTIMIZER_HIDE_VAR(ptr) right before
> the access also work in this case?
>
> I leave it to you which you think is cleaner - I'm guessing that we
> might want to avoid volatile if we can.

Okay, sent v2 which uses OPTIMIZER_HIDE_VAR.

Peter

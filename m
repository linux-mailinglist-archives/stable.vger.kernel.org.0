Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F6F5B0E9E
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 22:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiIGUwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 16:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIGUwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 16:52:53 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCCA72EDE
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 13:52:51 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 130so23350560ybw.8
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 13:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=eSmjHP3psGeOMr+WEOk0DOTV5ssd7/gZzN1bjJygBoE=;
        b=W/rcNroN25iYeVvA4FNx54QrYtbADyI5O2H8VEtzNGnvZ9oKm6c48boSOL9AicPayo
         UGAvE69d7IxuzXAA2/xE8dR3nkb39jB1608tET99ZpLMvjZgf9vM1Bu1MrVUGg7jcURa
         kN26DNyIQ5oqvDFkQFEH0V5+sVSSHBYL5cONOS4K9Gc82pdferYtOdBvjOEpty8BSuuc
         gXAtJVbIQ5Zv3wmVklfysoubfyGQBMg16hquIOyw3iqFF8FRjYIyot3QKHBqPLadevHq
         aiTWvTa6/qh35l94HjQnQtgPtOoKlWP3Lspzkh5wG7pxujSow7KZknk2ye4MKUmhu1r/
         tGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eSmjHP3psGeOMr+WEOk0DOTV5ssd7/gZzN1bjJygBoE=;
        b=yAx/VuABEZQNzykNMPsTwDsBSv6hGq6LOJg9fhkgRi+QHwHLoNNQxaapQfLdr1l8Lg
         D/lX+Sr7VQ1dy+nLy4BiuSwNO5EPMDb5c0l1CFr454cxWWPA/96NmegJP3k3JcFl8beI
         QQzvxVxWi4XQrEaJn53G2Dux5u8G/voTqCe7nH1dP1TXOQSPwTjoPGfOHSdMpU/Srqim
         GREpAVE5w2AjSEMqaw3RfiM6J6o8JoSF9DVJN+SHs6Rzv+B5b5NjkEE18OP6+qG/lM7N
         kSz6FTOuhQ1ONuNHmrbM5H34tVi0qaiLzNeJ5c7yrB7gCkym4hxE9bhOY7bIK793YMJQ
         Di8w==
X-Gm-Message-State: ACgBeo1ZdHWs7q0FIi1c/9IwkH5SFUW0sn6aqYC0J9xMP5iHMwTTPLTe
        o6ERcX4/L2YQKyA/AlbYYcHJB6xIbYe9SbtY9MDj0Q==
X-Google-Smtp-Source: AA6agR5SyII+g6dM3/0IIZUA8tRak0g0gdQnoJxzvJTclg/zaQA2sNycYdnFGvhHcXHM1N7GKELHo2uAWHtVy0ENKKY=
X-Received: by 2002:a25:1e86:0:b0:68d:549a:e4c2 with SMTP id
 e128-20020a251e86000000b0068d549ae4c2mr4320074ybe.93.1662583970644; Wed, 07
 Sep 2022 13:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220907173903.2268161-1-elver@google.com> <Yxjf2GtNbr8Ra5VL@boqun-archlinux>
In-Reply-To: <Yxjf2GtNbr8Ra5VL@boqun-archlinux>
From:   Marco Elver <elver@google.com>
Date:   Wed, 7 Sep 2022 22:52:13 +0200
Message-ID: <CANpmjNMNpFUN3mvpAfdgf2NRcrOjMKdnF09UcbPSvAi8+==Byw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kcsan: Instrument memcpy/memset/memmove with newer Clang
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org
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

On Wed, 7 Sept 2022 at 20:17, Boqun Feng <boqun.feng@gmail.com> wrote:
>
> On Wed, Sep 07, 2022 at 07:39:02PM +0200, Marco Elver wrote:
> > With Clang version 16+, -fsanitize=thread will turn
> > memcpy/memset/memmove calls in instrumented functions into
> > __tsan_memcpy/__tsan_memset/__tsan_memmove calls respectively.
> >
> > Add these functions to the core KCSAN runtime, so that we (a) catch data
> > races with mem* functions, and (b) won't run into linker errors with
> > such newer compilers.
> >
> > Cc: stable@vger.kernel.org # v5.10+
>
> For (b) I think this is Ok, but for (a), what the atomic guarantee of
> our mem* functions? Per-byte atomic or something more complicated (for
> example, providing best effort atomic if a memory location in the range
> is naturally-aligned to a machine word)?

There should be no atomicity guarantee of mem*() functions, anything
else would never be safe, given compilers love to optimize all of them
(replacing the calls with inline versions etc.).

> If it's a per-byte atomicity, then maybe another KCSAN_ACCESS_* flags is
> needed, otherwise memset(0x8, 0, 0x2) is considered as atomic if
> ASSUME_PLAIN_WRITES_ATOMIC=y. Unless I'm missing something.
>
> Anyway, this may be worth another patch and some discussion/doc, because
> it just improve the accuracy of the tool. In other words, this patch and
> the "stable" tag look good to me.

Right, this will treat write accesses done by mem*() functions with a
size less than or equal to word size as atomic if that option is on.
However, I feel the more interesting cases will be
memcpy/memset/memmove with much larger sizes. That being said, note
that even though we pretend smaller than word size writes might be
atomic, for no data race to be detected, both accesses need to be
atomic.

If that behaviour should be changed for mem*() functions in the
default non-strict config is, like you say, something to ponder. In
general, I find the ASSUME_PLAIN_WRITES_ATOMIC=y a pretty bad default,
and I'd rather just change that default. But unfortunately, I think
the kernel isn't ready for that, given opinions on this still diverge.

Thanks,
-- Marco

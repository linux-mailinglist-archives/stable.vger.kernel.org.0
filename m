Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9B0351FC2
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhDAT1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbhDAT1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:27:34 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47676C02D54D
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:59:22 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id d2so2891267ilm.10
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LTrV/slVNcOkclb52d6/XH5+RZLu+eLYQgE7tTk9jm8=;
        b=XqoN1J3OfCjIrC0KWqrkgQ4DHvlDvGlYbtGG6DwF8z4jqeqPjQ1wpeF1fBeQsk8Od9
         YkUQRF3ovgwy4aaADuNf66LgpJIfpfyEmaVzlL/9XTx8Z/9sLBkqco+k5KxHi74jEIQZ
         72DMM9iMns8rRBgUeb6W3OyJCjDnuFyIiDThI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LTrV/slVNcOkclb52d6/XH5+RZLu+eLYQgE7tTk9jm8=;
        b=rOv1zYtM/0EOv8EZJHCQLXsDHuGgkNVeSOIOfLfNIudelXQrAhH5Vp0r8o2XujSk6r
         3K79xQsRQyobK8dp4OcfQegrPzX+O92RY03sG2a8ahWQmsD3esZ4BEbzmOZHIlwHw6Wu
         CwyI2CUxReG0JPqtq87VuXGfS50BwuEcLLMkLx4pk/o7rHfcau4UAR5J6Q/zhYZmBlm/
         BZ+TBrU6ElT7QGiuAHhiOBW8sZbKa8VXlv1yi1yp15q9Abi0+xPzOFZrrVwVeZvVc6cS
         gPF99CAIg/OuBPGe4i27pC32C/s/I3btJnL3Lu/ppngE1eHPfVezDAu0IUZMigXkMJx/
         Wv0g==
X-Gm-Message-State: AOAM532/1zZI4geZPlOQQOWWw06Efldzw9dFgQvzYBOKuO47oy3EAF0m
        pizfpZIfRXckageFxm7jT8SAiBNh3Wu+Ag==
X-Google-Smtp-Source: ABdhPJyL+0gIADmhZN316S5q1/OxIKYr5Sb6ptb0Hsk0HjGapPqvmmQVA1R041zJeOJSq0zlQdQjmw==
X-Received: by 2002:a92:d28b:: with SMTP id p11mr8060249ilp.130.1617303560936;
        Thu, 01 Apr 2021 11:59:20 -0700 (PDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com. [209.85.166.176])
        by smtp.gmail.com with ESMTPSA id s11sm2902583ilh.47.2021.04.01.11.59.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 11:59:19 -0700 (PDT)
Received: by mail-il1-f176.google.com with SMTP id d2so2891154ilm.10
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:59:19 -0700 (PDT)
X-Received: by 2002:a05:6e02:20ee:: with SMTP id q14mr7590690ilv.223.1617303559149;
 Thu, 01 Apr 2021 11:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com>
In-Reply-To: <20210401181741.168763-1-surenb@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Apr 2021 11:59:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
Message-ID: <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 1, 2021 at 11:17 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> We received a report that the copy-on-write issue repored by Jann Horn in
> https://bugs.chromium.org/p/project-zero/issues/detail?id=2045 is still
> reproducible on 4.14 and 4.19 kernels (the first issue with the reproducer
> coded in vmsplice.c).

Gaah.

> I confirmed this and also that the issue was not
> reproducible with 5.10 kernel. I tracked the fix to the following patch
> introduced in 5.9 which changes the do_wp_page() logic:
>
> 09854ba94c6a 'mm: do_wp_page() simplification'

The problem here is that there's a _lot_ more patches than the few you
found that fixed various other cases (THP etc).

> I backported this patch (#2 in the series) along with 2 prerequisite patches
> (#1 and #4) that keep the backports clean and two followup fixes to the main
> patch (#3 and #5). I had to skip the following fix:
>
> feb889fb40fa 'mm: don't put pinned pages into the swap cache'
>
> because it uses page_maybe_dma_pinned() which does not exists in earlier
> kernels. Because pin_user_pages() does not exist there as well, I *think*
> we can safely skip this fix on older kernels, but I would appreciate if
> someone could confirm that claim.

Hmm. I think this means that swap activity can now break the
connection to a GUP page (the whole pre-pinning model), but it
probably isn't a new problem for 4.9/4.19.

I suspect the test there should be something like

        /* Single mapper, more references than us and the map? */
        if (page_mapcount(page) == 1 && page_count(page) > 2)
                goto keep_locked;

in the pre-pinning days.

But I really think that there are a number of other commits you're
missing too, because we had a whole series for THP fixes for the same
exact issue.

Added Peter Xu to the cc, because he probably tracked those issues
better than I did.

So NAK on this for now, I think this limited patch-set likely
introduces more problems than it fixes.

        Linus

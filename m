Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5C623F403
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHGUx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGUxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 16:53:25 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC88C061756;
        Fri,  7 Aug 2020 13:53:25 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i26so2183986edv.4;
        Fri, 07 Aug 2020 13:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uDdO7KYbxhxTk2FOJVbqBVzcbLgZ7jU5XfocoxoIBgI=;
        b=oMkbbQecdxBGwszkCSHjbswohitljIgQwkOQWaGukPotDPUE+7V5FqR8o21TlFSPZM
         VZFDmTR6WqPYKfGFGayZpJHlShZEQsgXE1YKOTOlOIJLLidt928lE7XmfS66hfv25SrU
         xbfpNpACS7a9qXUxwR26fHO3cV40IevWLB88M2CW5+ilqTNkGaA9vLebcRDqL63ZgECr
         IIa/53RI/TYMdm7dJNZZzTKitXZdWmhzOOvHbv7xWK36UGYk3T/S9DC2+KF6Q3mp36eU
         QBN96wXQGcKI+A12i+/kNwzHqS+QWQ695pqsYp54nfgxil0ad2eeyKq6h1BkjEIVnmGU
         ycGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uDdO7KYbxhxTk2FOJVbqBVzcbLgZ7jU5XfocoxoIBgI=;
        b=JJGxKkBn1VGugG1jOgFDq4TUH5TTUCa7y2m7yNizxnmlnmcb2T7rK7toCCEj4rDlW/
         Kq6ZY4L0SvGWZiGgV4lX9hFP+CTiArdHXs/BIh4CtSaqy6pz94u8kCCab57vSS3ZMo2b
         OyK5DnhklTmT4O70adMqyQjZ0huqHCDzeKxlQaMzId+fTh7NoTLcxrgRj98XSpmZbcuF
         N5+aTR4XEBHJqrA6zMPGX9T18bl0Jzhjph0jea/N6wGQwnyxYGb+9TIkAihyvi5hevgu
         SOuqQAKz3rsbAm8Xtl5DfuGz2MSMd0ZI0m4vPqPS7dW0hkbTdJbDt79L96db/GawEO+i
         ceWA==
X-Gm-Message-State: AOAM531WajbJrbvEZZJwXcWYSIKydv2gFWs+oJPTuP9uLwSBej9xQUH1
        BxDSh6SyfTvxWHHmx1pju7gAfQS9L7qW2L/Hpkg=
X-Google-Smtp-Source: ABdhPJw2DTnQO7A+X9ua1LSB52QrGpIJx4BF1Nb+Lgekbo+gJCkfmnEsq56kQIekJo8f6pdqErfZ/G2lea1hf2CtIvQ=
X-Received: by 2002:a05:6402:1d92:: with SMTP id dk18mr10324663edb.206.1596833604283;
 Fri, 07 Aug 2020 13:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
 <20200807061706.unk5_0KtC%akpm@linux-foundation.org> <CAHk-=wiK1oh8T_GNdnQk4UERuWmLQMnXuia8CpJ5QVzSAKuffQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiK1oh8T_GNdnQk4UERuWmLQMnXuia8CpJ5QVzSAKuffQ@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Fri, 7 Aug 2020 13:53:07 -0700
Message-ID: <CAHbLzkrSQ8CT5jaT-8LFtnEg-63qdZNoHe6XBc3F4orxuHt-7A@mail.gmail.com>
Subject: Re: [patch 001/163] mm/memory.c: avoid access flag update TLB flush
 for retried page fault
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <hdanton@sina.com>,
        Hugh Dickins <hughd@google.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Xu <xuyu@linux.alibaba.com>,
        Yang Shi <yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 11:17 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Aug 6, 2020 at 11:17 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Yang Shi <yang.shi@linux.alibaba.com>
> > Subject: mm/memory.c: avoid access flag update TLB flush for retried page fault
>
> This is not the safe version that just avoids the extra TLB flush.
>
> This is - once again - the thing that skips the whole mkdirty and page
> table update too.
>
> I'm not taking it this time _either_.

I'm supposed Catalin would submit his proposal (flush local TLB for
spurious TLB fault on ARM) for this specific regression per the
discussion, right?

And, the more general spurious TLB fault problem sounds not that
urgent since it should be very rare.

>
> Andrew, please flush this garbage from your system.
>
>                  Linus
>

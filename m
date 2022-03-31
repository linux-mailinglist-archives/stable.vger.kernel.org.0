Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41E34EDFDE
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 19:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiCaRoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiCaRog (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:44:36 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0D11A7777
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 10:42:49 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id r11so320444ila.1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 10:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U6ubVyBj38as5ODvGkC2B53srjaNL+Mv+ZjXdsr+jM8=;
        b=KOCaD+P3GIvKPSqNHIQNAmKa4Vf1WscepMhpco1VgttITKOlurmEPIhskbFLSb7Fg5
         AqFWxnnJYPjCnRolaik4JNfErwayE+4s/QjWXpN12Lebz8NUJhuwybfcQ3iDRcw76W7v
         kSF0A5YgSUYIvceZ5nMvrS45t5K6h2yfS930wYNZkUb082UR1d49PksjevHryYf6p4R3
         inox+lUFRx3t6ythmpop7G5KyuiTdJ5rUZE0dLJdm/gnW6utqDX/g/MbJ1fSuPkIg2X0
         BUO724aAfY8P+rwczuaymyiK4cxLq23LpwQeL485f1tmM/ZNLRu9g0KmKKNfid79i/5J
         pf9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U6ubVyBj38as5ODvGkC2B53srjaNL+Mv+ZjXdsr+jM8=;
        b=yf6itFOXu8zGOjl/HyQ8y2zYkRItLNCsiIWlMufIEDwF7bs9b/BOvV3RaI2aVhwQ3H
         g6fUJuJLWT7UNrwYY57YU22C6WcXdN1+Sf24sB+0S+0APaV9hcYFo/jkNz5kPUeY8pmn
         eTWdU7bUpgF8H7K6BE7qLXQFYhRBHdKJPo6Fck1FU59IHsE6/Wf9P3d8IW5HFnEHTsqK
         vfpdFqP9Fts8mcloGegp6A3ij4ij9pY9/gIQg+khTFKJiZNY5TsbefjSIzQ1YcUkI/yX
         LDcQK3mRgYeVJn2f5GxRlRrcmcHLp3hbahhvWxtCFusZYrfHp2LvHixjR5+4QgbQX5cB
         gEeQ==
X-Gm-Message-State: AOAM533CHx76tCqxkw+oTj6spiLnqYIX89DgHU4CMdqQjWCKRllrvbZ0
        XKJStpztaV67tdn9PCib4apHYt+gN5Jry8s34KfTlQ==
X-Google-Smtp-Source: ABdhPJzhrTiHesLUYytbExq7eH2GVZ+C3SxVbjPG4iZ47nyBE8cD82nlbPQh/5qffMfcXUwCDaN6MpXjfUeRDq8K5JE=
X-Received: by 2002:a05:6e02:1a08:b0:2c9:caca:b2 with SMTP id
 s8-20020a056e021a0800b002c9caca00b2mr8773091ild.247.1648748568350; Thu, 31
 Mar 2022 10:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220324210909.1843814-1-axelrasmussen@google.com>
 <YjzjiDFBgigPqEO9@casper.infradead.org> <CAJHvVcj90ROLGWGZi_f5b4VCugD4o7v3quCv-6A6jPUdMbqi6A@mail.gmail.com>
In-Reply-To: <CAJHvVcj90ROLGWGZi_f5b4VCugD4o7v3quCv-6A6jPUdMbqi6A@mail.gmail.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Thu, 31 Mar 2022 10:42:12 -0700
Message-ID: <CAJHvVchqPygpw9DGYuab+2ymFtF41E7RUyUUOiRHh1wicRgqCA@mail.gmail.com>
Subject: Re: [PATCH] mm/secretmem: fix panic when growing a memfd_secret
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
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

Any strong opinions on which error code is used? I think overall I
would still pick EOPNOTSUPP, but happy to change it if anyone feels
strongly.

- I think ENOSYS is specific to syscall nr not defined
- I think ENOTTY is specific to ioctls
- The kernel (sort of mistakenly) defines ENOTSUPP instead of ENOTSUP,
but it's marked deprecated and it's recommended to use EOPNOTSUPP
instead (despite POSIX saying these should be distinct and for
different uses).

On Thu, Mar 24, 2022 at 2:44 PM Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> On Thu, Mar 24, 2022 at 2:33 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Mar 24, 2022 at 02:09:09PM -0700, Axel Rasmussen wrote:
> > > This patch avoids the panic by implementing a custom setattr for
> > > memfd_secret, which detects resizes specifically (setting the size for
> > > the first time works just fine, since there are no existing pages to try
> > > to zero), and rejects them as not supported (ENOTSUP).
> >
> > Isn't ENOTTY the normal return value for this?  Or even ENOSYS?
>
> I'm unsure.
>
> Since errno(3) says ENOTTY means "Inappropriate I/O control operation"
> that makes me think it's meant to be used only for ioctls?
>
> I tried ENOSYS, but checkpatch warns me it's meant to be used for
> "invalid syscall nr" and nothing else.
>
> ENOTSUP / ENOTSUPP / EOPNOTSUPP all have their own share of
> weirdnesses too, though. There's the whole ENOTSUP / ENOTSUPP mess,
> and then also the fact that glibc says ENOTSUP == EOPNOTSUPP, whereas
> POSIX says EOPNOTSUPP should be distinct and used specifically for
> sockets...

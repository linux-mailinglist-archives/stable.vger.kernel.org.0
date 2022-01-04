Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3B44847A7
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbiADSUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiADSUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:20:19 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9518FC061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 10:20:18 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id o12so83625154lfk.1
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 10:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T90qK5WrIProRXKF6NNglO1QrpHxd/4mhxmZa401pIE=;
        b=hzC6WWrMCZZnON3Pps8dYWInoIrWRr8XyaIWomKCykwky/TndKi6B5JS4x96dYv7Lw
         mvB7jxfylsVmEnNhhwFpEekur00G+XyuJe/0SEbePEexc1hI8PvvxqpnpHqOapJCCwQ2
         mvbA8ixr/8rHLXOWSQLvoStlzCyRmWieZcf33Wqfkf/tw1p0VlvNxFljLVBtyox067D7
         wnBDwSrz4itY+UQF2Mh75EHAtKRPSM30iv83k6sdK2g6A2v9kdtuWoU1pYZfS2vrhNO/
         THbNTifGIkrRd6XYX2i8+IQJ/0YvFic1ZgRLnbxHpv8bepXC/sBJ6CRJuPRw3z+iEPfA
         mmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T90qK5WrIProRXKF6NNglO1QrpHxd/4mhxmZa401pIE=;
        b=XQ3gjKhlk49NTF+9DNu15iFufY2J8Zn7ojKtruSN4FZANFOeuKHIELKVjZXn5MqvMu
         uKxWY7AeBcrUWnsp0TEeo+Mk8/J1eELdiN55AfMyrwYwyfANxQod+8vPzGftidhMHmrO
         njkgJ9qvuOnMl0nUO8vj7hPxIc+IVW2ihFiq4ZutbWUSRIQ03FrSKFY2zv40gkY8EjGY
         lXrr7jyuIZedoPfGuOMzLOnYuobQ3E4ar+Zr9thvBIzWtWc/opoxepn3lXizg1km9lLK
         TYvII6xr9ZgbXqckla9Kdaa2PwZgYe3yBDavzj3g6M1PsoIT1jHhJ+6MzjyX4Y6KB04z
         T9+g==
X-Gm-Message-State: AOAM533PscUeT7AMs/hE3xB3kLTr+5sRm3bvljYZtpJVs7DgBbUdT6oX
        7vvGajFVLha7mkfMVDoD/cjr0tI+kgjm3IXKKL6pkQ==
X-Google-Smtp-Source: ABdhPJypw33U6G5rG8rTRnrSCwoXneNV6AvLAVOLne2qf4sGporOzRdQq1RWO5hXnZzFxZmjYVkR27Onq4stAUnh+Uc=
X-Received: by 2002:ac2:446d:: with SMTP id y13mr42503225lfl.210.1641320416701;
 Tue, 04 Jan 2022 10:20:16 -0800 (PST)
MIME-Version: 1.0
References: <63840bf3-2199-3240-bdfa-abb55518b5f9@colorfullife.com>
 <20211223031207.556189-1-chi.minghao@zte.com.cn> <97e94a27-6f9f-1a21-cf3e-11d97f74cbd8@kernel.org>
 <2cfe35d4-3220-dd60-88d3-90b86eb5084a@colorfullife.com>
In-Reply-To: <2cfe35d4-3220-dd60-88d3-90b86eb5084a@colorfullife.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 4 Jan 2022 10:20:05 -0800
Message-ID: <CALvZod5aTh6ZfQfkHiOhrdRKVxEaMVJ-ixbvD6j9JTLpcQWKzQ@mail.gmail.com>
Subject: Re: [PATCH v2] ipc/sem: do not sleep with a spin lock held
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>, cgel.zte@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        chi.minghao@zte.com.cn, Davidlohr Bueso <dbueso@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, unixbhaskar@gmail.com,
        Vasily Averin <vvs@virtuozzo.com>, zealci@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 3, 2022 at 9:18 AM Manfred Spraul <manfred@colorfullife.com> wrote:
>
> Hi Jiri,
>
> On 1/3/22 10:27, Jiri Slaby wrote:
> > On 23. 12. 21, 4:12, cgel.zte@gmail.com wrote:
> >> From: Minghao Chi <chi.minghao@zte.com.cn>
> >>
> >> We can't call kvfree() with a spin lock held, so defer it.
> >
> > Sorry, defer what?
> >
> First drop the spinlock, then call kvfree().
>
>
> > There are attempts to fix kvfree instead, not sure which of these
> > approaches (fix kvfree or its callers) won in the end?
> >
> Exactly. We have three options - but noone volunteered yet to decide:
>
> - change ipc/sem.c [minimal change]

Let's go with the minimal change for now which can easily be
cherry-picked for the stable tree. It seems other approaches need more
work/discussion.

>
> - change kvfree() to use vfree_atomic() [would also fix other changes
> that did s/kfree/kvfree/]
>
> - Modify the vma handling so that it becomes safe to call vfree() while
> holding a spinlock. [perfect approach, but I'm concerned about side effects]
>
>
> --
>
>      Manfred
>

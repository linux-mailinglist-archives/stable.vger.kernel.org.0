Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC546F2B7
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 19:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhLISG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 13:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243057AbhLISG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 13:06:29 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FE2C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 10:02:55 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y13so21800982edd.13
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 10:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqdZ3M76IB1SSykmh04Y3Lo84YOdOWQzNWkBQHhiwL0=;
        b=ZavXgalMvPws6B7jvVOJr9iYXFSQ+Ve+xzB/xQ0PKvdxMfmxrHbi4mOAwmtVap5HzF
         i7Nkk2JG3YWK49A5ao1c9B+9rNDuriLhMaU7X6p9gXoihI9+MzBmoDXPoCAxG7AMsjTc
         uY8XYPep0J+jvwo4NJwVAzrXtoSQ3VliSEvk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqdZ3M76IB1SSykmh04Y3Lo84YOdOWQzNWkBQHhiwL0=;
        b=sxm80wKQUvP3C2V6VDDUFGLJ4t0GBW+DD0Nea+v1Lf1l0mEJXLR5dukV65l2pJo7sa
         7wKd5SRoifKwNxt5/XeeDs/jDSpxHGfFgDwcfqxbrluFZ/67dhkeeUGO6JqNFmR71sUy
         Qy+EgIlDNfTBvoqOEF3/HLfmwoQdXln0VPhy7REAe7cWVD4a7Gc+SOJcsmW3+OdO8n8p
         qtEKjTkjFJgu4ZhpmvxDjCSUKIQejDCOlyBEEGypJmnbX2rU+3/TQk+fQuexuPNg7nQG
         BPVzCx+GRn/kDqpsJBZLTt4exjLB6+hmEkvC+Sj088gC8RiTf09hDzmmEHAi4cxCsCqC
         U4UQ==
X-Gm-Message-State: AOAM532+iMwEFFlzpl/2x323BGTlqQJQrqv9XcjrC0L98qZYUI8QSM1T
        OqesiLkI+wEALsrZkEfm/wmeiqweDcPP4NdDNUo=
X-Google-Smtp-Source: ABdhPJz/EdEnmnE+TSJ7AP2gEiZZjPvQfoGwONEKV+v6RgJTmUm8nZOXxvn4dJePxWtVXzEsjqJG8A==
X-Received: by 2002:a17:907:2bd1:: with SMTP id gv17mr16845075ejc.231.1639072867793;
        Thu, 09 Dec 2021 10:01:07 -0800 (PST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id mp26sm263233ejc.61.2021.12.09.10.01.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:01:06 -0800 (PST)
Received: by mail-wm1-f41.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so7244918wme.0
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 10:01:06 -0800 (PST)
X-Received: by 2002:a1c:800e:: with SMTP id b14mr9304451wmd.155.1639072866516;
 Thu, 09 Dec 2021 10:01:06 -0800 (PST)
MIME-Version: 1.0
References: <20211209010455.42744-1-ebiggers@kernel.org>
In-Reply-To: <20211209010455.42744-1-ebiggers@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 10:00:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
Message-ID: <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 8, 2021 at 5:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Careful review is appreciated; the aio poll code is very hard to work
> with, and it doesn't appear to have many tests.  I've verified that it
> passes the libaio test suite, which provides some coverage of poll.
>
> Note, it looks like io_uring has the same bugs as aio poll.  I haven't
> tried to fix io_uring.

I'm hoping Jens is looking at the io_ring case, but I'm also assuming
that I'll just get a pull request for this at some point.

It looks sane to me - my only internal cursing has been about epoll
and aio in general, not about these patches in particular.

              Linus

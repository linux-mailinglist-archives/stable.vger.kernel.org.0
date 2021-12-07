Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF046C831
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 00:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242554AbhLGX2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 18:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242544AbhLGX2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 18:28:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CD3C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 15:24:50 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so2326541edd.0
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 15:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lZHabsPUc23xUEp/km7HooDqnp/1KyBKhA9+Ose3GXw=;
        b=DvnwlWEkpneQi1XlSO3gBPxLD70iikmgjVN61w8yUvn34PBCune25Jj9mW9XNgFL4q
         un4+G4P2SmN1djB/dNEp7ybFulczA6mZmTtM/H80MUvsu1Ga3PzhvFuSc1Dk+D+hQ15/
         db+sVtRBcfzEfAnFuUgbgivW8aOWBdK5sEbbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lZHabsPUc23xUEp/km7HooDqnp/1KyBKhA9+Ose3GXw=;
        b=TKClzNiKNBI732d+gMnXHZvJKeJZ1bLqbcwojBNTIc7meq2sk6Rjvhul9206d/8fhA
         8lN939/QczUDAfQR0zP3mQFWNmorGKORJx8KtyeMaPRZAkIalhXMGXzqB4oDlajAOElT
         v4XuHznQvyQMXMSeOiDAhVRmIlrhShqUWwTW9AyPuYToLecUdmHYlWTzob+mraEE+7W0
         +M2ciDz9ahhLVZfQZ0c95lD1hsZfdvXsEVouk0o/AoBeXeVQfPDrk6GqDt/wShqvhK4M
         z/TrxMFxkUfyY+IKhSbpeITqZjxhNoEnxKZroFzXfz4stqExzxvpvQl+gDIMwl/aS0oC
         XhGw==
X-Gm-Message-State: AOAM530wtBWvyP52G7ceUo6ludwb8yA4bdygBHjrme1qP/4EXiu3fsAh
        DY19b63y/49nZJul2F9DAJyMVVL4jYG/AMnJGfY=
X-Google-Smtp-Source: ABdhPJw0MU2oYMk/F4YduMZD4mAkWdv7pMzzyiMGZ/j4Nb9fa9G/03etNi0Sc3SBvE11ifCr1lpAyA==
X-Received: by 2002:a05:6402:16cd:: with SMTP id r13mr13832881edx.264.1638919488782;
        Tue, 07 Dec 2021 15:24:48 -0800 (PST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id mc3sm501707ejb.24.2021.12.07.15.24.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 15:24:47 -0800 (PST)
Received: by mail-wr1-f43.google.com with SMTP id u1so815591wru.13
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 15:24:47 -0800 (PST)
X-Received: by 2002:adf:e5c7:: with SMTP id a7mr55762662wrn.318.1638919487065;
 Tue, 07 Dec 2021 15:24:47 -0800 (PST)
MIME-Version: 1.0
References: <20211207095726.169766-1-ebiggers@kernel.org>
In-Reply-To: <20211207095726.169766-1-ebiggers@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Dec 2021 15:24:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjXM77BfA6gZTYzpP_7nWw3Mdjfr8pid_TLAqsk-p0wOQ@mail.gmail.com>
Message-ID: <CAHk-=wjXM77BfA6gZTYzpP_7nWw3Mdjfr8pid_TLAqsk-p0wOQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] aio: fix use-after-free and missing wakeups
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

On Tue, Dec 7, 2021 at 1:59 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Careful review is appreciated;

I dunno about "careful", but looks sane to me.

> Note, it looks like io_uring has the same bugs as aio poll.  I haven't
> tried to fix io_uring.

Jens?

                Linus

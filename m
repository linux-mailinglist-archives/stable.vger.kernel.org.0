Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DFC33367E
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 08:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCJHko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 02:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhCJHkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 02:40:36 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93959C061761
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 23:40:36 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id v14so14660437ilj.11
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cq2aReYAb1NZEVYoZ/NXyw9vsJhlnWLU3P0pndjoTAE=;
        b=DLlBEv1FlGiqLVy6NzkOd9B1PaTLbdBPBDA26CrI+8Ac08za+k724bSm8tYj8G6iUN
         URNdXo+Ytnx63SWNCmWLe3ybgChdYoC3xHLbY/FM888J8RPDSqWbPG9FWgkRxhZ8fuiA
         7DUw3VXOqIlTcqHEednvFtpo7p0QhXG0XkW8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cq2aReYAb1NZEVYoZ/NXyw9vsJhlnWLU3P0pndjoTAE=;
        b=eHMmIonLz2jc+JuYX0jqL+NOq2SkLeUXyxzv3Py1xZmsLefYEFHOqYRbqbC6MLVhSK
         2E9Fu5gjGU2IxEbo1M3D2bmgPuDCjaOZ056Omrehp6sW1L16SblqwfTev2/wAnqm4PKd
         c2nMqsKivfHRAzcXK5wOH29Sut0sptETC+SAhn5V0Lt42ZG/z/OrO6QPK9b83TtF6aVC
         2gaTlffCJuledmyI1eb4HNOuC/Q1FBrrwiM+cC0BHRezZYjSOIFfwcGYFhmgjataDXqh
         lpHACX73k0kDnDJ1M3xPnnnQR8UXviRqrEylatsC9RIEDZc0IdGRd+sgYs1s7SJj9H3J
         xNAA==
X-Gm-Message-State: AOAM530TwJoCPrz+AMO+lsZusBEuUHf1VE0kote8GpAfb9IbvHGc8VPb
        3zZlv6CAhJMLhMF2fmPms5HVZfFWwBjTdA==
X-Google-Smtp-Source: ABdhPJy15Pn2sEz0PrHXKzp2kNbqNyKqUHzb6epLC5AdnsDUTjbnKYJffm3Z0cv+vi86wDOf0nxs5w==
X-Received: by 2002:a05:6e02:1a0c:: with SMTP id s12mr1721931ild.177.1615362035823;
        Tue, 09 Mar 2021 23:40:35 -0800 (PST)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com. [209.85.166.53])
        by smtp.gmail.com with ESMTPSA id k10sm8770025iop.42.2021.03.09.23.40.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 23:40:35 -0800 (PST)
Received: by mail-io1-f53.google.com with SMTP id f20so16865529ioo.10
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:40:35 -0800 (PST)
X-Received: by 2002:a02:a303:: with SMTP id q3mr1925364jai.32.1615362034751;
 Tue, 09 Mar 2021 23:40:34 -0800 (PST)
MIME-Version: 1.0
References: <20210309234317.1021588-1-ribalda@chromium.org> <YEgj61iAt4Avnp6d@google.com>
In-Reply-To: <YEgj61iAt4Avnp6d@google.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 10 Mar 2021 08:40:24 +0100
X-Gmail-Original-Message-ID: <CANiDSCuVvhRXGHch0EvJ22mU+bfVs7ZyT2vrnWPxNu0z-ja_1g@mail.gmail.com>
Message-ID: <CANiDSCuVvhRXGHch0EvJ22mU+bfVs7ZyT2vrnWPxNu0z-ja_1g@mail.gmail.com>
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in allocation
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sergey

On Wed, Mar 10, 2021 at 2:42 AM Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
>
> On (21/03/10 00:43), Ricardo Ribalda wrote:
> > The plane_length is an unsigned integer. So, if we have a size of
> > 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
>
> Hi Ricardo,
>
> > @@ -223,8 +223,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> >        * NOTE: mmapped areas should be page aligned
> >        */
> >       for (plane = 0; plane < vb->num_planes; ++plane) {
> > +             unsigned long size = vb->planes[plane].length;
> > +
> >               /* Memops alloc requires size to be page aligned. */
> > -             unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > +             size = PAGE_ALIGN(size);
> >
> >               /* Did it wrap around? */
> >               if (size < vb->planes[plane].length)
>
> Shouldn't the same be done in vb2_mmap()?
Indeed, I was having tunnel vision focussing on my issue.

I have sent a new patch.

Thanks!
>
>         -ss



--
Ricardo Ribalda

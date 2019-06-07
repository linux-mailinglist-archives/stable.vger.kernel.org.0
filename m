Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E0938E8B
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfFGPJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:09:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34278 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbfFGPJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 11:09:43 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so1676780iot.1
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 08:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSNwEwVBB35crYOfAcA03OB3tW5Yj6TRGwmQgBYzS/M=;
        b=XNeJTWv5IXSPKxj4O4Mhj3ddn0md3FRvFIIWRXJE8yJDd7Ys9oWZo1L5YVOYAWERSg
         nt6UPyZCSw5l/L9g1sx0bJXO+XoJOUTcB5+fPaFnQfDzH4h0BXIekTVxh29osI+nndYh
         89KgZAmKZSRHoBH7RCHlinKsP3GvccK957wV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSNwEwVBB35crYOfAcA03OB3tW5Yj6TRGwmQgBYzS/M=;
        b=CkTRXt3tCfu8sd8dzBrXForxdl3ZX9Tr51LWAaCNoaM80bQFzAKuLko42o5XkDmtAG
         GZ/feiDMVKr56rhSlGOkpLGj7SgMQ3kWf2Xn6or9XEWOs8jEoqyjuTktyBBpOjvzj90E
         GODkCFLqBRdVNRKfUYyDXIq31iwhq1go3YJAQaR5GtjKNK5BfLCJaAIUosJJl+BAn1pn
         9P9DxmccX9VwJc0YCOdxbstXuoggKfj1hZBm0B3O/Zeg4n0tQnT8JMy1RJu8+PPMR4YL
         bEFicR86iB6AQaDD/uhIeVgrKwZgd8M4oSkge19zzcR0p5Pi/T/Rl/bT/2i9+Y7pX4el
         jeGQ==
X-Gm-Message-State: APjAAAVcSEiEW5fx1qIe+fQ9ZRPy1F0yUU36oim+cWtbIPdaYs8qI6Td
        HN5iZU8H7aJ0wMUhydQeCi2Hxey19WQ=
X-Google-Smtp-Source: APXvYqyW6B2wOvOecFlG2mITPEe2w5lg9jY4kRnMerz4ianEgdiRXHs5XvSzoFo24bSwJ0ZIeXJ8/A==
X-Received: by 2002:a5d:91cc:: with SMTP id k12mr1218202ior.131.1559920182413;
        Fri, 07 Jun 2019 08:09:42 -0700 (PDT)
Received: from mail-it1-f176.google.com (mail-it1-f176.google.com. [209.85.166.176])
        by smtp.gmail.com with ESMTPSA id x78sm999586ita.44.2019.06.07.08.09.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 08:09:40 -0700 (PDT)
Received: by mail-it1-f176.google.com with SMTP id a186so3236903itg.0
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 08:09:40 -0700 (PDT)
X-Received: by 2002:a24:b106:: with SMTP id o6mr3886319itf.97.1559920180064;
 Fri, 07 Jun 2019 08:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <lsq.1549201507.384106140@decadent.org.uk> <lsq.1549201508.623062416@decadent.org.uk>
In-Reply-To: <lsq.1549201508.623062416@decadent.org.uk>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 7 Jun 2019 08:09:27 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U263K-OEdnDzL=4oxLHXTkqgQygYCup=jSCRGvv+vMsw@mail.gmail.com>
Message-ID: <CAD=FV=U263K-OEdnDzL=4oxLHXTkqgQygYCup=jSCRGvv+vMsw@mail.gmail.com>
Subject: Re: [PATCH 3.16 025/305] media: uvcvideo: Fix uvc_alloc_entity()
 allocation alignment
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Nadav Amit <namit@vmware.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Tomasz Figa <tfiga@chromium.org>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Feb 3, 2019 at 5:50 AM Ben Hutchings <ben@decadent.org.uk> wrote:
>
> 3.16.63-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Nadav Amit <namit@vmware.com>
>
> commit 89dd34caf73e28018c58cd193751e41b1f8bdc56 upstream.
>
> The use of ALIGN() in uvc_alloc_entity() is incorrect, since the size of
> (entity->pads) is not a power of two. As a stop-gap, until a better
> solution is adapted, use roundup() instead.
>
> Found by a static assertion. Compile-tested only.
>
> Fixes: 4ffc2d89f38a ("uvcvideo: Register subdevices for each entity")
>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -826,7 +826,7 @@ static struct uvc_entity *uvc_alloc_enti
>         unsigned int size;
>         unsigned int i;
>
> -       extra_size = ALIGN(extra_size, sizeof(*entity->pads));
> +       extra_size = roundup(extra_size, sizeof(*entity->pads));
>         num_inputs = (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
>         size = sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_pads
>              + num_inputs;

Funny that this commit made its way to 3.16 but didn't make its way to
4.19 (at least checking 4.19.43).  I haven't seen any actual crashes
caused by the lack of this commit but it seems like the kind of thing
we probably want picked back to other stable kernels too.

-Doug

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D19A4021A1
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 02:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhIGA0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 20:26:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229975AbhIGA0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 20:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630974309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jic5HY4jNpPRbTOqmnYf0rZzsoprtJWy8oewb7ALUqk=;
        b=FktdDvNA8Exhe/HhN5xYZRX0QfPYD20s2GriYh09M9bYsbB1A72yBEtcvDVlm6shulA4Wx
        h1OGC1J6i1b4Dck609fqhQSG7vyMq94eS30Xkhbkkp8/mKHjY1XVtCylXfGc9X8IAn25c0
        YL/uG33M6vZeFk0YhossKcu/mGfFhY0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-LvXbf9WrPhW_AGOtRZWo9w-1; Mon, 06 Sep 2021 20:25:08 -0400
X-MC-Unique: LvXbf9WrPhW_AGOtRZWo9w-1
Received: by mail-wm1-f70.google.com with SMTP id e33-20020a05600c4ba100b002f8993a54f8so388819wmp.7
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 17:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jic5HY4jNpPRbTOqmnYf0rZzsoprtJWy8oewb7ALUqk=;
        b=hw4VcCHUbcHc+J+k0KwpKad2d42QmkakiuL62kYTThSD0SKZemwrcg3tnJIp+ziE6d
         /TSlif8DdnXQEo7Ukv70BZc9kSR0mbcK7HYuGnHkKczaPEHgSWHCNPtX+T9eJyeCqzsA
         PAfWojJ+v2qCiNYbitzZa0Ez6bO2O0iv4HoKidOSznN9hELBvFWZLUP2eyAMv49l2nHQ
         q7lHMX8NFA/3U79H6gUq/avfYYEQqw7J9MHYnoko6aO+vWrW9jQe9HAOFnOC3RmvnJ9w
         bGQiiC6yKoWHSY+pBviwdfXF3o/s19eWsucEdo/g3PuRr7q1qStZ6pxvEA6hK7sgYzOF
         3zwA==
X-Gm-Message-State: AOAM531vhTmzK8HyPPw9BMw5y3eYGKPGGeZjQz5rqSNm5h5Ad6O2w/kT
        6NPE1MR4Auj9Z00QkhU6NeusnDEH6oGKi6ZJIGZT0EdKH1khzdnNcVMyFPFPcwlBl9j5y+YmQCb
        maRFvNRdi8+WROn4T8sLzPdT6XKBoBVnQ
X-Received: by 2002:adf:d184:: with SMTP id v4mr15702439wrc.229.1630974307010;
        Mon, 06 Sep 2021 17:25:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9oaLql9qw9yoEaRVBWmdJjUHaViTSV2BQtZQNSO/tf1UNrEHGPGIDNAwEVdW+beEeqqgAckgH7AK38kefaRo=
X-Received: by 2002:adf:d184:: with SMTP id v4mr15702436wrc.229.1630974306848;
 Mon, 06 Sep 2021 17:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210906005628.11499-1-skeggsb@gmail.com> <20210906005628.11499-2-skeggsb@gmail.com>
In-Reply-To: <20210906005628.11499-2-skeggsb@gmail.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Tue, 7 Sep 2021 02:24:56 +0200
Message-ID: <CACO55ttVQBhvakr4OhfE6x0rvE1kifLuQht6x+1X3HgXHv=z0A@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/nouveau/kms/tu102-: delay enabling cursor until
 after assign_windows
To:     Ben Skeggs <skeggsb@gmail.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 6, 2021 at 2:56 AM Ben Skeggs <skeggsb@gmail.com> wrote:
>
> From: Ben Skeggs <bskeggs@redhat.com>
>
> Prevent NVD core channel error code 67 occuring and hanging display,
> managed to reproduce on GA102 while testing suspend/resume scenarios.
>
> Required extension of earlier commit to fix interactions with EFI.
>

Reviewed-by: Karol Herbst <kherbst@redhat.com>


> Fixes: e78b1b545c6c ("drm/nouveau/kms/nv50: workaround EFI GOP window channel format differences").
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.12+
> ---
>  drivers/gpu/drm/nouveau/dispnv50/head.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
> index f8438a886b64..c3c57be54e1c 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/head.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
> @@ -52,6 +52,7 @@ nv50_head_flush_clr(struct nv50_head *head,
>  void
>  nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom *asyh)
>  {
> +       if (asyh->set.curs   ) head->func->curs_set(head, asyh);
>         if (asyh->set.olut   ) {
>                 asyh->olut.offset = nv50_lut_load(&head->olut,
>                                                   asyh->olut.buffer,
> @@ -67,7 +68,6 @@ nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
>         if (asyh->set.view   ) head->func->view    (head, asyh);
>         if (asyh->set.mode   ) head->func->mode    (head, asyh);
>         if (asyh->set.core   ) head->func->core_set(head, asyh);
> -       if (asyh->set.curs   ) head->func->curs_set(head, asyh);
>         if (asyh->set.base   ) head->func->base    (head, asyh);
>         if (asyh->set.ovly   ) head->func->ovly    (head, asyh);
>         if (asyh->set.dither ) head->func->dither  (head, asyh);
> --
> 2.31.1
>


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D5A44498A
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhKCUcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:32:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhKCUcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:32:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635971383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JYXXoD382YlaWwsm8RhT98RSUt90ubtt9LhxFyoOKpU=;
        b=S7/i8vCuQGc7ZY6pr9d5vY7Zu31O45G45sutg809EnsqkpU/T/29/A1ohoANfpj09rBOCy
        DMJ1hLPuIqoZn+A5DuBFoITA1SHPom8Slz1a1X4X+MEm3wUz/G33dvNhfZZ953MmfnbaKm
        /3jGec1DE8a1cFv9LVSiJHxW0Z1vdWk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-7qRNWQF0Oz6wwDLXE3eLrA-1; Wed, 03 Nov 2021 16:29:42 -0400
X-MC-Unique: 7qRNWQF0Oz6wwDLXE3eLrA-1
Received: by mail-wm1-f71.google.com with SMTP id n189-20020a1c27c6000000b00322f2e380f2so3280466wmn.6
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 13:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JYXXoD382YlaWwsm8RhT98RSUt90ubtt9LhxFyoOKpU=;
        b=SRx0ngUFDSRW+cKRsawUk/nm2NlDDqeIfisljYtBrQy0PwctIxLDVCvsaw1ZMnj0Ll
         9iTsL5rlLewkvAy42QslKJbh2H2Dlij8ZjHN7nxGfgTGXvHpYf3O4xTy455DZI3jRP17
         oJIQnVIeeu5ETipQUHq86tTmTOSDCxEHR0Jtkuawg71f5Cw+8gZQLnYpAYmCeVmx+i+K
         bxZuXrboxgw3rJqZlYu1NtJrK0DzHMpuy/6oOCj3h7rxbknEMIIAmSLbP7yQK09VSE/J
         27SuzkPs5EYki3IBQYSwNA+67H0kPfRiEnYEUON0ng+TQQ6PStqd43PGMGel0hGEapjG
         dgiw==
X-Gm-Message-State: AOAM530lHAFUvWPs4f9ePCK2KuihfBzkFjN/NGRX54+aTukYtzwlorLL
        //ex0UWE96gojevPxZE+wDcgmXhRpr1PlQarxClLWPOJrFUdHdXFk0U5b6fa/cfyIEbPeuAmCrU
        M5wlkQyLaBL5hg8ejhnX+hWpPvxjehHMI
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr42336874wrw.116.1635971380582;
        Wed, 03 Nov 2021 13:29:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfxtpdZAb0gL1AyUceKUTqCM9ysy/gh/RGCREHQblh5YqhTwn/yGQ6pNsAfrWkscr3Mxm3+yr4U09BDGEkSO4=
X-Received: by 2002:a5d:68ce:: with SMTP id p14mr42336850wrw.116.1635971380397;
 Wed, 03 Nov 2021 13:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211101082511.254155853@linuxfoundation.org> <20211101082518.624936309@linuxfoundation.org>
 <871r3x2f0y.fsf@turtle.gmx.de>
In-Reply-To: <871r3x2f0y.fsf@turtle.gmx.de>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Wed, 3 Nov 2021 21:29:29 +0100
Message-ID: <CACO55tsq6DOZnyCZrg+N3m_hseJfN_6+YhjDyxVBAGq9PFJmGA@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 5.10 32/77] drm/ttm: fix memleak in ttm_transfered_destroy
To:     Sven Joachim <svenjoac@gmx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Erhard F." <erhard_f@mailbox.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 3, 2021 at 8:52 PM Sven Joachim <svenjoac@gmx.de> wrote:
>
> On 2021-11-01 10:17 +0100, Greg Kroah-Hartman wrote:
>
> > From: Christian K=C3=B6nig <christian.koenig@amd.com>
> >
> > commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.
> >
> > We need to cleanup the fences for ghost objects as well.
> >
> > Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> > Reported-by: Erhard F. <erhard_f@mailbox.org>
> > Tested-by: Erhard F. <erhard_f@mailbox.org>
> > Reviewed-by: Huang Rui <ray.huang@amd.com>
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214029
> > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214447
> > CC: <stable@vger.kernel.org>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20211020173211.2247=
-1-christian.koenig@amd.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> > +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> > @@ -322,6 +322,7 @@ static void ttm_transfered_destroy(struc
> >       struct ttm_transfer_obj *fbo;
> >
> >       fbo =3D container_of(bo, struct ttm_transfer_obj, base);
> > +     dma_resv_fini(&fbo->base.base._resv);
> >       ttm_bo_put(fbo->bo);
> >       kfree(fbo);
> >  }
>
> Alas, this innocuous looking commit causes one of my systems to lock up
> as soon as run startx.  This happens with the nouveau driver, two other
> systems with radeon and intel graphics are not affected.  Also I only
> noticed it in 5.10.77.  Kernels 5.15 and 5.14.16 are not affected, and I
> do not use 5.4 anymore.
>
> I am not familiar with nouveau's ttm management and what has changed
> there between 5.10 and 5.14, but maybe one of their developers can shed
> a light on this.
>
> Cheers,
>        Sven
>

could be related to 265ec0dd1a0d18f4114f62c0d4a794bb4e729bc1


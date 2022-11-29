Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB3A63C9D4
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 21:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiK2Usj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 15:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236672AbiK2UsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 15:48:23 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E4B5ADCC;
        Tue, 29 Nov 2022 12:47:53 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id m7-20020a9d6447000000b0066da0504b5eso9910051otl.13;
        Tue, 29 Nov 2022 12:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7xFa82HHkehFEIoR/Gvkhv4ncrmYE6/UZyj0GoMKVNs=;
        b=d1+z9RcqxsHEvdxF2ZYD59XFcpNXwDtddi5ygpvFvjFqveifOzw1yesVKXP90PIEXW
         vV0OUhM439fDEhWTu061JQMjD+ULlcdCd0eRZxdqaN46i55hu207zyuTCzPCf9W2KJ1I
         4igj5TwC95XFIgbcpZxSHJPoyiqpzZmIW2FwrrWLSJJjE7U2daJ1ELd2AWJGORYxKSIX
         q9vNN4x0G8G2xMHlI6yIBuu74gBTJJzwpQ6DqkMLmhFRI3tcJe0Vmi4QLAlDHqfPUABd
         GmKPgFQ/UIppjYYAhxnS76U8SksKPHRnqcfLMCorJzF1XHTyuLskCmUNztdNOWI0lK/k
         kX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7xFa82HHkehFEIoR/Gvkhv4ncrmYE6/UZyj0GoMKVNs=;
        b=MC/qXuROj6VKMEYFTymoNHWdg08L2aahaop9iM0V5QFKlv9co+gw67t8A4VNhYdWwi
         IBWVp0Q+J+jReeCFy2qx7j1AHhqKBWhk6O9IehL73K76wTSyY5Gc69+bMaXgmClB1eU4
         NajmuXiwOQ6Lq2o/wWOwGSc6Eef9oTtM7ZOB49ZzSpeQQiMl0NaniW5noyUM3ZOGfcl/
         doVTthKYH4X0lvzqvKLn10mqAhduwml9+alH+bKdhwUktHeO2l1U2Lz9+dd7MZTMeUfw
         tHPG+OOhFpb0GJ/ft58l7Rd+o4/eLjGsnx6vmLD2wrneYilDkA4rNwuYOxEWlYFg7DZ+
         /W8A==
X-Gm-Message-State: ANoB5pno9mF7v9ChT6V5gmwg/aEo2suuAbgklaqqVd7WpQq+qr2sz5k7
        apb1H5nZbpts7VhuAkUw4uRmKnBViXS2y9FUmbQ=
X-Google-Smtp-Source: AA0mqf7xZMHsvKm3f3uDkSaG1qhhOp+y9VRfZiKgNKTiUdmmZM1boduAXuI5yJAsEVJrBoh/UZc3lt0Bov57xOliipE=
X-Received: by 2002:a9d:75d5:0:b0:667:7361:7db5 with SMTP id
 c21-20020a9d75d5000000b0066773617db5mr22095916otl.22.1669754873144; Tue, 29
 Nov 2022 12:47:53 -0800 (PST)
MIME-Version: 1.0
References: <20221129200242.298120-3-robdclark@gmail.com> <20221129203205.GA2132357@roeck-us.net>
In-Reply-To: <20221129203205.GA2132357@roeck-us.net>
From:   Rob Clark <robdclark@gmail.com>
Date:   Tue, 29 Nov 2022 12:47:42 -0800
Message-ID: <CAF6AEGuK4jv25cQ4p-rrytx9Qn4JZdRRfkVJn9T3nf7vJmG5VQ@mail.gmail.com>
Subject: Re: [2/2] drm/shmem-helper: Avoid vm_open error paths
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 12:32 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Tue, Nov 29, 2022 at 12:02:42PM -0800, Rob Clark wrote:
> > From: Rob Clark <robdclark@chromium.org>
> >
> > vm_open() is not allowed to fail.  Fortunately we are guaranteed that
> > the pages are already pinned, and only need to increment the refcnt.  So
> > just increment it directly.
>
> I don't know anything about drm or gem, but I am wondering _how_
> this would be guaranteed. Would it be through the pin function ?
> Just wondering, because that function does not seem to be mandatory.

We've pinned the pages already in mmap.. vm->open() is perhaps not the
best name for the callback function, but it is called for copying an
existing vma into a new process (and for some other cases which do not
apply here because VM_DONTEXPAND).

(Other drivers pin pages in the fault handler, where there is actually
potential to return an error, but that change was a bit more like
re-writing shmem helper ;-))

BR,
-R

> >
> > Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > ---
> >  drivers/gpu/drm/drm_gem_shmem_helper.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > index 110a9eac2af8..9885ba64127f 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
> >  {
> >       struct drm_gem_object *obj = vma->vm_private_data;
> >       struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> > -     int ret;
> >
> >       WARN_ON(shmem->base.import_attach);
> >
> > -     ret = drm_gem_shmem_get_pages(shmem);
> > -     WARN_ON_ONCE(ret != 0);
> > +     mutex_lock(&shmem->pages_lock);
> > +
> > +     /*
> > +      * We should have already pinned the pages, vm_open() just grabs
>
> should or guaranteed ? This sounds a bit weaker than the commit
> description.
>
> > +      * an additional reference for the new mm the vma is getting
> > +      * copied into.
> > +      */
> > +     WARN_ON_ONCE(!shmem->pages_use_count);
> > +
> > +     shmem->pages_use_count++;
> > +     mutex_unlock(&shmem->pages_lock);
>
> The previous code, in that situation, would not increment pages_use_count,
> and it would not set not set shmem->pages. Hopefully, it would not try to
> do anything with the pages it was unable to get. The new code assumes that
> shmem->pages is valid even if pages_use_count is 0, while at the same time
> taking into account that this can possibly happen (or the WARN_ON_ONCE
> would not be needed).
>
> Again, I don't know anything about gem and drm, but it seems to me that
> there might now be a severe problem later on if the WARN_ON_ONCE()
> ever triggers.
>
> Thanks,
> Guenter
>
> >
> >       drm_gem_vm_open(vma);
> >  }

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7A3644AD9
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 19:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLFSJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 13:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiLFSJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 13:09:24 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAAA3AC16;
        Tue,  6 Dec 2022 10:09:23 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1447c7aa004so10235318fac.11;
        Tue, 06 Dec 2022 10:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CWev+jDg0dJZ3iRe8fmDv7sVMbP2pNiYIK+0iXz8Ozw=;
        b=gGQ4+B1AD0prkHHQTMEZSg0B+Po3EeECzMeGxLiglZQCMnadIghRxwxHWlMxquyKfM
         lZYGC0USPIpX+prT+vtaowDIjN0L6IDesiXaKcbI0I8Tf/Z5LyT4gabJEv7w2YrxbBxc
         nJedvuGElXiXAtWQ49k9akfBY7U9WtFgCQBOsm9B/E0SzOXZcYBq6tVQYi5feQ5RS90Y
         1W2VHnpMB1vz/6R4PSPHvA596hjbHdO/46l/DkU8+E0w9rIvWwzQ/U77GhiuIEEoy1iz
         d0xHLBpDdDsSdRW7StAyzBge8nQ6rho0G8KlYlfjVf2WzxzHKCi0pwRxnXGf7nOZRWlW
         2SNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CWev+jDg0dJZ3iRe8fmDv7sVMbP2pNiYIK+0iXz8Ozw=;
        b=nad3VrToehX+U3e0+A2x3TACDLFEdXV8+fKVubxnoQNNGqhVUVgkoYMzWvjsyL/mSr
         AoJYu6eSJq7Gm1W7yYpjb4XGtbX3mpLzze7UlGR/NVHgvBCrop19L6NNRTF1gERkV0bV
         pQvH22al+ZX5fQGQvVSyZwcAbMxRp9pTy/ERb81N4tssgSpd8zvMu97lIIeWryOlVxTm
         nEY55X/r/596qERE5f9aSv1ZElB/1zCCC789Fe1epsLHnsaveDYHn3X/ssIFNSIWSTKb
         qPCCt5g1ygK2zz6exwpjluXHuZIosV+ep9FkR185Ta7l5dPnZBAr9jC7ZGY5rNI50IC1
         NIdA==
X-Gm-Message-State: ANoB5pmjEKNZxZuN/M/yDAMFIACpvANKhmQ4+H3X9OjQYInEgJyOeAoA
        PMaTD24spsdUEtKgDh4dVrTGvrDteoWspP06UhA=
X-Google-Smtp-Source: AA0mqf6iKPcyytwwVsEHd6kTCR7WtQHQnDpEAdLZZGz40NnxjMAO+4rIEjR8fUj3WHshRxS+nwOfEgXqCvw1ZdDfDiY=
X-Received: by 2002:a05:6870:e749:b0:144:5f0d:9fcb with SMTP id
 t9-20020a056870e74900b001445f0d9fcbmr8272974oak.38.1670350162551; Tue, 06 Dec
 2022 10:09:22 -0800 (PST)
MIME-Version: 1.0
References: <20221130185748.357410-1-robdclark@gmail.com> <20221130185748.357410-2-robdclark@gmail.com>
 <3e9e157d-e740-ee5b-b8d3-07822b2c9a9b@collabora.com>
In-Reply-To: <3e9e157d-e740-ee5b-b8d3-07822b2c9a9b@collabora.com>
From:   Rob Clark <robdclark@gmail.com>
Date:   Tue, 6 Dec 2022 10:09:16 -0800
Message-ID: <CAF6AEGud11KEJvBY9J_TPahFOvo=C0VhG0An7nfNbsHXKbKC2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm/shmem-helper: Remove errant put in error path
To:     Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc:     dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@chromium.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com
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

On Sun, Dec 4, 2022 at 12:45 PM Dmitry Osipenko
<dmitry.osipenko@collabora.com> wrote:
>
> On 11/30/22 21:57, Rob Clark wrote:
> > From: Rob Clark <robdclark@chromium.org>
> >
> > drm_gem_shmem_mmap() doesn't own this reference, resulting in the GEM
> > object getting prematurely freed leading to a later use-after-free.
> >
> > Link: https://syzkaller.appspot.com/bug?extid=c8ae65286134dd1b800d
> > Reported-by: syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com
> > Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/gpu/drm/drm_gem_shmem_helper.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > index 35138f8a375c..3b7b71391a4c 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -622,10 +622,8 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
> >       }
> >
> >       ret = drm_gem_shmem_get_pages(shmem);
> > -     if (ret) {
> > -             drm_gem_vm_close(vma);
> > +     if (ret)
> >               return ret;
> > -     }
> >
> >       vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
> >       vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
>
> AFAICS, the dmabuf mmaping code path needs a similar fix, isn't it?
>
> -               /* Drop the reference drm_gem_mmap_obj() acquired.*/
> -               drm_gem_object_put(obj);
>                 vma->vm_private_data = NULL;
>
> -               return dma_buf_mmap(obj->dma_buf, vma, 0);
> +               ret = dma_buf_mmap(obj->dma_buf, vma, 0);
> +
> +               /* Drop the reference drm_gem_mmap_obj() acquired.*/
> +               if (!ret)
> +                       drm_gem_object_put(obj);
> +
> +               return ret;
>

Yes, it seems that way.. I wish the shmem helpers worked in a less
"special" way with regards to refcnting :-(

BR,
-R

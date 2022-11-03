Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D44A618568
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 17:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbiKCQ5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 12:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiKCQ5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 12:57:16 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290A1B7EE;
        Thu,  3 Nov 2022 09:57:16 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id cg5so1581783qtb.12;
        Thu, 03 Nov 2022 09:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5f6aXj56xAZfn7DOJS1FLW7Ni6mOAd9f/GE0jolU2Y=;
        b=6cq6EKHpgeQowsdyBgkhGTpJgZ2XtchXxV5n2/gHCWPVMtrV/X2syLwHbwY2nYnbHT
         CdvazTTqYbQxINpBAFdBQksvOxmV1PYFP9Hs1tD2Xey7JcDvyiFX3OAU7DjHP+i0Rrb9
         LR4eCC8+CBczxCwLn2yweaD/nP8weuzMQZG/5/4/28ulr97VgB5N2QOtkdII9Vis43Z4
         bZf8kMRviDAu2bcwQHmTm+3cXTcT97mjM5H11A2n1Qpl83o0KCEATSfhZ5gefD2aen1+
         xxAWVdn8qZHsf7hZnm1Aro1mIYcYeL38gmdafhoHuLUdV6BWXoOTdYAgWhadfuJLTU8O
         ZrMA==
X-Gm-Message-State: ACrzQf3huYYw4Ifs2pM5fqz3aRbjYz1Sh4aJmZssp3hG3mRmkv/F7UtE
        CY80Hxd2/sfQbmm7nrp0isZIQXf5jjeF14hZf/B98i3QZdo=
X-Google-Smtp-Source: AMsMyM6M0ioG0ykMHiqlkEP1sHKfy+yBfBbtIgO0rPuYzYheEPAJ0KlFk2OunLazdQ7y2sfsX/qZrcDVuwcJgkgMhn4=
X-Received: by 2002:a05:622a:4c07:b0:3a5:27ec:6dd3 with SMTP id
 ey7-20020a05622a4c0700b003a527ec6dd3mr17732150qtb.411.1667494635318; Thu, 03
 Nov 2022 09:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20221101022840.1351163-1-tgsp002@gmail.com> <20221101022840.1351163-3-tgsp002@gmail.com>
 <CAJZ5v0hXSnx0NqPwTRm=5ewg+P08-HaYc0ERQ6Uebrop8BfkdA@mail.gmail.com>
In-Reply-To: <CAJZ5v0hXSnx0NqPwTRm=5ewg+P08-HaYc0ERQ6Uebrop8BfkdA@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 3 Nov 2022 17:57:04 +0100
Message-ID: <CAJZ5v0h82YpaG9a1mmavVnm4WwjDV5iU_Qof6dN_PqP1UR-OUQ@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] PM: hibernate: add check of preallocate mem for
 image size pages
To:     TGSP <tgsp002@gmail.com>
Cc:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiongxin <xiongxin@kylinos.cn>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 3, 2022 at 5:47 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Tue, Nov 1, 2022 at 3:28 AM TGSP <tgsp002@gmail.com> wrote:
> >
> > From: xiongxin <xiongxin@kylinos.cn>
> >
> > Added a check on the return value of preallocate_image_highmem(). If
> > memory preallocate is insufficient, S4 cannot be done;
> >
> > I am playing 4K video on a machine with AMD or other graphics card and
> > only 8GiB memory, and the kernel is not configured with CONFIG_HIGHMEM.
> > When doing the S4 test, the analysis found that when the pages get from
> > minimum_image_size() is large enough, The preallocate_image_memory() and
> > preallocate_image_highmem() calls failed to obtain enough memory. Add
> > the judgment that memory preallocate is insufficient;
> >
> > "pages -= free_unnecessary_pages()" below will let pages to drop a lot,
> > so I wonder if it makes sense to add a judgment here.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: xiongxin <xiongxin@kylinos.cn>
> > Signed-off-by: huanglei <huanglei@kylinos.cn>
> > ---
> >  kernel/power/snapshot.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> > index c20ca5fb9adc..670abf89cf31 100644
> > --- a/kernel/power/snapshot.c
> > +++ b/kernel/power/snapshot.c
> > @@ -1738,6 +1738,7 @@ int hibernate_preallocate_memory(void)
> >         struct zone *zone;
> >         unsigned long saveable, size, max_size, count, highmem, pages = 0;
> >         unsigned long alloc, save_highmem, pages_highmem, avail_normal;
> > +       unsigned long size_highmem;
>
> Please define this in the block where it will be used.
>
> >         ktime_t start, stop;
> >         int error;
> >
> > @@ -1863,7 +1864,13 @@ int hibernate_preallocate_memory(void)
> >                 pages_highmem += size;
>
> The line above can be dropped.

Not really, it needs to be replaced with

        size_highmem = size ;

> >                 alloc -= size;
> >                 size = preallocate_image_memory(alloc, avail_normal);
> > -               pages_highmem += preallocate_image_highmem(alloc - size);
> > +               size_highmem += preallocate_image_highmem(alloc - size);
>
> Did you mean "="?
>
> Assuming you did, this could be
>
>         size_highmem = size + preallocate_image_highmem(alloc - size);

And here

                  size_highmem += preallocate_image_highmem(alloc - size);

which is what you had in the original patch.

>         if (size_highmem < alloc) {
>
> > +               if (size_highmem < (alloc - size)) {
>
> The inner parens were not necessary.
>
> > +                       pr_err("Image allocation is %lu pages short, exit\n",
> > +                               alloc - size - pages_highmem);
> > +                       goto err_out;
> > +               }
> > +               pages_highmem += size_highmem;
> >                 pages += pages_highmem + size;
> >         }
> >
> > --
>
> But overall it would be better to avoid bailing out.

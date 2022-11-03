Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0A8618535
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 17:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiKCQtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 12:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKCQsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 12:48:47 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B211C42B;
        Thu,  3 Nov 2022 09:47:55 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id s4so1594486qtx.6;
        Thu, 03 Nov 2022 09:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E404s4tFf1UMhY1Ot8ZmocAjE/Hn6H6Pg5Qfx1UrAuk=;
        b=KN/ximEywLQ5p4hcwJW4NY8HSpyygPIDXV+She6iVafsTWHe4JO2KtpAdoXreoCuar
         NhD0nKporggtZnrP67/Gfx+lSPpZGsGqbhloebF0JnZSIBZ5WMdQf7Rn9CuAZlatp/yS
         ixCJkijuocOWUzjswGBgNJiESBUFMzMXvylUuZjuyqHjAZcDD/U88T6TyPKWXiLin20g
         ZzBu4yV/7Q5tZOl12nYfof7XCmxQGS6Tpb2T/4ga6gcHRP5+TCXlcHluLTxrBaUkawBl
         wMSZGo9TArSCB41yiHW1UiI8oqmEhdyxuWJ2JFpW5cmo3bYcEkyzsKXRW+6ukd7JHSf/
         S7Qw==
X-Gm-Message-State: ACrzQf3Y+SrQuj2BppX9DvttVncusYtoeFP0vEqjE+0han53wvdGrCyM
        J+vgLBsgyW/oz1SYeHjBUtQ1MaYTTCnmKYeGaXE=
X-Google-Smtp-Source: AMsMyM7xB1jHhynK53kTB4IA4LssmMOTgXhMosPDJMUg6dIwUxkHpR2Obq61cDOfD8xzwnyJJCBBKwsO9F66ipFs0zQ=
X-Received: by 2002:a05:622a:1a25:b0:39c:b862:7318 with SMTP id
 f37-20020a05622a1a2500b0039cb8627318mr25620524qtb.147.1667494074873; Thu, 03
 Nov 2022 09:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20221101022840.1351163-1-tgsp002@gmail.com> <20221101022840.1351163-3-tgsp002@gmail.com>
In-Reply-To: <20221101022840.1351163-3-tgsp002@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 3 Nov 2022 17:47:43 +0100
Message-ID: <CAJZ5v0hXSnx0NqPwTRm=5ewg+P08-HaYc0ERQ6Uebrop8BfkdA@mail.gmail.com>
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

On Tue, Nov 1, 2022 at 3:28 AM TGSP <tgsp002@gmail.com> wrote:
>
> From: xiongxin <xiongxin@kylinos.cn>
>
> Added a check on the return value of preallocate_image_highmem(). If
> memory preallocate is insufficient, S4 cannot be done;
>
> I am playing 4K video on a machine with AMD or other graphics card and
> only 8GiB memory, and the kernel is not configured with CONFIG_HIGHMEM.
> When doing the S4 test, the analysis found that when the pages get from
> minimum_image_size() is large enough, The preallocate_image_memory() and
> preallocate_image_highmem() calls failed to obtain enough memory. Add
> the judgment that memory preallocate is insufficient;
>
> "pages -= free_unnecessary_pages()" below will let pages to drop a lot,
> so I wonder if it makes sense to add a judgment here.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: xiongxin <xiongxin@kylinos.cn>
> Signed-off-by: huanglei <huanglei@kylinos.cn>
> ---
>  kernel/power/snapshot.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index c20ca5fb9adc..670abf89cf31 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -1738,6 +1738,7 @@ int hibernate_preallocate_memory(void)
>         struct zone *zone;
>         unsigned long saveable, size, max_size, count, highmem, pages = 0;
>         unsigned long alloc, save_highmem, pages_highmem, avail_normal;
> +       unsigned long size_highmem;

Please define this in the block where it will be used.

>         ktime_t start, stop;
>         int error;
>
> @@ -1863,7 +1864,13 @@ int hibernate_preallocate_memory(void)
>                 pages_highmem += size;

The line above can be dropped.

>                 alloc -= size;
>                 size = preallocate_image_memory(alloc, avail_normal);
> -               pages_highmem += preallocate_image_highmem(alloc - size);
> +               size_highmem += preallocate_image_highmem(alloc - size);

Did you mean "="?

Assuming you did, this could be

        size_highmem = size + preallocate_image_highmem(alloc - size);
        if (size_highmem < alloc) {

> +               if (size_highmem < (alloc - size)) {

The inner parens were not necessary.

> +                       pr_err("Image allocation is %lu pages short, exit\n",
> +                               alloc - size - pages_highmem);
> +                       goto err_out;
> +               }
> +               pages_highmem += size_highmem;
>                 pages += pages_highmem + size;
>         }
>
> --

But overall it would be better to avoid bailing out.

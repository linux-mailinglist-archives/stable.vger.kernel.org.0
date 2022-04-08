Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18874F8B49
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 02:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiDHAkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 20:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiDHAkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 20:40:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3EF16F6FF;
        Thu,  7 Apr 2022 17:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0CA2B829B3;
        Fri,  8 Apr 2022 00:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3463EC385A5;
        Fri,  8 Apr 2022 00:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649378289;
        bh=CVHEzTa06w9IXQftEgZii1PHojo5m4h3tRQOFvFM99s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pDZeBdKpytYf/RpT1wvDDi+93EZlNj/SQN1mhUKsjCetKqxsE6F3pgzwpBfPDQ4fZ
         FDAD/ljw+OPvXlLbCvfQe2svXgSycFXKpYYoJGp6rRxieZiVYeHpGCmUAoDCCYtbH8
         W0I7eNZQyi5sGKmBCFfHHlnjslk1VjRGX4MgsJIG25DPlKKkCEzt6tC+wrqhv541qD
         KcvHrx1Imk/jfBC24wbY57AvDUSKiSYtmLuBDiwoz+VEmkkC3QUCfdFDn4R5qxpKdk
         RWivXlbHO75PU/0wbwV8D3L2WTTXoFKGTqcxs4lIMSLbDNu+PUM0Jb/NB8Dy4v6GLr
         4OesR0MEr+z9g==
Received: by mail-yb1-f169.google.com with SMTP id r5so2738659ybd.8;
        Thu, 07 Apr 2022 17:38:09 -0700 (PDT)
X-Gm-Message-State: AOAM533OExlC8UVxblCgT71lQitsvmTOOnRLDx7GDxhtF9DtK4ztokLu
        2QAymecNd5vFiuZulMpO3wN83pej61ButXrhYHI=
X-Google-Smtp-Source: ABdhPJxZSEJvXnOSEuuJQrEwsomQA54vyst5hwzUzcTr7GcAKkuWwIWw4Yq8ZGv7YBWuDHCKqqxUUcRUzkhhmnK8mdE=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr11288152ybl.449.1649378288275; Thu, 07
 Apr 2022 17:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220328080559.25984-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220328080559.25984-1-xiam0nd.tong@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Apr 2022 17:37:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6AJAo_k1a5-EiUp-Qx9Rp=jkON155AtOMRO2JmhBVFjw@mail.gmail.com>
Message-ID: <CAPhsuW6AJAo_k1a5-EiUp-Qx9Rp=jkON155AtOMRO2JmhBVFjw@mail.gmail.com>
Subject: Re: [PATCH] md: fix an incorrect NULL check in md_reload_sb
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     rgoldwyn@suse.com, Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 1:06 AM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> The bug is here:
>         if (!rdev || rdev->desc_nr != nr) {
>
> The list iterator value 'rdev' will *always* be set and non-NULL
> by rdev_for_each_rcu(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element
> found (In fact, it will be a bogus pointer to an invalid struct
> object containing the HEAD). Otherwise it will bypass the check
> and lead to invalid memory access passing the check.
>
> To fix the bug, use a new variable 'iter' as the list iterator,
> while using the original variable 'pdev' as a dedicated pointer to
> point to the found element.
>
> Cc: stable@vger.kernel.org
> Fixes: 70bcecdb1534 ("amd-cluster: Improve md_reload_sb to be less error prone")

s/amd-cluster/md-cluster/

> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>
> changes from v1:
>  - rephrase the subject (Guoqing Jiang)
>
> v1:https://lore.kernel.org/lkml/20220327080111.12028-1-xiam0nd.tong@gmail.com/
>
> ---
>  drivers/md/md.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7476fc204172..f156678c08bc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9794,16 +9794,18 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
>
>  void md_reload_sb(struct mddev *mddev, int nr)
>  {
> -       struct md_rdev *rdev;
> +       struct md_rdev *rdev = NULL, *iter;
>         int err;
>
>         /* Find the rdev */
> -       rdev_for_each_rcu(rdev, mddev) {
> -               if (rdev->desc_nr == nr)
> +       rdev_for_each_rcu(iter, mddev) {
> +               if (iter->desc_nr == nr) {
> +                       rdev = iter;
>                         break;
> +               }
>         }
>
> -       if (!rdev || rdev->desc_nr != nr) {
> +       if (!rdev) {
>                 pr_warn("%s: %d Could not find rdev with nr %d\n", __func__, __LINE__, nr);
>                 return;
>         }
> --
> 2.17.1
>

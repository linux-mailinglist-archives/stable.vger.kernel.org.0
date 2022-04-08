Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01E24F8B5A
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 02:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiDHAjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 20:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiDHAjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 20:39:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5D3108195;
        Thu,  7 Apr 2022 17:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E526F61877;
        Fri,  8 Apr 2022 00:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC5FC385A9;
        Fri,  8 Apr 2022 00:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649378222;
        bh=i2XZq/Xu6H3REApuY9LUTcK2PgJHPjIMKr2oGYUJS+w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GyQOwOUtHJkHjJBvAbOA3vKcRaXiuGK57yvu8DZxwmGJcODd46H+mDgSPxPys/heZ
         YIA0G9VUuHm1uD7T4wTIltvaCJC33lHy63MYlQk8SGTNJbRU8tEOeOnljBjOCAT9CK
         0pkORZXXiztnnyvnEXxA6umz/fDxUB8+ygVGJRN67+GDyOPju3k4NkWVDQXfZIVnqt
         t43io2YNgWVMMQqRfrSSujgXIMWNxjVIRB51B9IoXYbRRSAevcZ2H1AYAxR2kaIBai
         y1XQmbuyJeV+kNq4WV35tfhDfL6qmQb5NcSx5aeFl/QeMCYlZ2rtFMzsrRnwiDQA1X
         u5B355z4sgGyw==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2db2add4516so80278687b3.1;
        Thu, 07 Apr 2022 17:37:02 -0700 (PDT)
X-Gm-Message-State: AOAM532eJRsVSTymVVl59Nmc+EmZUe0oS5fRw26vU0I81AOraahNo+0o
        EdAaFSUZsSDH382pYfH6bYywxXjziBW+Mim3vAs=
X-Google-Smtp-Source: ABdhPJwvzDb1VlAhZdTtbxJtXVdfI6VVJsSdq+zEc/GLZ2R9uDVGKWfT7S5dkfsKzl9zBEZRMG+1axuvTWqaaMPQYDU=
X-Received: by 2002:a0d:f6c6:0:b0:2e5:bf17:4dce with SMTP id
 g189-20020a0df6c6000000b002e5bf174dcemr14410627ywf.130.1649378221272; Thu, 07
 Apr 2022 17:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220328081127.26148-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220328081127.26148-1-xiam0nd.tong@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Apr 2022 17:36:48 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6S=PJsgVR=OkObMvs9uJ2QA3LFe+ZH8XtEyKRFh7XxHA@mail.gmail.com>
Message-ID: <CAPhsuW6S=PJsgVR=OkObMvs9uJ2QA3LFe+ZH8XtEyKRFh7XxHA@mail.gmail.com>
Subject: Re: [PATCH v2] md: fix an incorrect NULL check in sync_sbs
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     rgoldwyn@suse.com, Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 1:11 AM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>
> The bug is here:
>         if (!rdev)
>
> The list iterator value 'rdev' will *always* be set and non-NULL
> by rdev_for_each(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element found.
> Otherwise it will bypass the NULL check and lead to invalid memory
> access passing the check.
>
> To fix the bug, use a new variable 'iter' as the list iterator,
> while using the original variable 'pdev' as a dedicated pointer to

s/pdev/rdev/

> point to the found element.
>
> Cc: stable@vger.kernel.org
> Fixes: 2aa82191ac36c ("md-cluster: Perform a lazy update")

"Fixes" should use a hash of 12 characters (13 given here). Did
checkpatch.pl complain about it?

> Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>
> changes since v1:
>  - rephrase the subject (Guoqing Jiang)
>  - add Acked-by: for Guoqing Jiang
> v1:https://lore.kernel.org/lkml/20220327080002.11923-1-xiam0nd.tong@gmail.com/
>
> ---
>  drivers/md/md.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4d38bd7dadd6..7476fc204172 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2629,14 +2629,16 @@ static void sync_sbs(struct mddev *mddev, int nospares)
>
>  static bool does_sb_need_changing(struct mddev *mddev)
>  {
> -       struct md_rdev *rdev;
> +       struct md_rdev *rdev = NULL, *iter;
>         struct mdp_superblock_1 *sb;
>         int role;
>
>         /* Find a good rdev */
> -       rdev_for_each(rdev, mddev)
> -               if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
> +       rdev_for_each(iter, mddev)
> +               if ((iter->raid_disk >= 0) && !test_bit(Faulty, &iter->flags)) {
> +                       rdev = iter;
>                         break;
> +               }
>
>         /* No good device found. */
>         if (!rdev)
> --
> 2.17.1
>

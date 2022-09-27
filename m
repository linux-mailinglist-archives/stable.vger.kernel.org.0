Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE02F5EB739
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 03:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiI0Bw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 21:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiI0Bw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 21:52:57 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCBD71BD7;
        Mon, 26 Sep 2022 18:52:55 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-345528ceb87so86814647b3.11;
        Mon, 26 Sep 2022 18:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Z6mwGmWFe8kc9REvRMpgAR4kMVMlolmnZnXb+8WIi+s=;
        b=KrczsANKZsMTyMklSFvkrdvxJgxIFI9kJDdLp/RYNJ9YvtGYD9R9MKHZ0WZ0lg57xX
         qzCY3744UirNxRKftxwvbkH/QscgxysOQHIllQ4wmOvumns+waBQ3rfoqG3YWj8t8Q/V
         jClKe0yY8Iz7O7VfocOX5ypMwSLaOmywHHlYCR+IMzWLatpVNqGJinBmar9ctO+njQgx
         2aKdMhZrj4Me8wmnJXW485T7m8DL1twJWkK4VYCLr/Pv0ECL0024G9CdkKlRWIEeg7gL
         YbtPq18WroXJfgls+3eyVXT3V1rPg3xZgrgCYxdS3RyNpYIS+6IXLCMpfYaGFifITt4F
         27Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Z6mwGmWFe8kc9REvRMpgAR4kMVMlolmnZnXb+8WIi+s=;
        b=JstRS0Hw8r0WN1J2F4RtLk5E2Ra1KgV0zQKKld2sd1ug3jK4+FUxeNtAQhXXHDObvL
         ry6NL6hXV/Q954nwDWxXH2sSpDMGaAuZEWSq/JfDhsXq47Fk+0IfSR3viqfC7glTxPfi
         FR2dTG7MAdMMfFkr2RzreMcVTVtJCCXUIY3k8MXMC2SbzypjZyeagqk7bDAM9L6i+hXl
         OeqfDffL80S9+kE1ghNzaUgaIxRdbOiZzgdYspsTo1kaGfa+u/mmi7Zg85dFx6lNRpLp
         n3Oe03LxVysarNfDrHOUeDVy6VDlnvncFWrjiiQs+k5/6CKpx5PnBIpz4SGZ799liyRk
         hBtw==
X-Gm-Message-State: ACrzQf3r6Cf+8DiaJWXKpPrYWDjO5GG7Tv3taSpurOLOgORU8yofjAxz
        nLfE1rJTE9CYTqLCGYp28H/O7cBtPV9DKDvb4eI=
X-Google-Smtp-Source: AMsMyM6gAGGPR+PUOGrG4fFfhdSS86IMK5BBfOlEWtVx3KSbpPeZbjLW4xppB3pBN6UZOgIWqHfGVp6f+kPtGEHGUaI=
X-Received: by 2002:a81:6a05:0:b0:349:fad4:37cf with SMTP id
 f5-20020a816a05000000b00349fad437cfmr23936253ywc.137.1664243574189; Mon, 26
 Sep 2022 18:52:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220926160611.48536-1-sj@kernel.org> <20220926162326.49013-1-sj@kernel.org>
In-Reply-To: <20220926162326.49013-1-sj@kernel.org>
From:   Yun Levi <ppbuk5246@gmail.com>
Date:   Tue, 27 Sep 2022 10:52:42 +0900
Message-ID: <CAM7-yPQ-HnFP_h5x-yxLMVkktZ7rRtLf5TQi1Hz6pr9h_2+iKQ@mail.gmail.com>
Subject: Re: [PATCH v4] damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
To:     SeongJae Park <sj@kernel.org>
Cc:     akpm@linux-foundation.org, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks :)

And Sorry to my mistake.

On Tue, Sep 27, 2022 at 1:23 AM SeongJae Park <sj@kernel.org> wrote:
>
> I forgot removing the closing dot of the subject and making the subject
> lower-case.
>
> On Mon, 26 Sep 2022 16:06:11 +0000 SeongJae Park <sj@kernel.org> wrote:
>
> > From: Levi Yun <ppbuk5246@gmail.com>
> >
> > When damon_sysfs_add_target couldn't find proper task,
> > New allocated damon_target structure isn't registered yet,
> > So, it's impossible to free new allocated one by
> > damon_sysfs_destroy_targets.
> >
> > By calling daemon_add_target as soon as allocating new target, Fix this
>
> Also we should s/daemon/damon/
>
> I will revise and send v5.
>
> > possible memory leak.
> >
> > Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
> > Cc: <stable@vger.kernel.org> # 5.17.x
> > Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >
> > Changes from v3
> > (https://lore.kernel.org/damon/20220925234327.26345-1-ppbuk5246@gmail.com/)
> > - Fix Fixes: tag
> > - Add patch changelog
> >
> > Changes from v2
> > (https://lore.kernel.org/damon/20220925234053.26090-1-ppbuk5246@gmail.com/)
> > - Add Fixes: and Cc: stable
> >
> > Changes from v1
> > (https://lore.kernel.org/damon/20220925140257.23431-1-ppbuk5246@gmail.com/)
> > - Do damon_add_target() earlier instead of explicitly freeing the object
> >
> >  mm/damon/sysfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index 455215a5c059..9f1219a67e3f 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -2172,12 +2172,12 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
> >
> >       if (!t)
> >               return -ENOMEM;
> > +     damon_add_target(ctx, t);
> >       if (damon_target_has_pid(ctx)) {
> >               t->pid = find_get_pid(sys_target->pid);
> >               if (!t->pid)
> >                       goto destroy_targets_out;
> >       }
> > -     damon_add_target(ctx, t);
> >       err = damon_sysfs_set_regions(t, sys_target->regions);
> >       if (err)
> >               goto destroy_targets_out;
> > --
> > 2.25.1

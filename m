Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA744D6A6C
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 00:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiCKWo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 17:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCKWoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 17:44:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A579C5E157;
        Fri, 11 Mar 2022 14:40:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 604C9B80EE0;
        Fri, 11 Mar 2022 22:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65ACC340E9;
        Fri, 11 Mar 2022 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647038422;
        bh=edOeCCGPidsfDBta24UEYMa+thqJbgXW3F+tYAjMV38=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VrnWZOKoLwD0hxybT0jAHa2JNb1l6NsPOnrQGfKb0xmWhjH+IA+rkJCPYu/bXzixb
         YeO7kOcNOBXVy+3aHD1tSw99WdDOLiXtqL76Li3tQhNIvW0XaNA5xMVriz5CiDfbU8
         KiVZM05waHJHgFDX2Dl+tS8IW248Pda4Z+bdxgSvzWkmms/FNqzhkdbhCn1k+k2G0f
         7R+2xLNVNgOIV0vyfZr8Thz/3OWfcHXuauaXrTxjq4WTxHblWPA9tuTGeZc3H964kJ
         oa/pfyTY+f7JFLm9GS7tRZlihFXns41Kr38xPKo+2O07kmfJEgICj4ySLUQ4v9XK5j
         gn9X/wfszx9yA==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2dbd8777564so109970897b3.0;
        Fri, 11 Mar 2022 14:40:22 -0800 (PST)
X-Gm-Message-State: AOAM530iApPMdwl+xJok8nlFdg9S/j0SMo6gywNmJrTRHG3cNvbxCcgg
        op1IOq8cqn5XowIpeWFBYb7nciBbLNzaIr7IbxE=
X-Google-Smtp-Source: ABdhPJwC/f7TuYoXOvpNtGSwGatK99lRZca8plSgnId5Q0KVNB/jut3lyLb3jr6fZyOpB4fJxzANJy1VJktVfo0a/9A=
X-Received: by 2002:a81:7814:0:b0:2ca:287c:6c2e with SMTP id
 t20-20020a817814000000b002ca287c6c2emr10183626ywc.211.1647038421914; Fri, 11
 Mar 2022 14:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk> <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk> <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com> <11a4c611-ed0c-789f-b5d0-8a127539daf1@molgen.mpg.de>
In-Reply-To: <11a4c611-ed0c-789f-b5d0-8a127539daf1@molgen.mpg.de>
From:   Song Liu <song@kernel.org>
Date:   Fri, 11 Mar 2022 14:40:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4yZBEj1ObEV0b0O7yFYs5VqAeYBCgc39qL2dOp4FBeFw@mail.gmail.com>
Message-ID: <CAPhsuW4yZBEj1ObEV0b0O7yFYs5VqAeYBCgc39qL2dOp4FBeFw@mail.gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 1:42 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Song,
>
>
> Am 11.03.22 um 17:59 schrieb Song Liu:
>
> > On Fri, Mar 11, 2022 at 6:16 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 3/10/22 5:07 PM, Jens Axboe wrote:
> >>> In any case, just doing larger reads would likely help quite a bit, but
> >>> would still be nice to get to the bottom of why we're not seeing the
> >>> level of merging we expect.
> >>
> >> Song, can you try this one? It'll do the dispatch in a somewhat saner
> >> fashion, bundling identical queues. And we'll keep iterating the plug
> >> list for a merge if we have multiple disks, until we've seen a queue
> >> match and checked.
> >
> > This one works great! We are seeing 99% read request merge and
> > 500kB+ average read size. The original patch in this thread only got
> > 88% and 34kB for these two metrics.
>
> Nice. I am curious, how these metrics can be obtained?
>

We can use tools as iostat:
iostat -mx 2
Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdb           3176.50    1.00    100.57      0.00 22503.00     0.00
87.63   0.00   10.22    3.50  32.46    32.42     4.00   0.24  76.60
sdi           3167.00    1.00    100.57      0.00 22512.50     0.00
87.67   0.00   11.58    4.00  36.68    32.52     4.00   0.24  77.55

The two metrics we used here are %rrqm and rareq-sz.

Thanks,
Song

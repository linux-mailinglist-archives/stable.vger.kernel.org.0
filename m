Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72F4D5581
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 00:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344786AbiCJXev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 18:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344764AbiCJXen (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 18:34:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ABF1520ED;
        Thu, 10 Mar 2022 15:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E2A61D1C;
        Thu, 10 Mar 2022 23:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307FDC340E8;
        Thu, 10 Mar 2022 23:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646955220;
        bh=KtcNK43D297EfcW6xxSyyTTHCEYLXXZxSma9Kt0RP/Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nT7vS9BgZbx3tjzdNBb0zd1p+9YH/6eFrpTUjgJKbzPipC1h1GhSKxHRS5cbj15hU
         ZArBFUlBp0f83OrpjU3Dp3GDKnN7xOJLDYqYi7ClIi7iJH5Z28Oi7mEX8sZ9zYCCsa
         O/sr6t6MyZL4GIoJQRM8AFaCuSUVJ3OGf4yvafrjkycCoy5VZ1DDQUYAIs4DV/WHMw
         RtXxBTTTolsGIl76nniP+mpmg7Yc1e0xfkjYdv7PNwRUQ2hQEl5EleKz9lh8CPsqRJ
         76tRJXIcqtL8aRXt99GsLCZ6izj9y4Z9DWqvCvVRiPnvFpMq2+jo4b+EgjRE64087e
         sqZm8HvEkLbsg==
Received: by mail-yb1-f182.google.com with SMTP id l2so13988690ybe.8;
        Thu, 10 Mar 2022 15:33:40 -0800 (PST)
X-Gm-Message-State: AOAM531XyYASr2TiAn5/cmrPhKZGVC2SA+5TCdHO4WyACfF0p+krkkg7
        PZufWFYRCMdqNLOm2vDL+x71XmAc219oi5uVGHQ=
X-Google-Smtp-Source: ABdhPJzlRrlnsJBA+uqStOGRXSBFuEe4HZtQjB64G+Dv/jMEjhl4wivxLaMX14y4N4Jq4AkuL7oRzpK2KPVK8zg4vvw=
X-Received: by 2002:a25:d350:0:b0:629:173b:b133 with SMTP id
 e77-20020a25d350000000b00629173bb133mr5913520ybf.561.1646955219254; Thu, 10
 Mar 2022 15:33:39 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com> <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
In-Reply-To: <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 15:33:28 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
Message-ID: <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
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

On Thu, Mar 10, 2022 at 3:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/10/22 3:37 PM, Song Liu wrote:
> > On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 3/8/22 11:42 PM, Song Liu wrote:
> >>> RAID arrays check/repair operations benefit a lot from merging requests.
> >>> If we only check the previous entry for merge attempt, many merge will be
> >>> missed. As a result, significant regression is observed for RAID check
> >>> and repair.
> >>>
> >>> Fix this by checking more than just the previous entry when
> >>> plug->multiple_queues == true.
> >>>
> >>> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> >>> 103 MB/s.
> >>
> >> Do the underlying disks not have an IO scheduler attached? Curious why
> >> the merges aren't being done there, would be trivial when the list is
> >> flushed out. Because if the perf difference is that big, then other
> >> workloads would be suffering they are that sensitive to being within a
> >> plug worth of IO.
> >
> > The disks have mq-deadline by default. I also tried kyber, the result
> > is the same. Raid repair work sends IOs to all the HDDs in a
> > round-robin manner. If we only check the previous request, there isn't
> > much opportunity for merge. I guess other workloads may have different
> > behavior?
>
> Round robin one at the time? I feel like there's something odd or
> suboptimal with the raid rebuild, if it's that sensitive to plug
> merging.

It is not one request at a time, but more like (for raid456):
   read 4kB from HDD1, HDD2, HDD3...,
   then read another 4kB from HDD1, HDD2, HDD3, ...

> Plug merging is mainly meant to reduce the overhead of merging,
> complement what the scheduler would do. If there's a big drop in
> performance just by not getting as efficient merging on the plug side,
> that points to an issue with something else.

We introduced blk_plug_max_rq_count() to give md more opportunities
to merge at plug side, so I guess the behavior has been like this for a
long time. I will take a look at the scheduler side and see whether we
can just merge later, but I am not very optimistic about it.

Thanks,
Song

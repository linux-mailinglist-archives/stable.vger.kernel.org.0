Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C064D56C0
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 01:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344325AbiCKAcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 19:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238063AbiCKAcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 19:32:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6701A2734;
        Thu, 10 Mar 2022 16:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDB97B829A1;
        Fri, 11 Mar 2022 00:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67502C340EB;
        Fri, 11 Mar 2022 00:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646958701;
        bh=6d06D3u/B3wHGpCu2TTt/w2j7SquYAxum8vobyO8VWA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hEIoYmnyoT3s/8Vrk+uDe3QzxEjoBYOR1G8N62+wMDJNwiJggiVbbtD50QrlmkJSJ
         tFDKnapGgdj7bYrlUhY9KAS/lUCoUHBU1uLuafiGNc7PXxUdVQxf2BT2jOAlh8qjm5
         Cuj23gqyydyrkHZ/AzZVlyU2woBK9Bo9EgDAxoveXvmSlshcf/jkb2XoHVB07bh2ck
         VFjFC3KnhYSCTc0LmWfvLDHj3b/5b092phKY7UglEMXc4/rLvEUiVsIXqhv9NElSUP
         XUL5dhXus02Mw10TSVCM84/0B4CTIK2U7eXXiR9/jE7BA7DzaguqnJO4pHg8yGS4eE
         Y8pMWyesLV22w==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2d6d0cb5da4so77074377b3.10;
        Thu, 10 Mar 2022 16:31:41 -0800 (PST)
X-Gm-Message-State: AOAM533Nmb1Ra2w0wN+jIE4JPAgBfSUpfYbMT6QbieyaR558SQpiFPJd
        O1SpLEV9jjn9U8/IZyvHUNiVj27SphfrfyxNUeM=
X-Google-Smtp-Source: ABdhPJw8OG+l+nPEKummlx4iLHcm58Z/shKU17OV0iUhC27DObLTCBdl3nMqPJ1dmWDMZo9F+pCis++gyhKFI3oAdDw=
X-Received: by 2002:a81:10cc:0:b0:2dc:24f7:7dd3 with SMTP id
 195-20020a8110cc000000b002dc24f77dd3mr6459192ywq.460.1646958700445; Thu, 10
 Mar 2022 16:31:40 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk> <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
In-Reply-To: <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 16:31:29 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6ueGM_DZuAWvMbaB4PNftA5_MaqzMiY8_Bz7Bqy-ahZA@mail.gmail.com>
Message-ID: <CAPhsuW6ueGM_DZuAWvMbaB4PNftA5_MaqzMiY8_Bz7Bqy-ahZA@mail.gmail.com>
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

On Thu, Mar 10, 2022 at 4:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/10/22 4:33 PM, Song Liu wrote:
> > On Thu, Mar 10, 2022 at 3:02 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 3/10/22 3:37 PM, Song Liu wrote:
> >>> On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 3/8/22 11:42 PM, Song Liu wrote:
> >>>>> RAID arrays check/repair operations benefit a lot from merging requests.
> >>>>> If we only check the previous entry for merge attempt, many merge will be
> >>>>> missed. As a result, significant regression is observed for RAID check
> >>>>> and repair.
> >>>>>
> >>>>> Fix this by checking more than just the previous entry when
> >>>>> plug->multiple_queues == true.
> >>>>>
> >>>>> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> >>>>> 103 MB/s.
> >>>>
> >>>> Do the underlying disks not have an IO scheduler attached? Curious why
> >>>> the merges aren't being done there, would be trivial when the list is
> >>>> flushed out. Because if the perf difference is that big, then other
> >>>> workloads would be suffering they are that sensitive to being within a
> >>>> plug worth of IO.
> >>>
> >>> The disks have mq-deadline by default. I also tried kyber, the result
> >>> is the same. Raid repair work sends IOs to all the HDDs in a
> >>> round-robin manner. If we only check the previous request, there isn't
> >>> much opportunity for merge. I guess other workloads may have different
> >>> behavior?
> >>
> >> Round robin one at the time? I feel like there's something odd or
> >> suboptimal with the raid rebuild, if it's that sensitive to plug
> >> merging.
> >
> > It is not one request at a time, but more like (for raid456):
> >    read 4kB from HDD1, HDD2, HDD3...,
> >    then read another 4kB from HDD1, HDD2, HDD3, ...
>
> Ehm, that very much looks like one-at-the-time from each drive, which is
> pretty much the worst way to do it :-)
>
> Is there a reason for that? Why isn't it using 64k chunks or something
> like that? You could still do that as a kind of read-ahead, even if
> you're still processing in chunks of 4k.

raid456 handles logic in the granularity of stripe. Each stripe is 4kB from
every HDD in the array. AFAICT, we need some non-trivial change to
enable the read ahead.

>
> >> Plug merging is mainly meant to reduce the overhead of merging,
> >> complement what the scheduler would do. If there's a big drop in
> >> performance just by not getting as efficient merging on the plug side,
> >> that points to an issue with something else.
> >
> > We introduced blk_plug_max_rq_count() to give md more opportunities to
> > merge at plug side, so I guess the behavior has been like this for a
> > long time. I will take a look at the scheduler side and see whether we
> > can just merge later, but I am not very optimistic about it.
>
> Yeah I remember, and that also kind of felt like a work-around for some
> underlying issue. Maybe there's something about how the IO is issued
> that makes it go straight to disk and we never get any merging? Is it
> because they are sync reads?
>
> In any case, just doing larger reads would likely help quite a bit, but
> would still be nice to get to the bottom of why we're not seeing the
> level of merging we expect.

Let me look more into this. Maybe we messed something up in the
scheduler.

Thanks,
Song

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E894D54AB
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbiCJWid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiCJWid (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:38:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CBF5F65;
        Thu, 10 Mar 2022 14:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50F2BB82902;
        Thu, 10 Mar 2022 22:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25B6C340E8;
        Thu, 10 Mar 2022 22:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646951847;
        bh=O5nu2s34Arb4kXnG4Xq0X7+UxfVtHqzsSPaGy/3wC4k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MfyyYt1+TWS5g7wisWkNI2uEq4rV3M0Fyw6gGygomdjOqlsSK+ko3yE2i8LVPVfeh
         e4AwZzd9qhBjH801j/YeDcMTUK287DsettaMMkuptm11KIL3VTJHTymbtcECX9UNXM
         msXshqw5cyxORhON2JK2iZmf7rnrNd3jD6PXJsg2pe/SH1qOxNRCxh8KFsoxrrzGIN
         CDFhVlKKFRXs5MXmovRwNJML3BAeZR8x2RDNyHNlY+52LT56KHsqEpJJ3M987Ewkds
         lT4Zdc+wK2RanrnSoLqQWmlMDqe2tDdqo+eDuKw56TvzUDxlOWQpuowP+coCMJOLlB
         rKmywMBCMj3QA==
Received: by mail-yb1-f174.google.com with SMTP id g1so13792384ybe.4;
        Thu, 10 Mar 2022 14:37:26 -0800 (PST)
X-Gm-Message-State: AOAM531K6Z+hUsrDAsRKATvTNFtleytEhlcGUqQmyCP73DZPsHxblSY2
        Flb4zjeMJs6qHT4gSxvruDdliXK2KwOYfwkAWW4=
X-Google-Smtp-Source: ABdhPJwvBfYY2TpIsgin8PDJQBVUKLBbtqz9wax7hteqL23GE/VW4aIi3Ja0d0/Lx91Hy9JT+BPlBdWT5VE4qhu36V4=
X-Received: by 2002:a05:6902:1ca:b0:624:e2a1:2856 with SMTP id
 u10-20020a05690201ca00b00624e2a12856mr5747607ybh.389.1646951845989; Thu, 10
 Mar 2022 14:37:25 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
In-Reply-To: <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 14:37:15 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
Message-ID: <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
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

On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/8/22 11:42 PM, Song Liu wrote:
> > RAID arrays check/repair operations benefit a lot from merging requests.
> > If we only check the previous entry for merge attempt, many merge will be
> > missed. As a result, significant regression is observed for RAID check
> > and repair.
> >
> > Fix this by checking more than just the previous entry when
> > plug->multiple_queues == true.
> >
> > This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> > 103 MB/s.
>
> Do the underlying disks not have an IO scheduler attached? Curious why
> the merges aren't being done there, would be trivial when the list is
> flushed out. Because if the perf difference is that big, then other
> workloads would be suffering they are that sensitive to being within a
> plug worth of IO.

The disks have mq-deadline by default. I also tried kyber, the result is the
same. Raid repair work sends IOs to all the HDDs in a round-robin manner.
If we only check the previous request, there isn't much opportunity for
merge. I guess other workloads may have different behavior?

> Between your two approaches, I do greatly prefer the first one though.

I also like the first one better. But I am not sure whether it will slow down
other workloads. We can probably also make the second one cleaner
with a new variation of blk_start_plug.

Thanks,
Song

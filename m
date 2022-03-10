Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B874D545C
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344312AbiCJWNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiCJWNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:13:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE2485969;
        Thu, 10 Mar 2022 14:12:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDBF261B83;
        Thu, 10 Mar 2022 22:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF4FC340E9;
        Thu, 10 Mar 2022 22:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646950370;
        bh=90dWd3WMXBfclXU6Ng7x5a7PuNyUNDhZeXRVc60uhbg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZQinx6cXjQW9sQyaGIDtFfN5rwwP3OCPXqofCwx5osBNdIXc0lQc298DHC0tpZYtY
         ayJCIm7DMi3PisgVeUM+wifCKUhqMZ5SXZaP47ZIc/6NzxfhSte/I3K3zNEnJY1IGx
         Pa476c+yTzzE1//a8Th7J6avpEZfTqYT6+U+oyuBN09RgnTO9eUf06NiPSTN5z9WXd
         7wdpHyV8otQFuE7UdBBGCf6TUEDG4Iz1Jk6cI+Iyxfg3NooOAsrxVAio+ruO9HzWzp
         wtOfG01WYIBb3DSHUPGScD+NS3HvguxYEX580b8MDBH3EQAsgR4hzzVXVKenuQ4nuS
         uas3cVREKya9w==
Received: by mail-yb1-f174.google.com with SMTP id u3so13677652ybh.5;
        Thu, 10 Mar 2022 14:12:50 -0800 (PST)
X-Gm-Message-State: AOAM530YrNyqju5qWS8SnebXmlcJnoFPEL6XsAVZtA085OtjLt9akQv2
        GTFfy0Z3v7vwzMd0miWY55nJ9nfQL7CRyKXs5V4=
X-Google-Smtp-Source: ABdhPJyWWyoP+V45Q5VDLQwckcRyWAX2SrIm2A03kp3jsjWKm2N0PX4WbP+K/vESY/C6arjFB5J2qsBGYGUM3tgo3Mg=
X-Received: by 2002:a25:d350:0:b0:629:173b:b133 with SMTP id
 e77-20020a25d350000000b00629173bb133mr5689175ybf.561.1646950369311; Thu, 10
 Mar 2022 14:12:49 -0800 (PST)
MIME-Version: 1.0
References: <20220309064209.4169303-1-song@kernel.org> <YimfLJoWLKnnhLfR@infradead.org>
 <CAPhsuW4DJbvH5QZ5YMC4Ms4bd66UOFsLL=-yK8tQKrwreCfKDQ@mail.gmail.com> <CAPhsuW7AHuxOpiH_nsqg4dkb3pwOTy8f2sHsDrtAF73+BLZF5A@mail.gmail.com>
In-Reply-To: <CAPhsuW7AHuxOpiH_nsqg4dkb3pwOTy8f2sHsDrtAF73+BLZF5A@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 14:12:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5Ph5M5659xMAnMwmBvpsrWbFtVZB2j-EF7q3KHrrp-Ew@mail.gmail.com>
Message-ID: <CAPhsuW5Ph5M5659xMAnMwmBvpsrWbFtVZB2j-EF7q3KHrrp-Ew@mail.gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in blk_attempt_plug_merge
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
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

On Thu, Mar 10, 2022 at 2:10 PM Song Liu <song@kernel.org> wrote:
>
> On Wed, Mar 9, 2022 at 11:23 PM Song Liu <song@kernel.org> wrote:
> >
> > On Wed, Mar 9, 2022 at 10:48 PM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Tue, Mar 08, 2022 at 10:42:09PM -0800, Song Liu wrote:
> > > > RAID arrays check/repair operations benefit a lot from merging requests.
> > > > If we only check the previous entry for merge attempt, many merge will be
> > > > missed. As a result, significant regression is observed for RAID check
> > > > and repair.
> > > >
> > > > Fix this by checking more than just the previous entry when
> > > > plug->multiple_queues == true.
> > >
> > > But this also means really significant CPU overhead for all other
> > > workloads.
> >
> > Would the following check help with these workloads?
> >
> >  if (!plug->multiple_queues)
> >               break;
> >
> > >
> > > >
> > > > This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> > > > 103 MB/s.
> > >
> > > What driver uses multiple queues for HDDs?
> > >
> > > Can you explain the workload submitted by a md a bit better?  I wonder
> > > if we can easily do the right thing straight in the md driver.
> >
> > It is the md sync_thread doing check and repair. Basically, the md
> > thread reads all
> > the disks and computes parity from data.
> >
> > Maybe we should add a new flag to struct blk_plug for this special case?
>
> I meant something like:
>
> diff --git c/block/blk-core.c w/block/blk-core.c
> index 1039515c99d6..4fb09243e908 100644
> --- c/block/blk-core.c
> +++ w/block/blk-core.c
> @@ -1303,6 +1303,12 @@ void blk_finish_plug(struct blk_plug *plug)
>  }
>  EXPORT_SYMBOL(blk_finish_plug);
>
> +void blk_plug_merge_aggressively(struct blk_plug *plug)
> +{
> +    plug->aggresive_merge = true;
> +}
> +EXPORT_SYMBOL(blk_plug_merge_aggressively);
> +
>  void blk_io_schedule(void)
>  {
>      /* Prevent hang_check timer from firing at us during very long I/O */

Missed one change:

--- c/block/blk-core.c
+++ w/block/blk-core.c
@@ -1188,6 +1188,7 @@ void blk_start_plug_nr_ios(struct blk_plug
*plug, unsigned short nr_ios)
     plug->multiple_queues = false;
     plug->has_elevator = false;
     plug->nowait = false;
+    plug->aggresive_merge = false;
     INIT_LIST_HEAD(&plug->cb_list);

     /*

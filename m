Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0A4D5767
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 02:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345369AbiCKBeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 20:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345349AbiCKBeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 20:34:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1F82C12F6
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646962376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0BVkvO12mKC7YYvUmVHcGZENhxowvhj+FeEArZrimMw=;
        b=adkcGsv/uaGgrzw+3nZbYnQFJxwdsqic80PAc8h0zitZwHsSdt0v6+L2cimql2ulh62g3b
        l1YVxmD1EZYupWk+rJAiMqTwoyKxrB2GI4OLUJ4QkroLf6LnKr1ic3/xK7j/T0tgDSra/3
        j0WDE1HUVvD4IDTKlC9JTbgWbUHZASY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-HY2Qz_3APSOlomiyaZ0UPQ-1; Thu, 10 Mar 2022 20:32:53 -0500
X-MC-Unique: HY2Qz_3APSOlomiyaZ0UPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 222C02E67;
        Fri, 11 Mar 2022 01:32:52 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F02060C17;
        Fri, 11 Mar 2022 01:32:42 +0000 (UTC)
Date:   Fri, 11 Mar 2022 09:32:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Message-ID: <YiqmsypjvdPN/K3w@T590>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <CAPhsuW6ueGM_DZuAWvMbaB4PNftA5_MaqzMiY8_Bz7Bqy-ahZA@mail.gmail.com>
 <40ae10bd-6839-2246-c2d7-aa11e671d7d4@kernel.dk>
 <Yiqijd9S6Y92DnBu@T590>
 <0d7bb070-11a3-74b1-22d5-86001818018b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d7bb070-11a3-74b1-22d5-86001818018b@kernel.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 06:21:33PM -0700, Jens Axboe wrote:
> On 3/10/22 6:14 PM, Ming Lei wrote:
> > On Thu, Mar 10, 2022 at 05:36:44PM -0700, Jens Axboe wrote:
> >> On 3/10/22 5:31 PM, Song Liu wrote:
> >>> On Thu, Mar 10, 2022 at 4:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 3/10/22 4:33 PM, Song Liu wrote:
> >>>>> On Thu, Mar 10, 2022 at 3:02 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>> On 3/10/22 3:37 PM, Song Liu wrote:
> >>>>>>> On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>>>
> >>>>>>>> On 3/8/22 11:42 PM, Song Liu wrote:
> >>>>>>>>> RAID arrays check/repair operations benefit a lot from merging requests.
> >>>>>>>>> If we only check the previous entry for merge attempt, many merge will be
> >>>>>>>>> missed. As a result, significant regression is observed for RAID check
> >>>>>>>>> and repair.
> >>>>>>>>>
> >>>>>>>>> Fix this by checking more than just the previous entry when
> >>>>>>>>> plug->multiple_queues == true.
> >>>>>>>>>
> >>>>>>>>> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> >>>>>>>>> 103 MB/s.
> >>>>>>>>
> >>>>>>>> Do the underlying disks not have an IO scheduler attached? Curious why
> >>>>>>>> the merges aren't being done there, would be trivial when the list is
> >>>>>>>> flushed out. Because if the perf difference is that big, then other
> >>>>>>>> workloads would be suffering they are that sensitive to being within a
> >>>>>>>> plug worth of IO.
> >>>>>>>
> >>>>>>> The disks have mq-deadline by default. I also tried kyber, the result
> >>>>>>> is the same. Raid repair work sends IOs to all the HDDs in a
> >>>>>>> round-robin manner. If we only check the previous request, there isn't
> >>>>>>> much opportunity for merge. I guess other workloads may have different
> >>>>>>> behavior?
> >>>>>>
> >>>>>> Round robin one at the time? I feel like there's something odd or
> >>>>>> suboptimal with the raid rebuild, if it's that sensitive to plug
> >>>>>> merging.
> >>>>>
> >>>>> It is not one request at a time, but more like (for raid456):
> >>>>>    read 4kB from HDD1, HDD2, HDD3...,
> >>>>>    then read another 4kB from HDD1, HDD2, HDD3, ...
> >>>>
> >>>> Ehm, that very much looks like one-at-the-time from each drive, which is
> >>>> pretty much the worst way to do it :-)
> >>>>
> >>>> Is there a reason for that? Why isn't it using 64k chunks or something
> >>>> like that? You could still do that as a kind of read-ahead, even if
> >>>> you're still processing in chunks of 4k.
> >>>
> >>> raid456 handles logic in the granularity of stripe. Each stripe is 4kB from
> >>> every HDD in the array. AFAICT, we need some non-trivial change to
> >>> enable the read ahead.
> >>
> >> Right, you'd need to stick some sort of caching in between so instead of
> >> reading 4k directly, you ask the cache for 4k and that can manage
> >> read-ahead.
> >>
> >>>>>> Plug merging is mainly meant to reduce the overhead of merging,
> >>>>>> complement what the scheduler would do. If there's a big drop in
> >>>>>> performance just by not getting as efficient merging on the plug side,
> >>>>>> that points to an issue with something else.
> >>>>>
> >>>>> We introduced blk_plug_max_rq_count() to give md more opportunities to
> >>>>> merge at plug side, so I guess the behavior has been like this for a
> >>>>> long time. I will take a look at the scheduler side and see whether we
> >>>>> can just merge later, but I am not very optimistic about it.
> >>>>
> >>>> Yeah I remember, and that also kind of felt like a work-around for some
> >>>> underlying issue. Maybe there's something about how the IO is issued
> >>>> that makes it go straight to disk and we never get any merging? Is it
> >>>> because they are sync reads?
> >>>>
> >>>> In any case, just doing larger reads would likely help quite a bit, but
> >>>> would still be nice to get to the bottom of why we're not seeing the
> >>>> level of merging we expect.
> >>>
> >>> Let me look more into this. Maybe we messed something up in the
> >>> scheduler.
> >>
> >> I'm assuming you have a plug setup for doing the reads, which is why you
> >> see the big difference (or there would be none). But
> >> blk_mq_flush_plug_list() should really take care of this when the plug
> >> is flushed, requests should be merged at that point. And from your
> >> description, doesn't sound like they are at all.
> > 
> > requests are shared, when running out of request, plug list will be
> > flushed early.
> 
> That is true, but I don't think that's the problem here with the round
> robin approach. Seems like it'd drive a pretty low queue depth, even
> considering SATA.

Another one may be plug list not sorted before inserting requests to
scheduler in blk_mq_flush_plug_list(), looks you have mentioned.

Thanks,
Ming


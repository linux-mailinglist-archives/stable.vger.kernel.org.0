Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7A249CDCE
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 16:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbiAZPTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 10:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242665AbiAZPTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 10:19:07 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [IPv6:2a01:e0c:1:1599::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0087C06161C;
        Wed, 26 Jan 2022 07:19:07 -0800 (PST)
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id 1DCB2B00548;
        Wed, 26 Jan 2022 16:19:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AxJ5t5OjDUZXf2Lh6mDw1u0w444vTXzCEH4PtXRkqFE=; b=fDXhQqvzNe+/aO7uA8rxFhULso
        XSRds8LkBXxGUuvINy0QtiOuKn52kp4SlTedGHz8WZskocsgKb39ZDXoSu8ky811CzB616ft11oEn
        uSWRY4scVZ2WzY7ToXmMDjBnJJA2gTU+nQ8qOwoZsIQv3mjnKH77Ovy2kCF8KwGu70Rk=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1nCk4e-002pg7-E4; Wed, 26 Jan 2022 16:19:04 +0100
Date:   Wed, 26 Jan 2022 16:19:04 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>,
        Guillaume Morin <guillaume@morinfr.org>
Subject: Re: [PATCH 5.10 01/25] md: revert io stats accounting
Message-ID: <YfFmaKkdqZPXB5B0@bender.morinfr.org>
References: <20220114081542.698002137@linuxfoundation.org>
 <20220114081542.746291845@linuxfoundation.org>
 <CA+res+S1GcDzM6hnmar+s1k3ggswURZ+_8BqweifShCTjVJ2aQ@mail.gmail.com>
 <YfEztOTIhGjm3Hvs@kroah.com>
 <CA+res+RpQuedYu3hhRo5kBcs3tQrKc+7eyiFbVUAVG2h68cYkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+res+RpQuedYu3hhRo5kBcs3tQrKc+7eyiFbVUAVG2h68cYkg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26 Jan 13:37, Jack Wang wrote:
> > > >
> > > > -       if (bio->bi_end_io != md_end_io) {
> > > > -               struct md_io *md_io;
> > > > -
> > > > -               md_io = mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
> > > > -               md_io->mddev = mddev;
> > > > -               md_io->orig_bi_end_io = bio->bi_end_io;
> > > > -               md_io->orig_bi_private = bio->bi_private;
> > > > -
> > > > -               bio->bi_end_io = md_end_io;
> > > > -               bio->bi_private = md_io;
> > > > -
> > > > -               md_io->start_time = part_start_io_acct(mddev->gendisk,
> > > > -                                                      &md_io->part, bio);
> > > > -       }
> > > > -
> > > > +       /*
> > > > +        * save the sectors now since our bio can
> > > > +        * go away inside make_request
> > > > +        */
> > > > +       sectors = bio_sectors(bio);
> > > This code snip is not inside the original patch, and it's not in
> > > latest upstream too.
> > > >         /* bio could be mergeable after passing to underlayer */
> > > >         bio->bi_opf &= ~REQ_NOMERGE;
> > > >
> > > >         md_handle_request(mddev, bio);
> > > >
> > > > +       part_stat_lock();
> > > > +       part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
> > > > +       part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
> > > > +       part_stat_unlock();
> > > > +
> > > same here, this code snip is not inside the original patch, and it's
> > > not in latest upstream too.
> >
> > Is it a problem?
> Not sure, might cause some confusion regarding io stats.

Have you observed anything weird? Because if you don't include this, I
don't see where these stats are updated at all. Could you explain
please?

-- 
Guillaume Morin <guillaume@morinfr.org>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607C249CD84
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 16:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242611AbiAZPMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 10:12:49 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:51800 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242608AbiAZPMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 10:12:48 -0500
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id C12DBB00571;
        Wed, 26 Jan 2022 16:12:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=axzolPy+BPljfmZmSANvL0Zmeb7gY16v/jqcglkbVZk=; b=OZY/dz46COePbi3KCr5mx/5C5i
        dgvApOH88rAvSgolDRpEgVhbLzyCwxJwtWbn3T55ODD/oioxBk2zK9ytjfMzVOYUXSL58ZZXz8TfJ
        vmjKesP2y6OM8eEwcdJdjHfRSOPmjItCIc3+vUQ/N5aSG1tMs+xVBtLVkJcOTZWgPnqs=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1nCjyY-002pZ5-4w; Wed, 26 Jan 2022 16:12:46 +0100
Date:   Wed, 26 Jan 2022 16:12:46 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>,
        Guillaume Morin <guillaume@morinfr.org>
Subject: Re: [PATCH 5.10 01/25] md: revert io stats accounting
Message-ID: <YfFk7guenfgvrDlD@bender.morinfr.org>
References: <20220114081542.698002137@linuxfoundation.org>
 <20220114081542.746291845@linuxfoundation.org>
 <CA+res+S1GcDzM6hnmar+s1k3ggswURZ+_8BqweifShCTjVJ2aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+res+S1GcDzM6hnmar+s1k3ggswURZ+_8BqweifShCTjVJ2aQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26 Jan 11:09, Jack Wang wrote:
> >
> > -       if (bio->bi_end_io != md_end_io) {
> > -               struct md_io *md_io;
> > -
> > -               md_io = mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
> > -               md_io->mddev = mddev;
> > -               md_io->orig_bi_end_io = bio->bi_end_io;
> > -               md_io->orig_bi_private = bio->bi_private;
> > -
> > -               bio->bi_end_io = md_end_io;
> > -               bio->bi_private = md_io;
> > -
> > -               md_io->start_time = part_start_io_acct(mddev->gendisk,
> > -                                                      &md_io->part, bio);
> > -       }
> > -
> > +       /*
> > +        * save the sectors now since our bio can
> > +        * go away inside make_request
> > +        */
> > +       sectors = bio_sectors(bio);
> This code snip is not inside the original patch, and it's not in
> latest upstream too.
> >         /* bio could be mergeable after passing to underlayer */
> >         bio->bi_opf &= ~REQ_NOMERGE;
> >
> >         md_handle_request(mddev, bio);
> >
> > +       part_stat_lock();
> > +       part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
> > +       part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
> > +       part_stat_unlock();
> > +
> same here, this code snip is not inside the original patch, and it's
> not in latest upstream too.

Both snippets came from the code before 41d2d848e5c0 that the patch is
being reverted here.  As I explained in my original message, upstream is
different because of 99dfc43ecbf6 which is not in 5.10.

> I think would be good keep it as the upstream version.

If you don't include these lines, isn't this worse as it's not calling
either part_start_io_acct or bio_start_io_acct (in 99dfc43ecbf6)?

-- 
Guillaume Morin <guillaume@morinfr.org>

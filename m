Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EAC49CA2A
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbiAZM5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbiAZM5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:57:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43805C06161C;
        Wed, 26 Jan 2022 04:57:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10E43B81D05;
        Wed, 26 Jan 2022 12:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6A8C340E3;
        Wed, 26 Jan 2022 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643201841;
        bh=WjSXJJLFgn///WXgXrWaxq0fyKyJj+v3auEVSwOjjsE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jorod1QGnXM7vSthuCy+/TApHtZgb8F+R/HZUUNCIf0joFXIqav099INEcgMDOEZP
         ovxvtlkkiy7oR3WbIjN0HDKAW5Ak3tIfNiGnu/yQGztZCLMFRbsghKnwC4ITpdkdjZ
         fPd3I3BN2Smrt32hvdHN5bTVR/cGwZFAa9gJ9YWM=
Date:   Wed, 26 Jan 2022 13:57:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>,
        Guillaume Morin <guillaume@morinfr.org>
Subject: Re: [PATCH 5.10 01/25] md: revert io stats accounting
Message-ID: <YfFFL8U4usnhd18s@kroah.com>
References: <20220114081542.698002137@linuxfoundation.org>
 <20220114081542.746291845@linuxfoundation.org>
 <CA+res+S1GcDzM6hnmar+s1k3ggswURZ+_8BqweifShCTjVJ2aQ@mail.gmail.com>
 <YfEztOTIhGjm3Hvs@kroah.com>
 <CA+res+RpQuedYu3hhRo5kBcs3tQrKc+7eyiFbVUAVG2h68cYkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+res+RpQuedYu3hhRo5kBcs3tQrKc+7eyiFbVUAVG2h68cYkg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 01:37:12PM +0100, Jack Wang wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> 于2022年1月26日周三 12:42写道：
> >
> > On Wed, Jan 26, 2022 at 11:09:46AM +0100, Jack Wang wrote:
> > > Hi,
> > >
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> 于2022年1月14日周五 19:57写道：
> > > >
> > > > From: Guoqing Jiang <jgq516@gmail.com>
> > > >
> > > > commit ad3fc798800fb7ca04c1dfc439dba946818048d8 upstream.
> > > >
> > > > The commit 41d2d848e5c0 ("md: improve io stats accounting") could cause
> > > > double fault problem per the report [1], and also it is not correct to
> > > > change ->bi_end_io if md don't own it, so let's revert it.
> > > >
> > > > And io stats accounting will be replemented in later commits.
> > > >
> > > > [1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com/T/#t
> > > >
> > > > Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
> > > > Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> > > > Signed-off-by: Song Liu <song@kernel.org>
> > > > [GM: backport to 5.10-stable]
> > > > Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  drivers/md/md.c |   57 +++++++++++---------------------------------------------
> > > >  drivers/md/md.h |    1
> > > >  2 files changed, 12 insertions(+), 46 deletions(-)
> > > >
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -459,34 +459,12 @@ check_suspended:
> > > >  }
> > > >  EXPORT_SYMBOL(md_handle_request);
> > > >
> > > > -struct md_io {
> > > > -       struct mddev *mddev;
> > > > -       bio_end_io_t *orig_bi_end_io;
> > > > -       void *orig_bi_private;
> > > > -       unsigned long start_time;
> > > > -       struct hd_struct *part;
> > > > -};
> > > > -
> > > > -static void md_end_io(struct bio *bio)
> > > > -{
> > > > -       struct md_io *md_io = bio->bi_private;
> > > > -       struct mddev *mddev = md_io->mddev;
> > > > -
> > > > -       part_end_io_acct(md_io->part, bio, md_io->start_time);
> > > > -
> > > > -       bio->bi_end_io = md_io->orig_bi_end_io;
> > > > -       bio->bi_private = md_io->orig_bi_private;
> > > > -
> > > > -       mempool_free(md_io, &mddev->md_io_pool);
> > > > -
> > > > -       if (bio->bi_end_io)
> > > > -               bio->bi_end_io(bio);
> > > > -}
> > > > -
> > > >  static blk_qc_t md_submit_bio(struct bio *bio)
> > > >  {
> > > >         const int rw = bio_data_dir(bio);
> > > > +       const int sgrp = op_stat_group(bio_op(bio));
> > > >         struct mddev *mddev = bio->bi_disk->private_data;
> > > > +       unsigned int sectors;
> > > >
> > > >         if (mddev == NULL || mddev->pers == NULL) {
> > > >                 bio_io_error(bio);
> > > > @@ -507,26 +485,21 @@ static blk_qc_t md_submit_bio(struct bio
> > > >                 return BLK_QC_T_NONE;
> > > >         }
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
> >
> > > I think would be good keep it as the upstream version.
> >
> > Can you send a revert of this commit (it is in 5.10.92), and a backport
> > of the correct fix?
> >
> sure, I just sent an incremental fix for the backport itself.
> is it ok?

That works, I'll queue it up after this next round of releases, thanks!

greg k-h

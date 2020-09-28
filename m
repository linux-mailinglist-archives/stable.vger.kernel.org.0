Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D2227B4B0
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgI1SnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 14:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgI1SnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 14:43:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D08C207D8;
        Mon, 28 Sep 2020 18:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601318598;
        bh=+tpMq/EwkKDJtjWhYIvbjlAALa53N4IVRLHtR0393NM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uIoAAI2ngwOfQGVnnfWe1Qw/qJG5GFKTbonq2JEj9XhKApAGoT8/xcqRK7VS3ILjZ
         //tuHKW444KJslOYvpjReh8lf5JVTNneW/WLLNLO61bZfn4J85iy5jcQb4On4F0Mb9
         sh+1Av9qC03pGs8jwvfzNzTmfqD8MvfNb8sNCFXI=
Date:   Mon, 28 Sep 2020 20:43:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     ming.lei@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4, 5.8] dm: fix bio splitting and its bio completion
 order for regular IO
Message-ID: <20200928184325.GB2270606@kroah.com>
References: <1601301410240130@kroah.com>
 <20200928152941.GA66303@lobo>
 <20200928173144.GA2042505@kroah.com>
 <20200928175229.GA2202997@kroah.com>
 <20200928180325.GA23926@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928180325.GA23926@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 02:03:26PM -0400, Mike Snitzer wrote:
> On Mon, Sep 28 2020 at  1:52pm -0400,
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, Sep 28, 2020 at 07:31:44PM +0200, Greg KH wrote:
> > > On Mon, Sep 28, 2020 at 11:29:41AM -0400, Mike Snitzer wrote:
> > > > This backport applies (with mild offset) to both v5.4.67 and v5.8.11:
> > > > 
> > > > >From ee1dfad5325ff1cfb2239e564cd411b3bfe8667a Mon Sep 17 00:00:00 2001
> > > > From: Mike Snitzer <snitzer@redhat.com>
> > > > Date: Mon, 14 Sep 2020 13:04:19 -0400
> > > > Subject: [PATCH] dm: fix bio splitting and its bio completion order for regular IO
> > > > 
> > > > dm_queue_split() is removed because __split_and_process_bio() _must_
> > > > handle splitting bios to ensure proper bio submission and completion
> > > > ordering as a bio is split.
> > > > 
> > > > Otherwise, multiple recursive calls to ->submit_bio will cause multiple
> > > > split bios to be allocated from the same ->bio_split mempool at the same
> > > > time. This would result in deadlock in low memory conditions because no
> > > > progress could be made (only one bio is available in ->bio_split
> > > > mempool).
> > > > 
> > > > This fix has been verified to still fix the loss of performance, due
> > > > to excess splitting, that commit 120c9257f5f1 provided.
> > > > 
> > > > Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
> > > > Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
> > > > Reported-by: Ming Lei <ming.lei@redhat.com>
> > > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > 
> > > What is the git id of this patch in Linus's tree?
> > 
> > I dug it up:
> > 	ee1dfad5325f ("dm: fix bio splitting and its bio completion order for regular IO")
> 
> I thought this line was adequate in my original email:
> "From ee1dfad5325ff1cfb2239e564cd411b3bfe8667a Mon Sep 17 00:00:00 2001"
> 
> Maybe it was too subtle?  For future knowledge, how would you like to
> see the git id of Linus's tree referenced?

Oh, that was subtle, sorry, missed it :)

Better ways can be in that sentence that said what trees to backport it
to, right?  Explicit is good, especially when having to deal with as
many patches as we deal with, right?

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD2827B341
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgI1Rbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 13:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgI1Rbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 13:31:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D36D2083B;
        Mon, 28 Sep 2020 17:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601314296;
        bh=kGE2Xqe72I6KcltUsTs8gsQOC9SqlAdV0zI8wy7KvV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BW97N4in7WTP2H5OPsNBCaqZfKiGptfpCQs6svDwSleZxHBNe6IjKumQJntldpN3c
         8efTgE7BcghC8stC6egt+syx221HrsrXTpyeM6GHZ7lFkJYTZhyx5liCm8zy3RQXlK
         hOZrsBNyt2wTT7QIDJKjOQvutxs0ESHWh+R24ics=
Date:   Mon, 28 Sep 2020 19:31:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     ming.lei@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4, 5.8] dm: fix bio splitting and its bio completion
 order for regular IO
Message-ID: <20200928173144.GA2042505@kroah.com>
References: <1601301410240130@kroah.com>
 <20200928152941.GA66303@lobo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928152941.GA66303@lobo>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 11:29:41AM -0400, Mike Snitzer wrote:
> This backport applies (with mild offset) to both v5.4.67 and v5.8.11:
> 
> >From ee1dfad5325ff1cfb2239e564cd411b3bfe8667a Mon Sep 17 00:00:00 2001
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Mon, 14 Sep 2020 13:04:19 -0400
> Subject: [PATCH] dm: fix bio splitting and its bio completion order for regular IO
> 
> dm_queue_split() is removed because __split_and_process_bio() _must_
> handle splitting bios to ensure proper bio submission and completion
> ordering as a bio is split.
> 
> Otherwise, multiple recursive calls to ->submit_bio will cause multiple
> split bios to be allocated from the same ->bio_split mempool at the same
> time. This would result in deadlock in low memory conditions because no
> progress could be made (only one bio is available in ->bio_split
> mempool).
> 
> This fix has been verified to still fix the loss of performance, due
> to excess splitting, that commit 120c9257f5f1 provided.
> 
> Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
> Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

What is the git id of this patch in Linus's tree?

thanks,

greg k-h

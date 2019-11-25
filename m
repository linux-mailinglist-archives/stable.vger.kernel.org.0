Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75455109426
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 20:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKYTWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 14:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfKYTWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 14:22:53 -0500
Received: from localhost (unknown [104.132.0.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F5722075C;
        Mon, 25 Nov 2019 19:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574709772;
        bh=W9rdSYIXEkNtuvgcVbxsxMERlao6V+z7XjhC2PXwSGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xZuVXkiLxmY1R7JbFNqcd0PcOSKTeOxB0bG6o4v2D3lraz/evRhn55EKUsgPeduSq
         Z2vRrKJpYdsSWgHtRX4Icqy4Ltt9Vcl22UewkZ9Q5Q7oc+4N2oUUqCEsvSrS8r1SD6
         0gy+EOmO3jffbvEe70LuUCZRrl9VR3QuSsfYWERE=
Date:   Mon, 25 Nov 2019 11:22:51 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH v2] loop: avoid EAGAIN, if offset or block_size are
 changed
Message-ID: <20191125192251.GA76721@jaegeuk-macbookpro.roam.corp.google.com>
References: <20190518004751.18962-1-jaegeuk@kernel.org>
 <20190518005304.GA19446@jaegeuk-macbookpro.roam.corp.google.com>
 <1e1aae74-bd6b-dddb-0c88-660aac33872c@acm.org>
 <20191125175913.GC71634@jaegeuk-macbookpro.roam.corp.google.com>
 <a4e5d6bd-3685-379a-c388-cd2871827b21@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e5d6bd-3685-379a-c388-cd2871827b21@acm.org>
User-Agent: Mutt/1.8.2 (2017-04-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bart,

On 11/25, Bart Van Assche wrote:
> On 11/25/19 9:59 AM, Jaegeuk Kim wrote:
> > On 11/19, Bart Van Assche wrote:
> > > On 5/17/19 5:53 PM, Jaegeuk Kim wrote:
> > > > This patch tries to avoid EAGAIN due to nrpages!=0 that was originally trying
> > > > to drop stale pages resulting in wrong data access.
> > > > 
> > > > Report: https://bugs.chromium.org/p/chromium/issues/detail?id=938958#c38
> > > 
> > > Please provide a more detailed commit description. What is wrong with the
> > > current implementation and why is the new behavior considered the correct
> > > behavior?
> > 
> > Some history would be:
> > 
> > Original bug fix is:
> > commit 5db470e229e2 ("loop: drop caches if offset or block_size are changed"),
> > which returns EAGAIN so that user land like Chrome would require enhancing their
> > error handling routines.
> > 
> > So, this patch tries to avoid EAGAIN while addressing the original bug.
> > 
> > > 
> > > This patch moves draining code from before the following comment to after
> > > that comment:
> > > 
> > > /* I/O need to be drained during transfer transition */
> > > 
> > > Is that comment still correct or should it perhaps be updated?
> > 
> > IMHO, it's still valid.
> 
> Hi Jaegeuk,
> 
> Thank you for the additional and very helpful clarification. Can you have a look at the (totally untested) patch below? I prefer that version because it prevents concurrent processing of requests and syncing/killing the bdev.

Yeah, I thought this was much cleaner way, but wasn't sure it could be doable
to sync|kill block device after freezing the queue. Is it okay?

> 
> Thanks,
> 
> Bart.
> 
> 
> Subject: [PATCH] loop: Avoid EAGAIN if offset or block_size are changed
> 
> After sync_blockdev() and kill_bdev() have been called, more requests
> can be submitted to the loop device. These requests dirty additional
> pages, causing loop_set_status() to return -EAGAIN. Not all user space
> code that changes the offset and/or the block size handles -EAGAIN
> correctly. Hence make sure that loop_set_status() does not return
> -EAGAIN.
> 
> Fixes: 5db470e229e2 ("loop: drop caches if offset or block_size are changed")
> Reported-by: Gwendal Grignou <gwendal@chromium.org>
> Reported-by: grygorii tertychnyi <gtertych@cisco.com>
> Reported-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/block/loop.c | 35 +++++++----------------------------
>  1 file changed, 7 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 739b372a5112..48cfc8b9c247 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1264,15 +1264,15 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
>  		goto out_unlock;
>  	}
> 
> +	/* I/O need to be drained during transfer transition */
> +	blk_mq_freeze_queue(lo->lo_queue);
> +
>  	if (lo->lo_offset != info->lo_offset ||
>  	    lo->lo_sizelimit != info->lo_sizelimit) {
>  		sync_blockdev(lo->lo_device);
>  		kill_bdev(lo->lo_device);
>  	}
> 
> -	/* I/O need to be drained during transfer transition */
> -	blk_mq_freeze_queue(lo->lo_queue);
> -
>  	err = loop_release_xfer(lo);
>  	if (err)
>  		goto out_unfreeze;
> @@ -1298,14 +1298,6 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
> 
>  	if (lo->lo_offset != info->lo_offset ||
>  	    lo->lo_sizelimit != info->lo_sizelimit) {
> -		/* kill_bdev should have truncated all the pages */
> -		if (lo->lo_device->bd_inode->i_mapping->nrpages) {
> -			err = -EAGAIN;
> -			pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
> -				__func__, lo->lo_number, lo->lo_file_name,
> -				lo->lo_device->bd_inode->i_mapping->nrpages);
> -			goto out_unfreeze;
> -		}
>  		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit)) {
>  			err = -EFBIG;
>  			goto out_unfreeze;
> @@ -1531,39 +1523,26 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
> 
>  static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
>  {
> -	int err = 0;
> -
>  	if (lo->lo_state != Lo_bound)
>  		return -ENXIO;
> 
>  	if (arg < 512 || arg > PAGE_SIZE || !is_power_of_2(arg))
>  		return -EINVAL;
> 
> +	blk_mq_freeze_queue(lo->lo_queue);
> +
>  	if (lo->lo_queue->limits.logical_block_size != arg) {
>  		sync_blockdev(lo->lo_device);
>  		kill_bdev(lo->lo_device);
>  	}
> -
> -	blk_mq_freeze_queue(lo->lo_queue);
> -
> -	/* kill_bdev should have truncated all the pages */
> -	if (lo->lo_queue->limits.logical_block_size != arg &&
> -			lo->lo_device->bd_inode->i_mapping->nrpages) {
> -		err = -EAGAIN;
> -		pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
> -			__func__, lo->lo_number, lo->lo_file_name,
> -			lo->lo_device->bd_inode->i_mapping->nrpages);
> -		goto out_unfreeze;
> -	}
> -
>  	blk_queue_logical_block_size(lo->lo_queue, arg);
>  	blk_queue_physical_block_size(lo->lo_queue, arg);
>  	blk_queue_io_min(lo->lo_queue, arg);
>  	loop_update_dio(lo);
> -out_unfreeze:
> +
>  	blk_mq_unfreeze_queue(lo->lo_queue);
> 
> -	return err;
> +	return 0;
>  }
> 
>  static int lo_simple_ioctl(struct loop_device *lo, unsigned int cmd,

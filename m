Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ED6261527
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbgIHQpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732008AbgIHQb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:31:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F98A21D92;
        Tue,  8 Sep 2020 12:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599568276;
        bh=CZiGhxtXA6qLf7HwNdEB1B3XnhJP7APKPdY8F1qbYpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PytgGBcNzBvQcddJ00A6bN+BwotDmxlfVaRosJrJkLgJjgAM8FMo3ozkHK3vM7Fip
         o9asVp+tNR8xXb9X4OWFlrEIn36YUNj8RkAuJ/jhEkIIehEteHvhOSanxQ6FyUnbgk
         Mnnoaqp2fmw0mWGX+6WeYPCKdPDtayY1BmSIU+zM=
Date:   Tue, 8 Sep 2020 14:31:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: 5.8 io_uring stable
Message-ID: <20200908123129.GA1960547@kroah.com>
References: <49361215-3d71-71e8-7cd2-1f7009323a30@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49361215-3d71-71e8-7cd2-1f7009323a30@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 03:06:28PM -0600, Jens Axboe wrote:
> Hi,
> 
> Linus just pulled 3 fixes from me - 1+2 should apply directly, here's
> the 3rd one which will need some love for 5.8-stable. I'm including it
> below to preempt the failed to apply message :-)
> 
> 
> commit fb8d4046d50f77a26570101e5b8a7a026320a610
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Sep 2 10:19:04 2020 -0600
> 
>     io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file
>     
>     Actually two things that need fixing up here:
>     
>     - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
>       regular files, so don't ever attempt to do that on other types of
>       files.
>     
>     - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
>       it. It should just complete with -EAGAIN.
>     
>     Cc: stable@vger.kernel.org
>     Reported-by: Norman Maurer <norman.maurer@googlemail.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 82e15020d9a8..96be21ace79a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2726,6 +2726,12 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>  				ret = ret2;
>  				goto done;
>  			}
> +			/* no retry on NONBLOCK marked file */
> +			if (req->file->f_flags & O_NONBLOCK) {
> +				ret = ret2;
> +				goto done;
> +			}
> +
>  			/* some cases will consume bytes even on error returns */
>  			iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>  			ret2 = 0;
> @@ -2869,9 +2875,15 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
>  		 */
>  		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
>  			ret2 = -EAGAIN;
> +		/* no retry on NONBLOCK marked file */
> +		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
> +			ret = 0;
> +			goto done;
> +		}
>  		if (!force_nonblock || ret2 != -EAGAIN) {
>  			if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
>  				goto copy_iov;
> +done:
>  			kiocb_done(kiocb, ret2);
>  		} else {
>  copy_iov:
> 
> -- 
> Jens Axboe


Thanks for the backport, but this didn't apply at all to the 5.8.y tree.
What one did you make it against?

thanks,

greg k-h

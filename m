Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E83CB595
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 10:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbfJDIAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 04:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJDIAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 04:00:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D286222C9;
        Fri,  4 Oct 2019 08:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570176007;
        bh=uchkqfromS4CxmxAeEq9cziG2byREh/+BGOSA1jaQWs=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=2ftjWVpKz2XTDjgkiLOAHaXI2Htfsv+DE1VTeC0zmZRhEXlTml+njmZSkqgvY5niV
         3WOgN15c6KzL+BDCEsLjzQGBdkXfFD/s1LFhotDNPlzma+D7B1iylhL87xffgfukDt
         yBr0+mEXBYRBKyGh2qXX99QGETZo5DBDPIsz0SpY=
Date:   Fri, 4 Oct 2019 10:00:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+af05535bb79520f95431@syzkaller.appspotmail.com,
        syzbot+d86c4426a01f60feddc7@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 209/211] fuse: fix deadlock with aio poll and
 fuse_iqueue::waitq.lock
Message-ID: <20191004080005.GD10406@kroah.com>
References: <20191003154447.010950442@linuxfoundation.org>
 <20191003154530.645657617@linuxfoundation.org>
 <20191003194838.GA6620@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003194838.GA6620@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 12:48:39PM -0700, Eric Biggers wrote:
> On Thu, Oct 03, 2019 at 05:54:35PM +0200, Greg Kroah-Hartman wrote:
> >  
> >  static void queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
> >  {
> > -	spin_lock(&fiq->waitq.lock);
> > +	spin_lock(&fiq->lock);
> >  	if (test_bit(FR_FINISHED, &req->flags)) {
> > -		spin_unlock(&fiq->waitq.lock);
> > +		spin_unlock(&fiq->lock);
> >  		return;
> >  	}
> >  	if (list_empty(&req->intr_entry)) {
> >  		list_add_tail(&req->intr_entry, &fiq->interrupts);
> >  		wake_up_locked(&fiq->waitq);
> >  	}
> > -	spin_unlock(&fiq->waitq.lock);
> > +	spin_unlock(&fiq->lock);
> >  	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
> >  }
> 
> This isn't backported correctly.  wake_up_locked() needs to be changed to wake_up().
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index c0d59a86ada2e..6d39143cfa094 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -434,7 +434,7 @@ static void queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
>  	}
>  	if (list_empty(&req->intr_entry)) {
>  		list_add_tail(&req->intr_entry, &fiq->interrupts);
> -		wake_up_locked(&fiq->waitq);
> +		wake_up(&fiq->waitq);
>  	}
>  	spin_unlock(&fiq->lock);
>  	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);

Thanks for the update and for looking at this.  Now added to the
original patch and pushed out as part of a -rc3.

thanks,

greg k-h

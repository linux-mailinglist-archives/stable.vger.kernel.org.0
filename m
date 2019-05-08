Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9217963
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 14:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfEHMY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 08:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfEHMY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 08:24:26 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEAA021479;
        Wed,  8 May 2019 12:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557318265;
        bh=Zdk82H5gLZG6N4Ke8D6gtSQWOYRKyl+i+my5uTDvPkY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NPLLyKCstxxzVF30bqlo0UJ7W2M6zkKBgrR8JkIJUQTFJNk/igGlTI+hFLbgXEomh
         jcJLrLJT2f8LQ580P3GvxYD/i81OMDVZiSVtRFugWIXvTyGO2T7z/KygTDzQRfyqMU
         yS4fx77CAeKhGLO7We++w6DrCw7L6G5EgXJhxGmc=
Message-ID: <84addb90fc41372ad723d469a00bbb4cce2c9c55.camel@kernel.org>
Subject: Re: [PATCH 1/2] NFSv4.1: Again fix a race where CB_NOTIFY_LOCK
 fails to wake a waiter
From:   Jeff Layton <jlayton@kernel.org>
To:     Yihao Wu <wuyihao@linux.alibaba.com>, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc:     stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        caspar@linux.alibaba.com
Date:   Wed, 08 May 2019 08:24:23 -0400
In-Reply-To: <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
References: <d0b6fc01-0a73-e4f7-b393-3ecc9aacffb0@linux.alibaba.com>
         <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1 (3.32.1-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-05-08 at 17:13 +0800, Yihao Wu wrote:
> Commit b7dbcc0e433f ""NFSv4.1: Fix a race where CB_NOTIFY_LOCK fails
> to wake a waiter" found this bug. However it didn't fix it. This can
> be fixed by adding memory barrier pair.
> 
> Specifically, if any CB_NOTIFY_LOCK should be handled between unlocking
> the wait queue and freezable_schedule_timeout, only two cases are
> possible. So CB_NOTIFY_LOCK will not be dropped unexpectly.
> 
> 1. The callback thread marks the NFS client as waked. Then NFS client
> noticed that itself is waked, so it don't goes to sleep. And it cleans
> its wake mark.
> 
> 2. The NFS client noticed that itself is not waked yet, so it goes to
> sleep. No modification will ever happen to the wake mark in between.
> 

It's not clear to me what you mean by "wake mark" here. Do you mean the
"notified" flag? This could use a better description.

> Fixes: a1d617d ("nfs: allow blocking locks to be awoken by lock callbacks")
> Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
> ---
>  fs/nfs/nfs4proc.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 741ff8c..f13ea09 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -6867,7 +6867,6 @@ struct nfs4_lock_waiter {
>  	struct task_struct	*task;
>  	struct inode		*inode;
>  	struct nfs_lowner	*owner;
> -	bool			notified;
>  };
>  
>  static int
> @@ -6889,13 +6888,13 @@ struct nfs4_lock_waiter {
>  		/* Make sure it's for the right inode */
>  		if (nfs_compare_fh(NFS_FH(waiter->inode), &cbnl->cbnl_fh))
>  			return 0;
> -
> -		waiter->notified = true;
>  	}
>  
>  	/* override "private" so we can use default_wake_function */
>  	wait->private = waiter->task;
> -	ret = autoremove_wake_function(wait, mode, flags, key);
> +	ret = woken_wake_function(wait, mode, flags, key);
> +	if (ret)
> +		list_del_init(&wait->entry);
>  	wait->private = waiter;
>  	return ret;
>  }
> @@ -6914,8 +6913,7 @@ struct nfs4_lock_waiter {
>  				    .s_dev = server->s_dev };
>  	struct nfs4_lock_waiter waiter = { .task  = current,
>  					   .inode = state->inode,
> -					   .owner = &owner,
> -					   .notified = false };
> +					   .owner = &owner};
>  	wait_queue_entry_t wait;
>  
>  	/* Don't bother with waitqueue if we don't expect a callback */
> @@ -6928,21 +6926,12 @@ struct nfs4_lock_waiter {
>  	add_wait_queue(q, &wait);
>  
>  	while(!signalled()) {
> -		waiter.notified = false;
>  		status = nfs4_proc_setlk(state, cmd, request);
>  		if ((status != -EAGAIN) || IS_SETLK(cmd))
>  			break;
>  
>  		status = -ERESTARTSYS;
> -		spin_lock_irqsave(&q->lock, flags);
> -		if (waiter.notified) {
> -			spin_unlock_irqrestore(&q->lock, flags);
> -			continue;
> -		}
> -		set_current_state(TASK_INTERRUPTIBLE);
> -		spin_unlock_irqrestore(&q->lock, flags);
> -
> -		freezable_schedule_timeout(NFS4_LOCK_MAXTIMEOUT);
> +		wait_woken(&wait, TASK_INTERRUPTIBLE, NFS4_LOCK_MAXTIMEOUT);

This seems to have dropped the "freezable" part above, such that waiting
on a file lock will prevent (e.g.) a laptop from suspending. I think
that needs to be in here as those waits can be quite long.

>  	}
>  
>  	finish_wait(q, &wait);

-- 
Jeff Layton <jlayton@kernel.org>


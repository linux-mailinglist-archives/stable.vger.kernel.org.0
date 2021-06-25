Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCD33B479B
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 18:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhFYQ5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 12:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhFYQ5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 12:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F206193F;
        Fri, 25 Jun 2021 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624640086;
        bh=sEkPgxqfk0VrpshYLRmOVtcvJwj/6++q9U6NcXl8Xug=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VGzSbCsBsKJxTZsiJ6Ug20dJFEb5OndynFvYA0troZL60sa7Uh8DxWK8wYz4roeEK
         xnW0cQL4YRDaA0va9cJza66CI/kCFHAfhl5cB4eWh7nhi04GCUjSms7/i4mVQULNYH
         FY/xxZvBUaHVGF3FW1U/fSjaeHrLnc0j2AVjkts5lmTetTmqRXUkcPPjr/v/5Fxrmo
         ag9fHA44Oy7i2f7QwXjHxjUDqwVsJ9rVT8mPGBGlfExQAkD1i4MxaDEc1dYFffHdNu
         wbeSMWQz7gp3EvoJ9frBoEfV2WJEjhDNDxckg1HU9wRocr2HSxBQP7HM+peFxVE75+
         j8XB3NCviidLw==
Message-ID: <e427c4e5877e0b036c36eedbe40020047b02a85b.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: reduce contention in ceph_check_delayed_caps()
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Fri, 25 Jun 2021 12:54:44 -0400
In-Reply-To: <20210625154559.8148-1-lhenriques@suse.de>
References: <20210625154559.8148-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-06-25 at 16:45 +0100, Luis Henriques wrote:
> Function ceph_check_delayed_caps() is called from the mdsc->delayed_work
> workqueue and it can be kept looping for quite some time if caps keep being
> added back to the mdsc->cap_delay_list.  This may result in the watchdog
> tainting the kernel with the softlockup flag.
> 
> This patch re-arranges the loop through the caps list so that it initially
> removes all the caps from list, adding them to a temporary list.  And then, with
> less locking contention, it will eventually call the ceph_check_caps() for each
> inode.  Any caps added to the list in the meantime will be handled in the next
> run.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Hi Jeff!
> 
> So, I've not based this patch on top of your patchset that gets rid of
> ceph_async_iput() so that it will make it easier to backport it for stable
> kernels.  Of course I'm not 100% this classifies as stable material.
> 
> Other than that, I've been testing this patch and I couldn't see anything
> breaking.  Let me know what you think.
> 
> (I *think* I've seen a tracker bug for this in the past but I couldn't
> find it.  I guess it could be added as a 'Link:' tag.)
> 
> Cheers,
> --
> Luis
> 
>  fs/ceph/caps.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index a5e93b185515..727e41e3b939 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4229,6 +4229,7 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>  {
>  	struct inode *inode;
>  	struct ceph_inode_info *ci;
> +	LIST_HEAD(caps_list);
>  
>  	dout("check_delayed_caps\n");
>  	spin_lock(&mdsc->cap_delay_lock);
> @@ -4239,19 +4240,23 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>  		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
>  		    time_before(jiffies, ci->i_hold_caps_max))
>  			break;
> -		list_del_init(&ci->i_cap_delay_list);
> +		list_move_tail(&ci->i_cap_delay_list, &caps_list);
> +	}
> +	spin_unlock(&mdsc->cap_delay_lock);
>  
> +	while (!list_empty(&caps_list)) {
> +		ci = list_first_entry(&caps_list,
> +				      struct ceph_inode_info,
> +				      i_cap_delay_list);
> +		list_del_init(&ci->i_cap_delay_list);
>  		inode = igrab(&ci->vfs_inode);
>  		if (inode) {
> -			spin_unlock(&mdsc->cap_delay_lock);
>  			dout("check_delayed_caps on %p\n", inode);
>  			ceph_check_caps(ci, 0, NULL);
>  			/* avoid calling iput_final() in tick thread */
>  			ceph_async_iput(inode);
> -			spin_lock(&mdsc->cap_delay_lock);
>  		}
>  	}
> -	spin_unlock(&mdsc->cap_delay_lock);
>  }
>  
>  /*

I'm not sure this approach is viable, unfortunately. Once you've dropped
the cap_delay_lock, then nothing protects the i_cap_delay_list head
anymore.

So you could detach these objects and put them on the private list, and
then once you drop the spinlock another task could find one of them and
(e.g.) call __cap_delay_requeue on it, potentially corrupting your list.

I think we'll need to come up with a different way to do this...
-- 
Jeff Layton <jlayton@kernel.org>


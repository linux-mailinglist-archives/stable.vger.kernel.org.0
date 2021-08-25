Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF8B3F73A7
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 12:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbhHYKvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 06:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231995AbhHYKvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Aug 2021 06:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BCEA610D0;
        Wed, 25 Aug 2021 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629888616;
        bh=Z7mNY7J3mXqU+a89BwN+OKfKy3vTeMVmVhFdECcHp30=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i6LllugT/6m/E+ry2kvUGqq0xCvEBE9BhIy9uth9cKMShcTcE+gAL0lHYg/ssX7je
         cBNfft/MHxFkOq4oL06MSViFNsw7ADeiuBYmxaDx4XwrEHaWLWJiZNeIlCLwg7csq1
         5wQruN0qxH0kGcNVq3GsTPuFt6grmoFMZhqPGdXWvgreI8del0uJ5VZ7ZhP14AKRCX
         SVlxe/j4BzERRXWjd/Q8RBxSPWKmC04uZtwVuIO0ZZGhgdTEnnk8Co87yVo2sYW09k
         zOOoMJPvn4EMC07JUD5/V/j/NwubkxtQn6ru/BpjMnHMue1ZuHr4uzL/Q967hSGtw7
         rBJ6++GIB4FHQ==
Message-ID: <da7fe11c497e61573434591fe1dc07424eca0399.camel@kernel.org>
Subject: Re: [PATCH] ceph: init the i_list/g_list for cap flush
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, stable@vger.kernel.org
Date:   Wed, 25 Aug 2021 06:50:14 -0400
In-Reply-To: <20210825052212.19625-1-xiubli@redhat.com>
References: <20210825052212.19625-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-08-25 at 13:22 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Always init the i_list/g_list in the begining to make sure it won't
> crash the kernel if someone want to delete the cap_flush from the
> lists.
> 
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/52401
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 2 +-
>  fs/ceph/snap.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 4f0dbc640b0b..60f60260cf42 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3666,7 +3666,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>  	while (!list_empty(&to_remove)) {
>  		cf = list_first_entry(&to_remove,
>  				      struct ceph_cap_flush, i_list);
> -		list_del(&cf->i_list);
> +		list_del_init(&cf->i_list);
>  		if (!cf->is_capsnap)
>  			ceph_free_cap_flush(cf);
>  	}
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 62fab59bbf96..b41e6724c591 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -488,6 +488,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>  		return;
>  	}
>  	capsnap->cap_flush.is_capsnap = true;
> +	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
> +	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
>  
>  	spin_lock(&ci->i_ceph_lock);
>  	used = __ceph_caps_used(ci);

I'm not certain the second hunk is strictly needed. These either end up
on the list or they just get freed. That said, they shouldn't hurt
anything and it is more consistent. Merged into testing.

Ilya, since this is marked for stable, this probably ought to go to
Linus in the last v5.14 pile.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>


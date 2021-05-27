Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8310392B70
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 12:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhE0KKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 06:10:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235913AbhE0KKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 06:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622110129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttq7axdVYLD81r74CE3D8qHE56GrIu6ITcvhMbY6oeE=;
        b=SBaiRPU3YlSNTldHPuDsgnpT/85YYUpRwH7XfY7zjiPJx4Q4Jjdg9RpwhXeNX3qWM5drgy
        4ZszEfhyEZXULh5b+cu2xKJ06SGdqBrb9m3CYlUqJ13YLJsbT6eNSoAEEOHg+0rGl0iboB
        k1+Xp+p6vnkJvvQgmQSwgz547eteOk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-uKPL4hILOpORFmZcbPfMoQ-1; Thu, 27 May 2021 06:08:47 -0400
X-MC-Unique: uKPL4hILOpORFmZcbPfMoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F2D2108BD1D;
        Thu, 27 May 2021 10:08:45 +0000 (UTC)
Received: from dresden.str.redhat.com (ovpn-114-232.ams2.redhat.com [10.36.114.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CA085F90E;
        Thu, 27 May 2021 10:08:43 +0000 (UTC)
Subject: Re: [Virtio-fs] [PATCH 2/4] fuse: Fix infinite loop in sget_fc()
To:     Greg Kurz <groug@kaod.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
References: <20210525150230.157586-1-groug@kaod.org>
 <20210525150230.157586-3-groug@kaod.org>
From:   Max Reitz <mreitz@redhat.com>
Message-ID: <58c70352-2df5-0cb9-9ca6-bb4bf2edd1c2@redhat.com>
Date:   Thu, 27 May 2021 12:08:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210525150230.157586-3-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.05.21 17:02, Greg Kurz wrote:
> We don't set the SB_BORN flag on submounts. This is wrong as these
> superblocks are then considered as partially constructed or dying
> in the rest of the code and can break some assumptions.
> 
> One such case is when you have a virtiofs filesystem with submounts
> and you try to mount it again : virtio_fs_get_tree() tries to obtain
> a superblock with sget_fc(). The logic in sget_fc() is to loop until
> it has either found an existing matching superblock with SB_BORN set
> or to create a brand new one. It is assumed that a superblock without
> SB_BORN is transient and should go away. Forgetting to set SB_BORN on
> submounts hence causes sget_fc() to retry forever.
> 
> Setting SB_BORN requires special care, i.e. a write barrier for
> super_cache_count() which can check SB_BORN without taking any lock.
> We should call vfs_get_tree() to deal with that but this requires
> to have a proper ->get_tree() implementation for submounts, which
> is a bigger piece of work. Go for a simple bug fix in the meatime.
> 
> Fixes: bf109c64040f ("fuse: implement crossmounts")
> Cc: mreitz@redhat.com
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 01559061cbfb..3b0482738741 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -346,6 +346,16 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
>   		goto out_put_sb;
>   	}
>   
> +	/*
> +	 * FIXME: setting SB_BORN requires a write barrier for
> +	 *        super_cache_count(). We should actually come
> +	 *        up with a proper ->get_tree() implementation
> +	 *        for submounts and call vfs_get_tree() to take
> +	 *        care of the write barrier.
> +	 */
> +	smp_wmb();
> +	sb->s_flags |= SB_BORN;
> +

I’m not sure whether we should have the order be exactly the same as in 
vfs_get_tree(), i.e. whether this should be put after fsc->root has been 
set.  Or maybe even after fm has been added to fc->mounts, because that 
too was part of the fuse_get_tree_submount() function of your “fuse: 
Call vfs_get_tree() for submounts” patch.

 From a quick look at SB_BORN users, it doesn’t seem to make a 
difference to me, though, so:

Reviewed-by: Max Reitz <mreitz@redhat.com>

>   	sb->s_flags |= SB_ACTIVE;
>   	fsc->root = dget(sb->s_root);
>   	/* We are done configuring the superblock, so unlock it */
> 


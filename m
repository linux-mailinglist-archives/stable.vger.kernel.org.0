Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543C43519B3
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhDAR4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:56:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237196AbhDARvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 13:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXWPtffsDMR9QZWl6Ce2ebcQcVpDYm8f+5vNo4wn+Z8=;
        b=caVGPMXDmYWuYM5hSrjUji+pXrwlKnH4igvZkHl+5eIrK9ssMsj+vKzljhC57Rw98JwsFQ
        d28XfwRcJUs7Cxyvnl2ijoFJp3Q7r/5Ul0T0gUUY3Y9MCOXILSHwN9j3lsEaQaoSl2EM4P
        unug7Ssq+iN4p9eqODI5jExC+FwJhzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-QwU6G8GQPR-20xv5hW3C5w-1; Thu, 01 Apr 2021 12:50:28 -0400
X-MC-Unique: QwU6G8GQPR-20xv5hW3C5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7070187A826;
        Thu,  1 Apr 2021 16:50:27 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-97.rdu2.redhat.com [10.10.113.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C30F85D6D1;
        Thu,  1 Apr 2021 16:50:25 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 683EA22054F; Thu,  1 Apr 2021 12:50:24 -0400 (EDT)
Date:   Thu, 1 Apr 2021 12:50:24 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v1] ovl: Fix leaked dentry
Message-ID: <20210401165024.GB801967@redhat.com>
References: <20210329164907.2133175-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210329164907.2133175-1-mic@digikod.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 06:49:07PM +0200, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Since commit 6815f479ca90 ("ovl: use only uppermetacopy state in
> ovl_lookup()"), overlayfs doesn't put temporary dentry when there is a
> metacopy error, which leads to dentry leaks when shutting down the
> related superblock:
> 
>   overlayfs: refusing to follow metacopy origin for (/file0)
>   ...
>   BUG: Dentry (____ptrval____){i=3f33,n=file3}  still in use (1) [unmount of overlay overlay]
>   ...
>   WARNING: CPU: 1 PID: 432 at umount_check.cold+0x107/0x14d
>   CPU: 1 PID: 432 Comm: unmount-overlay Not tainted 5.12.0-rc5 #1
>   ...
>   RIP: 0010:umount_check.cold+0x107/0x14d
>   ...
>   Call Trace:
>    d_walk+0x28c/0x950
>    ? dentry_lru_isolate+0x2b0/0x2b0
>    ? __kasan_slab_free+0x12/0x20
>    do_one_tree+0x33/0x60
>    shrink_dcache_for_umount+0x78/0x1d0
>    generic_shutdown_super+0x70/0x440
>    kill_anon_super+0x3e/0x70
>    deactivate_locked_super+0xc4/0x160
>    deactivate_super+0xfa/0x140
>    cleanup_mnt+0x22e/0x370
>    __cleanup_mnt+0x1a/0x30
>    task_work_run+0x139/0x210
>    do_exit+0xb0c/0x2820
>    ? __kasan_check_read+0x1d/0x30
>    ? find_held_lock+0x35/0x160
>    ? lock_release+0x1b6/0x660
>    ? mm_update_next_owner+0xa20/0xa20
>    ? reacquire_held_locks+0x3f0/0x3f0
>    ? __sanitizer_cov_trace_const_cmp4+0x22/0x30
>    do_group_exit+0x135/0x380
>    __do_sys_exit_group.isra.0+0x20/0x20
>    __x64_sys_exit_group+0x3c/0x50
>    do_syscall_64+0x45/0x70
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   ...
>   VFS: Busy inodes after unmount of overlay. Self-destruct in 5 seconds.  Have a nice day...
> 
> This fix has been tested with a syzkaller reproducer.
> 

Looks good to me. I realized that dentry leak will happen on underlying
filesystem so unmount of underlying filesystem will give this warning. I
created nested overlayfs configuration and could reproduce this error
and tested that this patch fixes it.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.7+
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 6815f479ca90 ("ovl: use only uppermetacopy state in ovl_lookup()")
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> Link: https://lore.kernel.org/r/20210329164907.2133175-1-mic@digikod.net
> ---
>  fs/overlayfs/namei.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 3fe05fb5d145..424c594afd79 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -921,6 +921,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		if ((uppermetacopy || d.metacopy) && !ofs->config.metacopy) {
>  			err = -EPERM;
>  			pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n", dentry);
> +			dput(this);
>  			goto out_put;
>  		}
>  
> 
> base-commit: a5e13c6df0e41702d2b2c77c8ad41677ebb065b3
> -- 
> 2.30.2
> 


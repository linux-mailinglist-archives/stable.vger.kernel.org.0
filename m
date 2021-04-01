Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3195351AEE
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbhDASDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 14:03:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237524AbhDASAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 14:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617300016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZ5o8xyhoYGjZMwbZbuoSG15PY6aGXxwCTwzusxwEpc=;
        b=QGxIDx0wO+uOYhYaGHD1ebbtraUSs30PE3EzB+JeubT4+AxrqqiTzBvRuBhsLupMlbuxHm
        oUHVJhZX71h+dKDyno7Ot2/FI+EYbdXRixh6mU4QbocMk9HvWIkwBTadJy77WL19bUPjea
        2fu4PIQRC1j/uyXpmQKZM42PGxIU5Zw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-YVQssqzYNSmnqpfwZ9mZUA-1; Thu, 01 Apr 2021 11:58:19 -0400
X-MC-Unique: YVQssqzYNSmnqpfwZ9mZUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5909C1966324;
        Thu,  1 Apr 2021 15:58:15 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-97.rdu2.redhat.com [10.10.113.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4687B5DDAD;
        Thu,  1 Apr 2021 15:58:14 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id D9BD222054F; Thu,  1 Apr 2021 11:58:13 -0400 (EDT)
Date:   Thu, 1 Apr 2021 11:58:13 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v1] ovl: Fix leaked dentry
Message-ID: <20210401155813.GA801967@redhat.com>
References: <20210329164907.2133175-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210329164907.2133175-1-mic@digikod.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Hi,

Thanks for finding and fixing this bug. Patch looks correct to me. We
need to drop that reference to this.

I am not able to trigger this warning on umount of overlayfs. I copied
up a file with metacopy enabled and then remounted overlay again with
metacopy disabled. That does hit this code and I see the warning.

refusing to follow metacopy origin for (/foo.txt)

This should have lead to leak of dentry pointed by "this".

But after that I unmounted, overlay and that succeeds. Is there any
additional step to be done to trigger this VFS warning.

Vivek

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


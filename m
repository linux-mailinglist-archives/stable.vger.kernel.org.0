Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8855434E4A0
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 11:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhC3JnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 05:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhC3JnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 05:43:01 -0400
Received: from smtp-190e.mail.infomaniak.ch (smtp-190e.mail.infomaniak.ch [IPv6:2001:1600:4:17::190e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C38C061574;
        Tue, 30 Mar 2021 02:43:01 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4F8kyW6mfzzMpvrk;
        Tue, 30 Mar 2021 11:42:59 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4F8kyV6y72zlh8TT;
        Tue, 30 Mar 2021 11:42:58 +0200 (CEST)
Subject: Re: [PATCH v1] ovl: Fix leaked dentry
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20210329164907.2133175-1-mic@digikod.net>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <bfcd9935-f51d-a94e-2827-373ec0962e70@digikod.net>
Date:   Tue, 30 Mar 2021 11:44:00 +0200
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <20210329164907.2133175-1-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/03/2021 18:49, Mickaël Salaün wrote:
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
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.7+

The bogus commit 6815f479ca90 was applied on v5.7-rc2 but it is only
available since v5.8+ .

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
> 

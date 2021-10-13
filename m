Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867EB42BA7D
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhJMIfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:35:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23374 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhJMIfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 04:35:13 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HTlzs0z6Rzbcvw;
        Wed, 13 Oct 2021 16:28:41 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 16:33:06 +0800
Received: from [10.174.176.52] (10.174.176.52) by
 kwepemm600015.china.huawei.com (7.193.23.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 16:33:05 +0800
Subject: Re: [PATCH linux-4.19.y] VFS: Fix fuseblk memory leak caused by mount
 concurrency
To:     <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dhowells@redhat.com>, <yukuai3@huawei.com>, <yi.zhang@huawei.com>
References: <20211013040132.502406-1-chenxiaosong2@huawei.com>
From:   "chenxiaosong (A)" <chenxiaosong2@huawei.com>
Message-ID: <424000b0-aac0-65ff-6833-b4942092546a@huawei.com>
Date:   Wed, 13 Oct 2021 16:33:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20211013040132.502406-1-chenxiaosong2@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.52]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600015.china.huawei.com (7.193.23.52)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please ignore this patch.

ÔÚ 2021/10/13 12:01, ChenXiaoSong Ð´µÀ:
> If two processes mount same superblock, memory leak occurs:
> 
> CPU0               |  CPU1
> do_new_mount       |  do_new_mount
>    fs_set_subtype   |    fs_set_subtype
>      kstrdup        |
>                     |      kstrdup
>      memrory leak   |
> 
> Fix this by moving fs_set_subtype to mount_fs before up_write(&sb->s_umount).
> 
> Linus's tree already have refactoring patchset [1], one of them can fix this bug:
> 	c30da2e981a7 (fuse: convert to use the new mount API)
> 
> Since we did not merge the refactoring patchset in this branch, I create this patch.
> 
> [1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/
> 
> Fixes: 9d412a43c3b2 (vfs: split off vfsmount-related parts of vfs_kern_mount())
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
> ---
>   fs/namespace.c | 26 --------------------------
>   fs/super.c     | 30 ++++++++++++++++++++++++++++++
>   2 files changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 2f3c6a0350a8..556fdd3b6a4e 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2402,29 +2402,6 @@ static int do_move_mount(struct path *path, const char *old_name)
>   	return err;
>   }
>   
> -static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
> -{
> -	int err;
> -	const char *subtype = strchr(fstype, '.');
> -	if (subtype) {
> -		subtype++;
> -		err = -EINVAL;
> -		if (!subtype[0])
> -			goto err;
> -	} else
> -		subtype = "";
> -
> -	mnt->mnt_sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
> -	err = -ENOMEM;
> -	if (!mnt->mnt_sb->s_subtype)
> -		goto err;
> -	return mnt;
> -
> - err:
> -	mntput(mnt);
> -	return ERR_PTR(err);
> -}
> -
>   /*
>    * add a mount into a namespace's mount tree
>    */
> @@ -2490,9 +2467,6 @@ static int do_new_mount(struct path *path, const char *fstype, int sb_flags,
>   		return -ENODEV;
>   
>   	mnt = vfs_kern_mount(type, sb_flags, name, data);
> -	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
> -	    !mnt->mnt_sb->s_subtype)
> -		mnt = fs_set_subtype(mnt, fstype);
>   
>   	put_filesystem(type);
>   	if (IS_ERR(mnt))
> diff --git a/fs/super.c b/fs/super.c
> index 9fb4553c46e6..b181878753bb 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1240,6 +1240,30 @@ struct dentry *mount_single(struct file_system_type *fs_type,
>   }
>   EXPORT_SYMBOL(mount_single);
>   
> +static int fs_set_subtype(struct super_block *sb)
> +{
> +	int err;
> +	const char *fstype = sb->s_type->name;
> +	const char *subtype = strchr(fstype, '.');
> +	if (subtype) {
> +		subtype++;
> +		err = -EINVAL;
> +		if (!subtype[0])
> +			goto err;
> +	} else {
> +		subtype = "";
> +	}
> +
> +	sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
> +	err = -ENOMEM;
> +	if (!sb->s_subtype)
> +		goto err;
> +	return 0;
> +
> +err:
> +	return err;
> +}
> +
>   struct dentry *
>   mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
>   {
> @@ -1289,6 +1313,12 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
>   	WARN((sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
>   		"negative value (%lld)\n", type->name, sb->s_maxbytes);
>   
> +	if ((sb->s_type->fs_flags & FS_HAS_SUBTYPE) && !sb->s_subtype) {
> +		error = fs_set_subtype(sb);
> +		if (error)
> +			goto out_sb;
> +	}
> +
>   	up_write(&sb->s_umount);
>   	free_secdata(secdata);
>   	return root;
> 

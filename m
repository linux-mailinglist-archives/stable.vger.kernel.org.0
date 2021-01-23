Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126E430125E
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 03:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbhAWCqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 21:46:06 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11182 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbhAWCqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 21:46:05 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DN0nQ0059zl7Zc;
        Sat, 23 Jan 2021 10:43:53 +0800 (CST)
Received: from [10.174.176.185] (10.174.176.185) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sat, 23 Jan 2021 10:45:16 +0800
Subject: Re: [PATCH 3/4] ubifs: Update directory size when creating whiteouts
To:     Richard Weinberger <richard@nod.at>,
        <linux-mtd@lists.infradead.org>
CC:     <david@sigma-star.at>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210122212229.17072-1-richard@nod.at>
 <20210122212229.17072-4-richard@nod.at>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <5b51ff9c-8f5e-c348-5195-c0a0bf60b746@huawei.com>
Date:   Sat, 23 Jan 2021 10:45:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210122212229.17072-4-richard@nod.at>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.185]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ÔÚ 2021/1/23 5:22, Richard Weinberger Ð´µÀ:
> Although whiteouts are unlinked files they will get re-linked later,
I just want to make sure, is this where the count is increased?
do_rename -> inc_nlink(whiteout)
> therefore the size of the parent directory needs to be updated too.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9e0a1fff8db5 ("ubifs: Implement RENAME_WHITEOUT")
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   fs/ubifs/dir.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index 8a34e0118ee9..b5d523e5854f 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -361,6 +361,7 @@ static int do_tmpfile(struct inode *dir, struct dentry *dentry,
>   	struct ubifs_budget_req ino_req = { .dirtied_ino = 1 };
>   	struct ubifs_inode *ui, *dir_ui = ubifs_inode(dir);
>   	int err, instantiated = 0;
> +	int sz_change = 0;
>   	struct fscrypt_name nm;
>   
>   	/*
> @@ -411,6 +412,8 @@ static int do_tmpfile(struct inode *dir, struct dentry *dentry,
>   		mark_inode_dirty(inode);
>   		drop_nlink(inode);
>   		*whiteout = inode;
> +		sz_change = CALC_DENT_SIZE(fname_len(&nm));
> +		dir->i_size += sz_change;
>   	} else {
>   		d_tmpfile(dentry, inode);
>   	}
> @@ -430,6 +433,7 @@ static int do_tmpfile(struct inode *dir, struct dentry *dentry,
>   	return 0;
>   
>   out_cancel:
Does this need a judgment? Like this,
if (whiteout)
     dir->i_size -= sz_change;
> +	dir->i_size -= sz_change;
>   	mutex_unlock(&dir_ui->ui_mutex);
>   out_inode:
>   	make_bad_inode(inode);
> 


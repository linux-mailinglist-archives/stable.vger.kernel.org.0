Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A2D301253
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 03:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbhAWChA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 21:37:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11484 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbhAWCgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 21:36:46 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DN0b06Kblzj9Gr;
        Sat, 23 Jan 2021 10:34:52 +0800 (CST)
Received: from [10.174.176.185] (10.174.176.185) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 23 Jan 2021 10:35:57 +0800
Subject: Re: [PATCH 1/4] ubifs: Correctly set inode size in ubifs_link()
To:     Richard Weinberger <richard@nod.at>,
        <linux-mtd@lists.infradead.org>
CC:     <david@sigma-star.at>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210122212229.17072-1-richard@nod.at>
 <20210122212229.17072-2-richard@nod.at>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <91b23161-db4a-4d64-db30-e42e2eaade1e@huawei.com>
Date:   Sat, 23 Jan 2021 10:35:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210122212229.17072-2-richard@nod.at>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.185]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ÔÚ 2021/1/23 5:22, Richard Weinberger Ð´µÀ:
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index 9a6b8660425a..04912dedca48 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -693,7 +693,7 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
>   	struct inode *inode = d_inode(old_dentry);
>   	struct ubifs_inode *ui = ubifs_inode(inode);
>   	struct ubifs_inode *dir_ui = ubifs_inode(dir);
> -	int err, sz_change = CALC_DENT_SIZE(dentry->d_name.len);
> +	int err, sz_change;
>   	struct ubifs_budget_req req = { .new_dent = 1, .dirtied_ino = 2,
>   				.dirtied_ino_d = ALIGN(ui->data_len, 8) };
>   	struct fscrypt_name nm;
> @@ -731,6 +731,8 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
>   	if (inode->i_nlink == 0)
>   		ubifs_delete_orphan(c, inode->i_ino);
>   
> +	sz_change = CALC_DENT_SIZE(fname_len(&nm));
> +
>   	inc_nlink(inode);
>   	ihold(inode);
>   	inode->i_ctime = current_time(inode);
> 


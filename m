Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1118A2E2355
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 02:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgLXBMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 20:12:38 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9478 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgLXBMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 20:12:38 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D1X8R4f5CzhwlC;
        Thu, 24 Dec 2020 09:11:19 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.498.0; Thu, 24 Dec
 2020 09:11:53 +0800
Subject: Re: [PATCH 5.10 24/40] f2fs: fix to seek incorrect data offset in
 inline data file
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        kitestramuort <kitestramuort@autistici.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20201223150515.553836647@linuxfoundation.org>
 <20201223150516.715040953@linuxfoundation.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <962b2db7-383f-b4da-5221-2004235d19c1@huawei.com>
Date:   Thu, 24 Dec 2020 09:11:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201223150516.715040953@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Thanks a lot for helping to resend and merge the patch. :)

Thanks,

On 2020/12/23 23:33, Greg Kroah-Hartman wrote:
> From: Chao Yu <yuchao0@huawei.com>
> 
> commit 7a6e59d719ef0ec9b3d765cba3ba98ee585cbde3 upstream.
> 
> As kitestramuort reported:
> 
> F2FS-fs (nvme0n1p4): access invalid blkaddr:1598541474
> [   25.725898] ------------[ cut here ]------------
> [   25.725903] WARNING: CPU: 6 PID: 2018 at f2fs_is_valid_blkaddr+0x23a/0x250
> [   25.725923] Call Trace:
> [   25.725927]  ? f2fs_llseek+0x204/0x620
> [   25.725929]  ? ovl_copy_up_data+0x14f/0x200
> [   25.725931]  ? ovl_copy_up_inode+0x174/0x1e0
> [   25.725933]  ? ovl_copy_up_one+0xa22/0xdf0
> [   25.725936]  ? ovl_copy_up_flags+0xa6/0xf0
> [   25.725938]  ? ovl_aio_cleanup_handler+0xd0/0xd0
> [   25.725939]  ? ovl_maybe_copy_up+0x86/0xa0
> [   25.725941]  ? ovl_open+0x22/0x80
> [   25.725943]  ? do_dentry_open+0x136/0x350
> [   25.725945]  ? path_openat+0xb7e/0xf40
> [   25.725947]  ? __check_sticky+0x40/0x40
> [   25.725948]  ? do_filp_open+0x70/0x100
> [   25.725950]  ? __check_sticky+0x40/0x40
> [   25.725951]  ? __check_sticky+0x40/0x40
> [   25.725953]  ? __x64_sys_openat+0x1db/0x2c0
> [   25.725955]  ? do_syscall_64+0x2d/0x40
> [   25.725957]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> llseek() reports invalid block address access, the root cause is if
> file has inline data, f2fs_seek_block() will access inline data regard
> as block address index in inode block, which should be wrong, fix it.
> 
> Reported-by: kitestramuort <kitestramuort@autistici.org>
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>   fs/f2fs/file.c |   11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -412,9 +412,14 @@ static loff_t f2fs_seek_block(struct fil
>   		goto fail;
>   
>   	/* handle inline data case */
> -	if (f2fs_has_inline_data(inode) && whence == SEEK_HOLE) {
> -		data_ofs = isize;
> -		goto found;
> +	if (f2fs_has_inline_data(inode)) {
> +		if (whence == SEEK_HOLE) {
> +			data_ofs = isize;
> +			goto found;
> +		} else if (whence == SEEK_DATA) {
> +			data_ofs = offset;
> +			goto found;
> +		}
>   	}
>   
>   	pgofs = (pgoff_t)(offset >> PAGE_SHIFT);
> 
> 
> .
> 

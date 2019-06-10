Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F323B80A
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 17:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388932AbfFJPIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 11:08:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388848AbfFJPIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 11:08:22 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 308BBF2AA63D8E011BC6;
        Mon, 10 Jun 2019 23:08:19 +0800 (CST)
Received: from [10.151.23.176] (10.151.23.176) by smtp.huawei.com
 (10.3.19.205) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 10 Jun
 2019 23:08:03 +0800
Subject: Re: [PATCH 1/4] staging: erofs: add requirements field in superblock
To:     <stable@vger.kernel.org>
CC:     <xiang@kernel.org>, <miaoxie@huawei.com>
References: <20190610150619.107899-1-gaoxiang25@huawei.com>
From:   Gao Xiang <gaoxiang25@huawei.com>
Message-ID: <7ae923b6-0e8d-44c2-b84f-6e01d6394b48@huawei.com>
Date:   Mon, 10 Jun 2019 23:07:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190610150619.107899-1-gaoxiang25@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.151.23.176]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ sorry...please ignore this email... ]

On 2019/6/10 23:06, Gao Xiang wrote:
> There are some backward incompatible optimizations pending
> for months, mainly due to on-disk format expensions.
> 
> However, we should ensure that it cannot be mounted with
> old kernels. Otherwise, it will causes unexpected behaviors.
> 
> Fixes: ba2b77a82022 ("staging: erofs: add super block operations")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
> ---
>  drivers/staging/erofs/erofs_fs.h | 11 +++++++++--
>  drivers/staging/erofs/super.c    |  8 ++++++++
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
> index fa52898df006..531821757845 100644
> --- a/drivers/staging/erofs/erofs_fs.h
> +++ b/drivers/staging/erofs/erofs_fs.h
> @@ -17,10 +17,16 @@
>  #define EROFS_SUPER_MAGIC_V1    0xE0F5E1E2
>  #define EROFS_SUPER_OFFSET      1024
>  
> +/*
> + * Any bits that aren't in EROFS_ALL_REQUIREMENTS should be
> + * incompatible with this kernel version.
> + */
> +#define EROFS_ALL_REQUIREMENTS  0
> +
>  struct erofs_super_block {
>  /*  0 */__le32 magic;           /* in the little endian */
>  /*  4 */__le32 checksum;        /* crc32c(super_block) */
> -/*  8 */__le32 features;
> +/*  8 */__le32 features;        /* extra features for the image */
>  /* 12 */__u8 blkszbits;         /* support block_size == PAGE_SIZE only */
>  /* 13 */__u8 reserved;
>  
> @@ -34,8 +40,9 @@ struct erofs_super_block {
>  /* 44 */__le32 xattr_blkaddr;
>  /* 48 */__u8 uuid[16];          /* 128-bit uuid for volume */
>  /* 64 */__u8 volume_name[16];   /* volume name */
> +/* 80 */__le32 requirements;    /* all mandatory minimum requirements */
>  
> -/* 80 */__u8 reserved2[48];     /* 128 bytes */
> +/* 84 */__u8 reserved2[44];     /* 128 bytes */
>  } __packed;
>  
>  /*
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index f580d4ef77a1..815e5825db59 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -104,6 +104,14 @@ static int superblock_read(struct super_block *sb)
>  		goto out;
>  	}
>  
> +	/* check if the kernel meets all mandatory requirements */
> +	if (le32_to_cpu(layout->requirements) & (~EROFS_ALL_REQUIREMENTS)) {
> +		errln("too old to meet minimum requirements: %x supported: %x",
> +		      le32_to_cpu(layout->requirements),
> +		      EROFS_ALL_REQUIREMENTS);
> +		goto out;
> +	}
> +
>  	sbi->blocks = le32_to_cpu(layout->blocks);
>  	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
>  #ifdef CONFIG_EROFS_FS_XATTR
> 

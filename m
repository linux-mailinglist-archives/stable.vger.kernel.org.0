Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8062332DF64
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 03:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCECAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 21:00:13 -0500
Received: from mailex.mailcore.me ([94.136.40.143]:60396 "EHLO
        mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhCECAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 21:00:13 -0500
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175] helo=[192.168.178.33])
        by smtp03.mailcore.me with esmtpa (Exim 4.92.3)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1lFjJ4-0004eV-0M; Fri, 26 Feb 2021 20:01:46 +0000
Subject: Re: [PATCH] squashfs: fix inode lookup sanity checks
To:     Sean Nyekjaer <sean@geanix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210226092903.1473545-1-sean@geanix.com>
From:   Phillip Lougher <phillip@squashfs.org.uk>
Message-ID: <d91afd91-0d5e-22dd-3dff-17078184d2be@squashfs.org.uk>
Date:   Fri, 26 Feb 2021 20:01:42 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210226092903.1473545-1-sean@geanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/02/2021 09:29, Sean Nyekjaer wrote:
> When mouting a squashfs image created without inode compression it
> fails with: "unable to read inode lookup table"
> 
> It turns out that the BLOCK_OFFSET is missing when checking
> the SQUASHFS_METADATA_SIZE agaist the actual size.
> 
> Fixes: eabac19e40c0 ("squashfs: add more sanity checks in inode lookup")
> CC: stable@vger.kernel.org
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>

Acked-by: phillip@squashfs.org.uk.

> ---
>   fs/squashfs/export.c      | 8 ++++++--
>   fs/squashfs/squashfs_fs.h | 1 +
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
> index eb02072d28dd..723763746238 100644
> --- a/fs/squashfs/export.c
> +++ b/fs/squashfs/export.c
> @@ -152,14 +152,18 @@ __le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
>   		start = le64_to_cpu(table[n]);
>   		end = le64_to_cpu(table[n + 1]);
>   
> -		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
> +		if (start >= end
> +		    || (end - start) >
> +		    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
>   			kfree(table);
>   			return ERR_PTR(-EINVAL);
>   		}
>   	}
>   
>   	start = le64_to_cpu(table[indexes - 1]);
> -	if (start >= lookup_table_start || (lookup_table_start - start) > SQUASHFS_METADATA_SIZE) {
> +	if (start >= lookup_table_start ||
> +	    (lookup_table_start - start) >
> +	    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
>   		kfree(table);
>   		return ERR_PTR(-EINVAL);
>   	}
> diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
> index 8d64edb80ebf..b3fdc8212c5f 100644
> --- a/fs/squashfs/squashfs_fs.h
> +++ b/fs/squashfs/squashfs_fs.h
> @@ -17,6 +17,7 @@
>   
>   /* size of metadata (inode and directory) blocks */
>   #define SQUASHFS_METADATA_SIZE		8192
> +#define SQUASHFS_BLOCK_OFFSET		2
>   
>   /* default size of block device I/O */
>   #ifdef CONFIG_SQUASHFS_4K_DEVBLK_SIZE
> 


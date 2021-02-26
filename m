Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2273268FD
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 22:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBZUzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 15:55:10 -0500
Received: from outbound-gw.openxchange.ahost.me ([94.136.40.163]:41646 "EHLO
        outbound-gw.openxchange.ahost.me" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhBZUzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 15:55:08 -0500
X-Greylist: delayed 2657 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2021 15:55:08 EST
Received: from localhost ([127.0.0.1] helo=outbound-gw.openxchange.ahost.me)
        by outbound-gw.openxchange.ahost.me with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1lFjQZ-0001DC-Ua; Fri, 26 Feb 2021 20:09:31 +0000
Date:   Fri, 26 Feb 2021 20:09:31 +0000 (GMT)
From:   Phillip Lougher <phillip@squashfs.org.uk>
To:     Sean Nyekjaer <sean@geanix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1911592520.1810343.1614370171896@webmail.123-reg.co.uk>
In-Reply-To: <20210226092903.1473545-1-sean@geanix.com>
References: <20210226092903.1473545-1-sean@geanix.com>
Subject: Re: [PATCH] squashfs: fix inode lookup sanity checks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev30
X-Originating-IP: 82.69.79.175
X-Originating-Client: com.openexchange.ox.gui.dhtml
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On 26/02/2021 09:29 Sean Nyekjaer <sean@geanix.com> wrote:
> 
>  
> When mouting a squashfs image created without inode compression it
> fails with: "unable to read inode lookup table"
> 
> It turns out that the BLOCK_OFFSET is missing when checking
> the SQUASHFS_METADATA_SIZE agaist the actual size.
> 
> Fixes: eabac19e40c0 ("squashfs: add more sanity checks in inode lookup")
> CC: stable@vger.kernel.org
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>

Acked-by: Phillip Lougher <phillip@squashfs.org.uk>

> ---
>  fs/squashfs/export.c      | 8 ++++++--
>  fs/squashfs/squashfs_fs.h | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
> index eb02072d28dd..723763746238 100644
> --- a/fs/squashfs/export.c
> +++ b/fs/squashfs/export.c
> @@ -152,14 +152,18 @@ __le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
>  		start = le64_to_cpu(table[n]);
>  		end = le64_to_cpu(table[n + 1]);
>  
> -		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
> +		if (start >= end
> +		    || (end - start) >
> +		    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
>  			kfree(table);
>  			return ERR_PTR(-EINVAL);
>  		}
>  	}
>  
>  	start = le64_to_cpu(table[indexes - 1]);
> -	if (start >= lookup_table_start || (lookup_table_start - start) > SQUASHFS_METADATA_SIZE) {
> +	if (start >= lookup_table_start ||
> +	    (lookup_table_start - start) >
> +	    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
>  		kfree(table);
>  		return ERR_PTR(-EINVAL);
>  	}
> diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
> index 8d64edb80ebf..b3fdc8212c5f 100644
> --- a/fs/squashfs/squashfs_fs.h
> +++ b/fs/squashfs/squashfs_fs.h
> @@ -17,6 +17,7 @@
>  
>  /* size of metadata (inode and directory) blocks */
>  #define SQUASHFS_METADATA_SIZE		8192
> +#define SQUASHFS_BLOCK_OFFSET		2
>  
>  /* default size of block device I/O */
>  #ifdef CONFIG_SQUASHFS_4K_DEVBLK_SIZE
> -- 
> 2.29.2

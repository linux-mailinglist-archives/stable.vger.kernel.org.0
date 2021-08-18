Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE343EFE2F
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhHRHsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238014AbhHRHsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D43A16108D;
        Wed, 18 Aug 2021 07:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629272856;
        bh=Ww5raaylrzbIqskGneMELsHmUvPMzxgLtlRuOzHWY+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RweAzN/F7Nq4XEXKqPJMerd1nbzrLbdmGutoBUr9bQJbMRNX6n6x6zeFeBvSVbAH0
         rD1Q9gLtTnGkIoorSU1zBB2XsrVT4Kevv9KeBwNLS8pZY2Ql4iXVUHwEqEc+hcAiHT
         m4Mx76GrIV4sRJPGw4FpgOqb5ZCBsVqEPgntFbl8=
Date:   Wed, 18 Aug 2021 09:47:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, stable@vger.kernel.org,
        dhaval.giani@oracle.com, dan.carpenter@oracle.com,
        linux-ext4@vger.kernel.org, riteshh@linux.ibm.com
Subject: Re: [PATCH 5.4.y 0/1] ext4: fix EXT4_MAX_LOGICAL_BLOCK macro
Message-ID: <YRy7FYseom4OC5ry@kroah.com>
References: <1629234731-20065-1-git-send-email-george.kennedy@oracle.com>
 <1629234731-20065-2-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1629234731-20065-2-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 04:12:11PM -0500, George Kennedy wrote:
> From: Ritesh Harjani <riteshh@linux.ibm.com>
> 
> ext4 supports max number of logical blocks in a file to be 0xffffffff.
> (This is since ext4_extent's ee_block is __le32).
> This means that EXT4_MAX_LOGICAL_BLOCK should be 0xfffffffe (starting
> from 0 logical offset). This patch fixes this.
> 
> The issue was seen when ext4 moved to iomap_fiemap API and when
> overlayfs was mounted on top of ext4. Since overlayfs was missing
> filemap_check_ranges(), so it could pass a arbitrary huge length which
> lead to overflow of map.m_len logic.
> 
> This patch fixes that.
> 
> Fixes: d3b6f23f7167 ("ext4: move ext4_fiemap to use iomap framework")
> Reported-by: syzbot+77fa5bdb65cc39711820@syzkaller.appspotmail.com
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/20200505154324.3226743-2-hch@lst.de
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> (cherry picked from commit 175efa81feb8405676e0136d97b10380179c92e0)
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> ---
>  fs/ext4/ext4.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bf3eaa9..ae2cb15 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -718,7 +718,7 @@ enum {
>  #define EXT4_MAX_BLOCK_FILE_PHYS	0xFFFFFFFF
>  
>  /* Max logical block we can support */
> -#define EXT4_MAX_LOGICAL_BLOCK		0xFFFFFFFF
> +#define EXT4_MAX_LOGICAL_BLOCK		0xFFFFFFFE
>  
>  /*
>   * Structure of an inode on the disk
> -- 
> 1.8.3.1
> 

Now queued up, thanks.

greg k-h

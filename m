Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8971D4E4453
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 17:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiCVQjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 12:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbiCVQjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 12:39:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5242E9;
        Tue, 22 Mar 2022 09:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647967093; x=1679503093;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nC2uy4Xiy6nxLZooVE1BSEhtIrAjWOGJKX0aq/EHvdg=;
  b=Sif4+A+Fj2vWbzGHMQ4u7ON4xy9ZhrU6UMCrBD2oP4iDVadnx6GrLCXJ
   OKOkRtbqO9ZDWkxsk7FwYRAQQheGnM+9TqTpwHEM+wJ0pccLDyatYsqND
   y30BaA1a5tQU1p0LCEN4MhNgQ+4FCYQjS0bk5ogH9S8TF2ZpKAqOl2usY
   c+HHMVqDuyfiv5QFfwVS3FoIIQZGqvNoAG7vT32BmW9aU1fltusXKoxtK
   7LJgBDnWryFQKN2bksmghIUxsvyw79D1a3KIvVEW9anWy+zCpxhOpy+z3
   W5OX7Ct0vQ5xz7olOJVlwmnL0dQRV+A54ITJdmSXbJyaGh9ajp+rB+WeZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="282708280"
X-IronPort-AV: E=Sophos;i="5.90,202,1643702400"; 
   d="scan'208";a="282708280"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 09:37:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,202,1643702400"; 
   d="scan'208";a="600943360"
Received: from tsscotth-mobl1.amr.corp.intel.com (HELO localhost) ([10.213.167.42])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 09:37:44 -0700
Date:   Tue, 22 Mar 2022 09:37:43 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ext4: check if offset+length is valid in fallocate
Message-ID: <Yjn7V3whEZ3UmJlF@iweiny-desk3>
References: <20220315215439.269122-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315215439.269122-1-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 02:54:39PM -0700, Tadeusz Struk wrote:
> Syzbot found an issue [1] in ext4_fallocate().
> The C reproducer [2] calls fallocate(), passing size 0xffeffeff000ul,
> and offset 0x1000000ul, which, when added together exceed the disk size,
> and trigger a BUG in ext4_ind_remove_space() [3].
> According to the comment doc in ext4_ind_remove_space() the 'end' block
> parameter needs to be one block after the last block to remove.
> In the case when the BUG is triggered it points to the last block on
> a 4GB virtual disk image. This is calculated in
> ext4_ind_remove_space() in [4].
> This patch adds a check that ensure the length + offest to be
> within the valid range and returns -ENOSPC error code in case
> it is invalid.

Why is the check in vfs_fallocate() not working for this?

https://elixir.bootlin.com/linux/v5.17-rc8/source/fs/open.c#L300

Also why do other file systems not fail?  Is it because ext4 is special due to
the end block needing to be one block after the last.  That seems to imply the
last block can't be used or there is some off by one issue somewhere?

Ira

> 
> LINK: [1] https://syzkaller.appspot.com/bug?id=b80bd9cf348aac724a4f4dff251800106d721331
> LINK: [2] https://syzkaller.appspot.com/text?tag=ReproC&x=14ba0238700000
> LINK: [3] https://elixir.bootlin.com/linux/v5.17-rc8/source/fs/ext4/indirect.c#L1244
> LINK: [4] https://elixir.bootlin.com/linux/v5.17-rc8/source/fs/ext4/indirect.c#L1234
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Ritesh Harjani <riteshh@linux.ibm.com>
> Cc: <linux-ext4@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Fixes: a4bb6b64e39a ("ext4: enable "punch hole" functionality")
> Reported-by: syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> --
> v2: Change sbi->s_blocksize to inode->i_sb->s_blocksize in maxlength
>  computation.
> ---
>  fs/ext4/inode.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 01c9e4f743ba..355384007d11 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3924,7 +3924,8 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  	struct super_block *sb = inode->i_sb;
>  	ext4_lblk_t first_block, stop_block;
>  	struct address_space *mapping = inode->i_mapping;
> -	loff_t first_block_offset, last_block_offset;
> +	loff_t first_block_offset, last_block_offset, max_length;
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	handle_t *handle;
>  	unsigned int credits;
>  	int ret = 0, ret2 = 0;
> @@ -3967,6 +3968,16 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  		   offset;
>  	}
>  
> +	/*
> +	 * For punch hole the length + offset needs to be at least within
> +	 * one block before last
> +	 */
> +	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
> +	if (offset + length >= max_length) {
> +		ret = -ENOSPC;
> +		goto out_mutex;
> +	}
> +
>  	if (offset & (sb->s_blocksize - 1) ||
>  	    (offset + length) & (sb->s_blocksize - 1)) {
>  		/*
> -- 
> 2.35.1
> 

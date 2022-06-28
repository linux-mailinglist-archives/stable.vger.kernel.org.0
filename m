Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F9055D356
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbiF1Hqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 03:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiF1Hqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 03:46:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B828393;
        Tue, 28 Jun 2022 00:46:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EFD3B81D1A;
        Tue, 28 Jun 2022 07:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB16C3411D;
        Tue, 28 Jun 2022 07:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656402394;
        bh=IxHb5Sa8uGIBhk4i91g2SAWF7bvud0Zr0BWDSV74ZO0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Dfp9SRoCENBboDsPPDbzvwsj6X8XtsUzBtWEFVBfwNJW/VkXUWfbgjxhIEGVEhP90
         xXdbRrJSqnxDhQT/24mjLJCO+Qv5JDaO25a+SRlDTRd1qxQWjecqtQY94zTesah4OY
         sP5eD9Nba75z8EH7BbjJl6pykQaAvPKarDQjLBQ0MI1axNxmGuylA2EHOvqjU1o2ed
         FhvESCJ+6yJCwFYgnNuuhY5LQWbypR3hLFhqy4k7/Lf3yK5lRybKfHOn127dHa6EVn
         r4WdJGCGh095JhOTT31ZKhqyrFSlPat8J8+uKRI8c9kTJKfrwFd3F2i0jJ9orERZ0U
         1/rsKHRFgOz7w==
Message-ID: <f3484c66-bb5e-b4d6-fc43-95a73c280f1d@kernel.org>
Date:   Tue, 28 Jun 2022 15:46:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [f2fs-dev] [PATCH 1/3 v2] f2fs: attach inline_data after setting
 compression
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20220617223106.3517374-1-jaegeuk@kernel.org>
 <YrNJBMGpjPdtwVY+@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <YrNJBMGpjPdtwVY+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/23 0:53, Jaegeuk Kim wrote:
> This fixes the below corruption.
> 
> [345393.335389] F2FS-fs (vdb): sanity_check_inode: inode (ino=6d0, mode=33206) should not have inline_data, run fsck to fix
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 677a82b44ebf ("f2fs: fix to do sanity check for inline inode")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>   fs/f2fs/namei.c | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index c549acb52ac4..bf00d5057abb 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -89,8 +89,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>   	if (test_opt(sbi, INLINE_XATTR))
>   		set_inode_flag(inode, FI_INLINE_XATTR);
>   
> -	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
> -		set_inode_flag(inode, FI_INLINE_DATA);
>   	if (f2fs_may_inline_dentry(inode))
>   		set_inode_flag(inode, FI_INLINE_DENTRY);
>   
> @@ -107,10 +105,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>   
>   	f2fs_init_extent_tree(inode, NULL);
>   
> -	stat_inc_inline_xattr(inode);
> -	stat_inc_inline_inode(inode);
> -	stat_inc_inline_dir(inode);
> -
>   	F2FS_I(inode)->i_flags =
>   		f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
>   
> @@ -127,6 +121,14 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
>   			set_compress_context(inode);
>   	}
>   
> +	/* Should enable inline_data after compression set */
> +	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
> +		set_inode_flag(inode, FI_INLINE_DATA);
> +
> +	stat_inc_inline_xattr(inode);
> +	stat_inc_inline_inode(inode);
> +	stat_inc_inline_dir(inode);
> +
>   	f2fs_set_inode_flags(inode);
>   
>   	trace_f2fs_new_inode(inode, 0);
> @@ -325,6 +327,9 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
>   		if (!is_extension_exist(name, ext[i], false))
>   			continue;
>   
> +		/* Do not use inline_data with compression */
> +		stat_dec_inline_inode(inode);
> +		clear_inode_flag(inode, FI_INLINE_DATA);

It looks we don't need to dirty inode if there is no inline_data flag.

Thanks,

>   		set_compress_context(inode);
>   		return;
>   	}

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BC25507C1
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 02:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiFSAf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 20:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiFSAfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 20:35:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21866101F3;
        Sat, 18 Jun 2022 17:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B066060E04;
        Sun, 19 Jun 2022 00:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61531C3411A;
        Sun, 19 Jun 2022 00:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655598923;
        bh=JvhSdmaU8CkX1kionMrJZINyzM9zc4yNPpJWqKS7g2k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eQe20mOTH5uO8hNt8ucEZ04Pr7OO8kSatvZvQVMv5xXhnDC34BaZQm9Ff3o6/mu0r
         OgCJcWw6RwM5R0Chvvp3Y0Pq9sv+ekNMZJyBiA2LSJrv0h7Q8JvoON6pS26K8bPdQm
         UU0X7doUX6lXlPRJ/znUo7tGUsOaR63WKjb7ICN9MAxrUYjagsJ8PpBODkjNMrfZvg
         4AnTIccESlQtlSl+xDn2Fu8E1RYd7oukB1HU5+hA5Ij4PRqbfpVvZU/Lg8DTzkCofe
         fzFv0Uo9WeM5lvvM+s9I9fIOuyEArEByZVor8TlRTqGkVzqJYTkDlEOKwjULqNniuy
         +PZYqUyC22yvg==
Message-ID: <ae324c70-8671-8878-5854-c0910c744379@kernel.org>
Date:   Sun, 19 Jun 2022 08:35:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: attach inline_data after setting
 compression
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20220617223106.3517374-1-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20220617223106.3517374-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/18 6:31, Jaegeuk Kim wrote:
> This fixes the below corruption.
> 
> [345393.335389] F2FS-fs (vdb): sanity_check_inode: inode (ino=6d0, mode=33206) should not have inline_data, run fsck to fix
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 677a82b44ebf ("f2fs: fix to do sanity check for inline inode")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>   fs/f2fs/namei.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index c549acb52ac4..a841abe6a071 100644
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
> @@ -325,6 +327,8 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
>   		if (!is_extension_exist(name, ext[i], false))
>   			continue;
>   
> +		/* Do not use inline_data with compression */
> +		clear_inode_flag(inode, FI_INLINE_DATA);

if (is_inode_set_flag()) {
	clear_inode_flag();
	stat_dec_inline_inode();
}

Thanks,

>   		set_compress_context(inode);
>   		return;
>   	}

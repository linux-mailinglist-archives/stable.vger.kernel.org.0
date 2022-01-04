Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE8F484234
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 14:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiADNSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 08:18:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55048 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiADNSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 08:18:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C12D61426
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 13:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE805C36AE7;
        Tue,  4 Jan 2022 13:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641302292;
        bh=YnMaCUMaN6MFS9SW5hsu5+kjGgZjuaZQH7Uhhs1C3Gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LtIDotKL3VLhomm+82i1sW3l066f/grL3B9XKtLTY0T6yApKTBaRXQpTye4wZ5g5Y
         /F0m/BxlGPQ7xYsM7qzh2E/eoUcLxiHhJDalfvIPmZ5TR+1vxCTXEe2+1a5blzUeh7
         ggARx95Bcyy7aBDcvQ/fdEwB9uV70d70CfVlMuy8=
Date:   Tue, 4 Jan 2022 14:18:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chao Yu <chao@kernel.org>
Cc:     stable@vger.kernel.org, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Yi Zhuang <zhuangyi1@huawei.com>
Subject: Re: [PATCH] f2fs: quota: fix potential deadlock
Message-ID: <YdRJEBhSg8vlD6cP@kroah.com>
References: <20220104130513.3077-1-chao@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104130513.3077-1-chao@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 09:05:13PM +0800, Chao Yu wrote:
> commit a5c0042200b28fff3bde6fa128ddeaef97990f8d upstream.
> 
> As Yi Zhuang reported in bugzilla:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=214299
> 
> There is potential deadlock during quota data flush as below:
> 
> Thread A:			Thread B:
> f2fs_dquot_acquire
> down_read(&sbi->quota_sem)
> 				f2fs_write_checkpoint
> 				block_operations
> 				f2fs_look_all
> 				down_write(&sbi->cp_rwsem)
> f2fs_quota_write
> f2fs_write_begin
> __do_map_lock
> f2fs_lock_op
> down_read(&sbi->cp_rwsem)
> 				__need_flush_qutoa
> 				down_write(&sbi->quota_sem)
> 
> This patch changes block_operations() to use trylock, if it fails,
> it means there is potential quota data updater, in this condition,
> let's flush quota data first and then trylock again to check dirty
> status of quota data.
> 
> The side effect is: in heavy race condition (e.g. multi quota data
> upaters vs quota data flusher), it may decrease the probability of
> synchronizing quota data successfully in checkpoint() due to limited
> retry time of quota flush.
> 
> Fixes: db6ec53b7e03 ("f2fs: add a rw_sem to cover quota flag changes")
> Cc: stable@vger.kernel.org # v5.3+
> Reported-by: Yi Zhuang <zhuangyi1@huawei.com>
> Signed-off-by: Chao Yu <chao@kernel.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/checkpoint.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 83e9bc0f91ff..7b0282724231 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -1162,7 +1162,8 @@ static bool __need_flush_quota(struct f2fs_sb_info *sbi)
>  	if (!is_journalled_quota(sbi))
>  		return false;
>  
> -	down_write(&sbi->quota_sem);
> +	if (!down_write_trylock(&sbi->quota_sem))
> +		return true;
>  	if (is_sbi_flag_set(sbi, SBI_QUOTA_SKIP_FLUSH)) {
>  		ret = false;
>  	} else if (is_sbi_flag_set(sbi, SBI_QUOTA_NEED_REPAIR)) {
> -- 
> 2.32.0
> 

What stable tree(s) is this for?

thanks,

greg k-h

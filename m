Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651165574A7
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 09:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiFWH5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 03:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiFWH5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 03:57:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B5247389;
        Thu, 23 Jun 2022 00:57:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6544B82200;
        Thu, 23 Jun 2022 07:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF56C3411B;
        Thu, 23 Jun 2022 07:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655971062;
        bh=ANhwfxxjIa4IJy2tXFg8crRrfMzdxUvybqtIlxYXVwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r5AREGxzJQcgEIjMRRPm7K6wf+HwUCOn5ip1jxvDeXOZcamO9qg02tG+BjFZ7A2SL
         pMcZ0S0GdZXhtXiKtUSqhKHhy1jKlQtHLjA2bjqfWfKPL+ZMcGYeakJm2SBqhG8UDf
         xnLvtFw7b0GXVSB/MJuwgcIhDsVdb+m7PzpDVfq0=
Date:   Thu, 23 Jun 2022 09:57:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cgel.zte@gmail.com
Cc:     anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn, linux-fsdevel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>,
        syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com,
        Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>
Subject: Re: [PATCH] fs/ntfs: fix BUG_ON of ntfs_read_block()
Message-ID: <YrQc8xq+QezRcLi7@kroah.com>
References: <20220623033635.973929-1-xu.xin16@zte.com.cn>
 <20220623035131.974098-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623035131.974098-1-xu.xin16@zte.com.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 03:51:31AM +0000, cgel.zte@gmail.com wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> As the bug description, attckers can use this bug to crash the system
> When CONFIG_NTFS_FS is set.
> 
> So remove the BUG_ON, and use WARN and return instead until someone
> really solve the bug.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
> Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
> Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
> Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
> Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  fs/ntfs/aops.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index 5f4fb6ca6f2e..b6fd7e711420 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -183,7 +183,11 @@ static int ntfs_read_block(struct page *page)
>  	vol = ni->vol;
>  
>  	/* $MFT/$DATA must have its complete runlist in memory at all times. */
> -	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
> +	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
> +		WARN(1, "NTFS: ni->runlist.rl, ni->mft_no, and NInoAttr(ni) is null!\n");
> +		unlock_page(page);
> +		return -EINVAL;
> +	}
>  
>  	blocksize = vol->sb->s_blocksize;
>  	blocksize_bits = vol->sb->s_blocksize_bits;
> -- 
> 2.25.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E5B55842E
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiFWRkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiFWRiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:38:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A4E27B3A;
        Thu, 23 Jun 2022 10:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0012B82498;
        Thu, 23 Jun 2022 17:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E6AC3411B;
        Thu, 23 Jun 2022 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656004098;
        bh=de72aEPmiWhk8gVfT3liqSSGHCaeRekm8u+9NQohaUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fC2Hq0DsqYZk/Y/la3E9ChzRyhRvqK+C14cG9rRPKOo9XW3VxNyRyY+XJxtAI2J6V
         zjV4944fzCDsPaH9u7MapC0CIl0k8ALlcDcCZwUWPPH6yy/rXPiS/Faknap7CnvLdw
         /nwfIAaUZwX/KMRb4ITCw6xaHcHmliPDGYH4+85FZON/Uq5VpzpOWMfo31/lqA6dy4
         WYZ6nUJkWmHIvwqwYI5CkwPi7p1tW5oYyQoNrKfGSkZL0QE7CPl1Iu1RRVkg/iSVpZ
         QI5mm3aq6RqcpPogcGc9neDOQyjHy81EM6Z52gdIzvtBtZvjPmt4is2FwXCbotvwcl
         8nlpcKIw2sJfQ==
Date:   Thu, 23 Jun 2022 10:08:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
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
Subject: Re: [PATCH v2] fs/ntfs: fix BUG_ON of ntfs_read_block()
Message-ID: <YrSeAGmk4GZndtdn@sol.localdomain>
References: <20220623033635.973929-1-xu.xin16@zte.com.cn>
 <20220623094956.977053-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623094956.977053-1-xu.xin16@zte.com.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 09:49:56AM +0000, cgel.zte@gmail.com wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> As the bug description at
> https://lore.kernel.org/lkml/20220623033635.973929-1-xu.xin16@zte.com.cn/
> attckers can use this bug to crash the system.
> 
> So to avoid panic, remove the BUG_ON, and use ntfs_warning to output a
> warning to the syslog and return instead until someone really solve
> the problem.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
> Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
> Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
> Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
> Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
> 
> Change for v2:
>  - Use ntfs_warning instead of WARN().
>  - Add the tag Cc: stable@vger.kernel.org.
> ---
>  fs/ntfs/aops.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
> index 5f4fb6ca6f2e..84d68efb4ace 100644
> --- a/fs/ntfs/aops.c
> +++ b/fs/ntfs/aops.c
> @@ -183,7 +183,12 @@ static int ntfs_read_block(struct page *page)
>  	vol = ni->vol;
>  
>  	/* $MFT/$DATA must have its complete runlist in memory at all times. */
> -	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
> +	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
> +		ntfs_warning(vi->i_sb, "Error because ni->runlist.rl, ni->mft_no, "
> +				"and NInoAttr(ni) is null.");
> +		unlock_page(page);
> +		return -EINVAL;
> +	}

A better warning message that doesn't rely on implementation details (struct
field and macro names) would be "Runlist of $MFT/$DATA is not cached".  Also,
why does this situation happen in the first place?  Is there a way to prevent
this situation in the first place?

- Eric

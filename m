Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F574EA02F
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344024AbiC1Tuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343855AbiC1TrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:47:10 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F74252A5
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:43:22 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id z14-20020a92d6ce000000b002c993540ee1so3102388ilp.0
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=S4k3FRendpu+TqHI2hR9slC26O3+s2fIlWDvhX0PpD0=;
        b=1XJF2PErDZiXlXWIoXfcyX7YDv33N1i4p3F4LUSFoviYoy2RrvIG+Lx3DcRT57+QSd
         yYrsmOoVAf7TPiEpj/OXt+iz9unRFXH44zmpDFdYJ5e1LP3B7hy+4+1rAam+GWAJG2Xi
         U3/mdUH46Kxu5OakT3fKEI/0RHDGA1UYaEuI7k7qsd6AzVXDJbH+4yiagFtyhhfAbLV9
         H0BkrzJxm0p0+0dM2J3nuh+DX+uLgmoISOFFYSFtHCfn8IiFTI1A+80U3WbNl4sYLRrf
         L7v19xhWOAY2GPyKY0/a0gCFexawKXKIbccmztgRcSbR8agrSDe19pOTRhc2YWcjNK2n
         mW/g==
X-Gm-Message-State: AOAM530v3Urbij96NBH1VARWabLrhdt1JEeLnxiWAg10hBEnMXvba+VD
        2yrkUS1bUYaqk43JjSkNSGej/RJyiQlYgRdsc3CAxO59hRdJ
X-Google-Smtp-Source: ABdhPJzaUVAWAVpOKTbjMUl7VeylhMz1vos0gBsFmlLjxcxJJlntIEn0bDwFu+iMYxx+E5mrH53aWpFoXah1wPRsOkoDWF23uPX0
MIME-Version: 1.0
X-Received: by 2002:a5d:9a0a:0:b0:648:c8a4:c86 with SMTP id
 s10-20020a5d9a0a000000b00648c8a40c86mr7179135iol.168.1648496591670; Mon, 28
 Mar 2022 12:43:11 -0700 (PDT)
Date:   Mon, 28 Mar 2022 12:43:11 -0700
In-Reply-To: <20220328194300.1586178-7-sashal@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c2950d05db4c8516@google.com>
Subject: Re: [PATCH AUTOSEL 5.15 07/16] ext4: don't BUG if someone dirty pages
 without asking ext4 first
From:   syzbot 
        <syzbot+d59332e2db681cf18f0318a06e994ebbb529a8db@syzkaller.appspotmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     adilger.kernel@dilger.ca, lee.jones@linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Theodore Ts'o <tytso@mit.edu>
>
> [ Upstream commit cc5095747edfb054ca2068d01af20be3fcc3634f ]
>
> [un]pin_user_pages_remote is dirtying pages without properly warning
> the file system in advance.  A related race was noted by Jan Kara in
> 2018[1]; however, more recently instead of it being a very hard-to-hit
> race, it could be reliably triggered by process_vm_writev(2) which was
> discovered by Syzbot[2].
>
> This is technically a bug in mm/gup.c, but arguably ext4 is fragile in
> that if some other kernel subsystem dirty pages without properly
> notifying the file system using page_mkwrite(), ext4 will BUG, while
> other file systems will not BUG (although data will still be lost).
>
> So instead of crashing with a BUG, issue a warning (since there may be
> potential data loss) and just mark the page as clean to avoid
> unprivileged denial of service attacks until the problem can be
> properly fixed.  More discussion and background can be found in the
> thread starting at [2].
>
> [1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
> [2] https://lore.kernel.org/r/Yg0m6IjcNmfaSokM@google.com
>
> Reported-by: syzbot+d59332e2db681cf18f0318a06e994ebbb529a8db@syzkaller.appspotmail.com
> Reported-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://lore.kernel.org/r/YiDS9wVfq4mM2jGK@mit.edu
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ext4/inode.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a5140546fb..fff52292c01e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1992,6 +1992,15 @@ static int ext4_writepage(struct page *page,
>  	else
>  		len = PAGE_SIZE;
>  
> +	/* Should never happen but for bugs in other kernel subsystems */
> +	if (!page_has_buffers(page)) {
> +		ext4_warning_inode(inode,
> +		   "page %lu does not have buffers attached", page->index);
> +		ClearPageDirty(page);
> +		unlock_page(page);
> +		return 0;
> +	}
> +
>  	page_bufs = page_buffers(page);
>  	/*
>  	 * We cannot do block allocation or other extent handling in this
> @@ -2595,6 +2604,22 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			wait_on_page_writeback(page);
>  			BUG_ON(PageWriteback(page));
>  
> +			/*
> +			 * Should never happen but for buggy code in
> +			 * other subsystems that call
> +			 * set_page_dirty() without properly warning
> +			 * the file system first.  See [1] for more
> +			 * information.
> +			 *
> +			 * [1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
> +			 */
> +			if (!page_has_buffers(page)) {
> +				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", page->index);
> +				ClearPageDirty(page);
> +				unlock_page(page);
> +				continue;
> +			}
> +
>  			if (mpd->map.m_len == 0)
>  				mpd->first_page = page->index;
>  			mpd->next_page = page->index + 1;
> -- 
> 2.34.1
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.


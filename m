Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47508501289
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345822AbiDNNyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243479AbiDNNp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:56 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C605FE4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 06:43:31 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id v11-20020a056e0213cb00b002cbcd972206so3023480ilj.11
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 06:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=2VrWD7opmJFlL7T6rbv4Z/qjhpNRkx9YT608QCgTBxY=;
        b=3V8LG2XYr0LwINolPdNLlYveEdBw3V4RKhi06uKvqQdlPzas3x6B/Ob+ehYtBIzCGH
         BEl0jNfvnSPoE4LGVDC69CN+VS4u4RGEMu1DkHv9Zk3wLh0qEew3Hx6OKtOUoUPehDz3
         eWOfxWT9nqhmexAyqw01uIWj7exxg/LnpatSclBulwFZNFhWQ8dJZuM9BnJ0NAA3xx4x
         nzItMWkBIUvxnlWm+VjteDa8VsP5F1bk3FEZFO74Vh1Sjjlq1Wnqyo/PDQ5+1Ch6cUa4
         ErbHNKQOUWSygeQxN1UW5aqy+OscbrKhmJoAC3U4uMhwSe+muKwMdNt2PuBQzEpTH85X
         WKtw==
X-Gm-Message-State: AOAM5329sZ5oN2X9CuggNOp/7ZUaATDSYGt1tv2NwVaKop6Bhz4Co5RF
        thpF8Kle5iOS60YZ1h9IVfezB3sXVQ2//wqpaafGPnRhue65
X-Google-Smtp-Source: ABdhPJzJ0j2GI6IjPYE4GhvLOvIIkMP1+B/Dag4tF8n6BC5RtTyEfK6x/ex5ztjKQ7agboIv4tJcdcFCyqpld4pc3aAI1H4tRzqy
MIME-Version: 1.0
X-Received: by 2002:a05:6602:14cb:b0:646:3b7d:6aee with SMTP id
 b11-20020a05660214cb00b006463b7d6aeemr1254503iow.178.1649943811352; Thu, 14
 Apr 2022 06:43:31 -0700 (PDT)
Date:   Thu, 14 Apr 2022 06:43:31 -0700
In-Reply-To: <20220414110903.185132971@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c6715b05dc9d7ab5@google.com>
Subject: Re: [PATCH 5.4 289/475] ext4: dont BUG if someone dirty pages without
 asking ext4 first
From:   syzbot 
        <syzbot+d59332e2db681cf18f0318a06e994ebbb529a8db@syzkaller.appspotmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     gregkh@linuxfoundation.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, tytso@mit.edu
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
> index dcbd8ac8d471..0d62f05f8925 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2161,6 +2161,15 @@ static int ext4_writepage(struct page *page,
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
> @@ -2710,6 +2719,22 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
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
>
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.


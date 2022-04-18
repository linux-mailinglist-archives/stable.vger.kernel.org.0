Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99A0505617
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbiDRNcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244821AbiDRNa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:56 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238AB1EAFC
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 05:55:34 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id d19-20020a0566022d5300b0065499cd4a73so1942600iow.14
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 05:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=6XX2B/tfYftJVq+lKFHTXC/IvifKJmd57U4qIBJU5t8=;
        b=vtxR+Gt1dQXfkU5wLp5v0lRnwkokFfR/m9FkEAbpx5Yr5ZSDav2F3vfaNlD8GO+Yn1
         E7wL9u8MR+8mqmCgMvIUiHqnq37E6S1a0J1rhOb402r+zsErrsdMe6WzfRrd5r82Zcvo
         xkd77qkC1BnW5frNuON0/ZDt3l82IEl1ekgmAx6iwzd2dREuBPcQ58J4zWeJXHSHy1eb
         Ig/bPedx1a1hsOkN4JJv0l/upAVm5N7SkO4yN2vEvGpsHBIbaAgMr5jQg9Tzl6Veuw43
         83Rua0LaDoKJTaIyT7pHlOvm6eeiJsNBl/5fiTNBQqXBdZK4aVuiGuhVXVv4aU/69n/w
         YURQ==
X-Gm-Message-State: AOAM530q8ftuS6bIZoQ3uvhaznlkvDuieNfztMtry0GLkEvCf2isyVUn
        icKj0l0CTpJS9vD120yKi6ujCb5XQJglkYaPTO3sjvsUnSGR
X-Google-Smtp-Source: ABdhPJzeZvSXuu6fDoAoxkFo8SJGxurtiAcSgogn4Li1krgpRBdtgF+qWO8jb2PlJqvV05jjIZmg+gMNJnsbai8YDKsTwqtfItcy
MIME-Version: 1.0
X-Received: by 2002:a05:6638:329a:b0:328:9f50:f600 with SMTP id
 f26-20020a056638329a00b003289f50f600mr514315jav.114.1650286533456; Mon, 18
 Apr 2022 05:55:33 -0700 (PDT)
Date:   Mon, 18 Apr 2022 05:55:33 -0700
In-Reply-To: <20220418121216.379286117@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009ac4fe05dced464c@google.com>
Subject: Re: [PATCH 4.14 163/284] ext4: dont BUG if someone dirty pages
 without asking ext4 first
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
> index 9c07c8674b21..4d3eefff3c84 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2147,6 +2147,15 @@ static int ext4_writepage(struct page *page,
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
> @@ -2706,6 +2715,22 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
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


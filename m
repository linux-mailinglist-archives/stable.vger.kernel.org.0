Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D788A4F3955
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377464AbiDEL3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350370AbiDEJ5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:57:45 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9849152E7C
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 02:51:05 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id s14-20020a056e021a0e00b002c7c03a5d81so7814448ild.9
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 02:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=SInnLnS2EMQb5gkUQJdrUhJ2hqkPMTlZIqTnil/IjHw=;
        b=IuwOL/58AqY02dkaPU35incjycuPdF1Ee6H2SdloaaA3K+xK0lT9R+/GLJnVtKEcSJ
         q+rF/2BhVcVFxt3t2JodxMuxggtefdOdFWGPO7Eje/6Sqnpkla0x/rYHAsIPINtWEFqQ
         CJUUP0pFu4YSs18sJyiK7iHaNkZbdFeyCiBhJ8XYPJDzUacjCqtQNk7wldav4j3XZ6tN
         gPJKvgLOeD3QdBw8wVWCmQ8XcyVOMopumNM9qrAGsYVHvHTK49cqKMypGAACltcRpv4o
         R9Nh5M+3VGMUeFUTFRMz7pDg6embYgHWcmnx8gs4xUL/c2a57mxuxXDT7WgOSyGv3f9f
         akVA==
X-Gm-Message-State: AOAM531FnJxsxcopnIJtR3Favy1roXYkBYi5EdpNMrIDlxeeSc5/3pFw
        Iw0NKcxiESSYqXI8SsVXgqdPcX1s45jd3SBm2lf/Otth+Gou
X-Google-Smtp-Source: ABdhPJy4tENxxQnXA5v1FbQset4Wpq6BonrhyCYGHqMiNj2v/Lgkftmupdqm02S8sVovglgX+jSFp33jfft54FUJt51kQT37TPhE
MIME-Version: 1.0
X-Received: by 2002:a92:d8cb:0:b0:2ca:2f11:d352 with SMTP id
 l11-20020a92d8cb000000b002ca2f11d352mr1321846ilo.236.1649152264846; Tue, 05
 Apr 2022 02:51:04 -0700 (PDT)
Date:   Tue, 05 Apr 2022 02:51:04 -0700
In-Reply-To: <20220405070401.266956806@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed46cf05dbe52e65@google.com>
Subject: Re: [PATCH 5.15 715/913] ext4: dont BUG if someone dirty pages
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
>
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34386800A7
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 19:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjA2SKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 13:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjA2SKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 13:10:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685AB1BFC;
        Sun, 29 Jan 2023 10:10:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1974860DE8;
        Sun, 29 Jan 2023 18:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385F6C433EF;
        Sun, 29 Jan 2023 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675015837;
        bh=QoMQBtNVehDRxSiM9AqCrwTTzEdFEbMs5SmmQcd3b+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C87mr9bJcc9R5F+dEIFZCyE3PzkoMJNo05ZhSuxqN4HEcNDuC4YA3GlbSoWViDM5X
         bhY7FUVCS/LiGcEU/7lKeqABlSmOjPOTdrx1z8LSXEP5mh/X/4B193oFM6dLrvrIls
         xn3GSGDrJrPkJxV1VngbCJuN+2HwDImd7YgHkY8XtD8CkVxkqnY8i3gjbVmCykrINN
         +OPhFrNdgwPVfwfvvaY8P+Jbmi43tQKrnQHthZoGxmX8o4XJvcme5vXDGv4q3Xkdkp
         fhpUl/l/DlAW3hQtqxSB5CR3v8Xvwr1nv1jdgfL8ACB6NxQRSyKsfWzpML2fDWYpqd
         wqahZHwOuEq3Q==
Date:   Sun, 29 Jan 2023 10:10:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        stable@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Message-ID: <Y9a2m8uvmXmCVYvE@sol.localdomain>
References: <20230129121851.2248378-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230129121851.2248378-1-willy@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 29, 2023 at 12:18:51PM +0000, Matthew Wilcox (Oracle) wrote:
> Both f2fs and ext4 end up passing the ciphertext page to
> wbc_account_cgroup_owner().  At the moment, the ciphertext page appears
> to belong to no cgroup, so it is accounted to the root_mem_cgroup instead
> of whatever cgroup the original page was in.
> 
> It's hard to say how far back this is a bug.  The crypto code shared
> between ext4 & f2fs was created in May 2015 with commit 0b81d0779072,
> but neither filesystem did anything with memcg_data before then.  memcg
> writeback accounting was added to ext4 in July 2015 in commit 001e4a8775f6
> and it wasn't added to f2fs until January 2018 (commit 578c647879f7).
> 
> I'm going with the ext4 commit since this is the first commit where
> there was a difference in behaviour between encrypted and unencrypted
> filesystems.
> 
> Fixes: 001e4a8775f6 ("ext4: implement cgroup writeback support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/crypto/crypto.c | 3 +++
>  1 file changed, 3 insertions(+)

What is the actual effect of this bug?

The bounce pages are short-lived, so surely it doesn't really matter what memory
cgroup they get charged to?

I guess it's really more about the effect on cgroup writeback?  And that's also
the reason why this is a problem here but not e.g. in dm-crypt?

> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index e78be66bbf01..a4e76f96f291 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -205,6 +205,9 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
>  	}
>  	SetPagePrivate(ciphertext_page);
>  	set_page_private(ciphertext_page, (unsigned long)page);
> +#ifdef CONFIG_MEMCG
> +	ciphertext_page->memcg_data = page->memcg_data;
> +#endif
>  	return ciphertext_page;
>  }

Nothing outside mm/ and include/linux/memcontrol.h does anything with memcg_data
directly.  Are you sure this is the right thing to do here?

Also, this patch causes the following:

[   16.192276] BUG: Bad page state in process kworker/u4:2  pfn:10798a
[   16.192919] page:00000000332f5565 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10798a
[   16.193848] memcg:ffff88810766c000
[   16.194186] flags: 0x200000000000000(node=0|zone=2)
[   16.194642] raw: 0200000000000000 0000000000000000 dead000000000122 0000000000000000
[   16.195356] raw: 0000000000000000 0000000000000000 00000000ffffffff ffff88810766c000
[   16.196061] page dumped because: page still charged to cgroup
[   16.196599] CPU: 0 PID: 33 Comm: kworker/u4:2 Tainted: G                T  6.2.0-rc5-00001-gf84eecbf5db1 #3
[   16.197494] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Arch Linux 1.16.1-1-1 04/01/2014
[   16.198343] Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
[   16.198899] Call Trace:
[   16.199143]  <TASK>
[   16.199350]  show_stack+0x47/0x56
[   16.199670]  dump_stack_lvl+0x55/0x72
[   16.200019]  dump_stack+0x14/0x18
[   16.200345]  bad_page.cold+0x5e/0x8a
[   16.200685]  free_page_is_bad_report+0x61/0x70
[   16.201111]  free_pcp_prepare+0x13f/0x290
[   16.201486]  free_unref_page+0x27/0x1f0
[   16.201848]  __free_pages+0xa0/0xc0
[   16.202186]  mempool_free_pages+0xd/0x20
[   16.202556]  mempool_free+0x28/0x90
[   16.202889]  fscrypt_free_bounce_page+0x26/0x40
[   16.203322]  ext4_finish_bio+0x1ed/0x240
[   16.203690]  ext4_release_io_end+0x4a/0x100
[   16.204088]  ext4_end_io_rsv_work+0xa8/0x1b0
[   16.204492]  process_one_work+0x27f/0x580
[   16.204874]  worker_thread+0x5a/0x3d0
[   16.205229]  ? process_one_work+0x580/0x580
[   16.205621]  kthread+0x102/0x130
[   16.205929]  ? kthread_exit+0x30/0x30
[   16.206280]  ret_from_fork+0x1f/0x30
[   16.206620]  </TASK>

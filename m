Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79C4685FC1
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 07:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjBAGbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 01:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjBAGbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 01:31:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4672564B1;
        Tue, 31 Jan 2023 22:31:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18568B81F2D;
        Wed,  1 Feb 2023 06:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DECC4339C;
        Wed,  1 Feb 2023 06:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675233093;
        bh=kODbu8v8FoJJKSYLR/mctHsB9SNw4l1AhxYgBT5F4R8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a9FoKfofj9I8z7FRGoI5KTEFES31+jAGm9T1tXLHLt1ICF1vzD9lVLQ1PMHKF118R
         6gxgIJ4cvI9lNcgU8jhgYhiEgv0BWrRs5Y/zh8bBLAXcpiK3QfXg6S7LZIzG/slYMS
         swQmWjHUhSmrxd2OTgLY5hwoNrZgsycTEcAuddMz581Mil5Ri2sQKK3WIB2+xpqArZ
         kEhjGm4ZjunZ/TEXjM0KgrLsC6WGXeZTQmZl679nScLECIBqVi2GGuQ9cdxWQq4Zgo
         u0iSFo5+bK8fU17enBhGUD60FFec9CC5212xX0Hf8PjBrr4OTPvVVBpviTK7zVBKNh
         4741njuFWUngA==
Date:   Tue, 31 Jan 2023 22:31:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        stable@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Message-ID: <Y9oHQ6MfRbfwmFyK@sol.localdomain>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
 <Y9bkoasmAmtQ2nSV@casper.infradead.org>
 <Y9mH0PCcZoGPryXw@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9mH0PCcZoGPryXw@slm.duckdns.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 31, 2023 at 11:27:44AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Sun, Jan 29, 2023 at 09:26:57PM +0000, Matthew Wilcox wrote:
> > > > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > > > index e78be66bbf01..a4e76f96f291 100644
> > > > --- a/fs/crypto/crypto.c
> > > > +++ b/fs/crypto/crypto.c
> > > > @@ -205,6 +205,9 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
> > > >  	}
> > > >  	SetPagePrivate(ciphertext_page);
> > > >  	set_page_private(ciphertext_page, (unsigned long)page);
> > > > +#ifdef CONFIG_MEMCG
> > > > +	ciphertext_page->memcg_data = page->memcg_data;
> > > > +#endif
> > > >  	return ciphertext_page;
> > > >  }
> > > 
> > > Nothing outside mm/ and include/linux/memcontrol.h does anything with memcg_data
> > > directly.  Are you sure this is the right thing to do here?
> > 
> > Nope ;-)  Happy to hear from people who know more about cgroups than I
> > do.  Adding some more ccs.
> > 
> > > Also, this patch causes the following:
> > 
> > Oops.  Clearly memcg_data needs to be set to NULL before we free it.
> 
> These can usually be handled by explicitly associating the bio's to the
> desired cgroups using one of bio_associate_blkg*() or
> bio_clone_blkg_association().

Here that already happens in wbc_init_bio(), called from io_submit_init_bio() in
fs/ext4/page-io.c.

> It is possible to go through memcg ownership
> too using set_active_memcg() so that the page is owned by the target cgroup;
> however, the page ownership doesn't directly map to IO ownership as the
> relationship depends on the type of the page (e.g. IO ownership for
> pagecache writeback is determined per-inode, not per-page). If the in-flight
> pages are limited, it probably is better to set bio association directly.

ext4 also calls wbc_account_cgroup_owner() for each pagecache page that's
written out.  It seems this is for a different purpose -- it looks like the
fs-writeback code is trying to figure out which cgroup "owns" the inode based on
which cgroup "owns" most of the pagecache pages?

The bug we're discussing here is that when ext4 writes out a pagecache page in
an encrypted file, it first encrypts the data into a bounce page, then passes
the bounce page (which don't have a memcg) to wbc_account_cgroup_owner().  Maybe
the proper fix is to just pass the pagecache page to wbc_account_cgroup_owner()
instead?  See below for ext4 (a separate patch would be needed for f2fs):

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index beaec6d81074a..1e4db96a04e63 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -409,7 +409,8 @@ static void io_submit_init_bio(struct ext4_io_submit *io,
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
-			     struct page *page,
+			     struct page *pagecache_page,
+			     struct page *bounce_page,
 			     struct buffer_head *bh)
 {
 	int ret;
@@ -421,10 +422,11 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
 	}
 	if (io->io_bio == NULL)
 		io_submit_init_bio(io, bh);
-	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, bounce_page ?: pagecache_page,
+			   bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
-	wbc_account_cgroup_owner(io->io_wbc, page, bh->b_size);
+	wbc_account_cgroup_owner(io->io_wbc, pagecache_page, bh->b_size);
 	io->io_next_block++;
 }
 
@@ -561,8 +563,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		io_submit_add_bh(io, inode,
-				 bounce_page ? bounce_page : page, bh);
+		io_submit_add_bh(io, inode, page, bounce_page, bh);
 	} while ((bh = bh->b_this_page) != head);
 unlock:
 	unlock_page(page);

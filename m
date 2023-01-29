Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30B68017F
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 22:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbjA2V1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 16:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2V1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 16:27:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C914E8A;
        Sun, 29 Jan 2023 13:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bXKHXmqEaebxMzK8gnHyzoWXhX9Kr2E4BvSYUnQui+s=; b=IxMHpJnXGWl1mAd9RBC6Fzs9tN
        /g2C0765JWZhKFeJDvJac3rnrbux8FmFABeZaU67CqtwPrSCEYxMm37nwuy4iuy7sFMtF8J16OHQO
        AhoX3yt7iYvrcw/aIwYbNJrbKrOhPAVYpg3zqChpqv1rO0hTL3A9y8BmG7vBf+889jCkVVHMScdES
        K2jIJ4U2SkTozsLcoHUNIRdmhj3BtcHFfoExh40VIL8wXG89Gby/vBoMwKaVoUGeHyldtIXa4x+9o
        5q2v3Ke1jzOwYBGPBii/hIRmojfICe5/UAWHdOQ9NJILhSpLOmb8DWdZox/0LXt4/MP0T+9bygsP1
        S2t2wNrQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMFCU-009l87-0X; Sun, 29 Jan 2023 21:26:58 +0000
Date:   Sun, 29 Jan 2023 21:26:57 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        stable@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Message-ID: <Y9bkoasmAmtQ2nSV@casper.infradead.org>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9a2m8uvmXmCVYvE@sol.localdomain>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 29, 2023 at 10:10:35AM -0800, Eric Biggers wrote:
> On Sun, Jan 29, 2023 at 12:18:51PM +0000, Matthew Wilcox (Oracle) wrote:
> > Both f2fs and ext4 end up passing the ciphertext page to
> > wbc_account_cgroup_owner().  At the moment, the ciphertext page appears
> > to belong to no cgroup, so it is accounted to the root_mem_cgroup instead
> > of whatever cgroup the original page was in.
> > 
> > It's hard to say how far back this is a bug.  The crypto code shared
> > between ext4 & f2fs was created in May 2015 with commit 0b81d0779072,
> > but neither filesystem did anything with memcg_data before then.  memcg
> > writeback accounting was added to ext4 in July 2015 in commit 001e4a8775f6
> > and it wasn't added to f2fs until January 2018 (commit 578c647879f7).
> 
> What is the actual effect of this bug?
> 
> The bounce pages are short-lived, so surely it doesn't really matter what memory
> cgroup they get charged to?

Ah, we don't want to charge the _memory_ of the bounce pages to the
cgroup.  We want to charge the _I/O_ to the cgroup.

Looking at the original commits, the effect will be that if you have
an unencrypted filesystem, writeback will be throttled according to
the cgroup's rules, but if you have an encrypted filesystem, it will
escape the cgroup I/O limits.

> I guess it's really more about the effect on cgroup writeback?  And that's also
> the reason why this is a problem here but not e.g. in dm-crypt?

I haven't looked at dm-crypt at all, but my assumption is that the fs
charges the I/O of the pagecache page to the cgroup, and there's no need
to do it again.

> > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > index e78be66bbf01..a4e76f96f291 100644
> > --- a/fs/crypto/crypto.c
> > +++ b/fs/crypto/crypto.c
> > @@ -205,6 +205,9 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
> >  	}
> >  	SetPagePrivate(ciphertext_page);
> >  	set_page_private(ciphertext_page, (unsigned long)page);
> > +#ifdef CONFIG_MEMCG
> > +	ciphertext_page->memcg_data = page->memcg_data;
> > +#endif
> >  	return ciphertext_page;
> >  }
> 
> Nothing outside mm/ and include/linux/memcontrol.h does anything with memcg_data
> directly.  Are you sure this is the right thing to do here?

Nope ;-)  Happy to hear from people who know more about cgroups than I
do.  Adding some more ccs.

> Also, this patch causes the following:

Oops.  Clearly memcg_data needs to be set to NULL before we free it.

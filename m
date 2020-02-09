Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2B5156BC9
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 18:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBIRWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 12:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbgBIRWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 12:22:25 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C5920733;
        Sun,  9 Feb 2020 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581268945;
        bh=EHsl+9RUIiS3sKFarJov1SIQY/E7wF6UWE46XSYajv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pFax5NMMwm8Y4CNnLV1adajfE/AKMSnmTIf0BpdcxplWTFr3fhPSGlI+W8lAXPA7J
         H+wSpl5AKqeNkVmSImhwQT9cvus4zKrXnhZrzVmfMbB6ppja0GxN9XLl8gZSA3eMr4
         xJnWG1oxZMEmj6tMcyFinbRQzrYXvCi59sJUo2Xw=
Date:   Sun, 9 Feb 2020 18:12:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     ebiggers@google.com, tytso@mit.edu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: fix deadlock allocating crypto
 bounce page from mempool" failed to apply to 4.19-stable tree
Message-ID: <20200209171252.GB6225@kroah.com>
References: <1581247561145212@kroah.com>
 <20200209155757.GC3584@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209155757.GC3584@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 10:57:57AM -0500, Sasha Levin wrote:
> On Sun, Feb 09, 2020 at 12:26:01PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 547c556f4db7c09447ecf5f833ab6aaae0c5ab58 Mon Sep 17 00:00:00 2001
> > From: Eric Biggers <ebiggers@google.com>
> > Date: Tue, 31 Dec 2019 12:11:49 -0600
> > Subject: [PATCH] ext4: fix deadlock allocating crypto bounce page from mempool
> > 
> > ext4_writepages() on an encrypted file has to encrypt the data, but it
> > can't modify the pagecache pages in-place, so it encrypts the data into
> > bounce pages and writes those instead.  All bounce pages are allocated
> > from a mempool using GFP_NOFS.
> > 
> > This is not correct use of a mempool, and it can deadlock.  This is
> > because GFP_NOFS includes __GFP_DIRECT_RECLAIM, which enables the "never
> > fail" mode for mempool_alloc() where a failed allocation will fall back
> > to waiting for one of the preallocated elements in the pool.
> > 
> > But since this mode is used for all a bio's pages and not just the
> > first, it can deadlock waiting for pages already in the bio to be freed.
> > 
> > This deadlock can be reproduced by patching mempool_alloc() to pretend
> > that pool->alloc() always fails (so that it always falls back to the
> > preallocations), and then creating an encrypted file of size > 128 KiB.
> > 
> > Fix it by only using GFP_NOFS for the first page in the bio.  For
> > subsequent pages just use GFP_NOWAIT, and if any of those fail, just
> > submit the bio and start a new one.
> > 
> > This will need to be fixed in f2fs too, but that's less straightforward.
> > 
> > Fixes: c9af28fdd449 ("ext4 crypto: don't let data integrity writebacks fail with ENOMEM")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Link: https://lore.kernel.org/r/20191231181149.47619-1-ebiggers@kernel.org
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> I've worked around not having these patches:
> 
> 592ddec7578a ("ext4: use IS_ENCRYPTED() to check encryption status")
> 53bc1d854c64 ("fscrypt: support encrypting multiple filesystem blocks per page")
> d2d0727b1654 ("fscrypt: simplify bounce page handling")
> 
> And queued the backport to 4.19-4.4.

Thanks for fixing this up, and the other ones.

greg k-h

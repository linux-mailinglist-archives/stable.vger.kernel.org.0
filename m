Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658453DC0D1
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 00:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhG3WMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 18:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhG3WMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 18:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3409C60F01;
        Fri, 30 Jul 2021 22:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627683137;
        bh=z5hNmJdN8BGjw8r8v9HzovZwX29btJP0uJDcs7J+trA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AaivHF8bsl58yq6tjanaqzWD5gLJr8HgM735hZbIElwJGvp/ZMQ1KjvzyTsFlR8PX
         7CruPxkf07BFQlExyqEZozNfX1ZQU4E5K2ldMDwVpypeGf8x/6PEs1C0yqVUtqU6f0
         2pdz9bc1+laAaQ7VfpeBopksqZkLJ1gLtCQRH4RE9WkpP0Y/UawQKJblM4MCOeiQDC
         x+WO2yFr0p6dI1r8NlmFmy6O5WNJDeCyEAYUfwt5Fg+vMzoZVgjQI3CA0IiAKn0dnc
         kBl0vxfMyZ8SSvwSYQb0l6F78I1G1gZ8g1h+fk+tGyqQRO6Xd8oGYfViCUhkxGqacj
         FzP0g8mNi9nNQ==
Date:   Fri, 30 Jul 2021 15:12:15 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net, Chao Yu <chao@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YQR5P6aMxhOL+6os@google.com>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQRQRh1zUHSIzcC/@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/30, Eric Biggers wrote:
> On Tue, Jul 27, 2021 at 06:51:54PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> > they require preallocating blocks, but f2fs doesn't support unwritten
> > blocks and therefore has to preallocate the blocks as regular blocks.
> > f2fs has no way to reliably roll back such preallocations, so as a

Hmm, I'm still wondering why this becomes a problem. And, do we really need
to roll back the preallocated blocks?

> > result, f2fs will leak uninitialized blocks to users if a DIO write
> > doesn't fully complete.  This can be easily reproduced by issuing a DIO
> > write that will fail due to misalignment, e.g.:

If there's any error, truncating blocks having NEW_ADDR could address this?

> > 
> > 	rm -f file
> > 	truncate -s 1000000 file
> > 	dd if=/dev/zero bs=999999 oflag=direct conv=notrunc of=file
> > 	od -tx1 file  # shows uninitialized disk blocks
> > 
> > Until a proper design for non-overwrite DIO writes on f2fs can be
> > designed and implemented, remove support for them and make them fall
> > back to buffered I/O.  This is what other filesystems that don't support
> > unwritten blocks, e.g. ext2, also do, at least for non-extending DIO
> > writes.  However, f2fs can't do extending DIO writes either, as f2fs
> > appears to have no mechanism for guaranteeing that leftover allocated
> > blocks past EOF will get truncated.  (f2fs does have an orphan list, but
> > it's only used for deleting inodes, not truncating them.)
> > 
> > This patch doesn't attempt to remove the F2FS_GET_BLOCK_{DIO,PRE_DIO}
> > cases in f2fs_map_blocks(); that can be cleaned up later.
> > 
> > Fixes: bfad7c2d4033 ("f2fs: introduce a new direct_IO write path")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> 
> Any opinion on this patch?  This really needs to be fixed one way or another.
> Probably before the conversion to iomap, as this fix will need to be backported.
> 
> - Eric

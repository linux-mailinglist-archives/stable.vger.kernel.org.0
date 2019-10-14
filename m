Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE75D61BC
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 13:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfJNLwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 07:52:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:41752 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731040AbfJNLwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 07:52:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F09BAD73;
        Mon, 14 Oct 2019 11:52:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 595ADDA7E3; Mon, 14 Oct 2019 13:52:29 +0200 (CEST)
Date:   Mon, 14 Oct 2019 13:52:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: save i_size in compress_file_range
Message-ID: <20191014115228.GN2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <20191011130354.8232-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130354.8232-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 09:03:54AM -0400, Josef Bacik wrote:
> this is happening because the page is not locked when doing
> clear_page_dirty_for_io.  Looking at the core dump it was because our
> async_extent had a ram_size of 24576 but our async_chunk range only
> spanned 20480, so we had a whole extra page in our ram_size for our
> async_extent.
> 
> This happened because we try not to compress pages outside of our
> i_size, however a cleanup patch changed us to do
> 
> actual_end = min_t(u64, i_size_read(inode), end + 1);
> 
> which is problematic because i_size_read() can evaluate to different
> values in between checking and assigning.

The other patch adding READ_ONCE to i_size_read actually has the
interesting bits why this happens, so this changelog should have them
too.

> So either a expanding
> truncate or a fallocate could increase our i_size while we're doing
> writeout and actual_end would end up being past the range we have
> locked.

Yeah, it's there, the problematic part is the double load of inode size

  mov    0x20(%rsp),%rax
  cmp    %rax,0x48(%r15)
  movl   $0x0,0x18(%rsp)
  mov    %rax,%r12
  mov    %r14,%rax
  cmovbe 0x48(%r15),%r12

Where r15 is inode and 0x48 is offset of i_size.

> I confirmed this was what was happening by installing a debug kernel
> that had
> 
> actual_end = min_t(u64, i_size_read(inode), end + 1);
> if (actual_end > end + 1) {
> 	printk(KERN_ERR "WE GOT FUCKED\n");
> 	actual_end = end + 1;
> }
> 
> and installing it onto 500 boxes of the tier that had been seeing the
> problem regularly.  Last night I got my debug message and no panic,
> confirming what I expected.
> 
> Fixes: 62b37622718c ("btrfs: Remove isize local variable in compress_file_range")
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/inode.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2eb1d7249f83..9a483d1f61f8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -474,6 +474,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
>  	u64 start = async_chunk->start;
>  	u64 end = async_chunk->end;
>  	u64 actual_end;
> +	loff_t i_size = i_size_read(inode);
>  	int ret = 0;
>  	struct page **pages = NULL;
>  	unsigned long nr_pages;
> @@ -488,7 +489,13 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
>  	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
>  			SZ_16K);
>  
> -	actual_end = min_t(u64, i_size_read(inode), end + 1);
> +	/*
> +	 * We need to save i_size before now because it could change in between
> +	 * us evaluating the size and assigning it.  This is because we lock and
> +	 * unlock the page in truncate and fallocate, and then modify the i_size
> +	 * later on.
> +	 */
> +	actual_end = min_t(u64, i_size, end + 1);

Unfortunatelly this is not sufficient and does not prevent the compiler
to do the same optimization, though current compilers seem to do just
one load it's not prevented in principle.  The only cure is READ_ONCE,
either globally or locally done in compress_file_range.

The other patch addding READ_ONCE to i_size_read would be IMHO ideal.

I've experimented with various ways to do the 'once' semantics, the
following worked:

* force READ_ONCE on the isize varaible, as READ_ONCE requires lvalue,
  we can't do READ_ONCE(i_size_read())

  u64 isize;
  ...
  isize = i_read_size(inode);
  isize = READ_ONCE(isize);

* insert barrier

  u64 isize;
  ...
  isize = i_size_read(inode);
  barrier();

* i_size_read returns READ_ONCE(inode->i_size)

  same as current code, ie.
  actual_end = min_t(..., i_size_read(inode), ...)

All verified on the assembly level that this does not do the double
load.

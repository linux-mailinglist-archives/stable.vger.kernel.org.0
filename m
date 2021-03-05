Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E4332E0E1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 05:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCEEwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 23:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhCEEwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 23:52:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9660664EF6;
        Fri,  5 Mar 2021 04:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614919964;
        bh=zxC/9kcMnACFzH9ITkD6VZhydnGwzCTG1L8sFScG1+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NR5s6qZojEz91xa3HAt28QIC7ilr7VJvXJx9/mWCWO4FRBMVzUe4NKKfVaL0yCeJv
         H7+NaaXIyT2Ms980B/Wzm9QqtpLbdZhnzjfpfJqulai7y3eFrMwSAWCi03EsxMfvmD
         7Eas8GztpTBLgG+3KDOYLUDGBxegYRxxhklIrXKonWAlJ+YSU8/yridJ9IpZM+S524
         czMoWgLwnydRSUwX9c4wiaoNK47w3LU/KCrBswOx+z1aOD23pxzETX35iUvbWdGWeQ
         rZLHl355CVJweaeNblh+oh1YmOxqtkg4tL62hNaQ2LGCs5SlhEYrtIOt3/y76c9wT0
         hJhrJJ89om/SA==
Date:   Thu, 4 Mar 2021 20:52:43 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] f2fs: fix error handling in f2fs_end_enable_verity()
Message-ID: <YEG5G5d2YisF8zB0@sol.localdomain>
References: <20210302200420.137977-1-ebiggers@kernel.org>
 <20210302200420.137977-3-ebiggers@kernel.org>
 <9980e263-aa25-cf50-5a94-9f63a5ae667e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9980e263-aa25-cf50-5a94-9f63a5ae667e@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 09:37:26AM +0800, Chao Yu wrote:
> > +cleanup:
> > +	/*
> > +	 * Verity failed to be enabled, so clean up by truncating any verity
> > +	 * metadata that was written beyond i_size (both from cache and from
> > +	 * disk) and clearing FI_VERITY_IN_PROGRESS.
> > +	 */
> > +	truncate_inode_pages(inode->i_mapping, inode->i_size);
> > +	f2fs_truncate(inode);
> 
> Eric,
> 
> Truncation can fail due to a lot of reasons, if we fail in f2fs_truncate(),
> do we need to at least print a message here? or it allows to keep those
> meta/data silently.

I suppose we might as well, although hopefully there will already be a message
for the underlying failure reason too.  Also, f2fs_file_write_iter() has the
same issue too, right?

> One other concern is that how do you think of covering truncate_inode_pages &
> f2fs_truncate with F2FS_I(inode)->i_gc_rwsem[WRITE] lock to avoid racing with
> GC, so that page cache won't be revalidated after truncate_inode_pages().

Yes, that does seem to be needed, due to the way the f2fs garbage collection
works.

- Eric

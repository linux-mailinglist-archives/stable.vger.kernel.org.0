Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDDB3DCFCF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 06:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhHBEkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 00:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhHBEkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 00:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 166BE60FC1;
        Mon,  2 Aug 2021 04:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627879199;
        bh=qmobRmA+yWKnNrYpDsC8VuTL9aCRxBaKljY1RtdSS/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d6itMxKmjJac1CWHBdeojjaRGCFdZTHcTaeXudtPUJuPOe1No/durs9ba5gFKlXLF
         68b1wjODd1YzpJqC9imT3YoyVJRAGlfw4JPmUfI0j8ONGdBkTEvCBZ0MsIPgumdEYL
         qIIzns4n0gmeffxEWK/5o0wrwp2BppnVXiyctW56fKI2LD9m+F7lwWaT2GkqfS3VA1
         cSaSLpL4Qk5co/QM66eQ0t+gl+g/Fq1noylZXLV2hNajRKKpzdATegXYACzWTWUZq6
         WCZvrIlzePRxV2kCdufa2eJrcI5UZytwIs8gQejBXYfo+yvW5QO4tK525W2tJ0t3Oo
         muAOf1B4L1EiQ==
Date:   Sun, 1 Aug 2021 21:39:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YQd3Hbid/mFm0o24@sol.localdomain>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQS5eBljtztWwOFE@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQS5eBljtztWwOFE@mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 10:46:16PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 30, 2021 at 12:17:26PM -0700, Eric Biggers wrote:
> > > Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> > > they require preallocating blocks, but f2fs doesn't support unwritten
> > > blocks and therefore has to preallocate the blocks as regular blocks.
> > > f2fs has no way to reliably roll back such preallocations, so as a
> > > result, f2fs will leak uninitialized blocks to users if a DIO write
> > > doesn't fully complete.
> 
> There's another way of solving this problem which doesn't require
> supporting unwritten blocks.  What a file system *could* do is to
> allocate the blocks, but *not* update the on-disk data structures ---
> so the allocation happens in memory only, so you know that the
> physical blocks won't get used for another files, and then issue the
> data block writes.  On the block I/O completion, trigger a workqueue
> function which updates the on-disk metadata to assign physical blocks
> to the inode.
> 
> That way if you crash before the data I/O has a chance to complete,
> the on-disk logical block -> physical block map hasn't been updated
> yet, and so you don't need to worry about leaking uninitialized blocks.
> 
> Cheers,
> 
> 					- Ted

Jaegeuk and Chao, any idea how feasible it would be for f2fs to do this?

- Eric

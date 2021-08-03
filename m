Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3CD3DE409
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 03:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhHCBfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 21:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbhHCBfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 21:35:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 455F560FA0;
        Tue,  3 Aug 2021 01:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627954490;
        bh=XRzA3NrzzEUgpsOEuNtbvyLKsenWMKiE5wFIrQcFx2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tgaDKnP+hbvLQZXYzSVAUGYqbB3FuLq4omTfeTO1Pz2y32jDuHV8nhRUAqcWqs/U8
         l9fxboTiygfUKWrPbdU2gPVKZ5EiE0dmufn9LUwj5TeVckseuoOpXlnFPFxCqpSWXw
         NrIqvKK42kChEo+AYluJ0WNaV7fEM6L0H42L2jz05c6ng5C/bTf8V9yXAW4GK1k1k9
         va2C/Tf/5t5TcblLTTwde6RrRCTQHgkLbApoz36qVbG6ARjcaEspeo7DUr6OIVyAKP
         XRU9hp2Es1zy/7Grmi+ZlG6sfEfajF7w97x601rGidAkJi4oSY/WxOkzqU/qEH2bqC
         hhImbvyDtRTQA==
Date:   Mon, 2 Aug 2021 18:34:48 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YQidOD/zNB17fd9v@google.com>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/03, Chao Yu wrote:
> On 2021/8/3 2:23, Jaegeuk Kim wrote:
> > On 08/02, Chao Yu wrote:
> > > On 2021/8/2 12:39, Eric Biggers wrote:
> > > > On Fri, Jul 30, 2021 at 10:46:16PM -0400, Theodore Ts'o wrote:
> > > > > On Fri, Jul 30, 2021 at 12:17:26PM -0700, Eric Biggers wrote:
> > > > > > > Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> > > > > > > they require preallocating blocks, but f2fs doesn't support unwritten
> > > > > > > blocks and therefore has to preallocate the blocks as regular blocks.
> > > > > > > f2fs has no way to reliably roll back such preallocations, so as a
> > > > > > > result, f2fs will leak uninitialized blocks to users if a DIO write
> > > > > > > doesn't fully complete.
> > > > > 
> > > > > There's another way of solving this problem which doesn't require
> > > > > supporting unwritten blocks.  What a file system *could* do is to
> > > > > allocate the blocks, but *not* update the on-disk data structures ---
> > > > > so the allocation happens in memory only, so you know that the
> > > > > physical blocks won't get used for another files, and then issue the
> > > > > data block writes.  On the block I/O completion, trigger a workqueue
> > > > > function which updates the on-disk metadata to assign physical blocks
> > > > > to the inode.
> > > > > 
> > > > > That way if you crash before the data I/O has a chance to complete,
> > > > > the on-disk logical block -> physical block map hasn't been updated
> > > > > yet, and so you don't need to worry about leaking uninitialized blocks.
> > > 
> > > Thanks for your suggestion, I think it makes sense.
> > > 
> > > > > 
> > > > > Cheers,
> > > > > 
> > > > > 					- Ted
> > > > 
> > > > Jaegeuk and Chao, any idea how feasible it would be for f2fs to do this?
> > > 
> > > Firstly, let's notice that below metadata will be touched during DIO
> > > preallocation flow:
> > > - log header
> > > - sit bitmap/count
> > > - free seg/sec bitmap/count
> > > - dirty seg/sec bitmap/count
> > > 
> > > And there is one case we need to concern about is: checkpoint() can be
> > > triggered randomly in between dio_preallocate() and dio_end_io(), we should
> > > not persist any DIO preallocation related metadata during checkpoint(),
> > > otherwise, sudden power-cut after the checkpoint will corrupt filesytem.
> > > 
> > > So it needs to well separate two kinds of metadata update:
> > > a) belong to dio preallocation
> > > b) the left one
> > > 
> > > After that, it will simply checkpoint() flow to just flush metadata b), for
> > > other flow, like GC, data/node allocation, it needs to query/update metadata
> > > after we combine metadata a) and b).
> > > 
> > > In addition, there is an existing in-memory log header framework in f2fs,
> > > based on this fwk, it's very easy for us to add a new in-memory log header
> > > for DIO preallocation.
> > > 
> > > So it seems feasible for me until now...
> > > 
> > > Jaegeuk, any other concerns about the implementation details?
> > 
> > Hmm, I'm still trying to deal with this as a corner case where the writes
> > haven't completed due to an error. How about keeping the preallocated block
> > offsets and releasing them if we get an error? Do we need to handle EIO right?
> 
> What about the case that CP + SPO following DIO preallocation? User will
> encounter uninitialized block after recovery.

I think buffered writes as a workaround can expose the last unwritten block as
well, if SPO happens right after block allocation. We may need to compromise
at certain level?

> 
> Thanks,
> 
> > 
> > > 
> > > Thanks,
> > > 
> > > > 
> > > > - Eric
> > > > 

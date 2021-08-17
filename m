Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338613EE420
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 04:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhHQCD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 22:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233394AbhHQCDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 22:03:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B1DD60F4B;
        Tue, 17 Aug 2021 02:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629165803;
        bh=M4kPfTtv/YCNqqegGw5hhYfKzsIq9j0CDrkKB3eJQAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YHjQK8GsIwY+/8QKey2Ozcxv8CMsI7psHLUN/o2JVcJ3PCv+cyCLwnOKadOX5TwdR
         cZFxmFPTvirzcDCotfnIicTVoJsyOW6eVYJHBzid0TGlKjJZULVTLOHL1gmIbIwxGj
         lXHyAnfHDvY+8u5u07Qp4QCuhIVTUYyBCip+DSZiU1v216RhN+mlkTcG39yNtmLzSe
         /xavcGH4T0ABqmoE2MhSeuclyZ0AwumqhdK1kW/KIlAYLicwZ+4a92koP2uvsxy2Q5
         0CYD9vdnmZahKzFrYyUmV3f5fkrarm1i1WsbDrRwhETQ+c46eez/gA1j1W9AANQNv7
         9MPUo7vBMjuvg==
Date:   Mon, 16 Aug 2021 19:03:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Chao Yu <chao@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YRsY6dyHyaChkQ6n@gmail.com>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
 <YQidOD/zNB17fd9v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQidOD/zNB17fd9v@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 06:34:48PM -0700, Jaegeuk Kim wrote:
> On 08/03, Chao Yu wrote:
> > On 2021/8/3 2:23, Jaegeuk Kim wrote:
> > > On 08/02, Chao Yu wrote:
> > > > On 2021/8/2 12:39, Eric Biggers wrote:
> > > > > On Fri, Jul 30, 2021 at 10:46:16PM -0400, Theodore Ts'o wrote:
> > > > > > On Fri, Jul 30, 2021 at 12:17:26PM -0700, Eric Biggers wrote:
> > > > > > > > Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> > > > > > > > they require preallocating blocks, but f2fs doesn't support unwritten
> > > > > > > > blocks and therefore has to preallocate the blocks as regular blocks.
> > > > > > > > f2fs has no way to reliably roll back such preallocations, so as a
> > > > > > > > result, f2fs will leak uninitialized blocks to users if a DIO write
> > > > > > > > doesn't fully complete.
> > > > > > 
> > > > > > There's another way of solving this problem which doesn't require
> > > > > > supporting unwritten blocks.  What a file system *could* do is to
> > > > > > allocate the blocks, but *not* update the on-disk data structures ---
> > > > > > so the allocation happens in memory only, so you know that the
> > > > > > physical blocks won't get used for another files, and then issue the
> > > > > > data block writes.  On the block I/O completion, trigger a workqueue
> > > > > > function which updates the on-disk metadata to assign physical blocks
> > > > > > to the inode.
> > > > > > 
> > > > > > That way if you crash before the data I/O has a chance to complete,
> > > > > > the on-disk logical block -> physical block map hasn't been updated
> > > > > > yet, and so you don't need to worry about leaking uninitialized blocks.
> > > > 
> > > > Thanks for your suggestion, I think it makes sense.
> > > > 
> > > > > > 
> > > > > > Cheers,
> > > > > > 
> > > > > > 					- Ted
> > > > > 
> > > > > Jaegeuk and Chao, any idea how feasible it would be for f2fs to do this?
> > > > 
> > > > Firstly, let's notice that below metadata will be touched during DIO
> > > > preallocation flow:
> > > > - log header
> > > > - sit bitmap/count
> > > > - free seg/sec bitmap/count
> > > > - dirty seg/sec bitmap/count
> > > > 
> > > > And there is one case we need to concern about is: checkpoint() can be
> > > > triggered randomly in between dio_preallocate() and dio_end_io(), we should
> > > > not persist any DIO preallocation related metadata during checkpoint(),
> > > > otherwise, sudden power-cut after the checkpoint will corrupt filesytem.
> > > > 
> > > > So it needs to well separate two kinds of metadata update:
> > > > a) belong to dio preallocation
> > > > b) the left one
> > > > 
> > > > After that, it will simply checkpoint() flow to just flush metadata b), for
> > > > other flow, like GC, data/node allocation, it needs to query/update metadata
> > > > after we combine metadata a) and b).
> > > > 
> > > > In addition, there is an existing in-memory log header framework in f2fs,
> > > > based on this fwk, it's very easy for us to add a new in-memory log header
> > > > for DIO preallocation.
> > > > 
> > > > So it seems feasible for me until now...
> > > > 
> > > > Jaegeuk, any other concerns about the implementation details?
> > > 
> > > Hmm, I'm still trying to deal with this as a corner case where the writes
> > > haven't completed due to an error. How about keeping the preallocated block
> > > offsets and releasing them if we get an error? Do we need to handle EIO right?
> > 
> > What about the case that CP + SPO following DIO preallocation? User will
> > encounter uninitialized block after recovery.
> 
> I think buffered writes as a workaround can expose the last unwritten block as
> well, if SPO happens right after block allocation. We may need to compromise
> at certain level?
> 

Freeing preallocated blocks on error would be better than nothing, although note
that the preallocated blocks may have filled an arbitrary sequence of holes --
so simply truncating past EOF would *not* be sufficient.

But really filesystems need to be designed to never expose uninitialized data,
even if I/O errors or a sudden power failure occurs.  It is unfortunate that
f2fs apparently wasn't designed with that goal in mind.

In any case, I don't think we can proceed with any other f2fs direct I/O
improvements until this data leakage bug can be solved one way or another.  If
my patch to remove support for allocating writes isn't acceptable and the
desired solution is going to require some more invasive f2fs surgery, are you or
Chao going to work on it?  I'm not sure there's much I can do here.

- Eric

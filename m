Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B851A3DC2C3
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 04:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhGaCqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 22:46:36 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40499 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231380AbhGaCqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 22:46:36 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16V2kGk7028015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 22:46:17 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9B17815C37C0; Fri, 30 Jul 2021 22:46:16 -0400 (EDT)
Date:   Fri, 30 Jul 2021 22:46:16 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YQS5eBljtztWwOFE@mit.edu>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQRQRh1zUHSIzcC/@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 12:17:26PM -0700, Eric Biggers wrote:
> > Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> > they require preallocating blocks, but f2fs doesn't support unwritten
> > blocks and therefore has to preallocate the blocks as regular blocks.
> > f2fs has no way to reliably roll back such preallocations, so as a
> > result, f2fs will leak uninitialized blocks to users if a DIO write
> > doesn't fully complete.

There's another way of solving this problem which doesn't require
supporting unwritten blocks.  What a file system *could* do is to
allocate the blocks, but *not* update the on-disk data structures ---
so the allocation happens in memory only, so you know that the
physical blocks won't get used for another files, and then issue the
data block writes.  On the block I/O completion, trigger a workqueue
function which updates the on-disk metadata to assign physical blocks
to the inode.

That way if you crash before the data I/O has a chance to complete,
the on-disk logical block -> physical block map hasn't been updated
yet, and so you don't need to worry about leaking uninitialized blocks.

Cheers,

					- Ted

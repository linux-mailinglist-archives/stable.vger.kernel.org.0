Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F883EF678
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 02:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhHRAG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 20:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232706AbhHRAG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 20:06:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0D72601FA;
        Wed, 18 Aug 2021 00:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629245184;
        bh=gZg1UtCJiztDrJ25z8aSbakGUsVL/7mPg4qd/KxqXkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ogfKnf4KQ3JNLZVZESpD1EyBWo0GbhsrY8/MQkVTKYo65b3F8m5vrwe3YO2vZqcmx
         0pF0O+4P6l8CBkfop9inJXEUQdeo0CEF7Ihm5vM4mwCEftxm8+QKhyRg26aZg71wUX
         4wzrbNErM3S77UkY+9TMfeHmAVZ4G5GmmDfobGhIvFZLL83FZwO6bJK/4KZl2lDp1c
         /WNZJL8Gp4TMrWZKGZVCKFAehpnqH5UwAmC3TGl3EqYxyL1zzNC+GlB3Q1OSjmRrw/
         34ULnyfNmuEtNITqAVkAHD8oZVCyHVEMbqPYHBKOxy8TsGNm1ePd2H2pL9L4mZ2eHv
         O4N+2F2y5RFVA==
Date:   Tue, 17 Aug 2021 17:06:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, Chao Yu <chao@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YRxO/tzo15OTfbaZ@gmail.com>
References: <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
 <YQidOD/zNB17fd9v@google.com>
 <YRsY6dyHyaChkQ6n@gmail.com>
 <YRtMOqzZU4c1Vjje@infradead.org>
 <YRwGqsLgyKqdbkGX@google.com>
 <YRwblEj2b/tIBh8b@gmail.com>
 <YRwrDdcryfTH4Vwi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRwrDdcryfTH4Vwi@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 02:33:01PM -0700, Jaegeuk Kim wrote:
> On 08/17, Eric Biggers wrote:
> > On Tue, Aug 17, 2021 at 11:57:46AM -0700, Jaegeuk Kim wrote:
> > > On 08/17, Christoph Hellwig wrote:
> > > > On Mon, Aug 16, 2021 at 07:03:21PM -0700, Eric Biggers wrote:
> > > > > Freeing preallocated blocks on error would be better than nothing, although note
> > > > > that the preallocated blocks may have filled an arbitrary sequence of holes --
> > > > > so simply truncating past EOF would *not* be sufficient.
> > > > > 
> > > > > But really filesystems need to be designed to never expose uninitialized data,
> > > > > even if I/O errors or a sudden power failure occurs.  It is unfortunate that
> > > > > f2fs apparently wasn't designed with that goal in mind.
> > > > > 
> > > > > In any case, I don't think we can proceed with any other f2fs direct I/O
> > > > > improvements until this data leakage bug can be solved one way or another.  If
> > > > > my patch to remove support for allocating writes isn't acceptable and the
> > > > > desired solution is going to require some more invasive f2fs surgery, are you or
> > > > > Chao going to work on it?  I'm not sure there's much I can do here.
> > > > 
> > > > Btw, this is generally a problem for buffered I/O as well, although the
> > > > window for exposing uninitialized blocks on a crash tends to be smaller.
> > > 
> > > How about adding a warning message when we meet an error with preallocated
> > > unwritten blocks? In the meantime, can we get the Eric's patches for iomap
> > > support? I feel that we only need to modify the preallocation and error
> > > handling parts?
> > 
> > A warning message would do nothing to prevent uninitialized blocks from being
> > leaked to userspace.
> 
> To give a signal that it's a known issue that we'll fix later.
> 

This bug is concerning mainly because it's a security vulnerability: anyone with
read+write access to just one file on an f2fs filesystem can effectively read
all other files on that filesystem.  A warning message wouldn't change that.

And even in the case of this bug breaking a non-malicious program, hardly anyone
reads kernel log messages anyway.  If something is broken, having a log message
that says "yeah, this is broken, sorry" isn't going to accomplish much...

- Eric

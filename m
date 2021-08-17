Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C53EF404
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 22:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhHQU1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 16:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhHQU1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 16:27:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A15986023E;
        Tue, 17 Aug 2021 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629232021;
        bh=7uXwMUE6nCVLGwC/jf/GBBmqfuoSPzQ5my11HXxJJ+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XDVt4BIw8TZ4dDwPOYDNZ/G2MStCyFFOrVF8PKDzwzYf5nzchnVIan7DsQQFZTMyw
         /pKEAn4QeBsUxi5xf1lm/n79gqavsC2qCXa+XlN4DvCCjFFS072Wh1VBjL0U78Gy19
         frL/rs06eFjKxkzUQlv+77vJv/VAH1GfNu8Or52MXcLl51OQkoMKdVAdhb73d+b/R/
         L/ZbqvAzPueK/JiwfyPkooo4BcGXkRwCS8BEWlYbSlQq9/z72QkJOeprhsne5ZekPo
         uLpARkcYqMiThu886GNZg5/bKH0rvHUg2aYI1ja2foEfELKrOhlJMwkbWTpiCEej2O
         Hrtd2cL8QOdig==
Date:   Tue, 17 Aug 2021 13:27:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, Chao Yu <chao@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YRwblEj2b/tIBh8b@gmail.com>
References: <YQRQRh1zUHSIzcC/@gmail.com>
 <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
 <YQidOD/zNB17fd9v@google.com>
 <YRsY6dyHyaChkQ6n@gmail.com>
 <YRtMOqzZU4c1Vjje@infradead.org>
 <YRwGqsLgyKqdbkGX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRwGqsLgyKqdbkGX@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 11:57:46AM -0700, Jaegeuk Kim wrote:
> On 08/17, Christoph Hellwig wrote:
> > On Mon, Aug 16, 2021 at 07:03:21PM -0700, Eric Biggers wrote:
> > > Freeing preallocated blocks on error would be better than nothing, although note
> > > that the preallocated blocks may have filled an arbitrary sequence of holes --
> > > so simply truncating past EOF would *not* be sufficient.
> > > 
> > > But really filesystems need to be designed to never expose uninitialized data,
> > > even if I/O errors or a sudden power failure occurs.  It is unfortunate that
> > > f2fs apparently wasn't designed with that goal in mind.
> > > 
> > > In any case, I don't think we can proceed with any other f2fs direct I/O
> > > improvements until this data leakage bug can be solved one way or another.  If
> > > my patch to remove support for allocating writes isn't acceptable and the
> > > desired solution is going to require some more invasive f2fs surgery, are you or
> > > Chao going to work on it?  I'm not sure there's much I can do here.
> > 
> > Btw, this is generally a problem for buffered I/O as well, although the
> > window for exposing uninitialized blocks on a crash tends to be smaller.
> 
> How about adding a warning message when we meet an error with preallocated
> unwritten blocks? In the meantime, can we get the Eric's patches for iomap
> support? I feel that we only need to modify the preallocation and error
> handling parts?

A warning message would do nothing to prevent uninitialized blocks from being
leaked to userspace.

- Eric

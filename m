Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C13DC235
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 03:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhGaBGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 21:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234640AbhGaBGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 21:06:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F09A60295;
        Sat, 31 Jul 2021 01:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627693561;
        bh=0X9jHrsOU43z9tGeEAL322dqf3ZHE2S9QVnPefF+wwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sq4e9/j5X+/BIhXxpzSyXp5xyn0BeBnB6H2XlTRHdd9V/KpxJdTNOmGoM0/bju81L
         1V2KXECo2ORvb/rTi+sZ451TX/DgY07wKNl4MsjSjKFrZaGc3iBF+oYHbJhfUPj7GN
         AfKLCoj5o4+0BKMS+AxOZSlXLO9pDJMWjm/yHdIjXBxQe9LRbQjyOz052C8T/xPADH
         gJRG2EDjNYR1eVR26DZwCRjlHTFP9zNTtUeuieTMgArAuXFbOCdp7G9zXEvAJjqwbq
         90CKIYIMq+N+jZHy4l1uEreJYNUJbQX6hWSnHFrRF5qil1jKyswPnFlqtMrz8ecMab
         cj3ZEqg4KbcMA==
Date:   Fri, 30 Jul 2021 18:05:59 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net, Chao Yu <chao@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YQSh95wKJB+ax1VC@google.com>
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com>
 <YQR5P6aMxhOL+6os@google.com>
 <YQR69fzcv2vkgtfT@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQR69fzcv2vkgtfT@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/30, Eric Biggers wrote:
> On Fri, Jul 30, 2021 at 03:12:15PM -0700, Jaegeuk Kim wrote:
> > On 07/30, Eric Biggers wrote:
> > > On Tue, Jul 27, 2021 at 06:51:54PM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> > > > they require preallocating blocks, but f2fs doesn't support unwritten
> > > > blocks and therefore has to preallocate the blocks as regular blocks.
> > > > f2fs has no way to reliably roll back such preallocations, so as a
> > 
> > Hmm, I'm still wondering why this becomes a problem. And, do we really need
> > to roll back the preallocated blocks?
> > 
> > > > result, f2fs will leak uninitialized blocks to users if a DIO write
> > > > doesn't fully complete.  This can be easily reproduced by issuing a DIO
> > > > write that will fail due to misalignment, e.g.:
> > 
> > If there's any error, truncating blocks having NEW_ADDR could address this?
> > 
> 
> My understanding is that the "NEW_ADDR" block address in f2fs means that space
> was reserved for the block, but not allocated in any particular place yet.
> Buffered writes reserve blocks in this way, but DIO writes cannot because DIO by
> definition has to directly write to a specific on-disk location.  Therefore DIO
> writes require that the blocks be preallocated for real.

Sorry, checking back the DIO flow, we do allocate real block addresses if DIO
has holes.

f2fs_preallocate_blocks
 -> f2fs_map_blocks(F2FS_GET_BLOCK_PRE_DIO)
  -> __allocate_data_block()
   -> f2fs_allocate_data_block() gets a free LBA

Then, back to your concern, do we need to truncate blocks beyond i_size, if we
meet any failure?

> 
> - Eric

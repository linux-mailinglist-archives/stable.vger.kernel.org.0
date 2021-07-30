Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37403DBEDF
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 21:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhG3TRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 15:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230402AbhG3TRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 15:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB70060F00;
        Fri, 30 Jul 2021 19:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627672648;
        bh=XqeK93rCzU12KUxQ403dIfNb2X2IjmU3CuGxNcDcqD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFAppH6m2GqYRVPI4E09rzh1UCs2/hwjV7QKLXAh/XdlJoZ6cFF95s1//f6n9fnrd
         6vVQYLJQZYuFlgTOIWVWWb0+y4O73t6zO2JHqsPLYdxibg++14iGjcjEz7de8Yw1Hk
         0gX5shHMyJ/GymU70LeE7/PZVdmvu8JuZbCMFBo3a5kYzENhwDglZo5Ltrm/kWv8Sj
         MHSFyj7JTcFtA4spdJFWrHVxv8iCeiO5ONFT2HFJavoLcm6yK9MVLdIwuNI2FsTp0o
         d10tItZDVBGSPeiOZPvhrUEYUNVEnzfAaDBUoGW82AQdSi+Uw+qtzPOMuwPmkYrzo2
         jirN/MYC1Wh6Q==
Date:   Fri, 30 Jul 2021 12:17:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
Message-ID: <YQRQRh1zUHSIzcC/@gmail.com>
References: <20210728015154.171507-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728015154.171507-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 06:51:54PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
> they require preallocating blocks, but f2fs doesn't support unwritten
> blocks and therefore has to preallocate the blocks as regular blocks.
> f2fs has no way to reliably roll back such preallocations, so as a
> result, f2fs will leak uninitialized blocks to users if a DIO write
> doesn't fully complete.  This can be easily reproduced by issuing a DIO
> write that will fail due to misalignment, e.g.:
> 
> 	rm -f file
> 	truncate -s 1000000 file
> 	dd if=/dev/zero bs=999999 oflag=direct conv=notrunc of=file
> 	od -tx1 file  # shows uninitialized disk blocks
> 
> Until a proper design for non-overwrite DIO writes on f2fs can be
> designed and implemented, remove support for them and make them fall
> back to buffered I/O.  This is what other filesystems that don't support
> unwritten blocks, e.g. ext2, also do, at least for non-extending DIO
> writes.  However, f2fs can't do extending DIO writes either, as f2fs
> appears to have no mechanism for guaranteeing that leftover allocated
> blocks past EOF will get truncated.  (f2fs does have an orphan list, but
> it's only used for deleting inodes, not truncating them.)
> 
> This patch doesn't attempt to remove the F2FS_GET_BLOCK_{DIO,PRE_DIO}
> cases in f2fs_map_blocks(); that can be cleaned up later.
> 
> Fixes: bfad7c2d4033 ("f2fs: introduce a new direct_IO write path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Any opinion on this patch?  This really needs to be fixed one way or another.
Probably before the conversion to iomap, as this fix will need to be backported.

- Eric

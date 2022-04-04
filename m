Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47F64F1235
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244822AbiDDJnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 05:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244030AbiDDJnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 05:43:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3545F3584E;
        Mon,  4 Apr 2022 02:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4EDAB8075B;
        Mon,  4 Apr 2022 09:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13608C2BBE4;
        Mon,  4 Apr 2022 09:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649065301;
        bh=cBNn7x0rjPHdpw09Pnzzj0qz9uwvqfup4vnhB/JA3pk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H76Ohh/XJIzt6XfXDXlzZTGQyXB0NuwUJ68Rj1VerP9hIj46vo38SHoEsVdsvxB1c
         iTExd/2A78ZIpqTvqdK9hsFRBOBVPrAccDiC1T4mp3m0MtJ67Qf2rQQtDwoOUobLX7
         pwHtu4Q1fbjGoaKC4I0VsbJKu10mFtS3ASj4sA+O19m/Ka2Ve4pJbjYLfJjKQEllpP
         L7bvXJ7rTSZjLDED/xbIq4+aqgrgiwCFS9SJY+WyvhXNJw3QLsXyKBft/xtqK4B2IS
         zu+Bmz/IQJNsjkiXyS9EYG4Xp+R/Td8MKo4XBL1aS+kmR8np2+8LD1pMgbfLEWsS1T
         +RNXABJnlmxZg==
Date:   Mon, 4 Apr 2022 10:41:37 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        agruenba@redhat.com
Subject: Re: [PATCH 00/17 stable-5.15.y] Fix mmap + page fault deadlocks
Message-ID: <Ykq9UXXZLTZOJ6N+@debian9.Home>
References: <cover.1648636044.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 06:25:37PM +0800, Anand Jain wrote:
> This set fixes a process hang issue in btrfs and gf2 filesystems. When we
> do a direct IO read or write when the buffer given by the user is
> memory-mapped to the file range we are going to do IO, we end up ending
> in a deadlock. This is triggered by the test case generic/647 from
> fstests.
> 
> This fix depends on the iov_iter and iomap changes introduced in the
> commit c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2") and they
> are part of this set for stable-5.15.y.
> 
> Please note that patch 3/17 in this patchset changes the prototype and
> renames an exported symbol as below. All its references are updated as
> well.
> 
> -EXPORT_SYMBOL(iov_iter_fault_in_readable);
> +EXPORT_SYMBOL(fault_in_iov_iter_readable);
> 
> Andreas Gruenbacher (15):
>   powerpc/kvm: Fix kvm_use_magic_page
>   gup: Turn fault_in_pages_{readable,writeable} into
>     fault_in_{readable,writeable}
>   iov_iter: Turn iov_iter_fault_in_readable into
>     fault_in_iov_iter_readable
>   iov_iter: Introduce fault_in_iov_iter_writeable
>   gfs2: Add wrapper for iomap_file_buffered_write
>   gfs2: Clean up function may_grant
>   gfs2: Move the inode glock locking to gfs2_file_buffered_write
>   gfs2: Eliminate ip->i_gh
>   gfs2: Fix mmap + page fault deadlocks for buffered I/O
>   iomap: Fix iomap_dio_rw return value for user copies
>   iomap: Support partial direct I/O on user copy failures
>   iomap: Add done_before argument to iomap_dio_rw
>   gup: Introduce FOLL_NOFAULT flag to disable page faults
>   iov_iter: Introduce nofault flag to disable page faults
>   gfs2: Fix mmap + page fault deadlocks for direct I/O
> 
> Bob Peterson (1):
>   gfs2: Introduce flag for glock holder auto-demotion
> 
> Filipe Manana (1):
>   btrfs: fix deadlock due to page faults during direct IO reads and
>     writes

If this patchset is backported, then at least the following two commits
must also be backported:

commit fe673d3f5bf1fc50cdc4b754831db91a2ec10126
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Mar 8 11:55:48 2022 -0800

    mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

commit ca93e44bfb5fd7996b76f0f544999171f647f93b
Author: Filipe Manana <fdmanana@suse.com>
Date:   Wed Mar 2 11:48:39 2022 +0000

    btrfs: fallback to blocking mode when doing async dio over multiple extents

Maybe there's more that need to be backported. So cc'ing Andreas in
case he's aware of any such other commits.

> 
>  arch/powerpc/kernel/kvm.c           |   3 +-
>  arch/powerpc/kernel/signal_32.c     |   4 +-
>  arch/powerpc/kernel/signal_64.c     |   2 +-
>  arch/x86/kernel/fpu/signal.c        |   7 +-
>  drivers/gpu/drm/armada/armada_gem.c |   7 +-
>  fs/btrfs/file.c                     | 142 ++++++++++--
>  fs/btrfs/ioctl.c                    |   5 +-
>  fs/erofs/data.c                     |   2 +-
>  fs/ext4/file.c                      |   5 +-
>  fs/f2fs/file.c                      |   2 +-
>  fs/fuse/file.c                      |   2 +-
>  fs/gfs2/bmap.c                      |  60 +----
>  fs/gfs2/file.c                      | 252 +++++++++++++++++++--
>  fs/gfs2/glock.c                     | 330 +++++++++++++++++++++-------
>  fs/gfs2/glock.h                     |  20 ++
>  fs/gfs2/incore.h                    |   4 +-
>  fs/iomap/buffered-io.c              |   2 +-
>  fs/iomap/direct-io.c                |  29 ++-
>  fs/ntfs/file.c                      |   2 +-
>  fs/ntfs3/file.c                     |   2 +-
>  fs/xfs/xfs_file.c                   |   6 +-
>  fs/zonefs/super.c                   |   4 +-
>  include/linux/iomap.h               |  11 +-
>  include/linux/mm.h                  |   3 +-
>  include/linux/pagemap.h             |  58 +----
>  include/linux/uio.h                 |   4 +-
>  lib/iov_iter.c                      |  98 +++++++--
>  mm/filemap.c                        |   4 +-
>  mm/gup.c                            | 139 +++++++++++-
>  29 files changed, 911 insertions(+), 298 deletions(-)
> 
> -- 
> 2.33.1
> 

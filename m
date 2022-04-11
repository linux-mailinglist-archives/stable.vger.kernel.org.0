Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAD54FB538
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240473AbiDKHvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245648AbiDKHvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:51:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE7C245A2;
        Mon, 11 Apr 2022 00:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E51EF61481;
        Mon, 11 Apr 2022 07:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C5CC385A4;
        Mon, 11 Apr 2022 07:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649663373;
        bh=BtY5SJaAmb/z5LHvIgaCPzuS0BSrv/D5lOTTxenPImc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xLB/mqzc9lEe+qqkDDMiQjRC/8wzWKWLT0tC2cv0L4H4FOZ06nbfeqyiup6iNQskb
         vkCDHdzBUM2gAJNupHtCwLNS3WqWTCWS5eix7uwm5n0ycwzeopk7ncxmUtaI9qGmtM
         rTxqUFiZWisRzpd1SyTqHdBRgnx/0Mpemr1I+dd0=
Date:   Mon, 11 Apr 2022 09:49:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Filipe Manana <fdmanana@kernel.org>, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, agruenba@redhat.com
Subject: Re: [PATCH 00/17 stable-5.15.y] Fix mmap + page fault deadlocks
Message-ID: <YlPdiqAxpS1HJDrc@kroah.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
 <Ykq9UXXZLTZOJ6N+@debian9.Home>
 <e9805474-f672-3c29-a294-0fce060037b5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9805474-f672-3c29-a294-0fce060037b5@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 07:32:11PM +0800, Anand Jain wrote:
> 
> 
> On 04/04/2022 17:41, Filipe Manana wrote:
> > On Sat, Apr 02, 2022 at 06:25:37PM +0800, Anand Jain wrote:
> > > This set fixes a process hang issue in btrfs and gf2 filesystems. When we
> > > do a direct IO read or write when the buffer given by the user is
> > > memory-mapped to the file range we are going to do IO, we end up ending
> > > in a deadlock. This is triggered by the test case generic/647 from
> > > fstests.
> > > 
> > > This fix depends on the iov_iter and iomap changes introduced in the
> > > commit c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2") and they
> > > are part of this set for stable-5.15.y.
> > > 
> > > Please note that patch 3/17 in this patchset changes the prototype and
> > > renames an exported symbol as below. All its references are updated as
> > > well.
> > > 
> > > -EXPORT_SYMBOL(iov_iter_fault_in_readable);
> > > +EXPORT_SYMBOL(fault_in_iov_iter_readable);
> > > 
> > > Andreas Gruenbacher (15):
> > >    powerpc/kvm: Fix kvm_use_magic_page
> > >    gup: Turn fault_in_pages_{readable,writeable} into
> > >      fault_in_{readable,writeable}
> > >    iov_iter: Turn iov_iter_fault_in_readable into
> > >      fault_in_iov_iter_readable
> > >    iov_iter: Introduce fault_in_iov_iter_writeable
> > >    gfs2: Add wrapper for iomap_file_buffered_write
> > >    gfs2: Clean up function may_grant
> > >    gfs2: Move the inode glock locking to gfs2_file_buffered_write
> > >    gfs2: Eliminate ip->i_gh
> > >    gfs2: Fix mmap + page fault deadlocks for buffered I/O
> > >    iomap: Fix iomap_dio_rw return value for user copies
> > >    iomap: Support partial direct I/O on user copy failures
> > >    iomap: Add done_before argument to iomap_dio_rw
> > >    gup: Introduce FOLL_NOFAULT flag to disable page faults
> > >    iov_iter: Introduce nofault flag to disable page faults
> > >    gfs2: Fix mmap + page fault deadlocks for direct I/O
> > > 
> > > Bob Peterson (1):
> > >    gfs2: Introduce flag for glock holder auto-demotion
> > > 
> > > Filipe Manana (1):
> > >    btrfs: fix deadlock due to page faults during direct IO reads and
> > >      writes
> > 
> > If this patchset is backported, then at least the following two commits
> > must also be backported:
> > 
> > commit fe673d3f5bf1fc50cdc4b754831db91a2ec10126
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Tue Mar 8 11:55:48 2022 -0800
> > 
> >      mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
> > 
> > commit ca93e44bfb5fd7996b76f0f544999171f647f93b
> > Author: Filipe Manana <fdmanana@suse.com>
> > Date:   Wed Mar 2 11:48:39 2022 +0000
> > 
> >      btrfs: fallback to blocking mode when doing async dio over multiple extents
> 
> Thanks for pointing it out.
> 
> > Maybe there's more that need to be backported. So cc'ing Andreas in
> > case he's aware of any such other commits.
> 
> I have scanned through the commits. I didn't find any further Fixes
> for this series.
> 
> I am sending these two patches in a new patch set as part2. Instead,
> if it is better, I am ok to include these and send v2.

Please rebase the series and send a whole new one as I think there will
be at least one change you can drop as it has been accepted already, and
trying to deal with two different patch series is hard for everyone
involved.

thanks,

greg k-h

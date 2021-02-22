Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505663214C5
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhBVLHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 06:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhBVLHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 06:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F98F64DD0;
        Mon, 22 Feb 2021 11:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613992027;
        bh=iYnfRJzuuvrWl9J1H0O2Vmbq4Mjay3jDy0pUgADT1TA=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=V8vXFAXWFYHGFNlYrF60BEVa5ruxXB/HPqXEaFkKHpSjXgHLLlPF9xS1SSkiMcgtf
         gbD1qL28fgqpFl1QMblL5wsp4n2SHX7MSKTrVaQLOsQgs6p9/Q0jIcrQBsyuXTnYmA
         7UpdvKJkIQhqhzatTAbAJ8IBt3E+XDpkYfA/IEjQ=
Date:   Mon, 22 Feb 2021 12:07:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, fdmanana@kernel.org, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 5.10.x] btrfs: fix crash after non-aligned direct IO
 write with O_DSYNC
Message-ID: <YDOQWY26qlJJ+r6H@kroah.com>
References: <94663c8a2172dc96b760d356a538d45c36f46040.1613062764.git.fdmanana@suse.com>
 <YCvbvJujcuiGcBSj@kroah.com>
 <20210216151546.GQ1993@twin.jikos.cz>
 <YCvmAz/gtKQwkqOc@kroah.com>
 <20210216175221.GS1993@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216175221.GS1993@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 06:52:21PM +0100, David Sterba wrote:
> On Tue, Feb 16, 2021 at 04:34:27PM +0100, Greg KH wrote:
> > On Tue, Feb 16, 2021 at 04:15:46PM +0100, David Sterba wrote:
> > > On Tue, Feb 16, 2021 at 03:50:36PM +0100, Greg KH wrote:
> > > > On Tue, Feb 16, 2021 at 02:40:31PM +0000, fdmanana@kernel.org wrote:
> > > > As this is a one-off patch, I need the btrfs maintainers to ack this and
> > > > really justify why we can't take the larger patch or patch series here
> > > > instead, as that is almost always the correct thing to do instead.
> > > 
> > > Acked-by: David Sterba <dsterba@suse.com>
> > > 
> > > The full backport would be patches
> > > 
> > > ecfdc08b8cc6 btrfs: remove dio iomap DSYNC workaround
> > > a42fa643169d btrfs: call iomap_dio_complete() without inode_lock
> > > 502756b38093 btrfs: remove btrfs_inode::dio_sem
> > > e9adabb9712e btrfs: use shared lock for direct writes within EOF
> > > c35237063340 btrfs: push inode locking and unlocking into buffered/direct write
> > > a14b78ad06ab btrfs: introduce btrfs_inode_lock()/unlock()
> > > b8d8e1fd570a btrfs: introduce btrfs_write_check()
> > > 
> > > and maybe more.
> > > 
> > > $ git diff b8d8e1fd570a^..ecfdc08b8cc6 | diffstat
> > >  btrfs_inode.h |   10 -
> > >  ctree.h       |    8 +
> > >  file.c        |  338 +++++++++++++++++++++++++++-------------------------------
> > >  inode.c       |   96 +++++++---------
> > >  transaction.h |    1 
> > >  5 files changed, 213 insertions(+), 240 deletions(-)
> > > 
> > > That seems too much for a backport, the fix Filipe implemented is
> > > simpler and IMO qualifies as the exceptional stable-only patch.
> > 
> > Why is that too much?  For 7 patches that's a small overall diffstat.
> > And you match identically what is upstream in Linus's tree.  That means
> > over time, backporting fixing is much easier, and understanding the code
> > for everyone is simpler.
> 
> The changes are not trivial and touch eg. inode locking and other
> subsystems (iomap), so they're not self contained inside btrfs. And the
> list of possibly related patches is not entirely known at this moment,
> the above is an example that was obvious, but Filipe has expressed
> doubts that it's complete and I agree.
> 
> Backporting them to 5.10.x would need same amount of testing and
> validation that the 5.11 version got during the whole development cycle.
> 
> > It's almost always better to track what is in Linus's tree than to do
> > one-off patches as 95% of the time we do one-off patches they are buggy
> > and cause problems as no one else is running them.
> 
> While I understand that concern in general, in this case it's trading
> changes by lots of code with a targeted fix with a reproducer, basically
> fixing the buggy error handling path.
> 
> > So how about sending the above backported series instead please.
> 
> Considering the risk I don't want to do that.

Ok, thanks, now queued up.

greg k-h

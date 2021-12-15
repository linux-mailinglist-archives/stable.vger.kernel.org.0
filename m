Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0F4759FC
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhLONxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:53:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbhLONxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:53:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2408A61880;
        Wed, 15 Dec 2021 13:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A06C34605;
        Wed, 15 Dec 2021 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639576380;
        bh=119VNzAkORctr7YTAuIIllmMzk6Q8fgrclgE8m6SNkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MvzWOk6XhmBaWfQ1JLHILwQa5aXsJWIJr4yNQTiHuZUXRJ+BxlNMIgZuzUknOwXD3
         Ym4Rq2lUyxvf92CmeyfiwmXr79YmhYqPiDa/RJBP1KEmHw2dte16IHOL+jJKEh4t1m
         VSNlRHmIlKI+zD1XPrl3el3o5cotEX9dmnLQ5uPM=
Date:   Wed, 15 Dec 2021 14:52:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ed Tsai <ed.tsai@mediatek.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        chenguanyou <chenguanyou9338@gmail.com>,
        Stanley Chu =?utf-8?B?KOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        Yong-xuan Wang =?utf-8?B?KOeOi+ipoOiQsSk=?= 
        <Yong-xuan.Wang@mediatek.com>
Subject: Re: [PATCH] [fuse] alloc_page nofs avoid deadlock
Message-ID: <YbnzOQx0TXADXWcW@kroah.com>
References: <20210603125242.31699-1-chenguanyou@xiaomi.com>
 <CAJfpegsEkRnU26Vvo4BTQUmx89Hahp6=RTuyEcPm=rqz8icwUQ@mail.gmail.com>
 <1fabb91167a86990f4723e9036a0e006293518f4.camel@mediatek.com>
 <CAJfpegsOSWZpKHqDNE_B489dGCzLr-RVAhimVOsFkxJwMYmj9A@mail.gmail.com>
 <07c5f2f1e10671bc462f88717f84aae9ee1e4d2b.camel@mediatek.com>
 <CAJfpegvAJS=An+hyAshkNcTS8A2TM28V2UP4SYycXUw3awOR+g@mail.gmail.com>
 <YVMz8E1Lg/GZQcjw@miu.piliscsaba.redhat.com>
 <0cd20f8c582dd0288472408800a02f6093000f1e.camel@mediatek.com>
 <YbhmF2mVUqNw16x9@kroah.com>
 <75833704ac3ffff38a781c582f144c34dcef0e16.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75833704ac3ffff38a781c582f144c34dcef0e16.camel@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 04:22:12PM +0800, Ed Tsai wrote:
> On Tue, 2021-12-14 at 17:38 +0800, Greg Kroah-Hartman wrote:
> > On Tue, Dec 14, 2021 at 05:25:01PM +0800, Ed Tsai wrote:
> > > On Tue, 2021-09-28 at 23:25 +0800, Miklos Szeredi wrote:
> > > > On Fri, Sep 24, 2021 at 09:52:35AM +0200, Miklos Szeredi wrote:
> > > > > On Fri, 24 Sept 2021 at 05:52, Ed Tsai <ed.tsai@mediatek.com>
> > > > > wrote:
> > > > > > 
> > > > > > On Wed, 2021-08-18 at 17:24 +0800, Miklos Szeredi wrote:
> > > > > > > On Tue, 13 Jul 2021 at 04:42, Ed Tsai <ed.tsai@mediatek.com
> > > > > > > >
> > > > > > > wrote:
> > > > > > > > 
> > > > > > > > On Tue, 2021-06-08 at 17:30 +0200, Miklos Szeredi wrote:
> > > > > > > > > On Thu, 3 Jun 2021 at 14:52, chenguanyou <
> > > > > > > > > chenguanyou9338@gmail.com>
> > > > > > > > > wrote:
> > > > > > > > > > 
> > > > > > > > > > ABA deadlock
> > > > > > > > > > 
> > > > > > > > > > PID: 17172 TASK: ffffffc0c162c000 CPU: 6 COMMAND:
> > > > > > > > > > "Thread-21"
> > > > > > > > > > 0 [ffffff802d16b400] __switch_to at ffffff8008086a4c
> > > > > > > > > > 1 [ffffff802d16b470] __schedule at ffffff80091ffe58
> > > > > > > > > > 2 [ffffff802d16b4d0] schedule at ffffff8009200348
> > > > > > > > > > 3 [ffffff802d16b4f0] bit_wait at ffffff8009201098
> > > > > > > > > > 4 [ffffff802d16b510] __wait_on_bit at
> > > > > > > > > > ffffff8009200a34
> > > > > > > > > > 5 [ffffff802d16b5b0] inode_wait_for_writeback at
> > > > > > > > > > ffffff800830e1e8
> > > > > > > > > > 6 [ffffff802d16b5e0] evict at ffffff80082fb15c
> > > > > > > > > > 7 [ffffff802d16b620] iput at ffffff80082f9270
> > > > > > > > > > 8 [ffffff802d16b680] dentry_unlink_inode at
> > > > > > > > > > ffffff80082f4c90
> > > > > > > > > > 9 [ffffff802d16b6a0] __dentry_kill at
> > > > > > > > > > ffffff80082f1710
> > > > > > > > > > 10 [ffffff802d16b6d0] shrink_dentry_list at
> > > > > > > > > > ffffff80082f1c34
> > > > > > > > > > 11 [ffffff802d16b750] prune_dcache_sb at
> > > > > > > > > > ffffff80082f18a8
> > > > > > > > > > 12 [ffffff802d16b770] super_cache_scan at
> > > > > > > > > > ffffff80082d55ac
> > > > > > > > > > 13 [ffffff802d16b860] shrink_slab at ffffff8008266170
> > > > > > > > > > 14 [ffffff802d16b900] shrink_node at ffffff800826b420
> > > > > > > > > > 15 [ffffff802d16b980] do_try_to_free_pages at
> > > > > > > > > > ffffff8008268460
> > > > > > > > > > 16 [ffffff802d16ba60] try_to_free_pages at
> > > > > > > > > > ffffff80082680d0
> > > > > > > > > > 17 [ffffff802d16bbe0] __alloc_pages_nodemask at
> > > > > > > > > > ffffff8008256514
> > > > > > > > > > 18 [ffffff802d16bc60] fuse_copy_fill at
> > > > > > > > > > ffffff8008438268
> > > > > > > > > > 19 [ffffff802d16bd00] fuse_dev_do_read at
> > > > > > > > > > ffffff8008437654
> > > > > > > > > > 20 [ffffff802d16bdc0] fuse_dev_splice_read at
> > > > > > > > > > ffffff8008436f40
> > > > > > > > > > 21 [ffffff802d16be60] sys_splice at ffffff8008315d18
> > > > > > > > > > 22 [ffffff802d16bff0] __sys_trace at ffffff8008084014
> > > > > > > > > > 
> > > > > > > > > > PID: 9652 TASK: ffffffc0c9ce0000 CPU: 4 COMMAND:
> > > > > > > > > > "kworker/u16:8"
> > > > > > > > > > 0 [ffffff802e793650] __switch_to at ffffff8008086a4c
> > > > > > > > > > 1 [ffffff802e7936c0] __schedule at ffffff80091ffe58
> > > > > > > > > > 2 [ffffff802e793720] schedule at ffffff8009200348
> > > > > > > > > > 3 [ffffff802e793770] __fuse_request_send at
> > > > > > > > > > ffffff8008435760
> > > > > > > > > > 4 [ffffff802e7937b0] fuse_simple_request at
> > > > > > > > > > ffffff8008435b14
> > > > > > > > > > 5 [ffffff802e793930] fuse_flush_times at
> > > > > > > > > > ffffff800843a7a0
> > > > > > > > > > 6 [ffffff802e793950] fuse_write_inode at
> > > > > > > > > > ffffff800843e4dc
> > > > > > > > > > 7 [ffffff802e793980] __writeback_single_inode at
> > > > > > > > > > ffffff8008312740
> > > > > > > > > > 8 [ffffff802e793aa0] writeback_sb_inodes at
> > > > > > > > > > ffffff80083117e4
> > > > > > > > > > 9 [ffffff802e793b00] __writeback_inodes_wb at
> > > > > > > > > > ffffff8008311d98
> > > > > > > > > > 10 [ffffff802e793c00] wb_writeback at
> > > > > > > > > > ffffff8008310cfc
> > > > > > > > > > 11 [ffffff802e793d00] wb_workfn at ffffff800830e4a8
> > > > > > > > > > 12 [ffffff802e793d90] process_one_work at
> > > > > > > > > > ffffff80080e4fac
> > > > > > > > > > 13 [ffffff802e793e00] worker_thread at
> > > > > > > > > > ffffff80080e5670
> > > > > > > > > > 14 [ffffff802e793e60] kthread at ffffff80080eb650
> > > > > > > > > 
> > > > > > > > > The issue is real.
> > > > > > > > > 
> > > > > > > > > The fix, however, is not the right one.  The
> > > > > > > > > fundamental
> > > > > > > > > problem
> > > > > > > > > is
> > > > > > > > > that fuse_write_inode() blocks on a request to
> > > > > > > > > userspace.
> > > > > > > > > 
> > > > > > > > > This is the same issue that
> > > > > > > > > fuse_writepage/fuse_writepages
> > > > > > > > > face.  In
> > > > > > > > > that case the solution was to copy the page contents to
> > > > > > > > > a
> > > > > > > > > temporary
> > > > > > > > > buffer and return immediately as if the writeback
> > > > > > > > > already
> > > > > > > > > completed.
> > > > > > > > > 
> > > > > > > > > Something similar needs to be done here: send the
> > > > > > > > > FUSE_SETATTR
> > > > > > > > > request
> > > > > > > > > asynchronously and return immediately from
> > > > > > > > > fuse_write_inode().  The
> > > > > > > > > tricky part is to make sure that multiple time updates
> > > > > > > > > for
> > > > > > > > > the
> > > > > > > > > same
> > > > > > > > > inode aren't mixed up...
> > > > > > > > > 
> > > > > > > > > Thanks,
> > > > > > > > > Miklos
> > > > > > > > 
> > > > > > > > Dear Szeredi,
> > > > > > > > 
> > > > > > > > Writeback thread calls fuse_write_inode() and wait for
> > > > > > > > user
> > > > > > > > Daemon
> > > > > > > > to
> > > > > > > > complete this write inode request. The user daemon will
> > > > > > > > alloc_page()
> > > > > > > > after taking this request, and a deadlock could happen
> > > > > > > > when
> > > > > > > > we try
> > > > > > > > to
> > > > > > > > shrink dentry list under memory pressure.
> > > > > > > > 
> > > > > > > > We (Mediatek) glad to work on this issue for mainline and
> > > > > > > > also LTS.
> > > > > > > > So
> > > > > > > > another problem is that we should not change the protocol
> > > > > > > > or
> > > > > > > > feature
> > > > > > > > for stable kernel.
> > > > > > > > 
> > > > > > > > Use GFP_NOFS | __GFP_HIGHMEM can really avoid this by
> > > > > > > > skip
> > > > > > > > the
> > > > > > > > dentry
> > > > > > > > shirnker. It works but degrade the alloc_page success
> > > > > > > > rate.
> > > > > > > > In a
> > > > > > > > more
> > > > > > > > fundamental way, we could cache the contents and return
> > > > > > > > immediately.
> > > > > > > > But how to ensure the request will be done successfully,
> > > > > > > > e.g.,
> > > > > > > > always
> > > > > > > > retry if it fails from daemon.
> > > > > > > 
> > > > > > > Key is where the the dirty metadata is flushed.  To prevent
> > > > > > > deadlock
> > > > > > > it must not be flushed from memory reclaim, so must make
> > > > > > > sure
> > > > > > > that it
> > > > > > > is flushed on close(2) and munmap(2) and not dirtied after
> > > > > > > that.
> > > > > > > 
> > > > > > > I'm working on this currently and hope to get it ready for
> > > > > > > the
> > > > > > > next
> > > > > > > merge window.
> > > > > > > 
> > > > > > > Thanks,
> > > > > > > Miklos
> > > > > > 
> > > > > > Hi Miklos,
> > > > > > 
> > > > > > I'm not sure whether it has already been resolved in
> > > > > > mainline.
> > > > > > If it still WIP, please cc me on future emails.
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > This is taking a bit longer, unfortunately, but I already have
> > > > > something in testing and currently cleaning it up for
> > > > > review.  Hope
> > > > > to
> > > > > post a series today or early next week.
> > > > 
> > > > 
> > > > Here's a minimal patch.  It's been through some iterations and
> > > > some
> > > > testing, but
> > > > more review and testing is definitely welcome.
> > > > 
> > > > Chenguanyou, can you please verify that it fixes the deadlock?
> > > > 
> > > > Thanks,
> > > > Miklos
> > > > 
> > > > ---
> > > > From: Miklos Szeredi <mszeredi@redhat.com>
> > > > Subject: fuse: make sure reclaim doesn't write the inode
> > > > 
> > > > In writeback cache mode mtime/ctime updates are cached, and
> > > > flushed
> > > > to the
> > > > server using the ->write_inode() callback.
> > > > 
> > > > Closing the file will result in a dirty inode being immediately
> > > > written,
> > > > but in other cases the inode can remain dirty after all
> > > > references
> > > > are
> > > > dropped.  This result in the inode being written back from
> > > > reclaim,
> > > > which
> > > > can deadlock on a regular allocation while the request is being
> > > > served.
> > > > 
> > > > The usual mechanisms (GFP_NOFS/PF_MEMALLOC*) don't work for FUSE,
> > > > because
> > > > serving a request involves unrelated userspace process(es).
> > > > 
> > > > Instead do the same as for dirty pages: make sure the inode is
> > > > written
> > > > before the last reference is gone.
> > > > 
> > > >  - fuse_vma_close(): flush times in addition to the dirty pages
> > > > 
> > > >  - fallocate(2)/copy_file_range(2): these call file_update_time()
> > > > or
> > > >    file_modified(), so flush the inode before returning from the
> > > > call
> > > > 
> > > >  - unlink(2), link(2) and rename(2): these call
> > > > fuse_update_ctime(),
> > > > so
> > > >    flush the ctime directly from this helper
> > > > 
> > > > Reported-by: chenguanyou <chenguanyou@xiaomi.com>
> > > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > > > ---
> > > >  fs/fuse/dir.c    |    8 ++++++++
> > > >  fs/fuse/file.c   |   24 +++++++++++++++++++++---
> > > >  fs/fuse/fuse_i.h |    1 +
> > > >  3 files changed, 30 insertions(+), 3 deletions(-)
> > > > 
> > > > --- a/fs/fuse/dir.c
> > > > +++ b/fs/fuse/dir.c
> > > > @@ -738,12 +738,20 @@ static int fuse_symlink(struct user_name
> > > >  	return create_new_entry(fm, &args, dir, entry, S_IFLNK);
> > > >  }
> > > >  
> > > > +void fuse_flush_time_update(struct inode *inode)
> > > > +{
> > > > +	int err = sync_inode_metadata(inode, 1);
> > > > +
> > > > +	mapping_set_error(inode->i_mapping, err);
> > > > +}
> > > > +
> > > >  void fuse_update_ctime(struct inode *inode)
> > > >  {
> > > >  	fuse_invalidate_attr(inode);
> > > >  	if (!IS_NOCMTIME(inode)) {
> > > >  		inode->i_ctime = current_time(inode);
> > > >  		mark_inode_dirty_sync(inode);
> > > > +		fuse_flush_time_update(inode);
> > > >  	}
> > > >  }
> > > >  
> > > > --- a/fs/fuse/file.c
> > > > +++ b/fs/fuse/file.c
> > > > @@ -1847,6 +1847,17 @@ int fuse_write_inode(struct inode *inode
> > > >  	struct fuse_file *ff;
> > > >  	int err;
> > > >  
> > > > +	/*
> > > > +	 * Inode is always written before the last reference is dropped
> > > > and
> > > > +	 * hence this should not be reached from reclaim.
> > > > +	 *
> > > > +	 * Writing back the inode from reclaim can deadlock if the
> > > > request
> > > > +	 * processing itself needs an allocation.  Allocations
> > > > triggering
> > > > +	 * reclaim while serving a request can't be prevented, because
> > > > it can
> > > > +	 * involve any number of unrelated userspace processes.
> > > > +	 */
> > > > +	WARN_ON(wbc->for_reclaim);
> > > > +
> > > >  	ff = __fuse_write_file_get(fi);
> > > >  	err = fuse_flush_times(inode, ff);
> > > >  	if (ff)
> > > > @@ -2339,12 +2350,15 @@ static int fuse_launder_page(struct page
> > > >  }
> > > >  
> > > >  /*
> > > > - * Write back dirty pages now, because there may not be any
> > > > suitable
> > > > - * open files later
> > > > + * Write back dirty data/metadata now (there may not be any
> > > > suitable
> > > > + * open files later for data)
> > > >   */
> > > >  static void fuse_vma_close(struct vm_area_struct *vma)
> > > >  {
> > > > -	filemap_write_and_wait(vma->vm_file->f_mapping);
> > > > +	int err;
> > > > +
> > > > +	err = write_inode_now(vma->vm_file->f_mapping->host, 1);
> > > > +	mapping_set_error(vma->vm_file->f_mapping, err);
> > > >  }
> > > >  
> > > >  /*
> > > > @@ -3001,6 +3015,8 @@ static long fuse_file_fallocate(struct f
> > > >  	if (lock_inode)
> > > >  		inode_unlock(inode);
> > > >  
> > > > +	fuse_flush_time_update(inode);
> > > > +
> > > >  	return err;
> > > >  }
> > > >  
> > > > @@ -3110,6 +3126,8 @@ static ssize_t __fuse_copy_file_range(st
> > > >  	inode_unlock(inode_out);
> > > >  	file_accessed(file_in);
> > > >  
> > > > +	fuse_flush_time_update(inode_out);
> > > > +
> > > >  	return err;
> > > >  }
> > > >  
> > > > --- a/fs/fuse/fuse_i.h
> > > > +++ b/fs/fuse/fuse_i.h
> > > > @@ -1145,6 +1145,7 @@ int fuse_allow_current_process(struct fu
> > > >  
> > > >  u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
> > > >  
> > > > +void fuse_flush_time_update(struct inode *inode);
> > > >  void fuse_update_ctime(struct inode *inode);
> > > >  
> > > >  int fuse_update_attributes(struct inode *inode, struct file
> > > > *file);
> > > 
> > > Hi Mikloz, Greg,
> > > 
> > > This deadlock issue could be raised in high memory pressure and the
> > > patch has been merged in commit 5c791fe ("fuse: make sure reclaim
> > > doesn't write the inode").
> > > 
> > > Can we take it to the LTS version?
> > 
> > What kernel tree(s) do you want this backported to?  Have you tested
> > it
> > that it will apply cleanly and work?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg, I want to take this commit to 5.10 LTS. This can be work to
> resolve the deadlock issue. Also, I have done some monkey tests on our
> ACK 5.10 phone to confirm the stability.

Queued up for 5.15.y and 5.10.y now, thanks.

greg k-h

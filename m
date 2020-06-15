Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7B91F8F26
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 09:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgFOHPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 03:15:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:52616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgFOHPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 03:15:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7244ADC1;
        Mon, 15 Jun 2020 07:15:44 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3D6351E1289; Mon, 15 Jun 2020 09:15:40 +0200 (CEST)
Date:   Mon, 15 Jun 2020 09:15:40 +0200
From:   Jan Kara <jack@suse.cz>
To:     Martijn Coenen <maco@android.com>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] writeback: Avoid skipping inode writeback
Message-ID: <20200615071540.GB9449@quack2.suse.cz>
References: <20200611075033.1248-1-jack@suse.cz>
 <20200611081203.18161-2-jack@suse.cz>
 <CAB0TPYFOtDdS8BRk6aMhhB_5nxw4N7unqHCjgLFNh=YZC3vywA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB0TPYFOtDdS8BRk6aMhhB_5nxw4N7unqHCjgLFNh=YZC3vywA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 12-06-20 10:03:18, Martijn Coenen wrote:
> Hi Jan,
> 
> On Thu, Jun 11, 2020 at 10:12 AM Jan Kara <jack@suse.cz> wrote:
> > Reported-by: Martijn Coenen <maco@android.com>
> > Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Thanks again for the fix. We've been running this (well, v1) for over
> 2 weeks across at least ~1000 Android devices with different kernel
> versions, and I can confirm we haven't run into the issue this intends
> to fix, or any other issues for that matter. The patch LGTM as well.
> 
> Reviewed-by: Martijn Coenen <maco@android.com>
> Tested-by: Martijn Coenen <maco@android.com>

Thanks for testing and review! I'll queue the patches in my tree and push
them to Linus later this week.

								Honza


> 
> > ---
> >  fs/fs-writeback.c  | 17 ++++++++++++-----
> >  include/linux/fs.h |  8 ++++++--
> >  2 files changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index ff0b18331590..f470c10641c5 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -146,6 +146,7 @@ static void inode_io_list_del_locked(struct inode *inode,
> >         assert_spin_locked(&wb->list_lock);
> >         assert_spin_locked(&inode->i_lock);
> >
> > +       inode->i_state &= ~I_SYNC_QUEUED;
> >         list_del_init(&inode->i_io_list);
> >         wb_io_lists_depopulated(wb);
> >  }
> > @@ -1187,6 +1188,7 @@ static void redirty_tail_locked(struct inode *inode, struct bdi_writeback *wb)
> >                         inode->dirtied_when = jiffies;
> >         }
> >         inode_io_list_move_locked(inode, wb, &wb->b_dirty);
> > +       inode->i_state &= ~I_SYNC_QUEUED;
> >  }
> >
> >  static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
> > @@ -1262,8 +1264,11 @@ static int move_expired_inodes(struct list_head *delaying_queue,
> >                         break;
> >                 list_move(&inode->i_io_list, &tmp);
> >                 moved++;
> > +               spin_lock(&inode->i_lock);
> >                 if (flags & EXPIRE_DIRTY_ATIME)
> > -                       set_bit(__I_DIRTY_TIME_EXPIRED, &inode->i_state);
> > +                       inode->i_state |= I_DIRTY_TIME_EXPIRED;
> > +               inode->i_state |= I_SYNC_QUEUED;
> > +               spin_unlock(&inode->i_lock);
> >                 if (sb_is_blkdev_sb(inode->i_sb))
> >                         continue;
> >                 if (sb && sb != inode->i_sb)
> > @@ -1438,6 +1443,7 @@ static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
> >         } else if (inode->i_state & I_DIRTY_TIME) {
> >                 inode->dirtied_when = jiffies;
> >                 inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
> > +               inode->i_state &= ~I_SYNC_QUEUED;
> >         } else {
> >                 /* The inode is clean. Remove from writeback lists. */
> >                 inode_io_list_del_locked(inode, wb);
> > @@ -2301,11 +2307,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
> >                 inode->i_state |= flags;
> >
> >                 /*
> > -                * If the inode is being synced, just update its dirty state.
> > -                * The unlocker will place the inode on the appropriate
> > -                * superblock list, based upon its state.
> > +                * If the inode is queued for writeback by flush worker, just
> > +                * update its dirty state. Once the flush worker is done with
> > +                * the inode it will place it on the appropriate superblock
> > +                * list, based upon its state.
> >                  */
> > -               if (inode->i_state & I_SYNC)
> > +               if (inode->i_state & I_SYNC_QUEUED)
> >                         goto out_unlock_inode;
> >
> >                 /*
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 19ef6c88c152..48556efcdcf0 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2157,6 +2157,10 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
> >   *
> >   * I_DONTCACHE         Evict inode as soon as it is not used anymore.
> >   *
> > + * I_SYNC_QUEUED       Inode is queued in b_io or b_more_io writeback lists.
> > + *                     Used to detect that mark_inode_dirty() should not move
> > + *                     inode between dirty lists.
> > + *
> >   * Q: What is the difference between I_WILL_FREE and I_FREEING?
> >   */
> >  #define I_DIRTY_SYNC           (1 << 0)
> > @@ -2174,12 +2178,12 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
> >  #define I_DIO_WAKEUP           (1 << __I_DIO_WAKEUP)
> >  #define I_LINKABLE             (1 << 10)
> >  #define I_DIRTY_TIME           (1 << 11)
> > -#define __I_DIRTY_TIME_EXPIRED 12
> > -#define I_DIRTY_TIME_EXPIRED   (1 << __I_DIRTY_TIME_EXPIRED)
> > +#define I_DIRTY_TIME_EXPIRED   (1 << 12)
> >  #define I_WB_SWITCH            (1 << 13)
> >  #define I_OVL_INUSE            (1 << 14)
> >  #define I_CREATING             (1 << 15)
> >  #define I_DONTCACHE            (1 << 16)
> > +#define I_SYNC_QUEUED          (1 << 17)
> >
> >  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
> >  #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
> > --
> > 2.16.4
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

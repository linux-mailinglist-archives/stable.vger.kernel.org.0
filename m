Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E22340FE
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfFDIAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:00:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:32862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726792AbfFDIAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 04:00:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D685AAEB5;
        Tue,  4 Jun 2019 08:00:43 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 76BD51E3C24; Tue,  4 Jun 2019 10:00:43 +0200 (CEST)
Date:   Tue, 4 Jun 2019 10:00:43 +0200
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ext4 <linux-ext4@vger.kernel.org>,
        Ted Tso <tytso@mit.edu>, Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/2] mm: Add readahead file operation
Message-ID: <20190604080043.GL27933@quack2.suse.cz>
References: <20190603132155.20600-1-jack@suse.cz>
 <20190603132155.20600-2-jack@suse.cz>
 <CAOQ4uxibr6_k2T_0BeC7XAOnuX1PHmEmBjFwfzkVJVh17YAqrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxibr6_k2T_0BeC7XAOnuX1PHmEmBjFwfzkVJVh17YAqrw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 03-06-19 19:16:59, Amir Goldstein wrote:
> On Mon, Jun 3, 2019 at 4:22 PM Jan Kara <jack@suse.cz> wrote:
> >
> > Some filesystems need to acquire locks before pages are read into page
> > cache to protect from races with hole punching. The lock generally
> > cannot be acquired within readpage as it ranks above page lock so we are
> > left with acquiring the lock within filesystem's ->read_iter
> > implementation for normal reads and ->fault implementation during page
> > faults. That however does not cover all paths how pages can be
> > instantiated within page cache - namely explicitely requested readahead.
> > Add new ->readahead file operation which filesystem can use for this.
> >
> > CC: stable@vger.kernel.org # Needed by following ext4 fix
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  include/linux/fs.h |  5 +++++
> >  include/linux/mm.h |  3 ---
> >  mm/fadvise.c       | 12 +-----------
> >  mm/madvise.c       |  3 ++-
> >  mm/readahead.c     | 26 ++++++++++++++++++++++++--
> >  5 files changed, 32 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index f7fdfe93e25d..9968abcd06ea 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1828,6 +1828,7 @@ struct file_operations {
> >                                    struct file *file_out, loff_t pos_out,
> >                                    loff_t len, unsigned int remap_flags);
> >         int (*fadvise)(struct file *, loff_t, loff_t, int);
> > +       int (*readahead)(struct file *, loff_t, loff_t);
> 
> The new method is redundant, because it is a subset of fadvise.
> When overlayfs needed to implement both methods, Miklos
> suggested that we unite them into one, hence:
> 3d8f7615319b vfs: implement readahead(2) using POSIX_FADV_WILLNEED

Yes, I've noticed this.

> So you can accomplish the ext4 fix without the new method.
> All you need extra is implementing madvise_willneed() with vfs_fadvise().

Ah, that's an interesting idea. I'll try that out. It will require some
dance in madvise() to drop mmap_sem but we already do that for
madvise_free() so I can just duplicate that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A6C1F57D9
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 17:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgFJPa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 11:30:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:58726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgFJPa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 11:30:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 312A4AC7F;
        Wed, 10 Jun 2020 15:31:01 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EE0C91E1283; Wed, 10 Jun 2020 17:30:56 +0200 (CEST)
Date:   Wed, 10 Jun 2020 17:30:56 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        Ted Tso <tytso@mit.edu>, Martijn Coenen <maco@android.com>,
        tj@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: Avoid skipping inode writeback
Message-ID: <20200610153056.GA20677@quack2.suse.cz>
References: <20200601091202.31302-1-jack@suse.cz>
 <20200601091904.4786-1-jack@suse.cz>
 <20200610150203.GA21733@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610150203.GA21733@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 10-06-20 08:02:03, Christoph Hellwig wrote:
> This generall looks ok, but a few nitpicks below:
> 
> > -static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
> > +static void __redirty_tail(struct inode *inode, struct bdi_writeback *wb)
> 
> I think redirty_tail_locked would be a more decriptive name, and also
> fit other uses in this file (e.g. inode_io_list_move_locked and
> inode_io_list_del_locked).

Fair enough, will do.

> >  {
> > +	assert_spin_locked(&inode->i_lock);
> >  	if (!list_empty(&wb->b_dirty)) {
> 
> Nit: I find an empty line after asserts and before the real code starts
> nice on the eye.

Sure.

> >  			break;
> >  		list_move(&inode->i_io_list, &tmp);
> >  		moved++;
> > +		spin_lock(&inode->i_lock);
> >  		if (flags & EXPIRE_DIRTY_ATIME)
> > -			set_bit(__I_DIRTY_TIME_EXPIRED, &inode->i_state);
> > +			inode->i_state |= I_DIRTY_TIME_EXPIRED;
> > +		inode->i_state |= I_SYNC_QUEUED;
> > +		spin_unlock(&inode->i_lock);
> 
> I wonder if the locking changes should go into a prep patch vs the
> actual logic changes related to I_SYNC_QUEUED?  That would untangle
> the patch quite a bit and make it easier to follow.

OK, will do.
 
> >  #define I_WB_SWITCH		(1 << 13)
> >  #define I_OVL_INUSE		(1 << 14)
> >  #define I_CREATING		(1 << 15)
> > +#define I_SYNC_QUEUED		(1 << 16)
> 
> FYI, this conflicts with the I_DONTCAT addition in mainline now.

Yup, I've already found out when rebasing...

Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FEF3ED091
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhHPIvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234025AbhHPIvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F31E61AAB;
        Mon, 16 Aug 2021 08:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629103868;
        bh=ciSIBhOeQD+iLy6vUr0sXrU3k0nsj8ZsQ4cn75As4FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VwbEv2LdYI2vpiGqnJS3n/J9xj2D+LUh/U0JyO9kgM6RSwFdrBTzNgkGiuvJjmvKc
         ZHQtNYxHag31R1koUQqUL/uThdBKzYA2KH6V5c6/jv8OifmYSVO5lmzc4jVqTVsk/y
         JwUpnDhVN/D5EhCKGM/xjJXdNsygAOaXj4FoNejU=
Date:   Mon, 16 Aug 2021 10:51:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, lhenriques@suse.de, mnelson@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ceph: take snap_empty_lock atomically
 with snaprealm refcount" failed to apply to 5.13-stable tree
Message-ID: <YRom+nlUUZhdO6k1@kroah.com>
References: <162903121195232@kroah.com>
 <97e1f7dfb46c148144eca610c7b4cc50de948fcf.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97e1f7dfb46c148144eca610c7b4cc50de948fcf.camel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 15, 2021 at 09:50:48AM -0400, Jeff Layton wrote:
> On Sun, 2021-08-15 at 14:40 +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.13-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 8434ffe71c874b9c4e184b88d25de98c2bf5fe3f Mon Sep 17 00:00:00 2001
> > From: Jeff Layton <jlayton@kernel.org>
> > Date: Tue, 3 Aug 2021 12:47:34 -0400
> > Subject: [PATCH] ceph: take snap_empty_lock atomically with snaprealm refcount
> >  change
> > 
> > There is a race in ceph_put_snap_realm. The change to the nref and the
> > spinlock acquisition are not done atomically, so you could decrement
> > nref, and before you take the spinlock, the nref is incremented again.
> > At that point, you end up putting it on the empty list when it
> > shouldn't be there. Eventually __cleanup_empty_realms runs and frees
> > it when it's still in-use.
> > 
> > Fix this by protecting the 1->0 transition with atomic_dec_and_lock,
> > and just drop the spinlock if we can get the rwsem.
> > 
> > Because these objects can also undergo a 0->1 refcount transition, we
> > must protect that change as well with the spinlock. Increment locklessly
> > unless the value is at 0, in which case we take the spinlock, increment
> > and then take it off the empty list if it did the 0->1 transition.
> > 
> > With these changes, I'm removing the dout() messages from these
> > functions, as well as in __put_snap_realm. They've always been racy, and
> > it's better to not print values that may be misleading.
> > 
> > Cc: stable@vger.kernel.org
> > URL: https://tracker.ceph.com/issues/46419
> > Reported-by: Mark Nelson <mnelson@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > Reviewed-by: Luis Henriques <lhenriques@suse.de>
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index 4ac0606dcbd4..4c6bd1042c94 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -67,19 +67,19 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
> >  {
> >  	lockdep_assert_held(&mdsc->snap_rwsem);
> >  
> > -	dout("get_realm %p %d -> %d\n", realm,
> > -	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
> >  	/*
> > -	 * since we _only_ increment realm refs or empty the empty
> > -	 * list with snap_rwsem held, adjusting the empty list here is
> > -	 * safe.  we do need to protect against concurrent empty list
> > -	 * additions, however.
> > +	 * The 0->1 and 1->0 transitions must take the snap_empty_lock
> > +	 * atomically with the refcount change. Go ahead and bump the
> > +	 * nref here, unless it's 0, in which case we take the spinlock
> > +	 * and then do the increment and remove it from the list.
> >  	 */
> > -	if (atomic_inc_return(&realm->nref) == 1) {
> > -		spin_lock(&mdsc->snap_empty_lock);
> > +	if (atomic_inc_not_zero(&realm->nref))
> > +		return;
> > +
> > +	spin_lock(&mdsc->snap_empty_lock);
> > +	if (atomic_inc_return(&realm->nref) == 1)
> >  		list_del_init(&realm->empty_item);
> > -		spin_unlock(&mdsc->snap_empty_lock);
> > -	}
> > +	spin_unlock(&mdsc->snap_empty_lock);
> >  }
> >  
> >  static void __insert_snap_realm(struct rb_root *root,
> > @@ -208,28 +208,28 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
> >  {
> >  	lockdep_assert_held_write(&mdsc->snap_rwsem);
> >  
> > -	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> > -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> > +	/*
> > +	 * We do not require the snap_empty_lock here, as any caller that
> > +	 * increments the value must hold the snap_rwsem.
> > +	 */
> >  	if (atomic_dec_and_test(&realm->nref))
> >  		__destroy_snap_realm(mdsc, realm);
> >  }
> >  
> >  /*
> > - * caller needn't hold any locks
> > + * See comments in ceph_get_snap_realm. Caller needn't hold any locks.
> >   */
> >  void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
> >  			 struct ceph_snap_realm *realm)
> >  {
> > -	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> > -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> > -	if (!atomic_dec_and_test(&realm->nref))
> > +	if (!atomic_dec_and_lock(&realm->nref, &mdsc->snap_empty_lock))
> >  		return;
> >  
> >  	if (down_write_trylock(&mdsc->snap_rwsem)) {
> > +		spin_unlock(&mdsc->snap_empty_lock);
> >  		__destroy_snap_realm(mdsc, realm);
> >  		up_write(&mdsc->snap_rwsem);
> >  	} else {
> > -		spin_lock(&mdsc->snap_empty_lock);
> >  		list_add(&realm->empty_item, &mdsc->snap_empty);
> >  		spin_unlock(&mdsc->snap_empty_lock);
> >  	}
> > 
> 
> Ahh, I forgot to account for some new lockdep annotation when I marked
> these for stable. I think what we should probably do here is cherry-pick
> these as prerequisites before applying:
> 
>     a6862e6708c1 ceph: add some lockdep assertions around snaprealm handling
>     df2c0cb7f8e8 ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm
> 
> The first one should fix up the merge conflict, and the second will fix
> up a couple of bogus lockdep warnings that pop up from a6862e6708c1.
> 
> Greg, does that sound OK? 

Yup, that worked, all now queued up, thanks!

greg k-h

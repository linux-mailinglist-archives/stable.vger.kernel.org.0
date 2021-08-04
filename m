Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0B93E05FD
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbhHDQdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 12:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229743AbhHDQdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 12:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEB6060F0F;
        Wed,  4 Aug 2021 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628094776;
        bh=3n8u08rVXzR9o8j6IL8MF4txcxND9WHMAjGdli+PYQo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WKk2lGdm7CK0WLvFKUTG41vXfNlf164xmHd1PN4/LItxHmtG6uLErcx9wQCiKXpcT
         UT5hgN27OFeNgRg88NzgB2ncP4z5TAuq1AiFJPKeuKU2p5x1b3OTcFQ7moMXx05kGa
         0yfy3JZlWHQKFB6Ov33o/8prWRuJE6DJC+eNoFgwwLN1kG3CVaN3rwR5FRnflg1hFt
         8sPJmKAPePH4t4JKmQguWKsC9HPqXEibRgO6inDdPt78m9NIxttkRltuZK+v/CzJ9T
         g4EuQLiyDpDgnAhKCIil8OlNsrZK1pbJF/r7Kk1F1XgI10z1pX71ud7IyMb79Gb/kY
         +bRGGd9F0SxGA==
Message-ID: <a7566b1207ab66f4bdbeef8b653e97d5849a177f.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: ensure we take snap_empty_lock atomically with
 snaprealm refcount change
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        stable@vger.kernel.org, Sage Weil <sage@redhat.com>,
        Mark Nelson <mnelson@redhat.com>
Date:   Wed, 04 Aug 2021 12:32:54 -0400
In-Reply-To: <87o8adi3bo.fsf@suse.de>
References: <20210804155515.28984-1-jlayton@kernel.org>
         <87o8adi3bo.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-08-04 at 17:26 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > There is a race in ceph_put_snap_realm. The change to the nref and the
> > spinlock acquisition are not done atomically, so you could decrement nref,
> > and before you take the spinlock, the nref is incremented again. At that
> > point, you end up putting it on the empty list when it shouldn't be
> > there. Eventually __cleanup_empty_realms runs and frees it when it's
> > still in-use.
> > 
> > Fix this by protecting the 1->0 transition with atomic_dec_and_lock, and
> > just drop the spinlock if we can get the rwsem.
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
> > Cc: Sage Weil <sage@redhat.com>
> > Reported-by: Mark Nelson <mnelson@redhat.com>
> > URL: https://tracker.ceph.com/issues/46419
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/snap.c | 34 +++++++++++++++++-----------------
> >  1 file changed, 17 insertions(+), 17 deletions(-)
> > 
> > v2: No functional changes, but I cleaned up the comments a bit and
> >     added another in __put_snap_realm.
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index 9dbc92cfda38..158c11e96fb7 100644
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
> > +	if (atomic_add_unless(&realm->nref, 1, 0))
> 
> Here you could probably use atomic_inc_not_zero() instead.  But other
> than that it looks good.  Thanks a lot for solving yet another locking
> puzzle!
> 
> Reviewed-by: Luis Henriques <lhenriques@suse.de>
> 
> Cheers,

Good point! That is a little clearer. I'll incorporate that change and
merge it.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>


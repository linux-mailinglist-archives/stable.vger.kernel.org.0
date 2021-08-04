Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AC53E05E4
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 18:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbhHDQ0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 12:26:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50692 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbhHDQ0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 12:26:34 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9EE0A22290;
        Wed,  4 Aug 2021 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628094380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzKGCYtYilUyCd/lN9I4Gdi4yBPGOs/L7z6EQ7VcZA8=;
        b=Da7jODvAtciyfplqTnCRfeAkpFFj9iShqA2puyviKLDEp99MoIk6+QeloUMCH+3D2Hc/N9
        KT10AxDa4BPVdcylsmBUNk7+RAyaKbQbtxcwxuNxFmPfXjXf3ZWq6gPIZfdL3Km+JqjksJ
        by3UrO5YmQ3aImgJ8f2IB4P8ZI6I1FU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628094380;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzKGCYtYilUyCd/lN9I4Gdi4yBPGOs/L7z6EQ7VcZA8=;
        b=wUdsfI82gmm2y1eZE9hMbUeh50EzaVA16dpxcVrG2EESPOzVFvmk+Wh+F+ROgyanL5iLqv
        /NbisIFVP7W5lVDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 18FA813BD0;
        Wed,  4 Aug 2021 16:26:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 2tNlAqy/CmF4cgAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Wed, 04 Aug 2021 16:26:20 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 52b6610d;
        Wed, 4 Aug 2021 16:26:19 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        stable@vger.kernel.org, Sage Weil <sage@redhat.com>,
        Mark Nelson <mnelson@redhat.com>
Subject: Re: [PATCH v2] ceph: ensure we take snap_empty_lock atomically with
 snaprealm refcount change
References: <20210804155515.28984-1-jlayton@kernel.org>
Date:   Wed, 04 Aug 2021 17:26:19 +0100
In-Reply-To: <20210804155515.28984-1-jlayton@kernel.org> (Jeff Layton's
        message of "Wed, 4 Aug 2021 11:55:15 -0400")
Message-ID: <87o8adi3bo.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> There is a race in ceph_put_snap_realm. The change to the nref and the
> spinlock acquisition are not done atomically, so you could decrement nref,
> and before you take the spinlock, the nref is incremented again. At that
> point, you end up putting it on the empty list when it shouldn't be
> there. Eventually __cleanup_empty_realms runs and frees it when it's
> still in-use.
>
> Fix this by protecting the 1->0 transition with atomic_dec_and_lock, and
> just drop the spinlock if we can get the rwsem.
>
> Because these objects can also undergo a 0->1 refcount transition, we
> must protect that change as well with the spinlock. Increment locklessly
> unless the value is at 0, in which case we take the spinlock, increment
> and then take it off the empty list if it did the 0->1 transition.
>
> With these changes, I'm removing the dout() messages from these
> functions, as well as in __put_snap_realm. They've always been racy, and
> it's better to not print values that may be misleading.
>
> Cc: stable@vger.kernel.org
> Cc: Sage Weil <sage@redhat.com>
> Reported-by: Mark Nelson <mnelson@redhat.com>
> URL: https://tracker.ceph.com/issues/46419
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/snap.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> v2: No functional changes, but I cleaned up the comments a bit and
>     added another in __put_snap_realm.
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9dbc92cfda38..158c11e96fb7 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -67,19 +67,19 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
>  {
>  	lockdep_assert_held(&mdsc->snap_rwsem);
>  
> -	dout("get_realm %p %d -> %d\n", realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
>  	/*
> -	 * since we _only_ increment realm refs or empty the empty
> -	 * list with snap_rwsem held, adjusting the empty list here is
> -	 * safe.  we do need to protect against concurrent empty list
> -	 * additions, however.
> +	 * The 0->1 and 1->0 transitions must take the snap_empty_lock
> +	 * atomically with the refcount change. Go ahead and bump the
> +	 * nref here, unless it's 0, in which case we take the spinlock
> +	 * and then do the increment and remove it from the list.
>  	 */
> -	if (atomic_inc_return(&realm->nref) == 1) {
> -		spin_lock(&mdsc->snap_empty_lock);
> +	if (atomic_add_unless(&realm->nref, 1, 0))

Here you could probably use atomic_inc_not_zero() instead.  But other
than that it looks good.  Thanks a lot for solving yet another locking
puzzle!

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
-- 
Luis

> +		return;
> +
> +	spin_lock(&mdsc->snap_empty_lock);
> +	if (atomic_inc_return(&realm->nref) == 1)
>  		list_del_init(&realm->empty_item);
> -		spin_unlock(&mdsc->snap_empty_lock);
> -	}
> +	spin_unlock(&mdsc->snap_empty_lock);
>  }
>  
>  static void __insert_snap_realm(struct rb_root *root,
> @@ -208,28 +208,28 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
>  {
>  	lockdep_assert_held_write(&mdsc->snap_rwsem);
>  
> -	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> +	/*
> +	 * We do not require the snap_empty_lock here, as any caller that
> +	 * increments the value must hold the snap_rwsem.
> +	 */
>  	if (atomic_dec_and_test(&realm->nref))
>  		__destroy_snap_realm(mdsc, realm);
>  }
>  
>  /*
> - * caller needn't hold any locks
> + * See comments in ceph_get_snap_realm. Caller needn't hold any locks.
>   */
>  void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
>  			 struct ceph_snap_realm *realm)
>  {
> -	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> -	if (!atomic_dec_and_test(&realm->nref))
> +	if (!atomic_dec_and_lock(&realm->nref, &mdsc->snap_empty_lock))
>  		return;
>  
>  	if (down_write_trylock(&mdsc->snap_rwsem)) {
> +		spin_unlock(&mdsc->snap_empty_lock);
>  		__destroy_snap_realm(mdsc, realm);
>  		up_write(&mdsc->snap_rwsem);
>  	} else {
> -		spin_lock(&mdsc->snap_empty_lock);
>  		list_add(&realm->empty_item, &mdsc->snap_empty);
>  		spin_unlock(&mdsc->snap_empty_lock);
>  	}
> -- 
>
> 2.31.1
>


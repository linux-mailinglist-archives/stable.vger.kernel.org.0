Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8089575113
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbiGNOtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 10:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbiGNOtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 10:49:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE82B50075;
        Thu, 14 Jul 2022 07:49:18 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9A9881F99B;
        Thu, 14 Jul 2022 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657810157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C4gR9WjHkSv+JuEhHHqt/TweVA9hBFvLCXYGUOsJs/k=;
        b=mExAge31BKuvKCmXZrFi9HEFtMutgkPbchp3W7QdWF76uQzspwpKujuPGUPeqhsZ3Mdvj7
        ddGiCTje+NRYASpNOrD0Tz0hovbAAd+cYVRmcFMgL378B7YPtvbsHp/BNPGbf4YyEft05L
        JhVMWNpcZKrqvry44m1jV/CHl4XLvLo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657810157;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C4gR9WjHkSv+JuEhHHqt/TweVA9hBFvLCXYGUOsJs/k=;
        b=NDUUFdOfQae9usSdTw5WJE4pClql75zPZUmkhuL/F9+9UqKUKeQgrwS3RvSZvzCzuVkp4v
        +FFTkP/FGMsSEcBQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8542A2C141;
        Thu, 14 Jul 2022 14:49:17 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 20864A0659; Thu, 14 Jul 2022 16:49:16 +0200 (CEST)
Date:   Thu, 14 Jul 2022 16:49:16 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mbcache: Add functions to delete entry if unused
Message-ID: <20220714144916.4bu3ugk2j776wb2l@quack3>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-2-jack@suse.cz>
 <20220714121532.xwh72dnys3ngg37k@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714121532.xwh72dnys3ngg37k@riteshh-domain>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 14-07-22 17:45:32, Ritesh Harjani wrote:
> On 22/07/12 12:54PM, Jan Kara wrote:
> > Add function mb_cache_entry_delete_or_get() to delete mbcache entry if
> > it is unused and also add a function to wait for entry to become unused
> > - mb_cache_entry_wait_unused(). We do not share code between the two
> > deleting function as one of them will go away soon.
> >
> > CC: stable@vger.kernel.org
> > Fixes: 82939d7999df ("ext4: convert to mbcache2")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/mbcache.c            | 66 +++++++++++++++++++++++++++++++++++++++--
> >  include/linux/mbcache.h | 10 ++++++-
> >  2 files changed, 73 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/mbcache.c b/fs/mbcache.c
> > index cfc28129fb6f..2010bc80a3f2 100644
> > --- a/fs/mbcache.c
> > +++ b/fs/mbcache.c
> > @@ -11,7 +11,7 @@
> >  /*
> >   * Mbcache is a simple key-value store. Keys need not be unique, however
> >   * key-value pairs are expected to be unique (we use this fact in
> > - * mb_cache_entry_delete()).
> > + * mb_cache_entry_delete_or_get()).
> >   *
> >   * Ext2 and ext4 use this cache for deduplication of extended attribute blocks.
> >   * Ext4 also uses it for deduplication of xattr values stored in inodes.
> > @@ -125,6 +125,19 @@ void __mb_cache_entry_free(struct mb_cache_entry *entry)
> >  }
> >  EXPORT_SYMBOL(__mb_cache_entry_free);
> >
> > +/*
> > + * mb_cache_entry_wait_unused - wait to be the last user of the entry
> > + *
> > + * @entry - entry to work on
> > + *
> > + * Wait to be the last user of the entry.
> > + */
> > +void mb_cache_entry_wait_unused(struct mb_cache_entry *entry)
> > +{
> > +	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 3);
> 
> It's not very intuitive of why we check for refcnt <= 3.
> A small note at top of this function might be helpful.
> IIUC, it is because by default when anyone creates an entry we start with
> a refcnt of 2 (in mb_cache_entry_create.
> - Now when the user of the entry wants to delete this, it will try and call
>   mb_cache_entry_delete_or_get(). If during this function call it sees that the
>   refcnt is elevated more than 2, that means there is another user of this entry
>   currently active and hence we should wait before we remove this entry from the
>   cache. So it will take an extra refcnt and return.
> - So then this caller will call mb_cache_entry_wait_unused() for the refcnt to
>   be <= 3, so that the entry can be deleted.

Correct. I will add a comment as you suggest.

> Quick qn -
> So now is the design like, ext4_evict_ea_inode() will be waiting indefinitely
> until the other user of this mb_cache entry releases the reference right?

Correct. Similarly for ext4_xattr_release_block().

> And that will not happen until,
> - either the shrinker removes this entry from the cache during which we are
>   checking if the refcnt <= 3, then we call a wakeup event

No, shrinker will not touch these entries with active users anymore.

> - Or the user removes/deletes the xattr entry

No. We hold reference to mbcache entry only while we are trying to reuse
it. So functions ext4_xattr_block_cache_find() and
ext4_xattr_inode_cache_find() will lookup potential mbcache entry that may
have the same contents and get reference to it. Then we do comparisons
verifying whether the contents really matches, if yes, we increment on-disk
inode/block refcount. Then we drop mbcache entry reference which unblocks
waiters in mb_cache_entry_wait_unused().

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

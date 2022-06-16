Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1E54E8A5
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 19:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbiFPRax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 13:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbiFPRaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 13:30:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F672C66E;
        Thu, 16 Jun 2022 10:30:50 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9052E21CA4;
        Thu, 16 Jun 2022 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655400649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iM8FR9fOrMDEAPeEbNG2sNIxibqQuAn4USfLuMIYlW0=;
        b=upQNrf3UupIEdjC023xU4QUUrxSul4OSZL1IWh1EwUASw27oWhHFdNGoSlf4g3h8OzK7p/
        MfFFl5C+FnvbhgVZMWXE6+u3TdJaMabhtXT3gGwsb4Gksll4mXQdMJ3NEz8QcH/ykwcV27
        GRpRxKZNLR5Eb6fi4L8S+SY7eTecaS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655400649;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iM8FR9fOrMDEAPeEbNG2sNIxibqQuAn4USfLuMIYlW0=;
        b=wdeWedgyjP4Xnsfp6mpFzJQi0qodKF7KEseyxD6GQjaSzDT3gTdRDoHrnarZfnbNlO3RRt
        3zLj4XJIbfS+VlCA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7CC782C141;
        Thu, 16 Jun 2022 17:30:49 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 38566A062E; Thu, 16 Jun 2022 19:30:49 +0200 (CEST)
Date:   Thu, 16 Jun 2022 19:30:49 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 03/10] ext4: Remove EA inode entry from mbcache on inode
 eviction
Message-ID: <20220616173049.7gt2w2ah3dzyipab@quack3.lan>
References: <20220614124146.21594-1-jack@suse.cz>
 <20220614160603.20566-3-jack@suse.cz>
 <20220616150118.bgwmibp6q7dy6wgi@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616150118.bgwmibp6q7dy6wgi@riteshh-domain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 16-06-22 20:31:18, Ritesh Harjani wrote:
> On 22/06/14 06:05PM, Jan Kara wrote:
> > Currently we remove EA inode from mbcache as soon as its xattr refcount
> > drops to zero. However there can be pending attempts to reuse the inode
> > and thus refcount handling code has to handle the situation when
> > refcount increases from zero anyway. So save some work and just keep EA
> > inode in mbcache until it is getting evicted. At that moment we are sure
> > following iget() of EA inode will fail anyway (or wait for eviction to
> > finish and load things from the disk again) and so removing mbcache
> > entry at that moment is fine and simplifies the code a bit.
> >
> > CC: stable@vger.kernel.org
> > Fixes: 82939d7999df ("ext4: convert to mbcache2")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/inode.c |  2 ++
> >  fs/ext4/xattr.c | 24 ++++++++----------------
> >  fs/ext4/xattr.h |  1 +
> >  3 files changed, 11 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 3dce7d058985..7450ee734262 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -177,6 +177,8 @@ void ext4_evict_inode(struct inode *inode)
> >
> >  	trace_ext4_evict_inode(inode);
> >
> > +	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
> > +		ext4_evict_ea_inode(inode);
> >  	if (inode->i_nlink) {
> >  		/*
> >  		 * When journalling data dirty buffers are tracked only in the
> > diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> > index 042325349098..7fc40fb1e6b3 100644
> > --- a/fs/ext4/xattr.c
> > +++ b/fs/ext4/xattr.c
> > @@ -436,6 +436,14 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
> >  	return err;
> >  }
> >
> > +/* Remove entry from mbcache when EA inode is getting evicted */
> > +void ext4_evict_ea_inode(struct inode *inode)
> > +{
> > +	if (EA_INODE_CACHE(inode))
> > +		mb_cache_entry_delete(EA_INODE_CACHE(inode),
> > +			ext4_xattr_inode_get_hash(inode), inode->i_ino);
> > +}
> > +
> >  static int
> >  ext4_xattr_inode_verify_hashes(struct inode *ea_inode,
> >  			       struct ext4_xattr_entry *entry, void *buffer,
> > @@ -976,10 +984,8 @@ int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
> >  static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
> >  				       int ref_change)
> >  {
> > -	struct mb_cache *ea_inode_cache = EA_INODE_CACHE(ea_inode);
> >  	struct ext4_iloc iloc;
> >  	s64 ref_count;
> > -	u32 hash;
> >  	int ret;
> >
> >  	inode_lock(ea_inode);
> > @@ -1002,14 +1008,6 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
> >
> >  			set_nlink(ea_inode, 1);
> >  			ext4_orphan_del(handle, ea_inode);
> > -
> > -			if (ea_inode_cache) {
> > -				hash = ext4_xattr_inode_get_hash(ea_inode);
> > -				mb_cache_entry_create(ea_inode_cache,
> > -						      GFP_NOFS, hash,
> > -						      ea_inode->i_ino,
> > -						      true /* reusable */);
> > -			}
> 
> Ok, so if I understand this correctly, since we are not immediately removing the
> ea_inode_cache entry when the recount reaches 0, hence when the refcount is
> reaches 1 from 0, we need not create mb_cache entry is it?
> Is this since the entry never got deleted in the first place?

Correct.

> But what happens when the entry is created the very first time?
> I might need to study xattr code to understand how this condition is
> taken care.

There are other places that take care of creating the entry in that case.
E.g. ext4_xattr_inode_get() or ext4_xattr_inode_lookup_create().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

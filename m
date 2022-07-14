Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10EC5750ED
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 16:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiGNOgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 10:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbiGNOgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 10:36:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BC549B6E;
        Thu, 14 Jul 2022 07:36:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CEFA81F889;
        Thu, 14 Jul 2022 14:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657809372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oiA6bm68GhNL1nE09mGZal3jW7PG2ycFzn8PLoBQg4E=;
        b=QL3DsJujqdIQvn52TEio7swg8ge2ikF8ogH0NKasGJZGk7MurF4+qTox7+I3U6ED0ZPRbw
        aROzuLAJB2+ZGJLJJl2mPhaJ7H2NZLpLshjC4gieOSZxhR5erj28QqtOJNAQ8cBMiCr/qx
        m6JV4fKYNQ+uOzQO/TfOIs6xN8lwoG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657809372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oiA6bm68GhNL1nE09mGZal3jW7PG2ycFzn8PLoBQg4E=;
        b=XOqQbPUF62a5LjCXjCEdRpbPxPwXd72QtfWK30wI+YZz3QkbAQFYcq2A2YgdC6jIDqtLZX
        r79qS1XMknD+cDDw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BBB822C141;
        Thu, 14 Jul 2022 14:36:12 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 640A5A0659; Thu, 14 Jul 2022 16:36:12 +0200 (CEST)
Date:   Thu, 14 Jul 2022 16:36:12 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mbcache: Don't reclaim used entries
Message-ID: <20220714143612.oa2u6opi6feqkrvy@quack3>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-1-jack@suse.cz>
 <20220714114702.wwd4o3zjdujd34kz@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714114702.wwd4o3zjdujd34kz@riteshh-domain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 14-07-22 17:17:02, Ritesh Harjani wrote:
> On 22/07/12 12:54PM, Jan Kara wrote:
> > Do not reclaim entries that are currently used by somebody from a
> > shrinker. Firstly, these entries are likely useful. Secondly, we will
> > need to keep such entries to protect pending increment of xattr block
> > refcount.
> >
> > CC: stable@vger.kernel.org
> > Fixes: 82939d7999df ("ext4: convert to mbcache2")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/mbcache.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/mbcache.c b/fs/mbcache.c
> > index 97c54d3a2227..cfc28129fb6f 100644
> > --- a/fs/mbcache.c
> > +++ b/fs/mbcache.c
> > @@ -288,7 +288,7 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
> >  	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
> >  		entry = list_first_entry(&cache->c_list,
> >  					 struct mb_cache_entry, e_list);
> > -		if (entry->e_referenced) {
> > +		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {
> >  			entry->e_referenced = 0;
> >  			list_move_tail(&entry->e_list, &cache->c_list);
> >  			continue;
> > @@ -302,6 +302,14 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
> >  		spin_unlock(&cache->c_list_lock);
> >  		head = mb_cache_entry_head(cache, entry->e_key);
> >  		hlist_bl_lock(head);
> > +		/* Now a reliable check if the entry didn't get used... */
> > +		if (atomic_read(&entry->e_refcnt) > 2) {
> 
> On taking a look at this patchset again. I think if we move this "if" condition
> of checking refcnt to above i.e. before we delete the entry from c_list.
> Then we can avoid =>
> removing of the entry -> checking it's refcnt under lock -> adding it back
> if the refcnt is elevated.
> 
> Thoughts?

Well, but synchronization would get more complicated because we don't want
to acquire hlist_bl_lock() under c_list_lock (technically we could at this
point in the series but it would make life harder for the last patch in the
series). And we need c_list_lock to remove entry from the LRU list. It
could be all done but I don't think what you suggest is really that simpler
and this code will go away later in the patchset anyway...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

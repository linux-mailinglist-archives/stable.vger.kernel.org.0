Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A263554E897
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 19:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiFPRZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 13:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiFPRZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 13:25:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103DE2898A;
        Thu, 16 Jun 2022 10:25:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B379B1F8BB;
        Thu, 16 Jun 2022 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655400311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2n0eJK6sV5SnpmgSlQ3Vffj0/UT0crGDHueSd2fcjv8=;
        b=nVyMmK+fzWBPQoVAnC5P4iqZAH11EPA4kRgzZMFI+UlJDBPMgKNO7gfHp5WvxRT4THok0f
        md8xDsAgPI6XkdoUjnAN1+dTkfhGGsd3J2aMZSpWGP22mYurTy4VR/IAv5lCGNyhowVau2
        Mj80VFGOWkgiYPFJweoMRksID8iUONM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655400311;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2n0eJK6sV5SnpmgSlQ3Vffj0/UT0crGDHueSd2fcjv8=;
        b=OSKXdVseRSAhdo0eHRnqgif7RB72B0istn/kordKYsiIk/1RywQjpZGt9rJqKBafVfphSz
        uabBZr6XvISkshBw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9101A2C141;
        Thu, 16 Jun 2022 17:25:11 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 2F0ABA062E; Thu, 16 Jun 2022 19:25:08 +0200 (CEST)
Date:   Thu, 16 Jun 2022 19:25:08 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mbcache: Don't reclaim used entries
Message-ID: <20220616172508.opvbzujokoyhhbui@quack3.lan>
References: <20220614124146.21594-1-jack@suse.cz>
 <20220614160603.20566-1-jack@suse.cz>
 <20220616142212.do5hdazjkuq5ayar@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616142212.do5hdazjkuq5ayar@riteshh-domain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 16-06-22 19:52:12, Ritesh Harjani wrote:
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
> 
> Sure, yes, the above "||" conditions looks good.
> i.e. if the refcnt is above 2, then we should move the entry to the tail of LRU.
> Because that means that there is another user of this entry which might have
> incremented the refcnt.
> 
> >  			entry->e_referenced = 0;
> >  			list_move_tail(&entry->e_list, &cache->c_list);
> >  			continue;
> > @@ -302,6 +302,14 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
> >  		spin_unlock(&cache->c_list_lock);
> >  		head = mb_cache_entry_head(cache, entry->e_key);
> >  		hlist_bl_lock(head);
> > +		/* Now a reliable check if the entry didn't get used... */
> 
> But not sure why this is more reliable? Anytime we add or remove the entry,
> we first always do the list operation and then increment or decrement the
> refcnt "atomically".
> 
> So could you please help in understanding why will this be more reliable?

It is reliable in the sense that while we hold hlist_bl_lock() there can be
no new references acquired (they get acquired only through the hash table
lookup) and so here we can "atomically" do "check entry is unused and
remove it from the hash".

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

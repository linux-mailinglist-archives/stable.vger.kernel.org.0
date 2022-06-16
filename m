Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD32C54E89C
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 19:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiFPR2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 13:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiFPR2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 13:28:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536E327CD2;
        Thu, 16 Jun 2022 10:28:17 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0346421B39;
        Thu, 16 Jun 2022 17:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655400496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jfoyucw0SLezVKbV72zfCm9Yi7Bb79n9aUhNpcIV7Jo=;
        b=kCe4YisQ3BsxemYIPgjXWEppBH+GlvZKM4tlBR5XTyRuxa2pgtEUS6C7CvL0yANqr563Mu
        vcDNxjcWXG18jtQ6OAq/NPJJwXhTEk3FovZ+02fjN5H9WNGNylqpOjaJvxaKMtkDkr+aS5
        Le+XmwWQxNCDZqQysjmMpx1cnc7+yf8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655400496;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jfoyucw0SLezVKbV72zfCm9Yi7Bb79n9aUhNpcIV7Jo=;
        b=UXCVaqMFwk+whumQ5IYvNL0SYz0b5NfDZOEbN6HjfzlDFdoopobiCf8ECc0T2HDIqHwl61
        7KBxsnJx+ZHN6sCA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E46342C141;
        Thu, 16 Jun 2022 17:28:15 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 3511BA062E; Thu, 16 Jun 2022 19:28:10 +0200 (CEST)
Date:   Thu, 16 Jun 2022 19:28:10 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mbcache: Add functions to delete entry if unused
Message-ID: <20220616172810.guv2v6cwqjxywdew@quack3.lan>
References: <20220614124146.21594-1-jack@suse.cz>
 <20220614160603.20566-2-jack@suse.cz>
 <20220616144722.of7v2rgd76y3gsv5@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616144722.of7v2rgd76y3gsv5@riteshh-domain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 16-06-22 20:17:22, Ritesh Harjani wrote:
> On 22/06/14 06:05PM, Jan Kara wrote:
> > Add function mb_cache_entry_try_delete() to delete mbcache entry if it
> > is unused and also add a function to wait for entry to become unused -
> > mb_cache_entry_wait_unused(). We do not share code between the two
> > deleting function as one of them will go away soon.
> >
> > CC: stable@vger.kernel.org
> > Fixes: 82939d7999df ("ext4: convert to mbcache2")
> > Signed-off-by: Jan Kara <jack@suse.cz>

...

> > +/* mb_cache_entry_try_delete - try to remove a cache entry
> > + * @cache - cache we work with
> > + * @key - key
> > + * @value - value
> > + *
> > + * Remove entry from cache @cache with key @key and value @value. The removal
> > + * happens only if the entry is unused. The function returns NULL in case the
> > + * entry was successfully removed or there's no entry in cache. Otherwise the
> > + * function returns the entry that we failed to delete because it has users.
> 
> "...Also increment it's refcnt in case if the entry is returned. So the
> caller is responsible to call for mb_cache_entry_put() later."

Definitely, I'll expand the comment.

> Do you think comment should be added too? And the api naming should be
> mb_cache_entry_try_delete_or_get().
> 
> Looks like e_refcnt increment is done quitely in case of the entry is found
> where as the api just says mb_cache_entry_try_delete().

It's a bit long name but I agree it describes the function better. OK,
let's rename.
 
> Other than that, all other code logic looks right to me.

Thanks for review!

								Honza


> > + */
> > +struct mb_cache_entry *mb_cache_entry_try_delete(struct mb_cache *cache,
> > +						 u32 key, u64 value)
> > +{
> > +	struct hlist_bl_node *node;
> > +	struct hlist_bl_head *head;
> > +	struct mb_cache_entry *entry;
> > +
> > +	head = mb_cache_entry_head(cache, key);
> > +	hlist_bl_lock(head);
> > +	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
> > +		if (entry->e_key == key && entry->e_value == value) {
> > +			if (atomic_read(&entry->e_refcnt) > 2) {
> > +				atomic_inc(&entry->e_refcnt);
> > +				hlist_bl_unlock(head);
> > +				return entry;
> > +			}
> > +			/* We keep hash list reference to keep entry alive */
> > +			hlist_bl_del_init(&entry->e_hash_list);
> > +			hlist_bl_unlock(head);
> > +			spin_lock(&cache->c_list_lock);
> > +			if (!list_empty(&entry->e_list)) {
> > +				list_del_init(&entry->e_list);
> > +				if (!WARN_ONCE(cache->c_entry_count == 0,
> > +		"mbcache: attempt to decrement c_entry_count past zero"))
> > +					cache->c_entry_count--;
> > +				atomic_dec(&entry->e_refcnt);
> > +			}
> > +			spin_unlock(&cache->c_list_lock);
> > +			mb_cache_entry_put(cache, entry);
> > +			return NULL;
> > +		}
> > +	}
> > +	hlist_bl_unlock(head);
> > +
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL(mb_cache_entry_try_delete);
> > +
> >  /* mb_cache_entry_touch - cache entry got used
> >   * @cache - cache the entry belongs to
> >   * @entry - entry that got used
> > diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
> > index 20f1e3ff6013..1176fdfb8d53 100644
> > --- a/include/linux/mbcache.h
> > +++ b/include/linux/mbcache.h
> > @@ -30,15 +30,23 @@ void mb_cache_destroy(struct mb_cache *cache);
> >  int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
> >  			  u64 value, bool reusable);
> >  void __mb_cache_entry_free(struct mb_cache_entry *entry);
> > +void mb_cache_entry_wait_unused(struct mb_cache_entry *entry);
> >  static inline int mb_cache_entry_put(struct mb_cache *cache,
> >  				     struct mb_cache_entry *entry)
> >  {
> > -	if (!atomic_dec_and_test(&entry->e_refcnt))
> > +	unsigned int cnt = atomic_dec_return(&entry->e_refcnt);
> > +
> > +	if (cnt > 0) {
> > +		if (cnt <= 3)
> > +			wake_up_var(&entry->e_refcnt);
> >  		return 0;
> > +	}
> >  	__mb_cache_entry_free(entry);
> >  	return 1;
> >  }
> >
> > +struct mb_cache_entry *mb_cache_entry_try_delete(struct mb_cache *cache,
> > +						 u32 key, u64 value);
> >  void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value);
> >  struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
> >  					  u64 value);
> > --
> > 2.35.3
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

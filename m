Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BE6575149
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbiGNPAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 11:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbiGNPAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 11:00:07 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098B42AE13;
        Thu, 14 Jul 2022 08:00:06 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so3337485pjl.4;
        Thu, 14 Jul 2022 08:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qmtNgO7vSfvGleBqdaptbT2JTg3RXUw2zvHeBfllIys=;
        b=ZizK3MeKbUpwmC3QHiXbnf89dHIh/fyAwnFxK+3MsPJySh1i8oy8vOJSZTCdAgpC8+
         xdDvJcJS7Jtq9KXEdtkYlnqOCrbJ3Tht4Z0fDVRXTUK5Mn8JcMw1B3LEgLnDmlDGm2hD
         M9la9J1djsAn0AK+tMUM8iyjV64r9Ye4dDbH+ibsRTukSQxXrWkjtdwKKd2pKUyaE7qZ
         oqWM5PfmgFyB0ht174x4nSu64dUkXnnAHlPJHZ7ahseicdU1qBoH5QI/dpbbTgvwjnWZ
         9arWS0uyOkfJBGDRxH5BxvmHq7yb+xfSFN9SpJv3TIQvo/zGUEkMTp/L0bNiyKwc+XCZ
         nCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qmtNgO7vSfvGleBqdaptbT2JTg3RXUw2zvHeBfllIys=;
        b=h37mY4YKQZ/I7NKMuYkfa7VOVlWj9Cz5ZgprWyjeEmqilx9aM7VOgNSwa0OEx+OZQr
         pqOoeIcv5vLIQKW9ht36qkNPq2EaQpztTNIdY3fmmQuRZfgrnPZSJY9vk75GASjtgylr
         QPwFkrudaYiFqW66i5PRbUPDH9iUpfl0LCmGN+BfjuqDdqVUeDeZjDs1fSLLkIjbDcn3
         lnY6wh4HDXptg/Ut948iS44IPyFL1NXc+Vf0M7dVN7BQtjkZ5ZrSzqFEu3aAREx4a2Bi
         obhgIp45aWDPKPU4Hb0vFV5I1EDPjtXnZSVBeoSspvy8WoodG94fYe/9CZNJ3DnHsAHw
         E8qQ==
X-Gm-Message-State: AJIora9dMGRwEQYOUT84pzd2L8nh6E56q837yI3VCpTWzDQ1v1gsUbtf
        EmddIGVZAgHyNEgrOrOPpA7jz6mPs/Q=
X-Google-Smtp-Source: AGRyM1u2GKVmW9p6FMXkd3Fh4kGlY4kukHP61YxD+zeUKgEFudUnWZAMsYeFr8LeJtFSfnynE9DEcw==
X-Received: by 2002:a17:90b:3807:b0:1f0:a86:6875 with SMTP id mq7-20020a17090b380700b001f00a866875mr16608421pjb.103.1657810805404;
        Thu, 14 Jul 2022 08:00:05 -0700 (PDT)
Received: from localhost ([2406:7400:63:cb1d:811:33e9:9bc2:d40])
        by smtp.gmail.com with ESMTPSA id j24-20020a63cf18000000b0041975999455sm1469044pgg.75.2022.07.14.08.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:00:04 -0700 (PDT)
Date:   Thu, 14 Jul 2022 20:30:00 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mbcache: Add functions to delete entry if unused
Message-ID: <20220714150000.hkq5d435rxdcz5jy@riteshh-domain>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-2-jack@suse.cz>
 <20220714121532.xwh72dnys3ngg37k@riteshh-domain>
 <20220714144916.4bu3ugk2j776wb2l@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714144916.4bu3ugk2j776wb2l@quack3>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/07/14 04:49PM, Jan Kara wrote:
> On Thu 14-07-22 17:45:32, Ritesh Harjani wrote:
> > On 22/07/12 12:54PM, Jan Kara wrote:
> > > Add function mb_cache_entry_delete_or_get() to delete mbcache entry if
> > > it is unused and also add a function to wait for entry to become unused
> > > - mb_cache_entry_wait_unused(). We do not share code between the two
> > > deleting function as one of them will go away soon.
> > >
> > > CC: stable@vger.kernel.org
> > > Fixes: 82939d7999df ("ext4: convert to mbcache2")
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/mbcache.c            | 66 +++++++++++++++++++++++++++++++++++++++--
> > >  include/linux/mbcache.h | 10 ++++++-
> > >  2 files changed, 73 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/mbcache.c b/fs/mbcache.c
> > > index cfc28129fb6f..2010bc80a3f2 100644
> > > --- a/fs/mbcache.c
> > > +++ b/fs/mbcache.c
> > > @@ -11,7 +11,7 @@
> > >  /*
> > >   * Mbcache is a simple key-value store. Keys need not be unique, however
> > >   * key-value pairs are expected to be unique (we use this fact in
> > > - * mb_cache_entry_delete()).
> > > + * mb_cache_entry_delete_or_get()).
> > >   *
> > >   * Ext2 and ext4 use this cache for deduplication of extended attribute blocks.
> > >   * Ext4 also uses it for deduplication of xattr values stored in inodes.
> > > @@ -125,6 +125,19 @@ void __mb_cache_entry_free(struct mb_cache_entry *entry)
> > >  }
> > >  EXPORT_SYMBOL(__mb_cache_entry_free);
> > >
> > > +/*
> > > + * mb_cache_entry_wait_unused - wait to be the last user of the entry
> > > + *
> > > + * @entry - entry to work on
> > > + *
> > > + * Wait to be the last user of the entry.
> > > + */
> > > +void mb_cache_entry_wait_unused(struct mb_cache_entry *entry)
> > > +{
> > > +	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 3);
> >
> > It's not very intuitive of why we check for refcnt <= 3.
> > A small note at top of this function might be helpful.
> > IIUC, it is because by default when anyone creates an entry we start with
> > a refcnt of 2 (in mb_cache_entry_create.
> > - Now when the user of the entry wants to delete this, it will try and call
> >   mb_cache_entry_delete_or_get(). If during this function call it sees that the
> >   refcnt is elevated more than 2, that means there is another user of this entry
> >   currently active and hence we should wait before we remove this entry from the
> >   cache. So it will take an extra refcnt and return.
> > - So then this caller will call mb_cache_entry_wait_unused() for the refcnt to
> >   be <= 3, so that the entry can be deleted.
>
> Correct. I will add a comment as you suggest.
>
> > Quick qn -
> > So now is the design like, ext4_evict_ea_inode() will be waiting indefinitely
> > until the other user of this mb_cache entry releases the reference right?
>
> Correct. Similarly for ext4_xattr_release_block().
>
> > And that will not happen until,
> > - either the shrinker removes this entry from the cache during which we are
> >   checking if the refcnt <= 3, then we call a wakeup event
>
> No, shrinker will not touch these entries with active users anymore.
>
> > - Or the user removes/deletes the xattr entry
>
> No. We hold reference to mbcache entry only while we are trying to reuse
> it. So functions ext4_xattr_block_cache_find() and
> ext4_xattr_inode_cache_find() will lookup potential mbcache entry that may
> have the same contents and get reference to it. Then we do comparisons
> verifying whether the contents really matches, if yes, we increment on-disk
> inode/block refcount. Then we drop mbcache entry reference which unblocks
> waiters in mb_cache_entry_wait_unused().
>

ohk, yes. This is where I was a bit confused.
Thanks for explaining it. This makes more sense. I did go through the mbcache
implementation, but I was missing the info on how the callers are using it.

-ritesh

> 								Honza
>
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

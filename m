Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAC63D9256
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhG1Puk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 11:50:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40380 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbhG1Puh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 11:50:37 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2643F1FFD0;
        Wed, 28 Jul 2021 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627487389;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=upRxFQ3m+In6q7JonR1jdicgI1MGOFp1GrrhziqMYzI=;
        b=Na/CAPpXFVMJuB/M+66gdunt27wNX8X883ICPSLEKA/ux7lVcfpVYJ+W0A4oEU5iFGsqYS
        c2McKzq4ejJY24gqCewYoVBNvs/GsNjqUm9+ErIC/qtYLXYtMj7OmHh6RbZYdDdLFo4Md0
        OM06XDpZoP2zGFJGx72EuNPRXmFXgPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627487389;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=upRxFQ3m+In6q7JonR1jdicgI1MGOFp1GrrhziqMYzI=;
        b=X34D87sXWq97mAPUR05VMghmN6rKgxibZGAWER4cvAUSD1oYCt0GzCiMiMBrsGMgXFI4Rw
        LvwPSuIGdI8LWzAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id EA1B1A3B87;
        Wed, 28 Jul 2021 15:49:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0866EDA8A7; Wed, 28 Jul 2021 17:47:03 +0200 (CEST)
Date:   Wed, 28 Jul 2021 17:47:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH] btrfs: properly split extent_map for REQ_OP_ZONE_APPEND
Message-ID: <20210728154703.GO5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20210628085728.2813793-1-naohiro.aota@wdc.com>
 <CAL3q7H4LsXDK8rTr3yEkftMm9ok9kWdQuwxk57Pke5oJ+EZOZQ@mail.gmail.com>
 <CAL3q7H6dMNGQ+RKrK91pZsbXQO9852fE+pqZDzo53xOvDAeYFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6dMNGQ+RKrK91pZsbXQO9852fE+pqZDzo53xOvDAeYFA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 01, 2021 at 05:55:51PM +0100, Filipe Manana wrote:
> > > +       if (pre) {
> > > +               /* Insert the middle extent_map */
> > > +               split_mid->start = em->start + pre;
> > > +               split_mid->len = em->len - pre - post;
> > > +               split_mid->orig_start = split_mid->start;
> > > +               split_mid->block_start = em->block_start + pre;
> > > +               split_mid->block_len = split_mid->len;
> > > +               split_mid->orig_block_len = split_mid->block_len;
> > > +               split_mid->ram_bytes = split_mid->len;
> > > +               split_mid->flags = flags;
> > > +               split_mid->compress_type = em->compress_type;
> > > +               split_mid->generation = em->generation;
> > > +               add_extent_mapping(em_tree, split_mid, modified);
> > > +       }
> > > +
> > > +       if (post) {
> > > +               split_post->start = em->start + em->len - post;
> > > +               split_post->len = post;
> > > +               split_post->orig_start = split_post->start;
> > > +               split_post->block_start = em->block_start + em->len - post;
> > > +               split_post->block_len = split_post->len;
> > > +               split_post->orig_block_len = split_post->block_len;
> > > +               split_post->ram_bytes = split_post->len;
> > > +               split_post->flags = flags;
> > > +               split_post->compress_type = em->compress_type;
> > > +               split_post->generation = em->generation;
> > > +               add_extent_mapping(em_tree, split_post, modified);
> > > +       }
> >
> > So this happens when running delalloc, after creating the original
> > extent map and ordered extent, the original "em" must have had the
> > PINNED flag set.
> >
> > The "pre" and "post" extent maps should have the PINNED flag set. It's
> > important to have the flag set to prevent extent map merging, which
> > could result in a log corruption if the file is being fsync'ed
> > multiple times in the current transaction and running delalloc was
> > triggered precisely by an fsync. The corruption result would be
> > logging extent items with overlapping ranges, since we construct them
> > based on extent maps, and that's why we have the PINNED flag to
> > prevent merging.
> 
> Well, it actually happens that merging should not happen because the
> original extent map was in the list of modified extents, and so should
> be the new extent maps.
> But we are really supposed to have the PINNED flag from the moment we
> run delalloc and create a new extent map until the respective ordered
> extent completes and unpins it.
> 
> Also EXTENT_FLAG_LOGGING should not be set at this point - if it were
> we would screw up with a task logging the extent map.
> 
> Maybe assert that it is not set in the original extent map?
> And also assert that the original em is in the list of modified
> extents and has the PINNED flag set?

Agreed, the asserts should be here, Naohiro, please send a followup,
thanks.

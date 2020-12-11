Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A362D7D91
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbgLKSE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 13:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390547AbgLKSEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 13:04:08 -0500
Date:   Fri, 11 Dec 2020 10:03:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607709807;
        bh=vIMyhl7sd6mVx4IlRszltySzPw7tdhmA7dkJ2CxtvMU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ouStJnNQZOafvHqGTmZr9kEnnNbatY34bjiiiKFzqWz3TKTEjo9B5c8NS6H/x6hdf
         fJ35kkigO50qem8eOztJGxAY4qK4m+ihZYW6a4t5nu56WDoLDCk+V8lleP7a4G+JOH
         2tPBoJhF01QJ+TzNOZK2hHzUa0g7sWYekn47/QYh3+hHnlPE9+swqtnHDwpvusxSbU
         jDb1vLJCxwumg20yfezAjfTsUtbC1HvKE3SRFGbEtGHWK/go/td8zIgAeGJwtT9UO+
         DymEYZ+W5DSvG+fFroPxHgOfA8uJhLmxOymwkhS5MD/Bbr87iUxjFr+fzcBEIKfXCc
         5qNZpWvp80xBA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Suleiman Souhlal <suleiman@google.com>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] ext4 fscrypt_get_encryption_info() circular locking
 dependency
Message-ID: <X9O0brQ7junfZTfI@sol.localdomain>
References: <20201211033657.GE1667627@google.com>
 <X9LsDPsXdLNv0+va@sol.localdomain>
 <20201211040807.GF1667627@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211040807.GF1667627@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 01:08:07PM +0900, Sergey Senozhatsky wrote:
> On (20/12/10 19:48), Eric Biggers wrote:
> > > 
> > > [  133.454836] Chain exists of:
> > >                  jbd2_handle --> fscrypt_init_mutex --> fs_reclaim
> > > 
> > > [  133.454840]  Possible unsafe locking scenario:
> > > 
> > > [  133.454841]        CPU0                    CPU1
> > > [  133.454843]        ----                    ----
> > > [  133.454844]   lock(fs_reclaim);
> > > [  133.454846]                                lock(fscrypt_init_mutex);
> > > [  133.454848]                                lock(fs_reclaim);
> > > [  133.454850]   lock(jbd2_handle);
> > > [  133.454851] 
> > 
> > This actually got fixed by the patch series
> > https://lkml.kernel.org/linux-fscrypt/20200913083620.170627-1-ebiggers@kernel.org/
> > which went into 5.10.  The more recent patch to remove ext4_dir_open() isn't
> > related.
> > 
> > It's a hard patch series to backport.  Backporting it to 5.4 would be somewhat
> > feasible, while 4.19 would be very difficult as there have been a lot of other
> > fscrypt commits which would heavily conflict with cherry-picks.
> > 
> > How interested are you in having this fixed?  Did you encounter an actual
> > deadlock or just the lockdep report?
> 
> Difficult to say. On one hand 'yes' I see lockups on my devices (4.19
> kernel); I can't tell at the moment what's the root cause. So on the
> other hand 'no' I can't say that it's because of ext4_dir_open().
> 
> What I saw so far involved ext4, kswapd, khugepaged and lots of other things.
> 
> [ 1598.655901] INFO: task khugepaged:66 blocked for more than 122 seconds.
> [ 1598.655914] Call Trace:
> [ 1598.655920]  __schedule+0x506/0x1240
> [ 1598.655924]  ? kvm_zap_rmapp+0x52/0x69
> [ 1598.655927]  schedule+0x3f/0x78
> [ 1598.655929]  __rwsem_down_read_failed_common+0x186/0x201
> [ 1598.655933]  call_rwsem_down_read_failed+0x14/0x30
> [ 1598.655936]  down_read+0x2e/0x45
> [ 1598.655939]  rmap_walk_file+0x73/0x1ce
> [ 1598.655941]  page_referenced+0x10d/0x154
> [ 1598.655948]  shrink_active_list+0x1d4/0x475
> 
> [..]
> 
> [ 1598.655986] INFO: task kswapd0:79 blocked for more than 122 seconds.
> [ 1598.655993] Call Trace:
> [ 1598.655995]  __schedule+0x506/0x1240
> [ 1598.655998]  schedule+0x3f/0x78
> [ 1598.656000]  __rwsem_down_read_failed_common+0x186/0x201
> [ 1598.656003]  call_rwsem_down_read_failed+0x14/0x30
> [ 1598.656006]  down_read+0x2e/0x45
> [ 1598.656008]  rmap_walk_file+0x73/0x1ce
> [ 1598.656010]  page_referenced+0x10d/0x154
> [ 1598.656015]  shrink_active_list+0x1d4/0x475
> 
> [..]
> 
> [ 1598.658233]  __rwsem_down_read_failed_common+0x186/0x201
> [ 1598.658235]  call_rwsem_down_read_failed+0x14/0x30
> [ 1598.658238]  down_read+0x2e/0x45
> [ 1598.658240]  rmap_walk_file+0x73/0x1ce
> [ 1598.658242]  page_referenced+0x10d/0x154
> [ 1598.658247]  shrink_active_list+0x1d4/0x475
> [ 1598.658250]  shrink_node+0x27e/0x661
> [ 1598.658254]  try_to_free_pages+0x425/0x7ec
> [ 1598.658258]  __alloc_pages_nodemask+0x80b/0x1514
> [ 1598.658279]  __do_page_cache_readahead+0xd4/0x1a9
> [ 1598.658282]  filemap_fault+0x346/0x573
> [ 1598.658287]  ext4_filemap_fault+0x31/0x44

Could you provide some more information about what is causing these actual
lockups for you?  Are there more stack traces?

I'd be surprised if it's related to the fscrypt-related lockdep reports you're
getting, as the fscrypt bug seemed unlikely to cause deadlocks in practice, as
most of the time fscrypt_get_encryption_info() does *not* do or wait for a
GFP_KERNEL allocation.  It's only in certain causes (generally, when things are
being initialized as opposed to already running) that it could.

See e.g. how the lockdep reports assume GFP_KERNEL done under
fscrypt_init_mutex, but that only happens the first time an encrypted directory
is accessed after boot.  So that path can't cause a deadlock after that.

This was also a 5 years old bug, so it's unclear why it would suddenly be
causing problems just now...

Maybe something changed that exposed the bug more.  I don't know what it would
be, though.

As I said, the fix would be difficult to backport.  It required a redesign of
how encrypted files get created, as there were lots of different ways in which
fscrypt_get_encryption_info() could be called during a filesystem transaction.
There's a nontrivial risk of regressions by backporting it.  (In fact I already
found and fixed two regressions in it upstream...)

So it would be helpful to know if this is important enough to you that you would
be willing to accept a risk of regressions above that of a typical stable
backport in order to get the re-design that fixes this issue backported.

- Eric

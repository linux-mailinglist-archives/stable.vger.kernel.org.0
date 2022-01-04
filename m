Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF794847FF
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiADSlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:41:15 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34280 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiADSlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:41:15 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 235EF1F37B;
        Tue,  4 Jan 2022 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641321674;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fiPWDmTs95fSfDRhM5RHRVhxbWEVA80G5JMKNKGoWeE=;
        b=q9Cjdnb8CdVbrmOJZPaNPL+gV1bYkxPUdDWUjmMKxSz+ya9GvHjNejpaDWWBtjOgNW+uT2
        j1M3RsGieRZ/almh+VAZGBTS9tjPr7DVP5asg2BQMu8MUjeCP7PQwYKnJNGwbutaH/a0oe
        bjQ4SfZUjRcFmv3gfEwyNJ48fFwoPdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641321674;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fiPWDmTs95fSfDRhM5RHRVhxbWEVA80G5JMKNKGoWeE=;
        b=Vp7P042Pdh84+tL5blaCEuFL7wUpqxiNOyrgTdLdbgdCgdF40vmo/YxP5RvlVP9wbH8bLG
        sMPfIGMrnHt3pFBw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 1B9FCA3B81;
        Tue,  4 Jan 2022 18:41:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BEE21DA729; Tue,  4 Jan 2022 19:40:44 +0100 (CET)
Date:   Tue, 4 Jan 2022 19:40:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: don't start transaction for scrub if the fs
 is mounted read-only
Message-ID: <20220104184044.GV28560@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <20211216114736.69757-1-wqu@suse.com>
 <20211216114736.69757-2-wqu@suse.com>
 <20220103185237.GQ28560@twin.jikos.cz>
 <4f1857d7-3788-6d0e-96a1-23a9a3ec61e9@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f1857d7-3788-6d0e-96a1-23a9a3ec61e9@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 07:52:39AM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/1/4 02:52, David Sterba wrote:
> > On Thu, Dec 16, 2021 at 07:47:35PM +0800, Qu Wenruo wrote:
> >> [BUG]
> >> The following super simple script would crash btrfs at unmount time, if
> >> CONFIG_BTRFS_ASSERT() is set.
> >>
> >>   mkfs.btrfs -f $dev
> >>   mount $dev $mnt
> >>   xfs_io -f -c "pwrite 0 4k" $mnt/file
> >>   umount $mnt
> >>   mount -r ro $dev $mnt
> >>   btrfs scrub start -Br $mnt
> >>   umount $mnt
> >>
> >> This will trigger the following ASSERT() introduced by commit
> >> 0a31daa4b602 ("btrfs: add assertion for empty list of transactions at
> >> late stage of umount").
> >>
> >> That patch is deifnitely not the cause, it just makes enough noise for
> >> us developer.
> >>
> >> [CAUSE]
> >> We will start transaction for the following call chain during scrub:
> >>
> >>    scrub_enumerate_chunks()
> >>    |- btrfs_inc_block_group_ro()
> >>       |- btrfs_join_transaction()
> >>
> >> However for RO mount, there is no running transaction at all, thus
> >> btrfs_join_transaction() will start a new transaction.
> >>
> >> Furthermore, since it's read-only mount, btrfs_sync_fs() will not call
> >> btrfs_commit_super() to commit the new but empty transaction.
> >>
> >> And lead to the ASSERT() being triggered.
> >>
> >> The bug should be there for a long time. Only the new ASSERT() makes it
> >> noisy enough to be noticed.
> >>
> >> [FIX]
> >> For read-only scrub on read-only mount, there is no need to start a
> >> transaction nor to allocate new chunks in btrfs_inc_block_group_ro().
> >>
> >> Just do extra read-only mount check in btrfs_inc_block_group_ro(), and
> >> if it's read-only, skip all chunk allocation and go inc_block_group_ro()
> >> directly.
> >>
> >> Since we're here, also add extra debug message at unmount for
> >> btrfs_fs_info::trans_list.
> >> Sometimes just knowing that there is no dirty metadata bytes for a
> >> uncommitted transaction can tell us a lot of things.
> >>
> >> Cc: stable@vger.kernel.org # 5.4+
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>   fs/btrfs/block-group.c | 13 +++++++++++++
> >>   1 file changed, 13 insertions(+)
> >>
> >> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> >> index 1db24e6d6d90..702219361b12 100644
> >> --- a/fs/btrfs/block-group.c
> >> +++ b/fs/btrfs/block-group.c
> >> @@ -2544,6 +2544,19 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
> >>   	int ret;
> >>   	bool dirty_bg_running;
> >>
> >> +	/*
> >> +	 * This can only happen when we are doing read-only scrub on read-only
> >> +	 * mount.
> >> +	 * In that case we should not start a new transaction on read-only fs.
> >> +	 * Thus here we skip all chunk allocation.
> >> +	 */
> >> +	if (sb_rdonly(fs_info->sb)) {
> >
> > Should this also verify or at least assert that do_chunk_alloc is not
> > set? The scrub code is used for replace that can set the parameter to
> > true.
> 
> Replace start needs RW mount, thus we don't need to bother replace in
> this case.

What if replace starts on rw mount, and then it's flipped to read-only?
I don't see how this is prevented (like by mnt_want_write). It should
not cause any problems either, as it would not start the transaction.

> >> +		mutex_lock(&fs_info->ro_block_group_mutex);
> >> +		ret = inc_block_group_ro(cache, 0);
> >> +		mutex_unlock(&fs_info->ro_block_group_mutex);
> >> +		return ret;
> >
> > So this is taking a shortcut and skips a few things done in the function
> > that use the transaction. I'm not sure how safe this is, it depends on
> > the read-only status of superblock, that can chage any time, so what are
> > further calls to btrfs_inc_block_group_ro going to do regaring the
> > transaction?
> 
> By anytime you mean "remount". Thus if that's your concern, I can make
> remount to stop read-only scrub, just to be extra safe.

If scrub is running in the read-only mode then it's fine, the corner
cases I'm interested in are some mixture of read-write/read-only on the
filesystem and scrub and when they get out of sync.

> Another thing is, only scrub and balance uses this function, for balance
> it needs RW.
> 
> For scrub, if one scrub is already running, even it's RO and then the fs
> mounted RW, then the next scrub run will return -EINPROGRESS or similar
> error.
> 
> Thus I don't think we need to bother too much about this.

It's not about another scrub running, that won't work, but what if
scrub is started, and then at some point the filesystem gets remounted
read-only. Both can be done without any notification by any system tool
or service. So ther's no problematic case, then ok, I'm probably not
understanding it completely yet so I'm asking. If it works by accident
or there's a corner case left I'd rather find it now.

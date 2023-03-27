Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A592B6C9FEC
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 11:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbjC0JgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 05:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjC0Jf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 05:35:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EE92108;
        Mon, 27 Mar 2023 02:35:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 458971FD6A;
        Mon, 27 Mar 2023 09:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679909754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TW0fKPKBX7rmV6RVNJ4lsd/4xOoTdCAvbvh5iuHbCQQ=;
        b=yG41cqsNZN/9+pXmfiH761y/x4v+MDo6ehuG3+65gNK3AUPDowTPqtBriczigQ/YmFs/Qw
        MNGZLkDR2uR1+B/9Z7Q0nJ9yYDOQDU+qcivvp9sFPF0LtsApNj9ENEC1k6j0/q26P4yYaR
        unNfZdMYsnzRShxwIcWabx7HjREuD5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679909754;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TW0fKPKBX7rmV6RVNJ4lsd/4xOoTdCAvbvh5iuHbCQQ=;
        b=zTjgNNY75KaHZMOx48/yVGdKtszWK36qyPbtDfk9uKMaSqP26vnb/PPDG2uJVJBKOzNFvr
        mOWRVyAWpdeDndBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38BE013482;
        Mon, 27 Mar 2023 09:35:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SKLPDXpjIWRWaQAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 27 Mar 2023 09:35:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id CA1C9A071C; Mon, 27 Mar 2023 11:35:53 +0200 (CEST)
Date:   Mon, 27 Mar 2023 11:35:53 +0200
From:   Jan Kara <jack@suse.cz>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ritesh.list@gmail.com,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, yukuai3@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ext4: fix race between writepages and remount
Message-ID: <20230327093553.up7dhoyqe4ecpn7y@quack3>
References: <20230316112832.2711783-1-libaokun1@huawei.com>
 <20230316112832.2711783-4-libaokun1@huawei.com>
 <20230323114407.xenntblzv4ewfqkk@quack3>
 <269d37fd-d3f2-d059-b71f-acaea2e7ce4b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <269d37fd-d3f2-d059-b71f-acaea2e7ce4b@huawei.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 23-03-23 22:18:53, Baokun Li wrote:
> On 2023/3/23 19:44, Jan Kara wrote:
> > > ---
> > >   fs/ext4/ext4.h      |  3 ++-
> > >   fs/ext4/ext4_jbd2.h |  9 +++++----
> > >   fs/ext4/super.c     | 14 ++++++++++++++
> > >   3 files changed, 21 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index 08b29c289da4..f60967fa648f 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -1703,7 +1703,8 @@ struct ext4_sb_info {
> > >   	/*
> > >   	 * Barrier between writepages ops and changing any inode's JOURNAL_DATA
> > > -	 * or EXTENTS flag.
> > > +	 * or EXTENTS flag or between changing SHOULD_DIOREAD_NOLOCK flag on
> > > +	 * remount and writepages ops.
> > >   	 */
> > >   	struct percpu_rw_semaphore s_writepages_rwsem;
> > >   	struct dax_device *s_daxdev;
> > > diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> > > index 0c77697d5e90..d82bfcdd56e5 100644
> > > --- a/fs/ext4/ext4_jbd2.h
> > > +++ b/fs/ext4/ext4_jbd2.h
> > > @@ -488,6 +488,9 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
> > >   	return blocks + 2*(EXT4_SB(inode->i_sb)->s_cluster_ratio - 1);
> > >   }
> > > +/* delalloc is a temporary fix to prevent generic/422 test failures*/
> > > +#define EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK (EXT4_MOUNT_DIOREAD_NOLOCK | \
> > > +					  EXT4_MOUNT_DELALLOC)
> > >   /*
> > >    * This function controls whether or not we should try to go down the
> > >    * dioread_nolock code paths, which makes it safe to avoid taking
> > > @@ -499,7 +502,8 @@ static inline int ext4_free_data_revoke_credits(struct inode *inode, int blocks)
> > >    */
> > >   static inline int ext4_should_dioread_nolock(struct inode *inode)
> > >   {
> > > -	if (!test_opt(inode->i_sb, DIOREAD_NOLOCK))
> > > +	if (test_opt(inode->i_sb, SHOULD_DIOREAD_NOLOCK) !=
> > > +	    EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK)
> > >   		return 0;
> > >   	if (!S_ISREG(inode->i_mode))
> > >   		return 0;
> > > @@ -507,9 +511,6 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
> > >   		return 0;
> > >   	if (ext4_should_journal_data(inode))
> > >   		return 0;
> > > -	/* temporary fix to prevent generic/422 test failures */
> > > -	if (!test_opt(inode->i_sb, DELALLOC))
> > > -		return 0;
> > >   	return 1;
> > >   }
> > Is there a need for this SHOULD_DIOREAD_NOLOCK? When called from writeback
> > we will be protected by s_writepages_rwsem anyway. When called from other
> > places, we either decide to do dioread_nolock or don't but the situation
> > can change at any instant so I don't see how unifying this check would
> > help. And the new SHOULD_DIOREAD_NOLOCK somewhat obfuscates what's going
> > on.
> We're thinking that the mount-related flags in
> ext4_should_dioread_nolock() might be modified, such as DELALLOC being
> removed because generic/422 test failures were fixed in some other way,
> resulting in some unnecessary locking during remount, or for whatever
> reason a mount-related flag was added to ext4_should_dioread_nolock(),
> and we didn't make a synchronization change in __ext4_remount() that
> would cause the problem to recur.  So we added this flag to this function
> (instead of in ext4.h), so that when we change the mount option in
> ext4_should_dioread_nolock(), we directly change this flag, and we don't
> have to consider making synchronization changes in __ext4_remount().
> 
> We have checked where this function is called and there are two types of
> calls to this function:
> 1. One category is ext4_do_writepages() and mpage_map_one_extent(), which
> are protected by s_writepages_rwsem, the location of the problem;
> 2. The other type is in ext4_page_mkwrite(),
> ext4_convert_inline_data_to_extent(), ext4_write_begin() to determine
> whether to get the block using ext4_get_block_unwritten() or
> ext4_get_block().
>
>     1) If we just started fetching written blocks, it looks like there is no
> problem;
>     2) If we start getting unwritten blocks, when DIOREAD_NOLOCK is cleared
> by remount,
>         we will convert the blocks to written in ext4_map_blocks(). The
> data=ordered mode ensures that we don't see stale data.

Yes. So do you agree that EXT4_MOUNT_SHOULD_DIOREAD_NOLOCK is not really
needed?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

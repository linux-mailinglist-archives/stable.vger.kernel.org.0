Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931325801C6
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 17:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiGYPYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 11:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiGYPXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 11:23:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF5ADEFF;
        Mon, 25 Jul 2022 08:23:51 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2A9B134766;
        Mon, 25 Jul 2022 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1658762630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUGJ3PqQTnqm66MAy0/FjC/XqfK/N/RtNfVCGdAwbxE=;
        b=1rpIOmW2vAzYN8Nn540Ti8uSriFLrQ1+TAFRG2TsJmHX1WAQhx6F7HYlmwgDzwVi0Gl44Q
        7880uAqz8cwF/AMWD+qUx+PZh6wlKYWK1fMSCOgskaBCt0zgTTPPwMsGttDKwDwRmE2zDV
        8uAtvNRbANk7rWTwnaupkUsxS2JgquQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1658762630;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUGJ3PqQTnqm66MAy0/FjC/XqfK/N/RtNfVCGdAwbxE=;
        b=I4rPhN2ui5XLrHOWaVqKuBS+xoVwH8rn2/mYSSln0zKzEpSR3/r1etK8HlAX10ULMzrgS9
        aTrUB+D9DtmdZsDQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A28AF2C171;
        Mon, 25 Jul 2022 15:23:48 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 5F0CDA0663; Mon, 25 Jul 2022 17:23:29 +0200 (CEST)
Date:   Mon, 25 Jul 2022 17:23:29 +0200
From:   Jan Kara <jack@suse.cz>
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 05/10] ext4: Fix race when reusing xattr blocks
Message-ID: <20220725152329.xleuy6quqsh2mtkn@quack3>
References: <20220712104519.29887-1-jack@suse.cz>
 <20220712105436.32204-5-jack@suse.cz>
 <0556811b-29f7-799b-66fc-87e4127cb714@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0556811b-29f7-799b-66fc-87e4127cb714@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 16-07-22 11:00:46, Zhihao Cheng wrote:
> 在 2022/7/12 18:54, Jan Kara 写道:
> Hi Jan, one little question confuses me:
> > When ext4_xattr_block_set() decides to remove xattr block the following
> > race can happen:
> > 
> > CPU1                                    CPU2
> > ext4_xattr_block_set()                  ext4_xattr_release_block()
> >    new_bh = ext4_xattr_block_cache_find()
> > 
> >                                            lock_buffer(bh);
> >                                            ref = le32_to_cpu(BHDR(bh)->h_refcount);
> >                                            if (ref == 1) {
> >                                              ...
> >                                              mb_cache_entry_delete();
> >                                              unlock_buffer(bh);
> >                                              ext4_free_blocks();
> >                                                ...
> >                                                ext4_forget(..., bh, ...);
> >                                                  jbd2_journal_revoke(..., bh);
> > 
> >    ext4_journal_get_write_access(..., new_bh, ...)
> >      do_get_write_access()
> >        jbd2_journal_cancel_revoke(..., new_bh);
> > 
> > Later the code in ext4_xattr_block_set() finds out the block got freed
> > and cancels reusal of the block but the revoke stays canceled and so in
> > case of block reuse and journal replay the filesystem can get corrupted.
> > If the race works out slightly differently, we can also hit assertions
> > in the jbd2 code.
> > 
> > Fix the problem by making sure that once matching mbcache entry is
> > found, code dropping the last xattr block reference (or trying to modify
> > xattr block in place) waits until the mbcache entry reference is
> > dropped. This way code trying to reuse xattr block is protected from
> > someone trying to drop the last reference to xattr block.
> > 
> > Reported-and-tested-by: Ritesh Harjani <ritesh.list@gmail.com>
> > CC: stable@vger.kernel.org
> > Fixes: 82939d7999df ("ext4: convert to mbcache2")
> > Signed-off-by: Jan Kara <jack@suse.cz>

...

> > @@ -1991,18 +2020,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
> >   				lock_buffer(new_bh);
> >   				/*
> >   				 * We have to be careful about races with
> > -				 * freeing, rehashing or adding references to
> > -				 * xattr block. Once we hold buffer lock xattr
> > -				 * block's state is stable so we can check
> > -				 * whether the block got freed / rehashed or
> > -				 * not.  Since we unhash mbcache entry under
> > -				 * buffer lock when freeing / rehashing xattr
> > -				 * block, checking whether entry is still
> > -				 * hashed is reliable. Same rules hold for
> > -				 * e_reusable handling.
> > +				 * adding references to xattr block. Once we
> > +				 * hold buffer lock xattr block's state is
> > +				 * stable so we can check the additional
> > +				 * reference fits.
> >   				 */
> > -				if (hlist_bl_unhashed(&ce->e_hash_list) ||
> > -				    !ce->e_reusable) {
> > +				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
> > +				if (ref > EXT4_XATTR_REFCOUNT_MAX) {
> 
> So far, we have mb_cache_entry_delete_or_get() and
> mb_cache_entry_wait_unused(), so used cache entry cannot be concurrently
> removed. Removing check 'hlist_bl_unhashed(&ce->e_hash_list)' is okay.
> 
> What's affect of changing the other two checks 'ref >=
> EXT4_XATTR_REFCOUNT_MAX' and '!ce->e_reusable'? To make code more obvious?
> eg. To point out the condition of 'ref <= EXT4_XATTR_REFCOUNT_MAX' rather
> than 'ce->e_reusable', we have checked 'ce->e_reusable' in
> ext4_xattr_block_cache_find() before?

Well, ce->e_reusable is set if and only if BHDR(new_bh)->h_refcount <
EXT4_XATTR_REFCOUNT_MAX. So checking whether the refcount is small enough
is all that is needed and we don't need the ce->e_reusable check here.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

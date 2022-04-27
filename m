Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F4051176E
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiD0MfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 08:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbiD0MfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 08:35:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4DE4B1F7;
        Wed, 27 Apr 2022 05:31:51 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 25822210E1;
        Wed, 27 Apr 2022 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651062710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C3N+181NGxO23xtLtvgHl8EcRvfl2YIztgq+N5zcc0Q=;
        b=kWUZDuXbv8n2l/4bg7OILM4Wfr0TQMfM5n6UhSLLBFO7QYMTHTlbH+FN7XNsg/mci/2Rx7
        I2lkStWKbWmrJEWTtKeJ3rmPz4ywrN5IbbBdWTo7xlqxFERARNsiPV213biZtVVk/prgZw
        LBdLLHuyIdfvp1EFx7JNWnosE4JstNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651062710;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C3N+181NGxO23xtLtvgHl8EcRvfl2YIztgq+N5zcc0Q=;
        b=YDFmMRH5H6YmEcStLmEwyHz/6yKosU9Gn1KxGeR6GXSKAKCWA/0JT4zdiRl/XcfLXUj4ki
        wXIOqfgdtdVLYTBQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0C0EB2C141;
        Wed, 27 Apr 2022 12:31:49 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 95379A0620; Wed, 27 Apr 2022 14:31:46 +0200 (CEST)
Date:   Wed, 27 Apr 2022 14:31:46 +0200
From:   Jan Kara <jack@suse.cz>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yebin10@huawei.com, yukuai3@huawei.com, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH v2] ext4: fix race condition between ext4_write and
 ext4_convert_inline_data
Message-ID: <20220427123146.ymm7lodedvtot2ij@quack3.lan>
References: <20220426140658.1046700-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426140658.1046700-1-libaokun1@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 26-04-22 22:06:58, Baokun Li wrote:
> Hulk Robot reported a BUG_ON:
>  ==================================================================
>  EXT4-fs error (device loop3): ext4_mb_generate_buddy:805: group 0,
>  block bitmap and bg descriptor inconsistent: 25 vs 31513 free clusters
>  kernel BUG at fs/ext4/ext4_jbd2.c:53!
>  invalid opcode: 0000 [#1] SMP KASAN PTI
>  CPU: 0 PID: 25371 Comm: syz-executor.3 Not tainted 5.10.0+ #1
>  RIP: 0010:ext4_put_nojournal fs/ext4/ext4_jbd2.c:53 [inline]
>  RIP: 0010:__ext4_journal_stop+0x10e/0x110 fs/ext4/ext4_jbd2.c:116
>  [...]
>  Call Trace:
>   ext4_write_inline_data_end+0x59a/0x730 fs/ext4/inline.c:795
>   generic_perform_write+0x279/0x3c0 mm/filemap.c:3344
>   ext4_buffered_write_iter+0x2e3/0x3d0 fs/ext4/file.c:270
>   ext4_file_write_iter+0x30a/0x11c0 fs/ext4/file.c:520
>   do_iter_readv_writev+0x339/0x3c0 fs/read_write.c:732
>   do_iter_write+0x107/0x430 fs/read_write.c:861
>   vfs_writev fs/read_write.c:934 [inline]
>   do_pwritev+0x1e5/0x380 fs/read_write.c:1031
>  [...]
>  ==================================================================
> 
> Above issue may happen as follows:
>            cpu1                     cpu2
> __________________________|__________________________
> do_pwritev
>  vfs_writev
>   do_iter_write
>    ext4_file_write_iter
>     ext4_buffered_write_iter
>      generic_perform_write
>       ext4_da_write_begin
>                            vfs_fallocate
>                             ext4_fallocate
>                              ext4_convert_inline_data
>                               ext4_convert_inline_data_nolock
>                                ext4_destroy_inline_data_nolock
>                                 clear EXT4_STATE_MAY_INLINE_DATA
>                                ext4_map_blocks
>                                 ext4_ext_map_blocks
>                                  ext4_mb_new_blocks
>                                   ext4_mb_regular_allocator
>                                    ext4_mb_good_group_nolock
>                                     ext4_mb_init_group
>                                      ext4_mb_init_cache
>                                       ext4_mb_generate_buddy  --> error
>        ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)
>                                 ext4_restore_inline_data
>                                  set EXT4_STATE_MAY_INLINE_DATA
>        ext4_block_write_begin
>       ext4_da_write_end
>        ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)
>        ext4_write_inline_data_end
>         handle=NULL
>         ext4_journal_stop(handle)
>          __ext4_journal_stop
>           ext4_put_nojournal(handle)
>            ref_cnt = (unsigned long)handle
>            BUG_ON(ref_cnt == 0)  ---> BUG_ON
> 
> The lock held by ext4_convert_inline_data is xattr_sem, but the lock
> held by generic_perform_write is i_rwsem. Therefore, the two locks can
> be concurrent. To solve above issue, we just add inode_lock in
> ext4_convert_inline_data.
> 
> Fixes: 0c8d414f163f ("ext4: let fallocate handle inline data correctly")
> Cc: stable@vger.kernel.org
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Thanks for the report and the patch. I agree inode_lock is needed to
protect the conversion.  However you cannot lock it inside
ext4_convert_inline_data() because it is often called with inode_lock
already held (in fact in most of the other cases as far as I have checked).
So the right fix is to reorganize ext4_fallocate() a bit to do something
like:

	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
	if (ext4_has_inline_data(inode)) {
		inode_lock(inode);
		ret = ext4_convert_inline_data(inode);
		inode_unlock(inode);
		if (ret)
			goto exit;
	}

and remove similar handling from ext4_punch_hole() (and make sure it uses
the new handling in ext4_fallocate()).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

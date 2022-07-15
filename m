Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DFC5763B4
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiGOOgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiGOOgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:36:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016164E856
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 07:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0684B82BAD
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 14:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BD8C34115;
        Fri, 15 Jul 2022 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657895779;
        bh=5uoOKUnb+mQQz65bfusGg5ofEMk7zhXgg0Uz8Wi1eOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vcyqA+DtgXhJc1+g8BCjySxc/gdaCgC6CGf39b7pskBHQ0it1/yHFvcrmjfuaJl2p
         9STBRtoY96xpAxrg+KO3b0rKBtbmpNu2Tzgh8BMfMCDvLuqGAb95YYEcxCTifVeHn/
         3l83U4U1Wj/b81eH91Y9/Y+TUYjxyUkSXuTKdn14=
Date:   Fri, 15 Jul 2022 16:36:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        syzbot+2cc95c8e803bc7c9e5cb@syzkaller.appspotmail.com,
        Hulk Robot <hulkci@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5.10] ext4: fix race condition between ext4_write and
 ext4_convert_inline_data
Message-ID: <YtF7YPLIhZosOeIt@kroah.com>
References: <20220712185026.2801747-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712185026.2801747-1-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 11:50:26AM -0700, Tadeusz Struk wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> This is backport to 5.10 stable kernel only.
> This patch has already been applied to kernels > 5.10.
> 
> commit f87c7a4b084afc13190cbb263538e444cb2b392a upstream
> 
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
> be concurrent.
> 
> To solve above issue, we add inode_lock() for ext4_convert_inline_data().
> At the same time, move ext4_convert_inline_data() in front of
> ext4_punch_hole(), remove similar handling from ext4_punch_hole().
> 
> Fixes: 0c8d414f163f ("ext4: let fallocate handle inline data correctly")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+2cc95c8e803bc7c9e5cb@syzkaller.appspotmail.com
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://syzkaller.appspot.com/bug?id=184195865fd95e1e551f8af0fe43858126d15076
> Link: https://lore.kernel.org/r/20220428134031.4153381-1-libaokun1@huawei.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  fs/ext4/extents.c | 9 +++++----
>  fs/ext4/inode.c   | 9 ---------
>  2 files changed, 5 insertions(+), 13 deletions(-)

Both now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFC6603D3F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJSJAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiJSI6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45849DD89;
        Wed, 19 Oct 2022 01:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45AD2617D1;
        Wed, 19 Oct 2022 08:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E03C433C1;
        Wed, 19 Oct 2022 08:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169034;
        bh=F/hirolBpGxpu/uc2JCMoWzXNNZUj+88U+p3ETdyMeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUxBeqoMiO8KYKEh7JW+bUgMx+i017e2rlsG8RaEHgXN6mDVJpFhRjodFRyihoHmz
         PHrYs8r31pEKFqBvkghMRmd8c1MgVJkomIK6cFBGmYnzpdRFj+tJX2CRYCBWtbc3P9
         j6hhiJaTg/VysFouI17+3pB1FAZhPD90WkkirtRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Baokun Li <libaokun1@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 136/862] ext4: fix null-ptr-deref in ext4_write_info
Date:   Wed, 19 Oct 2022 10:23:43 +0200
Message-Id: <20221019083255.990667040@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit f9c1f248607d5546075d3f731e7607d5571f2b60 upstream.

I caught a null-ptr-deref bug as follows:
==================================================================
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 1 PID: 1589 Comm: umount Not tainted 5.10.0-02219-dirty #339
RIP: 0010:ext4_write_info+0x53/0x1b0
[...]
Call Trace:
 dquot_writeback_dquots+0x341/0x9a0
 ext4_sync_fs+0x19e/0x800
 __sync_filesystem+0x83/0x100
 sync_filesystem+0x89/0xf0
 generic_shutdown_super+0x79/0x3e0
 kill_block_super+0xa1/0x110
 deactivate_locked_super+0xac/0x130
 deactivate_super+0xb6/0xd0
 cleanup_mnt+0x289/0x400
 __cleanup_mnt+0x16/0x20
 task_work_run+0x11c/0x1c0
 exit_to_user_mode_prepare+0x203/0x210
 syscall_exit_to_user_mode+0x5b/0x3a0
 do_syscall_64+0x59/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
 ==================================================================

Above issue may happen as follows:
-------------------------------------
exit_to_user_mode_prepare
 task_work_run
  __cleanup_mnt
   cleanup_mnt
    deactivate_super
     deactivate_locked_super
      kill_block_super
       generic_shutdown_super
        shrink_dcache_for_umount
         dentry = sb->s_root
         sb->s_root = NULL              <--- Here set NULL
        sync_filesystem
         __sync_filesystem
          sb->s_op->sync_fs > ext4_sync_fs
           dquot_writeback_dquots
            sb->dq_op->write_info > ext4_write_info
             ext4_journal_start(d_inode(sb->s_root), EXT4_HT_QUOTA, 2)
              d_inode(sb->s_root)
               s_root->d_inode          <--- Null pointer dereference

To solve this problem, we use ext4_journal_start_sb directly
to avoid s_root being used.

Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220805123947.565152-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6653,7 +6653,7 @@ static int ext4_write_info(struct super_
 	handle_t *handle;
 
 	/* Data block + inode block */
-	handle = ext4_journal_start(d_inode(sb->s_root), EXT4_HT_QUOTA, 2);
+	handle = ext4_journal_start_sb(sb, EXT4_HT_QUOTA, 2);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit_info(sb, type);



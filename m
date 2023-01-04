Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFB65D92B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbjADQWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbjADQWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BEEA45E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:22:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE2B861798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C8BC433EF;
        Wed,  4 Jan 2023 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849322;
        bh=v5XiEtDxwyasmqQJ9siHlmK2qqmLaQFwWIlnYW3zvCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQ2yiDI9ipf/SxyR+yfyHKknMhMc/uNe4iNMAx3z1CLG/1uY2wLrp1myho5md+S56
         9ev4QxiAG8PxfsLlzrGWGTiEQhVCN8YIqSaQOmfF5OLp55QrQe3wBd++6l3wt7gJgX
         2o37anVSnG7QiCGEBWJgBM7/FWn0t8ZrVOddTTeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baokun Li <libaokun1@huawei.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jason Yan <yanaijie@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.1 170/207] ext4: fix bug_on in __es_tree_search caused by bad quota inode
Date:   Wed,  4 Jan 2023 17:07:08 +0100
Message-Id: <20230104160517.267072225@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit d323877484765aaacbb2769b06e355c2041ed115 upstream.

We got a issue as fllows:
==================================================================
 kernel BUG at fs/ext4/extents_status.c:202!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 1 PID: 810 Comm: mount Not tainted 6.1.0-rc1-next-g9631525255e3 #352
 RIP: 0010:__es_tree_search.isra.0+0xb8/0xe0
 RSP: 0018:ffffc90001227900 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: 0000000077512a0f RCX: 0000000000000000
 RDX: 0000000000000002 RSI: 0000000000002a10 RDI: ffff8881004cd0c8
 RBP: ffff888177512ac8 R08: 47ffffffffffffff R09: 0000000000000001
 R10: 0000000000000001 R11: 00000000000679af R12: 0000000000002a10
 R13: ffff888177512d88 R14: 0000000077512a10 R15: 0000000000000000
 FS: 00007f4bd76dbc40(0000)GS:ffff88842fd00000(0000)knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005653bf993cf8 CR3: 000000017bfdf000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  ext4_es_cache_extent+0xe2/0x210
  ext4_cache_extents+0xd2/0x110
  ext4_find_extent+0x5d5/0x8c0
  ext4_ext_map_blocks+0x9c/0x1d30
  ext4_map_blocks+0x431/0xa50
  ext4_getblk+0x82/0x340
  ext4_bread+0x14/0x110
  ext4_quota_read+0xf0/0x180
  v2_read_header+0x24/0x90
  v2_check_quota_file+0x2f/0xa0
  dquot_load_quota_sb+0x26c/0x760
  dquot_load_quota_inode+0xa5/0x190
  ext4_enable_quotas+0x14c/0x300
  __ext4_fill_super+0x31cc/0x32c0
  ext4_fill_super+0x115/0x2d0
  get_tree_bdev+0x1d2/0x360
  ext4_get_tree+0x19/0x30
  vfs_get_tree+0x26/0xe0
  path_mount+0x81d/0xfc0
  do_mount+0x8d/0xc0
  __x64_sys_mount+0xc0/0x160
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  </TASK>
==================================================================

Above issue may happen as follows:
-------------------------------------
ext4_fill_super
 ext4_orphan_cleanup
  ext4_enable_quotas
   ext4_quota_enable
    ext4_iget --> get error inode <5>
     ext4_ext_check_inode --> Wrong imode makes it escape inspection
     make_bad_inode(inode) --> EXT4_BOOT_LOADER_INO set imode
    dquot_load_quota_inode
     vfs_setup_quota_inode --> check pass
     dquot_load_quota_sb
      v2_check_quota_file
       v2_read_header
        ext4_quota_read
         ext4_bread
          ext4_getblk
           ext4_map_blocks
            ext4_ext_map_blocks
             ext4_find_extent
              ext4_cache_extents
               ext4_es_cache_extent
                __es_tree_search.isra.0
                 ext4_es_end --> Wrong extents trigger BUG_ON

In the above issue, s_usr_quota_inum is set to 5, but inode<5> contains
incorrect imode and disordered extents. Because 5 is EXT4_BOOT_LOADER_INO,
the ext4_ext_check_inode check in the ext4_iget function can be bypassed,
finally, the extents that are not checked trigger the BUG_ON in the
__es_tree_search function. To solve this issue, check whether the inode is
bad_inode in vfs_setup_quota_inode().

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221026042310.3839669-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/quota/dquot.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2324,6 +2324,8 @@ static int vfs_setup_quota_inode(struct
 	struct super_block *sb = inode->i_sb;
 	struct quota_info *dqopt = sb_dqopt(sb);
 
+	if (is_bad_inode(inode))
+		return -EUCLEAN;
 	if (!S_ISREG(inode->i_mode))
 		return -EACCES;
 	if (IS_RDONLY(inode))



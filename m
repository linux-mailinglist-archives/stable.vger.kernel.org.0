Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C58C59D7F3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351129AbiHWJgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351829AbiHWJgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:36:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29931979EC;
        Tue, 23 Aug 2022 01:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED03611DD;
        Tue, 23 Aug 2022 08:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6707C433D6;
        Tue, 23 Aug 2022 08:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243958;
        bh=vVIE8jLVJxP6CJmflVD1oLU9ouDnYVctK1YS8qIz2no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16lm036aElAtjJ2Y2mY8xuN6yaHtzzxiiWlVv0exU7vIB4AGg8TMWy/ogmMySeWHg
         XQXAQQQS4ua8YyiJp84ydW9T88VtQOE6Lr7SZ9oRm5WD3P1w1XA7AmltW3x8+ESGID
         NXm/oZ+7t4//YnkafkIN7ZJO6j1J9jwHqPODVO9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Nikolay Borisov <nborisov@suse.com>,
        Zixuan Fu <r33s3n6@gmail.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 014/244] btrfs: unset reloc control if transaction commit fails in prepare_to_relocate()
Date:   Tue, 23 Aug 2022 10:22:53 +0200
Message-Id: <20220823080059.553744861@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zixuan Fu <r33s3n6@gmail.com>

commit 85f02d6c856b9f3a0acf5219de6e32f58b9778eb upstream.

In btrfs_relocate_block_group(), the rc is allocated.  Then
btrfs_relocate_block_group() calls

relocate_block_group()
  prepare_to_relocate()
    set_reloc_control()

that assigns rc to the variable fs_info->reloc_ctl. When
prepare_to_relocate() returns, it calls

btrfs_commit_transaction()
  btrfs_start_dirty_block_groups()
    btrfs_alloc_path()
      kmem_cache_zalloc()

which may fail for example (or other errors could happen). When the
failure occurs, btrfs_relocate_block_group() detects the error and frees
rc and doesn't set fs_info->reloc_ctl to NULL. After that, in
btrfs_init_reloc_root(), rc is retrieved from fs_info->reloc_ctl and
then used, which may cause a use-after-free bug.

This possible bug can be triggered by calling btrfs_ioctl_balance()
before calling btrfs_ioctl_defrag().

To fix this possible bug, in prepare_to_relocate(), check if
btrfs_commit_transaction() fails. If the failure occurs,
unset_reloc_control() is called to set fs_info->reloc_ctl to NULL.

The error log in our fault-injection testing is shown as follows:

  [   58.751070] BUG: KASAN: use-after-free in btrfs_init_reloc_root+0x7ca/0x920 [btrfs]
  ...
  [   58.753577] Call Trace:
  ...
  [   58.755800]  kasan_report+0x45/0x60
  [   58.756066]  btrfs_init_reloc_root+0x7ca/0x920 [btrfs]
  [   58.757304]  record_root_in_trans+0x792/0xa10 [btrfs]
  [   58.757748]  btrfs_record_root_in_trans+0x463/0x4f0 [btrfs]
  [   58.758231]  start_transaction+0x896/0x2950 [btrfs]
  [   58.758661]  btrfs_defrag_root+0x250/0xc00 [btrfs]
  [   58.759083]  btrfs_ioctl_defrag+0x467/0xa00 [btrfs]
  [   58.759513]  btrfs_ioctl+0x3c95/0x114e0 [btrfs]
  ...
  [   58.768510] Allocated by task 23683:
  [   58.768777]  ____kasan_kmalloc+0xb5/0xf0
  [   58.769069]  __kmalloc+0x227/0x3d0
  [   58.769325]  alloc_reloc_control+0x10a/0x3d0 [btrfs]
  [   58.769755]  btrfs_relocate_block_group+0x7aa/0x1e20 [btrfs]
  [   58.770228]  btrfs_relocate_chunk+0xf1/0x760 [btrfs]
  [   58.770655]  __btrfs_balance+0x1326/0x1f10 [btrfs]
  [   58.771071]  btrfs_balance+0x3150/0x3d30 [btrfs]
  [   58.771472]  btrfs_ioctl_balance+0xd84/0x1410 [btrfs]
  [   58.771902]  btrfs_ioctl+0x4caa/0x114e0 [btrfs]
  ...
  [   58.773337] Freed by task 23683:
  ...
  [   58.774815]  kfree+0xda/0x2b0
  [   58.775038]  free_reloc_control+0x1d6/0x220 [btrfs]
  [   58.775465]  btrfs_relocate_block_group+0x115c/0x1e20 [btrfs]
  [   58.775944]  btrfs_relocate_chunk+0xf1/0x760 [btrfs]
  [   58.776369]  __btrfs_balance+0x1326/0x1f10 [btrfs]
  [   58.776784]  btrfs_balance+0x3150/0x3d30 [btrfs]
  [   58.777185]  btrfs_ioctl_balance+0xd84/0x1410 [btrfs]
  [   58.777621]  btrfs_ioctl+0x4caa/0x114e0 [btrfs]
  ...

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3576,7 +3576,12 @@ int prepare_to_relocate(struct reloc_con
 		 */
 		return PTR_ERR(trans);
 	}
-	return btrfs_commit_transaction(trans);
+
+	ret = btrfs_commit_transaction(trans);
+	if (ret)
+		unset_reloc_control(rc);
+
+	return ret;
 }
 
 static noinline_for_stack int relocate_block_group(struct reloc_control *rc)



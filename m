Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263C9561D3C
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiF3OI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237014AbiF3OIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:08:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A97F58FE2;
        Thu, 30 Jun 2022 06:55:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F053A6214E;
        Thu, 30 Jun 2022 13:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0907BC34115;
        Thu, 30 Jun 2022 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597295;
        bh=AfiYerHK8ynfsAmFQ810Q0NwarNpAhjP60hMUlP7REA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibwPTHJ0Z65733JH6U2QgcJxCOUgqXGpUgjn9zFMSe0qOLbP9OFNvdSQuRUym+SOq
         ONJ/YmHLLFS4ybIr+iH1Pl/jEKeeFmNZp+0YVyMvDmii/ywdlX2p3ISc61GLc9hgFT
         xXNYBRLZWsTaKKCSnH8fJvLshDeBzuqkAo10bzmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 07/28] xfs: Fix the free logic of state in xfs_attr_node_hasname
Date:   Thu, 30 Jun 2022 15:47:03 +0200
Message-Id: <20220630133233.142499211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

[ Upstream commit a1de97fe296c52eafc6590a3506f4bbd44ecb19a ]

When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.

The deadlock as below:
[983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
[  983.923405] Call Trace:
[  983.923410]  __schedule+0x2c4/0x700
[  983.923412]  schedule+0x37/0xa0
[  983.923414]  schedule_timeout+0x274/0x300
[  983.923416]  __down+0x9b/0xf0
[  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923453]  down+0x3b/0x50
[  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
[  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
[  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
[  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
[  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
[  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
[  983.923624]  ? kmem_cache_alloc+0x12e/0x270
[  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
[  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
[  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
[  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
[  983.923686]  __vfs_removexattr+0x4d/0x60
[  983.923688]  __vfs_removexattr_locked+0xac/0x130
[  983.923689]  vfs_removexattr+0x4e/0xf0
[  983.923690]  removexattr+0x4d/0x80
[  983.923693]  ? __check_object_size+0xa8/0x16b
[  983.923695]  ? strncpy_from_user+0x47/0x1a0
[  983.923696]  ? getname_flags+0x6a/0x1e0
[  983.923697]  ? _cond_resched+0x15/0x30
[  983.923699]  ? __sb_start_write+0x1e/0x70
[  983.923700]  ? mnt_want_write+0x28/0x50
[  983.923701]  path_removexattr+0x9b/0xb0
[  983.923702]  __x64_sys_removexattr+0x17/0x20
[  983.923704]  do_syscall_64+0x5b/0x1a0
[  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[  983.923707] RIP: 0033:0x7f080f10ee1b

When getxattr calls xfs_attr_node_get function, xfs_da3_node_lookup_int fails with EFSCORRUPTED in
xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
free state in internal and xfs_attr_node_get doesn't do xfs_buf_trans release job.

Then subsequent removexattr will hang because of it.

This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
in this case. But xfs_attr_node_hasname will free state itself instead of caller if
xfs_da3_node_lookup_int fails.

Fix this bug by moving the step of free state into caller.

Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
xfs_attr_node_removename_setup function because we should free state ourselves.

Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1077,21 +1077,18 @@ xfs_attr_node_hasname(
 
 	state = xfs_da_state_alloc(args);
 	if (statep != NULL)
-		*statep = NULL;
+		*statep = state;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error) {
-		xfs_da_state_free(state);
-		return error;
-	}
+	if (error)
+		retval = error;
 
-	if (statep != NULL)
-		*statep = state;
-	else
+	if (!statep)
 		xfs_da_state_free(state);
+
 	return retval;
 }
 
@@ -1112,7 +1109,7 @@ xfs_attr_node_addname_find_attr(
 	 */
 	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		return retval;
+		goto error;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto error;
@@ -1337,7 +1334,7 @@ int xfs_attr_node_removename_setup(
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
-		return error;
+		goto out;
 	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);



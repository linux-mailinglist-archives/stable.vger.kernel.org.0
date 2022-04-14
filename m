Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9291501170
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244850AbiDNNgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343688AbiDNN3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2185E9F6EE;
        Thu, 14 Apr 2022 06:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B216F61B18;
        Thu, 14 Apr 2022 13:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF205C385A1;
        Thu, 14 Apr 2022 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942713;
        bh=AyLMklGPuJYElFV3GJEcjuGGHBpthjripRp0e51U+I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfimXx5uC7rui1QXbn80N1dKY6UR/chzpMz4hPCi7m6rzC8XTf/BatCRa9uBG3zP1
         eRfxh6tQmpihNs2e9o0FOEyajmMB8fnR3rqdfOo+TCVH5yB62wT4nzrkE/OdfyaS7M
         Vq5VJjRjvRVccjFdumWSiyhk49lmakbi8izuYfRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.19 233/338] ubifs: rename_whiteout: Fix double free for whiteout_ui->data
Date:   Thu, 14 Apr 2022 15:12:16 +0200
Message-Id: <20220414110845.521261097@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 40a8f0d5e7b3999f096570edab71c345da812e3e upstream.

'whiteout_ui->data' will be freed twice if space budget fail for
rename whiteout operation as following process:

rename_whiteout
  dev = kmalloc
  whiteout_ui->data = dev
  kfree(whiteout_ui->data)  // Free first time
  iput(whiteout)
    ubifs_free_inode
      kfree(ui->data)	    // Double free!

KASAN reports:
==================================================================
BUG: KASAN: double-free or invalid-free in ubifs_free_inode+0x4f/0x70
Call Trace:
  kfree+0x117/0x490
  ubifs_free_inode+0x4f/0x70 [ubifs]
  i_callback+0x30/0x60
  rcu_do_batch+0x366/0xac0
  __do_softirq+0x133/0x57f

Allocated by task 1506:
  kmem_cache_alloc_trace+0x3c2/0x7a0
  do_rename+0x9b7/0x1150 [ubifs]
  ubifs_rename+0x106/0x1f0 [ubifs]
  do_syscall_64+0x35/0x80

Freed by task 1506:
  kfree+0x117/0x490
  do_rename.cold+0x53/0x8a [ubifs]
  ubifs_rename+0x106/0x1f0 [ubifs]
  do_syscall_64+0x35/0x80

The buggy address belongs to the object at ffff88810238bed8 which
belongs to the cache kmalloc-8 of size 8
==================================================================

Let ubifs_free_inode() free 'whiteout_ui->data'. BTW, delete unused
assignment 'whiteout_ui->data_len = 0', process 'ubifs_evict_inode()
-> ubifs_jnl_delete_inode() -> ubifs_jnl_write_inode()' doesn't need it
(because 'inc_nlink(whiteout)' won't be excuted by 'goto out_release',
 and the nlink of whiteout inode is 0).

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1442,8 +1442,6 @@ static int do_rename(struct inode *old_d
 
 		err = ubifs_budget_space(c, &wht_req);
 		if (err) {
-			kfree(whiteout_ui->data);
-			whiteout_ui->data_len = 0;
 			iput(whiteout);
 			goto out_release;
 		}



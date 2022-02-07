Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B474ABC0D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiBGLf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384403AbiBGL2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBEDC043189;
        Mon,  7 Feb 2022 03:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FE8CB80EC3;
        Mon,  7 Feb 2022 11:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82B4C340EB;
        Mon,  7 Feb 2022 11:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233175;
        bh=nX/spthLodhzppYhHdGfbmaXFQuRzGLMi4gWVQbVVgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAFE0WzNKEQbYlRWECCnpDjb6Sw2bGEb9w2mj4zniqWHBcvDVMsftwjt5NUqQUz5K
         fRIitt3klS7J9b2Z5Qdh46Sj/xjoZTR8QWFZkGc6zpO4B7ghTW8V/KZMEiVn2GNQEM
         Jft6wweEFxmAJUYl55Bqgpx9kl1w41jU9otDY8XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e3f96c43d19782dd14a7@syzkaller.appspotmail.com,
        Jason Gunthorpe <jgg@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 5.15 040/110] RDMA/ucma: Protect mc during concurrent multicast leaves
Date:   Mon,  7 Feb 2022 12:06:13 +0100
Message-Id: <20220207103803.638511265@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

commit 36e8169ec973359f671f9ec7213547059cae972e upstream.

Partially revert the commit mentioned in the Fixes line to make sure that
allocation and erasing multicast struct are locked.

  BUG: KASAN: use-after-free in ucma_cleanup_multicast drivers/infiniband/core/ucma.c:491 [inline]
  BUG: KASAN: use-after-free in ucma_destroy_private_ctx+0x914/0xb70 drivers/infiniband/core/ucma.c:579
  Read of size 8 at addr ffff88801bb74b00 by task syz-executor.1/25529
  CPU: 0 PID: 25529 Comm: syz-executor.1 Not tainted 5.16.0-rc7-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
   print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
   __kasan_report mm/kasan/report.c:433 [inline]
   kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
   ucma_cleanup_multicast drivers/infiniband/core/ucma.c:491 [inline]
   ucma_destroy_private_ctx+0x914/0xb70 drivers/infiniband/core/ucma.c:579
   ucma_destroy_id+0x1e6/0x280 drivers/infiniband/core/ucma.c:614
   ucma_write+0x25c/0x350 drivers/infiniband/core/ucma.c:1732
   vfs_write+0x28e/0xae0 fs/read_write.c:588
   ksys_write+0x1ee/0x250 fs/read_write.c:643
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Currently the xarray search can touch a concurrently freeing mc as the
xa_for_each() is not surrounded by any lock. Rather than hold the lock for
a full scan hold it only for the effected items, which is usually an empty
list.

Fixes: 95fe51096b7a ("RDMA/ucma: Remove mc_list and rely on xarray")
Link: https://lore.kernel.org/r/1cda5fabb1081e8d16e39a48d3a4f8160cea88b8.1642491047.git.leonro@nvidia.com
Reported-by: syzbot+e3f96c43d19782dd14a7@syzkaller.appspotmail.com
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/ucma.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -95,6 +95,7 @@ struct ucma_context {
 	u64			uid;
 
 	struct list_head	list;
+	struct list_head	mc_list;
 	struct work_struct	close_work;
 };
 
@@ -105,6 +106,7 @@ struct ucma_multicast {
 
 	u64			uid;
 	u8			join_state;
+	struct list_head	list;
 	struct sockaddr_storage	addr;
 };
 
@@ -198,6 +200,7 @@ static struct ucma_context *ucma_alloc_c
 
 	INIT_WORK(&ctx->close_work, ucma_close_id);
 	init_completion(&ctx->comp);
+	INIT_LIST_HEAD(&ctx->mc_list);
 	/* So list_del() will work if we don't do ucma_finish_ctx() */
 	INIT_LIST_HEAD(&ctx->list);
 	ctx->file = file;
@@ -484,19 +487,19 @@ err1:
 
 static void ucma_cleanup_multicast(struct ucma_context *ctx)
 {
-	struct ucma_multicast *mc;
-	unsigned long index;
+	struct ucma_multicast *mc, *tmp;
 
-	xa_for_each(&multicast_table, index, mc) {
-		if (mc->ctx != ctx)
-			continue;
+	xa_lock(&multicast_table);
+	list_for_each_entry_safe(mc, tmp, &ctx->mc_list, list) {
+		list_del(&mc->list);
 		/*
 		 * At this point mc->ctx->ref is 0 so the mc cannot leave the
 		 * lock on the reader and this is enough serialization
 		 */
-		xa_erase(&multicast_table, index);
+		__xa_erase(&multicast_table, mc->id);
 		kfree(mc);
 	}
+	xa_unlock(&multicast_table);
 }
 
 static void ucma_cleanup_mc_events(struct ucma_multicast *mc)
@@ -1469,12 +1472,16 @@ static ssize_t ucma_process_join(struct
 	mc->uid = cmd->uid;
 	memcpy(&mc->addr, addr, cmd->addr_size);
 
-	if (xa_alloc(&multicast_table, &mc->id, NULL, xa_limit_32b,
+	xa_lock(&multicast_table);
+	if (__xa_alloc(&multicast_table, &mc->id, NULL, xa_limit_32b,
 		     GFP_KERNEL)) {
 		ret = -ENOMEM;
 		goto err_free_mc;
 	}
 
+	list_add_tail(&mc->list, &ctx->mc_list);
+	xa_unlock(&multicast_table);
+
 	mutex_lock(&ctx->mutex);
 	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *)&mc->addr,
 				  join_state, mc);
@@ -1500,8 +1507,11 @@ err_leave_multicast:
 	mutex_unlock(&ctx->mutex);
 	ucma_cleanup_mc_events(mc);
 err_xa_erase:
-	xa_erase(&multicast_table, mc->id);
+	xa_lock(&multicast_table);
+	list_del(&mc->list);
+	__xa_erase(&multicast_table, mc->id);
 err_free_mc:
+	xa_unlock(&multicast_table);
 	kfree(mc);
 err_put_ctx:
 	ucma_put_ctx(ctx);
@@ -1569,15 +1579,17 @@ static ssize_t ucma_leave_multicast(stru
 		mc = ERR_PTR(-EINVAL);
 	else if (!refcount_inc_not_zero(&mc->ctx->ref))
 		mc = ERR_PTR(-ENXIO);
-	else
-		__xa_erase(&multicast_table, mc->id);
-	xa_unlock(&multicast_table);
 
 	if (IS_ERR(mc)) {
+		xa_unlock(&multicast_table);
 		ret = PTR_ERR(mc);
 		goto out;
 	}
 
+	list_del(&mc->list);
+	__xa_erase(&multicast_table, mc->id);
+	xa_unlock(&multicast_table);
+
 	mutex_lock(&mc->ctx->mutex);
 	rdma_leave_multicast(mc->ctx->cm_id, (struct sockaddr *) &mc->addr);
 	mutex_unlock(&mc->ctx->mutex);



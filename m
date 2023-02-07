Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F8768D5E1
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBGLn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBGLnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:43:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9E711E9C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 03:43:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4647661355
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C38C433EF;
        Tue,  7 Feb 2023 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675770203;
        bh=cm+Ae6dXpHHlVf4fox9uKw8CLHvBGpVzLtxPuJjz49w=;
        h=Subject:To:Cc:From:Date:From;
        b=FrOvR12RsCwSvwsve3NpdUjSauayQUT5LNO69BCIt600a7Ksf+Q20ooxDT+FDOJXZ
         Husvr+7r6bnMARpZC6JRLTq81WsBfxs53lqXPpJa4wjVY8QibcLsgWjEIojQGTadDH
         ViDot/NlZ0yV+Lgett2uhZX87h1oVSqDVGPUlizc=
Subject: FAILED: patch "[PATCH] nvme-auth: use workqueue dedicated to authentication" failed to apply to 6.1-stable tree
To:     shinichiro.kawasaki@wdc.com, dwagner@suse.de, hare@suse.de,
        hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 12:43:20 +0100
Message-ID: <1675770200135119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

bd97a59da6a8 ("nvme-auth: use workqueue dedicated to authentication")
aa36d711e945 ("nvme-auth: convert dhchap_auth_list to an array")
8d1c1904e947 ("nvme-auth: clear sensitive info right after authentication completes")
e481fc0a3777 ("nvme-auth: guarantee dhchap buffers under memory pressure")
b7d604cae8f6 ("nvme-auth: don't keep long lived 4k dhchap buffer")
bfc4068e1e55 ("nvme-auth: remove redundant if statement")
01604350e145 ("nvme-auth: don't override ctrl keys before validation")
193a8c7e5f1a ("nvme-auth: don't ignore key generation failures when initializing ctrl keys")
f6b182fbd5c6 ("nvme-auth: remove redundant buffer deallocations")
0c999e69c40a ("nvme-auth: rename authentication work elements")
0a7ce375f83f ("nvme-auth: rename __nvme_auth_[reset|free] to nvme_auth[reset|free]_dhchap")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bd97a59da6a866e3dee5d2a2d582ec71dbbc84cd Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Tue, 31 Jan 2023 18:26:44 +0900
Subject: [PATCH] nvme-auth: use workqueue dedicated to authentication

NVMe In-Band authentication uses two kinds of works: chap->auth_work and
ctrl->dhchap_auth_work. The latter work flushes or cancels the former
work. However, the both works are queued to the same workqueue nvme-wq.
It results in the lockdep WARNING as follows:

 WARNING: possible recursive locking detected
 6.2.0-rc4+ #1 Not tainted
 --------------------------------------------
 kworker/u16:7/69 is trying to acquire lock:
 ffff902d52e65548 ((wq_completion)nvme-wq){+.+.}-{0:0}, at: start_flush_work+0x2c5/0x380

 but task is already holding lock:
 ffff902d52e65548 ((wq_completion)nvme-wq){+.+.}-{0:0}, at: process_one_work+0x210/0x410

To avoid the WARNING, introduce a new workqueue nvme-auth-wq dedicated
to chap->auth_work.

Reported-by: Daniel Wagner <dwagner@suse.de>
Link: https://lore.kernel.org/linux-nvme/20230130110802.paafkiipmitwtnwr@carbon.lan/
Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 4424f53a8a0a..b57630d1d3b8 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -45,6 +45,8 @@ struct nvme_dhchap_queue_context {
 	int sess_key_len;
 };
 
+struct workqueue_struct *nvme_auth_wq;
+
 #define nvme_auth_flags_from_qid(qid) \
 	(qid == 0) ? 0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED
 #define nvme_auth_queue_from_qid(ctrl, qid) \
@@ -866,7 +868,7 @@ int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
 
 	chap = &ctrl->dhchap_ctxs[qid];
 	cancel_work_sync(&chap->auth_work);
-	queue_work(nvme_wq, &chap->auth_work);
+	queue_work(nvme_auth_wq, &chap->auth_work);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_negotiate);
@@ -1008,10 +1010,15 @@ EXPORT_SYMBOL_GPL(nvme_auth_free);
 
 int __init nvme_init_auth(void)
 {
+	nvme_auth_wq = alloc_workqueue("nvme-auth-wq",
+			       WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
+	if (!nvme_auth_wq)
+		return -ENOMEM;
+
 	nvme_chap_buf_cache = kmem_cache_create("nvme-chap-buf-cache",
 				CHAP_BUF_SIZE, 0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!nvme_chap_buf_cache)
-		return -ENOMEM;
+		goto err_destroy_workqueue;
 
 	nvme_chap_buf_pool = mempool_create(16, mempool_alloc_slab,
 			mempool_free_slab, nvme_chap_buf_cache);
@@ -1021,6 +1028,8 @@ int __init nvme_init_auth(void)
 	return 0;
 err_destroy_chap_buf_cache:
 	kmem_cache_destroy(nvme_chap_buf_cache);
+err_destroy_workqueue:
+	destroy_workqueue(nvme_auth_wq);
 	return -ENOMEM;
 }
 
@@ -1028,4 +1037,5 @@ void __exit nvme_exit_auth(void)
 {
 	mempool_destroy(nvme_chap_buf_pool);
 	kmem_cache_destroy(nvme_chap_buf_cache);
+	destroy_workqueue(nvme_auth_wq);
 }


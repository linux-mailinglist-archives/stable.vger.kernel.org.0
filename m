Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296395B4469
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiIJG1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIJG1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377579DB77
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 23:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAAAF60C66
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 06:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBB1C433C1;
        Sat, 10 Sep 2022 06:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662791261;
        bh=7VTXKRLddc21bso/RLPr1EbJ2MVUPeithwMX76jiqKk=;
        h=Subject:To:Cc:From:Date:From;
        b=yztawc5cmf5o8FYi2pMPrZzqgwo0zgrFXIzAzYoXa0ZfFs445yufimJmjB73kpyOS
         Ugu5UjLQxuOMIElltAm21sB3+vUiNXw5U6nyIMkhkwZ9pOQLWI69tLj3sckiRGJHmA
         xW192bzu59gBsXRx42vyKaK1Ja6yfnAzRlKZAOcs=
Subject: FAILED: patch "[PATCH] nvmet: fix a use-after-free" failed to apply to 4.14-stable tree
To:     bvanassche@acm.org, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Sep 2022 08:27:55 +0200
Message-ID: <1662791275149178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6a02a61e81c2 ("nvmet: fix a use-after-free")
a5448fdc469d ("nvmet: introduce target-side trace")
76574f37bf4c ("nvmet: add interface to update error-log page")
872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
cb019da3dabf ("nvmet: use unlikely for req status check")
e6a622fd6d66 ("nvmet: support fabrics sq flow control")
55eb942eda2c ("nvmet: add buffered I/O support for file backed ns")
d5eff33ee6f8 ("nvmet: add simple file backed ns support")
618cff4285dc ("nvmet: remove duplicate NULL initialization for req->ns")
e929f06d9eaa ("nvmet: constify struct nvmet_fabrics_ops")
4c6526858810 ("nvmet: don't return "any" ip address in discovery log page")
423b4487fb23 ("nvmet: release a ns reference in nvmet_req_uninit if needed")
e2c5923c349c ("Merge branch 'for-4.15/block' of git://git.kernel.dk/linux-block")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6a02a61e81c231cc5c680c5dbf8665275147ac52 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 12 Aug 2022 14:03:17 -0700
Subject: [PATCH] nvmet: fix a use-after-free

Fix the following use-after-free complaint triggered by blktests nvme/004:

BUG: KASAN: user-memory-access in blk_mq_complete_request_remote+0xac/0x350
Read of size 4 at addr 0000607bd1835943 by task kworker/13:1/460
Workqueue: nvmet-wq nvme_loop_execute_work [nvme_loop]
Call Trace:
 show_stack+0x52/0x58
 dump_stack_lvl+0x49/0x5e
 print_report.cold+0x36/0x1e2
 kasan_report+0xb9/0xf0
 __asan_load4+0x6b/0x80
 blk_mq_complete_request_remote+0xac/0x350
 nvme_loop_queue_response+0x1df/0x275 [nvme_loop]
 __nvmet_req_complete+0x132/0x4f0 [nvmet]
 nvmet_req_complete+0x15/0x40 [nvmet]
 nvmet_execute_io_connect+0x18a/0x1f0 [nvmet]
 nvme_loop_execute_work+0x20/0x30 [nvme_loop]
 process_one_work+0x56e/0xa70
 worker_thread+0x2d1/0x640
 kthread+0x183/0x1c0
 ret_from_fork+0x1f/0x30

Cc: stable@vger.kernel.org
Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index a1345790005f..7f4083cf953a 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -735,6 +735,8 @@ static void nvmet_set_error(struct nvmet_req *req, u16 status)
 
 static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_ns *ns = req->ns;
+
 	if (!req->sq->sqhd_disabled)
 		nvmet_update_sq_head(req);
 	req->cqe->sq_id = cpu_to_le16(req->sq->qid);
@@ -745,9 +747,9 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 	trace_nvmet_req_complete(req);
 
-	if (req->ns)
-		nvmet_put_namespace(req->ns);
 	req->ops->queue_response(req);
+	if (ns)
+		nvmet_put_namespace(ns);
 }
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)


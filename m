Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E735E9F74
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiIZKZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiIZKYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25A914D21;
        Mon, 26 Sep 2022 03:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B5660BB7;
        Mon, 26 Sep 2022 10:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EBDC433C1;
        Mon, 26 Sep 2022 10:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187473;
        bh=txTZLVjtLQkcTi+soDlGB8fViSjcCVpczDKhYZmxGqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpFBRUlSW8PLLuVwXJSNyZrJ5+qTPF9wjyzjPZWr3jpGFBwANRdrb5TIwdP0KUk/z
         XTY3pxYKGLzCPggOclmN2iSfPk4kjLsmA+nS8NjFK79WW/ToOg4J6vZLNqJ18+qSdJ
         8u0q663qvKIZWgGpAVPVSzOM6IwGXp9+f0H1DmNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/58] nvmet: fix a use-after-free
Date:   Mon, 26 Sep 2022 12:11:26 +0200
Message-Id: <20220926100741.687815267@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 6a02a61e81c231cc5c680c5dbf8665275147ac52 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 1a35d73c39c3..80b5aae1bdc9 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -504,6 +504,7 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
 	u32 old_sqhd, new_sqhd;
 	u16 sqhd;
+	struct nvmet_ns *ns = req->ns;
 
 	if (status)
 		nvmet_set_status(req, status);
@@ -520,9 +521,9 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 	req->rsp->sq_id = cpu_to_le16(req->sq->qid);
 	req->rsp->command_id = req->cmd->common.command_id;
 
-	if (req->ns)
-		nvmet_put_namespace(req->ns);
 	req->ops->queue_response(req);
+	if (ns)
+		nvmet_put_namespace(ns);
 }
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
-- 
2.35.1




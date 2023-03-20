Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD656C1898
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbjCTP0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbjCTPZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:25:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21848367D9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:18:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AC3B61582
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD1FC433EF;
        Mon, 20 Mar 2023 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325529;
        bh=TeaqC4z12YuH/P4sRvKFIB85Q3X/e7BUxVhZTw+uggY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBoR84aHPEh+sp4lznSqwT5t9KMnCTl7+ZNuXKi/UIaIqpJOTv1s4u/rDG4Obgu0H
         xfstqKd3Bgjp/idV1CBQ1IFtOglTZUWsAt1jZXMoJK4MSQtGhEB6l/EM1x7OrBIuMb
         dJDPvxYv2YpJ0Fo4ar8vT73HoTOBIu5sLRsIIw0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 053/211] loop: Fix use-after-free issues
Date:   Mon, 20 Mar 2023 15:53:08 +0100
Message-Id: <20230320145515.466478672@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 9b0cb770f5d7b1ff40bea7ca385438ee94570eec ]

do_req_filebacked() calls blk_mq_complete_request() synchronously or
asynchronously when using asynchronous I/O unless memory allocation fails.
Hence, modify loop_handle_cmd() such that it does not dereference 'cmd' nor
'rq' after do_req_filebacked() finished unless we are sure that the request
has not yet been completed. This patch fixes the following kernel crash:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000054
Call trace:
 css_put.42938+0x1c/0x1ac
 loop_process_work+0xc8c/0xfd4
 loop_rootcg_workfn+0x24/0x34
 process_one_work+0x244/0x558
 worker_thread+0x400/0x8fc
 kthread+0x16c/0x1e0
 ret_from_fork+0x10/0x20

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
Fixes: c74d40e8b5e2 ("loop: charge i/o to mem and blk cg")
Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230314182155.80625-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1b35cbd029c7c..eabbc3bdec221 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1853,35 +1853,44 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void loop_handle_cmd(struct loop_cmd *cmd)
 {
+	struct cgroup_subsys_state *cmd_blkcg_css = cmd->blkcg_css;
+	struct cgroup_subsys_state *cmd_memcg_css = cmd->memcg_css;
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	const bool write = op_is_write(req_op(rq));
 	struct loop_device *lo = rq->q->queuedata;
 	int ret = 0;
 	struct mem_cgroup *old_memcg = NULL;
+	const bool use_aio = cmd->use_aio;
 
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
 		goto failed;
 	}
 
-	if (cmd->blkcg_css)
-		kthread_associate_blkcg(cmd->blkcg_css);
-	if (cmd->memcg_css)
+	if (cmd_blkcg_css)
+		kthread_associate_blkcg(cmd_blkcg_css);
+	if (cmd_memcg_css)
 		old_memcg = set_active_memcg(
-			mem_cgroup_from_css(cmd->memcg_css));
+			mem_cgroup_from_css(cmd_memcg_css));
 
+	/*
+	 * do_req_filebacked() may call blk_mq_complete_request() synchronously
+	 * or asynchronously if using aio. Hence, do not touch 'cmd' after
+	 * do_req_filebacked() has returned unless we are sure that 'cmd' has
+	 * not yet been completed.
+	 */
 	ret = do_req_filebacked(lo, rq);
 
-	if (cmd->blkcg_css)
+	if (cmd_blkcg_css)
 		kthread_associate_blkcg(NULL);
 
-	if (cmd->memcg_css) {
+	if (cmd_memcg_css) {
 		set_active_memcg(old_memcg);
-		css_put(cmd->memcg_css);
+		css_put(cmd_memcg_css);
 	}
  failed:
 	/* complete non-aio request */
-	if (!cmd->use_aio || ret) {
+	if (!use_aio || ret) {
 		if (ret == -EOPNOTSUPP)
 			cmd->ret = ret;
 		else
-- 
2.39.2




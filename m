Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D447B6309A2
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiKSCP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbiKSCNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:13:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6FF7D527;
        Fri, 18 Nov 2022 18:12:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25D68B82676;
        Sat, 19 Nov 2022 02:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84651C433C1;
        Sat, 19 Nov 2022 02:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823948;
        bh=FeaKcLN1S4XmFshriQOuOyCx2NqwtkX1LXyM/ywyDIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fV2qqx09Ky/ia4p1FzmqP6g+YZYVvDfg4iyS02+jUtuQS4+zw01g79ThB8P8CEoFi
         tGX3XTlbIRTm+uEvFlXMH9vAr1NkIkV6l/qqhTqbdJv1OPK4AOZc1ZDGgGWkO09/g5
         zq1IMSI0VbP1vb4f941LnVL6aiJu/kBA+bAgJg79nsxXAct3fJbVTOBvywHXVjcpsm
         5r8sXe5cB6lOaV4peYGPfxmnSvzmXPaV3VTe5b5bNiW5tGR4aqcD2DxtIo91VUlgFd
         sT0bZzo0BGOaVyxVzBj2a0WOkNdf86EX6Q5FCCt7shYxCvGWTNWWOZ3IIKxTlgPIbv
         du8FMDmWPIM3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Alan Adamson <alan.adamson@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 31/44] nvme: quiet user passthrough command errors
Date:   Fri, 18 Nov 2022 21:11:11 -0500
Message-Id: <20221119021124.1773699-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit d7ac8dca938cd60cf7bd9a89a229a173c6bcba87 ]

The driver is spamming the kernel logs for entirely harmless errors from
user space submitting unsupported commands. Just silence the errors.
The application has direct access to command status, so there's no need
to log these.

And since every passthrough command now uses the quiet flag, move the
setting to the common initializer.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Tested-by: Alan Adamson <alan.adamson@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 +--
 drivers/nvme/host/pci.c  | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ed47c256dbd2..01c36284e542 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -675,6 +675,7 @@ void nvme_init_request(struct request *req, struct nvme_command *cmd)
 	if (req->mq_hctx->type == HCTX_TYPE_POLL)
 		req->cmd_flags |= REQ_POLLED;
 	nvme_clear_nvme_request(req);
+	req->rq_flags |= RQF_QUIET;
 	memcpy(nvme_req(req)->cmd, cmd, sizeof(*cmd));
 }
 EXPORT_SYMBOL_GPL(nvme_init_request);
@@ -1037,7 +1038,6 @@ int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 			goto out;
 	}
 
-	req->rq_flags |= RQF_QUIET;
 	ret = nvme_execute_rq(req, at_head);
 	if (result && ret >= 0)
 		*result = nvme_req(req)->result;
@@ -1225,7 +1225,6 @@ static void nvme_keep_alive_work(struct work_struct *work)
 	rq->timeout = ctrl->kato * HZ;
 	rq->end_io = nvme_keep_alive_end_io;
 	rq->end_io_data = ctrl;
-	rq->rq_flags |= RQF_QUIET;
 	blk_execute_rq_nowait(rq, false);
 }
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 554468ea5a2a..73c464d68777 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1438,7 +1438,6 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 
 	abort_req->end_io = abort_endio;
 	abort_req->end_io_data = NULL;
-	abort_req->rq_flags |= RQF_QUIET;
 	blk_execute_rq_nowait(abort_req, false);
 
 	/*
@@ -2489,7 +2488,6 @@ static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 	req->end_io_data = nvmeq;
 
 	init_completion(&nvmeq->delete_done);
-	req->rq_flags |= RQF_QUIET;
 	blk_execute_rq_nowait(req, false);
 	return 0;
 }
-- 
2.35.1


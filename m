Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6790C55D15D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbiF0L0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiF0LZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:25:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F186598;
        Mon, 27 Jun 2022 04:25:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87260B81123;
        Mon, 27 Jun 2022 11:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F055DC341CB;
        Mon, 27 Jun 2022 11:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329121;
        bh=e4ymCOZXHGywOTnDX4ndbtuQkWK5+6M0Va1Vujg3/3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSohV4ZTleU5PHws0J5/wH6I35fF7NcLPrn/bXQdSxNNwWUhkH1U/5yg0anGJZLjn
         NvI0p8Gfz+O4OHgH6ufw+cd3Z/aOoKa5hcnn509FvB48QwLpi2kwp3vkBTkIg4FiEn
         zGw8aPIdtQrUxb1hFhWYr1/mH37gBYTA9aGe7968=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/102] nvme-pci: allocate nvme_command within driver pdu
Date:   Mon, 27 Jun 2022 13:21:09 +0200
Message-Id: <20220627111935.192365232@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit af7fae857ea22e9c2aef812e1321d9c5c206edde ]

Except for pci, all the nvme transport drivers allocate a command within
the driver's pdu. Align pci with everyone else by allocating the nvme
command within pci's pdu and replace the .queue_rq() stack variable with
this.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 07a4d5d387cd..31c6938e5045 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -224,6 +224,7 @@ struct nvme_queue {
  */
 struct nvme_iod {
 	struct nvme_request req;
+	struct nvme_command cmd;
 	struct nvme_queue *nvmeq;
 	bool use_sgl;
 	int aborted;
@@ -917,7 +918,7 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct nvme_dev *dev = nvmeq->dev;
 	struct request *req = bd->rq;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct nvme_command cmnd;
+	struct nvme_command *cmnd = &iod->cmd;
 	blk_status_t ret;
 
 	iod->aborted = 0;
@@ -931,24 +932,24 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
 		return BLK_STS_IOERR;
 
-	ret = nvme_setup_cmd(ns, req, &cmnd);
+	ret = nvme_setup_cmd(ns, req, cmnd);
 	if (ret)
 		return ret;
 
 	if (blk_rq_nr_phys_segments(req)) {
-		ret = nvme_map_data(dev, req, &cmnd);
+		ret = nvme_map_data(dev, req, cmnd);
 		if (ret)
 			goto out_free_cmd;
 	}
 
 	if (blk_integrity_rq(req)) {
-		ret = nvme_map_metadata(dev, req, &cmnd);
+		ret = nvme_map_metadata(dev, req, cmnd);
 		if (ret)
 			goto out_unmap_data;
 	}
 
 	blk_mq_start_request(req);
-	nvme_submit_cmd(nvmeq, &cmnd, bd->last);
+	nvme_submit_cmd(nvmeq, cmnd, bd->last);
 	return BLK_STS_OK;
 out_unmap_data:
 	nvme_unmap_data(dev, req);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8695603E16
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiJSJKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiJSJJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0979F362;
        Wed, 19 Oct 2022 02:00:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E6161800;
        Wed, 19 Oct 2022 09:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AA1C433C1;
        Wed, 19 Oct 2022 09:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170053;
        bh=+vbNUCQv8UUCMwCDsqLsnnb70lWBjwdQNQ0Y+msAdpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zb8GnXL1b8j3+3WvQprX8M8FBws05KrrMigCJmVVTpElmFYyWw7eLy+zS3PVKX6fn
         hukBDEEA8TaQv73/bvRCK/0NSnBsTc7u/ao/q/mBJ70wf+eL2GQ56xnKiIiH0G8pa1
         pyuAyDGMcvtMVMaIuhE37pN6tFPl6VFYhRsIFw5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Hai <haijie1@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 509/862] dmaengine: hisilicon: Fix CQ head update
Date:   Wed, 19 Oct 2022 10:29:56 +0200
Message-Id: <20221019083312.477351647@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Hai <haijie1@huawei.com>

[ Upstream commit 94477a79cf80e8ab55b68f14bc579a12ddea1e0b ]

After completion of data transfer of one or multiple descriptors,
the completion status and the current head pointer to submission
queue are written into the CQ and interrupt can be generated to
inform the software. In interrupt process CQ is read and cq_head
is updated.

hisi_dma_irq updates cq_head only when the completion status is
success. When an abnormal interrupt reports, cq_head will not update
which will cause subsequent interrupt processes read the error CQ
and never report the correct status.

This patch updates cq_head whenever CQ is accessed.

Fixes: e9f08b65250d ("dmaengine: hisilicon: Add Kunpeng DMA engine support")
Signed-off-by: Jie Hai <haijie1@huawei.com>
Acked-by: Zhou Wang <wangzhou1@hisilicon.com>
Link: https://lore.kernel.org/r/20220830062251.52993-3-haijie1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hisi_dma.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/hisi_dma.c b/drivers/dma/hisi_dma.c
index 98bc488893cc..837f7e4adfa6 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -436,12 +436,10 @@ static irqreturn_t hisi_dma_irq(int irq, void *data)
 	desc = chan->desc;
 	cqe = chan->cq + chan->cq_head;
 	if (desc) {
+		chan->cq_head = (chan->cq_head + 1) % hdma_dev->chan_depth;
+		hisi_dma_chan_write(hdma_dev->base, HISI_DMA_CQ_HEAD_PTR,
+				    chan->qp_num, chan->cq_head);
 		if (FIELD_GET(STATUS_MASK, cqe->w0) == STATUS_SUCC) {
-			chan->cq_head = (chan->cq_head + 1) %
-					hdma_dev->chan_depth;
-			hisi_dma_chan_write(hdma_dev->base,
-					    HISI_DMA_CQ_HEAD_PTR, chan->qp_num,
-					    chan->cq_head);
 			vchan_cookie_complete(&desc->vd);
 		} else {
 			dev_err(&hdma_dev->pdev->dev, "task error!\n");
-- 
2.35.1




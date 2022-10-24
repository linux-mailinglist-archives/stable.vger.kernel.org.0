Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D3D60B034
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiJXQCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiJXQBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:01:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168879C2D3;
        Mon, 24 Oct 2022 07:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 595A1B811CF;
        Mon, 24 Oct 2022 12:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB031C433C1;
        Mon, 24 Oct 2022 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614324;
        bh=vUlw16hYju9MK+wWt/NqUTk3qu5CjvEwj9o7bmckfn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vQDBwmxVYacyif4lnp4EkN+8LoXj0TSrssdnsD2vFAK6ZdT2DuNJBxN8qSZEmXxQ
         Nlu9FXKCoTnH30mqMRkTCikG1X06RGC1079pckN9kh3JJ7psApy5SdPEDK3BRPWMAO
         6wGwpshy0LIUSD40MRyh34YmqfSP6WSQrwjTjuJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Hai <haijie1@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/390] dmaengine: hisilicon: Add multi-thread support for a DMA channel
Date:   Mon, 24 Oct 2022 13:30:13 +0200
Message-Id: <20221024113031.978049057@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Hai <haijie1@huawei.com>

[ Upstream commit 2cbb95883c990d0002a77e13d3278913ab26ad79 ]

When we get a DMA channel and try to use it in multiple threads it
will cause oops and hanging the system.

% echo 100 > /sys/module/dmatest/parameters/threads_per_chan
% echo 100 > /sys/module/dmatest/parameters/iterations
% echo 1 > /sys/module/dmatest/parameters/run
[383493.327077] Unable to handle kernel paging request at virtual
		address dead000000000108
[383493.335103] Mem abort info:
[383493.335103]   ESR = 0x96000044
[383493.335105]   EC = 0x25: DABT (current EL), IL = 32 bits
[383493.335107]   SET = 0, FnV = 0
[383493.335108]   EA = 0, S1PTW = 0
[383493.335109]   FSC = 0x04: level 0 translation fault
[383493.335110] Data abort info:
[383493.335111]   ISV = 0, ISS = 0x00000044
[383493.364739]   CM = 0, WnR = 1
[383493.367793] [dead000000000108] address between user and kernel
		address ranges
[383493.375021] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[383493.437574] CPU: 63 PID: 27895 Comm: dma0chan0-copy2 Kdump:
		loaded Tainted: GO 5.17.0-rc4+ #2
[383493.457851] pstate: 204000c9 (nzCv daIF +PAN -UAO -TCO -DIT
		-SSBS BTYPE=--)
[383493.465331] pc : vchan_tx_submit+0x64/0xa0
[383493.469957] lr : vchan_tx_submit+0x34/0xa0

This occurs because the transmission timed out, and that's due
to data race. Each thread rewrite channels's descriptor as soon as
device_issue_pending is called. It leads to the situation that
the driver thinks that it uses the right descriptor in interrupt
handler while channels's descriptor has been changed by other
thread. The descriptor which in fact reported interrupt will not
be handled any more, as well as its tx->callback.
That's why timeout reports.

With current fixes channels' descriptor changes it's value only
when it has been used. A new descriptor is acquired from
vc->desc_issued queue that is already filled with descriptors
that are ready to be sent. Threads have no direct access to DMA
channel descriptor. In case of channel's descriptor is busy, try
to submit to HW again when a descriptor is completed. In this case,
vc->desc_issued may be empty when hisi_dma_start_transfer is called,
so delete error reporting on this. Now it is just possible to queue
a descriptor for further processing.

Fixes: e9f08b65250d ("dmaengine: hisilicon: Add Kunpeng DMA engine support")
Signed-off-by: Jie Hai <haijie1@huawei.com>
Acked-by: Zhou Wang <wangzhou1@hisilicon.com>
Link: https://lore.kernel.org/r/20220830062251.52993-4-haijie1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hisi_dma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/hisi_dma.c b/drivers/dma/hisi_dma.c
index 08ec90dd4c46..8f1651367310 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -276,7 +276,6 @@ static void hisi_dma_start_transfer(struct hisi_dma_chan *chan)
 
 	vd = vchan_next_desc(&chan->vc);
 	if (!vd) {
-		dev_err(&hdma_dev->pdev->dev, "no issued task!\n");
 		chan->desc = NULL;
 		return;
 	}
@@ -308,7 +307,7 @@ static void hisi_dma_issue_pending(struct dma_chan *c)
 
 	spin_lock_irqsave(&chan->vc.lock, flags);
 
-	if (vchan_issue_pending(&chan->vc))
+	if (vchan_issue_pending(&chan->vc) && !chan->desc)
 		hisi_dma_start_transfer(chan);
 
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
@@ -447,11 +446,10 @@ static irqreturn_t hisi_dma_irq(int irq, void *data)
 				    chan->qp_num, chan->cq_head);
 		if (FIELD_GET(STATUS_MASK, cqe->w0) == STATUS_SUCC) {
 			vchan_cookie_complete(&desc->vd);
+			hisi_dma_start_transfer(chan);
 		} else {
 			dev_err(&hdma_dev->pdev->dev, "task error!\n");
 		}
-
-		chan->desc = NULL;
 	}
 
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248AE11B7A6
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387538AbfLKQJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730720AbfLKPMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90F2C208C3;
        Wed, 11 Dec 2019 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077128;
        bh=I2kL1eyh/q9jqbz6IjKwTQx2WHD3sCRx/+BtxzJk3T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrmKqAIPxUiWWw+o928mlB+seHZmtt1pWFIwFBRNTqndVI2vdnd+ba6sLKlnFkO3t
         7Vdl3ECgmgSU6y8IBNJcICejomPOEstp9QzBt2kYI847N7uS4DynTtXr8T6NbXEPaT
         j3RRQow0rd43W6O+3CKPmSd9+7qlSoWLNJcXoobw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Graumann <nick.graumann@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 016/134] dmaengine: xilinx_dma: Clear desc_pendingcount in xilinx_dma_reset
Date:   Wed, 11 Dec 2019 10:09:52 -0500
Message-Id: <20191211151150.19073-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Graumann <nick.graumann@gmail.com>

[ Upstream commit 8a631a5a0f7d4a4a24dba8587d5d9152be0871cc ]

Whenever we reset the channel, we need to clear desc_pendingcount
along with desc_submitcount. Otherwise when a new transaction is
submitted, the irq coalesce level could be programmed to an incorrect
value in the axidma case.

This behavior can be observed when terminating pending transactions
with xilinx_dma_terminate_all() and then submitting new transactions
without releasing and requesting the channel.

Signed-off-by: Nicholas Graumann <nick.graumann@gmail.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1571150904-3988-8-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 5d56f1e4d332c..43acba2a1c0ee 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1433,6 +1433,7 @@ static int xilinx_dma_reset(struct xilinx_dma_chan *chan)
 
 	chan->err = false;
 	chan->idle = true;
+	chan->desc_pendingcount = 0;
 	chan->desc_submitcount = 0;
 
 	return err;
-- 
2.20.1


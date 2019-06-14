Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAF46B01
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFNUjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfFNU2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:28:51 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE17121850;
        Fri, 14 Jun 2019 20:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544130;
        bh=kOj2ED/pks+yCY9Anj6LUlMl2iZ4JhcYhRf7j7D8cwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcuvFwGBOVKYpzwc8HQVfWCan9JVm3+UIl4rHWNMIj3YB0p4ewOIFgTiG5lXg1u3a
         0sd1io1M6CAYW1FPQRE2xzBX0IvArtsuSNyq/S64v8ntPiGSNx2C18oVbWZ8aCtFnR
         RMeqFxOqDcby5yHrthXrM1iZPzgRH42GRGfU3wms=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 07/59] dmaengine: sprd: Add validation of current descriptor in irq handler
Date:   Fri, 14 Jun 2019 16:27:51 -0400
Message-Id: <20190614202843.26941-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linaro.org>

[ Upstream commit 58152b0e573e5581c4b9ef7cf06d2e9fafae27d4 ]

When user terminates one DMA channel to free all its descriptors, but
at the same time one transaction interrupt was triggered possibly, now
we should not handle this interrupt by validating if the 'schan->cur_desc'
was set as NULL to avoid crashing the kernel.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index e29342ab85f6..431e289d59a5 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -552,12 +552,17 @@ static irqreturn_t dma_irq_handle(int irq, void *dev_id)
 		schan = &sdev->channels[i];
 
 		spin_lock(&schan->vc.lock);
+
+		sdesc = schan->cur_desc;
+		if (!sdesc) {
+			spin_unlock(&schan->vc.lock);
+			return IRQ_HANDLED;
+		}
+
 		int_type = sprd_dma_get_int_type(schan);
 		req_type = sprd_dma_get_req_type(schan);
 		sprd_dma_clear_int(schan);
 
-		sdesc = schan->cur_desc;
-
 		/* cyclic mode schedule callback */
 		cyclic = schan->linklist.phy_addr ? true : false;
 		if (cyclic == true) {
-- 
2.20.1


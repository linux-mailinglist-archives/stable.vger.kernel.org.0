Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0398E1E6079
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389560AbgE1MLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388644AbgE1L4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF8BD2089D;
        Thu, 28 May 2020 11:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666970;
        bh=LzQfa0p9cHUENQO0mAWYOT5ENogDMcPQBaPgv/iz+ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM6xcPr2w/zjbtyNpXyh8KfjYBOdYe0GaG3r0SYRYUVh0RTKG59zGtaDQ7qbeDAXa
         RSaGg1+vDXfuXg2jKOTdYo6d5E4cT8oEkwjMR7Pi6xWGvbFetF6wJeOaP5bO5VU1Zc
         MJYwm7cM/0xJ4yZVgz4KQjx9NG1lId+ez0PwoaZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 08/47] dmaengine: ti: k3-udma: Fix TR mode flags for slave_sg and memcpy
Date:   Thu, 28 May 2020 07:55:21 -0400
Message-Id: <20200528115600.1405808-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit be4054b8b6671ebc977eb7774b8e889d2d05d3e3 ]

cppi5_tr_csf_set() clears previously set Configuration Specific Flags.
Setting the EOP flag clears the SUPR_EVT flag for the last TR which is not
desirable as we do not want to have events from the TR.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200512134531.5742-1-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 0536866a58ce..4bfbca2add1b 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -2148,7 +2148,8 @@ udma_prep_slave_sg_tr(struct udma_chan *uc, struct scatterlist *sgl,
 		d->residue += sg_dma_len(sgent);
 	}
 
-	cppi5_tr_csf_set(&tr_req[tr_idx - 1].flags, CPPI5_TR_CSF_EOP);
+	cppi5_tr_csf_set(&tr_req[tr_idx - 1].flags,
+			 CPPI5_TR_CSF_SUPR_EVT | CPPI5_TR_CSF_EOP);
 
 	return d;
 }
@@ -2725,7 +2726,8 @@ udma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		tr_req[1].dicnt3 = 1;
 	}
 
-	cppi5_tr_csf_set(&tr_req[num_tr - 1].flags, CPPI5_TR_CSF_EOP);
+	cppi5_tr_csf_set(&tr_req[num_tr - 1].flags,
+			 CPPI5_TR_CSF_SUPR_EVT | CPPI5_TR_CSF_EOP);
 
 	if (uc->config.metadata_size)
 		d->vd.tx.metadata_ops = &metadata_ops;
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E629B261D62
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgIHTfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730967AbgIHP5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:57:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E97E23C91;
        Tue,  8 Sep 2020 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579403;
        bh=R8jaWjAyQ+yI0TtsogPIEPznYFmbRymeMiijpJN2YFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nu4QlNVLFEIeHVCfYXVjUTA4RMAAVokKIiTm6Av7cHRjhIv/Tt/m30BsFRbHCmegK
         Nh2BXmbNeojfTNf9V1Mqj/jqm/NJdO59R5k2ownke7LyXQwuySseO8PwhV+KqKnPbX
         aetyFA5SC69vn1nYBDfmbiEloraMxJMTLhnBNgdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 063/186] dmaengine: ti: k3-udma: Fix the TR initialization for prep_slave_sg
Date:   Tue,  8 Sep 2020 17:23:25 +0200
Message-Id: <20200908152244.714205354@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 33ebffa105990c43bf336cabe26c77384f59fe70 ]

The TR which needs to be initialized for the next sg entry is indexed by
tr_idx and not by the running i counter.

In case any sub element in the SG needs more than one TR, the code would
corrupt an already configured TR.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200824120108.9178-1-peter.ujfalusi@ti.com
Fixes: 6cf668a4ef829 ("dmaengine: ti: k3-udma: Use the TR counter helper for slave_sg and cyclic")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 6c879a7343604..3e488d963f246 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -2109,9 +2109,9 @@ udma_prep_slave_sg_tr(struct udma_chan *uc, struct scatterlist *sgl,
 			return NULL;
 		}
 
-		cppi5_tr_init(&tr_req[i].flags, CPPI5_TR_TYPE1, false, false,
-			      CPPI5_TR_EVENT_SIZE_COMPLETION, 0);
-		cppi5_tr_csf_set(&tr_req[i].flags, CPPI5_TR_CSF_SUPR_EVT);
+		cppi5_tr_init(&tr_req[tr_idx].flags, CPPI5_TR_TYPE1, false,
+			      false, CPPI5_TR_EVENT_SIZE_COMPLETION, 0);
+		cppi5_tr_csf_set(&tr_req[tr_idx].flags, CPPI5_TR_CSF_SUPR_EVT);
 
 		tr_req[tr_idx].addr = sg_addr;
 		tr_req[tr_idx].icnt0 = tr0_cnt0;
-- 
2.25.1




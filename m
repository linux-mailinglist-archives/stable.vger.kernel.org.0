Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108DB1EFB52
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgFEOZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgFEOQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22459208B8;
        Fri,  5 Jun 2020 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366580;
        bh=LzQfa0p9cHUENQO0mAWYOT5ENogDMcPQBaPgv/iz+ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaQ9xPps8VDC6lrzac9rrch59jnaiGgtMMoT+AKH69HPCK8LOcN1F/RuhCMQfkT9U
         a3+S2HYsjYsckliAjE2GO2HgdMX9BGh5UAqEtBJrD0AYXCxUZ266GgNiUvZNYYiUXr
         hV4if5Iz3q3PChjT4dLnew01syA9MuZSXMyqe1xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 10/43] dmaengine: ti: k3-udma: Fix TR mode flags for slave_sg and memcpy
Date:   Fri,  5 Jun 2020 16:14:40 +0200
Message-Id: <20200605140153.064092219@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




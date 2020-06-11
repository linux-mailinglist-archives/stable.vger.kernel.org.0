Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7841F68FE
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 15:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgFKNVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 09:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgFKNVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 09:21:44 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D7D520747;
        Thu, 11 Jun 2020 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591881703;
        bh=OBPMc7itq41nVZ9VUj3BHPffpSQ5D0xsnUCrEtNQCTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmoxLQICdTtxNJbc0hF3pdIDAq7WDR9cEkjY3uxws4uxjHSQHA87xquSpjp4kDRz7
         APad7eBsR6z6gt2Qqks9gvePLoU6LFlzBwoUr9GBYce2FKNBPaBxTrJ9cCKN1dbCec
         UIY39La3e9X9N6dUhzlbpr17oLRpq5ueKaNtumVg=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vinod Koul <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Angelo Dureghello <angelo@sysam.it>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robin Gong <yibin.gong@nxp.com>, Peng Ma <peng.ma@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] dmaengine: mcf-edma: Fix NULL pointer exception in mcf_edma_tx_handler
Date:   Thu, 11 Jun 2020 15:21:05 +0200
Message-Id: <1591881665-25592-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591877861-28156-2-git-send-email-krzk@kernel.org>
References: <1591877861-28156-2-git-send-email-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Toradex Colibri VF50 (Vybrid VF5xx) with fsl-edma driver NULL pointer
exception happens occasionally on serial output initiated by login
timeout.

This was reproduced only if kernel was built with significant debugging
options and EDMA driver is used with serial console.

Issue looks like a race condition between interrupt handler
fsl_edma_tx_handler() (called as a result of fsl_edma_xfer_desc()) and
terminating the transfer with fsl_edma_terminate_all().

The fsl_edma_tx_handler() handles interrupt for a transfer with already
freed edesc and idle==true.

The mcf-edma driver shares design and lot of code with fsl-edma.  It
looks like being affected by same problem.  Fix this pattern the same
way as fix for fsl-edma driver.

Fixes: e7a3ff92eaf1 ("dmaengine: fsl-edma: add ColdFire mcf5441x edma support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Not tested on HW.
---
 drivers/dma/mcf-edma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dma/mcf-edma.c b/drivers/dma/mcf-edma.c
index e15bd15a9ef6..e12b754e6398 100644
--- a/drivers/dma/mcf-edma.c
+++ b/drivers/dma/mcf-edma.c
@@ -35,6 +35,13 @@ static irqreturn_t mcf_edma_tx_handler(int irq, void *dev_id)
 			mcf_chan = &mcf_edma->chans[ch];
 
 			spin_lock(&mcf_chan->vchan.lock);
+
+			if (!mcf_chan->edesc) {
+				/* terminate_all called before */
+				spin_unlock(&mcf_chan->vchan.lock);
+				continue;
+			}
+
 			if (!mcf_chan->edesc->iscyclic) {
 				list_del(&mcf_chan->edesc->vdesc.node);
 				vchan_cookie_complete(&mcf_chan->edesc->vdesc);
-- 
2.7.4


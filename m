Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7052BE5C26
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfJZNU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbfJZNU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068692070B;
        Sat, 26 Oct 2019 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096056;
        bh=x28+h5H5jHREltbJwUDghmna6hxRR603M3GxNdAR+JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+ediD9oPHIh/VNHIgl996EZUvgJavNSbHDUDD4KCuVZxkeecb1fBmF1/wruVaFwd
         gGLb9C8ByQK13EHdfslBnXDHJT47keZQzT0bqKHqGWXpeadD+kvtGdUzMqQ9+twhTB
         Dzl9HD1NNTVvVlSwIp21u0lcpd49V99iEGZqw9Ck=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florin Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 53/59] dpaa2-eth: add irq for the dpmac connect/disconnect event
Date:   Sat, 26 Oct 2019 09:19:04 -0400
Message-Id: <20191026131910.3435-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>

[ Upstream commit 8398b375a9e3f5e4bba9bcdfed152a8a247dee01 ]

Add IRQ for the DPNI endpoint change event, resolving the issue
when a dynamically created DPNI gets a randomly generated hw address
when the endpoint is a DPMAC object.

Signed-off-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fsl-dpaa2/ethernet/dpaa2-eth.c | 6 +++++-
 drivers/staging/fsl-dpaa2/ethernet/dpni.h      | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethernet/dpaa2-eth.c b/drivers/staging/fsl-dpaa2/ethernet/dpaa2-eth.c
index 9329fcad95acd..ed78efd898c59 100644
--- a/drivers/staging/fsl-dpaa2/ethernet/dpaa2-eth.c
+++ b/drivers/staging/fsl-dpaa2/ethernet/dpaa2-eth.c
@@ -2400,6 +2400,9 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 	if (status & DPNI_IRQ_EVENT_LINK_CHANGED)
 		link_state_update(netdev_priv(net_dev));
 
+	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED)
+		set_mac_addr(netdev_priv(net_dev));
+
 	return IRQ_HANDLED;
 }
 
@@ -2425,7 +2428,8 @@ static int setup_irqs(struct fsl_mc_device *ls_dev)
 	}
 
 	err = dpni_set_irq_mask(ls_dev->mc_io, 0, ls_dev->mc_handle,
-				DPNI_IRQ_INDEX, DPNI_IRQ_EVENT_LINK_CHANGED);
+				DPNI_IRQ_INDEX, DPNI_IRQ_EVENT_LINK_CHANGED |
+				DPNI_IRQ_EVENT_ENDPOINT_CHANGED);
 	if (err < 0) {
 		dev_err(&ls_dev->dev, "dpni_set_irq_mask(): %d\n", err);
 		goto free_irq;
diff --git a/drivers/staging/fsl-dpaa2/ethernet/dpni.h b/drivers/staging/fsl-dpaa2/ethernet/dpni.h
index b378a00c7c534..92a8bc0f3183f 100644
--- a/drivers/staging/fsl-dpaa2/ethernet/dpni.h
+++ b/drivers/staging/fsl-dpaa2/ethernet/dpni.h
@@ -133,9 +133,12 @@ int dpni_reset(struct fsl_mc_io	*mc_io,
  */
 #define DPNI_IRQ_INDEX				0
 /**
- * IRQ event - indicates a change in link state
+ * IRQ events:
+ *       indicates a change in link state
+ *       indicates a change in endpoint
  */
 #define DPNI_IRQ_EVENT_LINK_CHANGED		0x00000001
+#define DPNI_IRQ_EVENT_ENDPOINT_CHANGED		0x00000002
 
 int dpni_set_irq_enable(struct fsl_mc_io	*mc_io,
 			u32			cmd_flags,
-- 
2.20.1


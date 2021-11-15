Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8886F4521F1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376776AbhKPBHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245279AbhKOTT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E763263525;
        Mon, 15 Nov 2021 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001101;
        bh=UPTlsE2EtP9BIi1WNtKkwz98aVsA67KuNWxttsQgWPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JzoEOWx850rYPMpoR81it70/lmr2M2yfIcP++ZtucGHpVgDLEaIVETkfKpCmB80i
         SXiCiUVzAvmGqyCE8xaedU5IHkAdIH0o8I8Nr6vd9wFSBpUXeGn++LdsBk+f+BT1OY
         gLrbC+38h8E2WmmlUrGcXGigATbKBOVLc2nL4T6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derong Liu <derong.liu@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 018/917] mmc: mtk-sd: Add wait dma stop done flow
Date:   Mon, 15 Nov 2021 17:51:53 +0100
Message-Id: <20211115165429.353137570@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derong Liu <derong.liu@mediatek.com>

commit 43e5fee317f4b0a48992b8b07935b1a3ac20ce84 upstream.

We found this issue on a 5G platform, during CMDQ error handling, if DMA
status is active when it call msdc_reset_hw(), it means mmc host hw reset
and DMA transfer will be parallel, mmc host may access sram region
unexpectedly. According to the programming guide of mtk-sd host, it needs
to wait for dma stop done after set dma stop.

This change should be applied to all SoCs.

Signed-off-by: Derong Liu <derong.liu@mediatek.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210827071537.1034-1-derong.liu@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -8,6 +8,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/iopoll.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/of_address.h>
@@ -2330,6 +2331,7 @@ static void msdc_cqe_enable(struct mmc_h
 static void msdc_cqe_disable(struct mmc_host *mmc, bool recovery)
 {
 	struct msdc_host *host = mmc_priv(mmc);
+	unsigned int val = 0;
 
 	/* disable cmdq irq */
 	sdr_clr_bits(host->base + MSDC_INTEN, MSDC_INT_CMDQ);
@@ -2339,6 +2341,9 @@ static void msdc_cqe_disable(struct mmc_
 	if (recovery) {
 		sdr_set_field(host->base + MSDC_DMA_CTRL,
 			      MSDC_DMA_CTRL_STOP, 1);
+		if (WARN_ON(readl_poll_timeout(host->base + MSDC_DMA_CFG, val,
+			!(val & MSDC_DMA_CFG_STS), 1, 3000)))
+			return;
 		msdc_reset_hw(host);
 	}
 }



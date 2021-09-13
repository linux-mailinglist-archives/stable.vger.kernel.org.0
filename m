Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4C84094D4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345046AbhIMOgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345632AbhIMOck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC4DD61BB2;
        Mon, 13 Sep 2021 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541130;
        bh=a5AH1LaVXEL52OVqmReiFyNs+0ZJmKc+pEiWPGgv4wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iR4prfhYTxSfbPaqXFYXVL73iMCO+3859Z0bZc8fyciVCqoUZwlyyzQ4fKiKjXPuf
         HaERMcJGtJDtUKGDpTkbfup8L8woWlmBEPMhd2/vyecTzmaEt6LjEs/OeN92Hv7pYV
         DGVgvnQOeGLv+7zaYQUG8z7bsfwLBS0PnsXUc1n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 176/334] net: ti: am65-cpsw-nuss: fix RX IRQ state after .ndo_stop()
Date:   Mon, 13 Sep 2021 15:13:50 +0200
Message-Id: <20210913131119.298885279@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 47bfc4d128dedd9e828e33b70b87b591a6d59edf ]

On TI K3 am64x platform the issue with RX IRQ is observed - it's become
disabled forever after .ndo_stop(). The K3 CPSW driver manipulates RX IRQ
by using standard Linux enable_irq()/disable_irq_nosync() API as there is
no IRQ enable/disable options in CPSW HW itself, as result during
.ndo_stop() following sequence happens

  phy_stop()
  teardown TX/RX channels
  wait for TX tdown complete
  napi_disable(TX)
  clean up TX channels

  (a)

  napi_disable(RX)

At point (a) it's not possible to predict if RX IRQ was triggered or not.
if RX IRQ was triggered then it also not possible to definitely say if RX
NAPI was run or only scheduled and immediately canceled by
napi_disable(RX). Actually the last case causes RX IRQ to be permanently
disabled.

Another observed issue is that RX IRQ enable counter become unbalanced if
(gro_flush_timeout =! 0) while (napi_defer_hard_irqs == 0):

Unbalanced enable for IRQ 44
WARNING: CPU: 0 PID: 10 at ../kernel/irq/manage.c:776 __enable_irq+0x38/0x80
__enable_irq+0x38/0x80
enable_irq+0x54/0xb0
am65_cpsw_nuss_rx_poll+0x2f4/0x368
__napi_poll+0x34/0x1b8
net_rx_action+0xe4/0x220
_stext+0x11c/0x284
run_ksoftirqd+0x4c/0x60

To avoid above issues introduce flag indicating if RX was actually disabled
before enabling it in am65_cpsw_nuss_rx_poll() and restore RX IRQ state in
.ndo_open()

Fixes: 4f7cce272403 ("net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 13 +++++++++++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index fb58fc470773..e967cd1ade36 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -518,6 +518,10 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 	}
 
 	napi_enable(&common->napi_rx);
+	if (common->rx_irq_disabled) {
+		common->rx_irq_disabled = false;
+		enable_irq(common->rx_chns.irq);
+	}
 
 	dev_dbg(common->dev, "cpsw_nuss started\n");
 	return 0;
@@ -871,8 +875,12 @@ static int am65_cpsw_nuss_rx_poll(struct napi_struct *napi_rx, int budget)
 
 	dev_dbg(common->dev, "%s num_rx:%d %d\n", __func__, num_rx, budget);
 
-	if (num_rx < budget && napi_complete_done(napi_rx, num_rx))
-		enable_irq(common->rx_chns.irq);
+	if (num_rx < budget && napi_complete_done(napi_rx, num_rx)) {
+		if (common->rx_irq_disabled) {
+			common->rx_irq_disabled = false;
+			enable_irq(common->rx_chns.irq);
+		}
+	}
 
 	return num_rx;
 }
@@ -1090,6 +1098,7 @@ static irqreturn_t am65_cpsw_nuss_rx_irq(int irq, void *dev_id)
 {
 	struct am65_cpsw_common *common = dev_id;
 
+	common->rx_irq_disabled = true;
 	disable_irq_nosync(irq);
 	napi_schedule(&common->napi_rx);
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 5d93e346f05e..048ed10143c1 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -126,6 +126,8 @@ struct am65_cpsw_common {
 	struct am65_cpsw_rx_chn	rx_chns;
 	struct napi_struct	napi_rx;
 
+	bool			rx_irq_disabled;
+
 	u32			nuss_ver;
 	u32			cpsw_ver;
 	unsigned long		bus_freq;
-- 
2.30.2




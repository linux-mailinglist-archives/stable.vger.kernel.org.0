Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFAB613E31E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbgAPRAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387618AbgAPRAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 643E622525;
        Thu, 16 Jan 2020 17:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194001;
        bh=i/V3gk9PEcJrPo97JdmBI9EBn/+Wp7cEy9/qDwLVC2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIHpmzlcKdhCPKt9LXfo/JPdNE7TMSTVqcABQqGMri18I+5KBx+Wx9VA/XZgcqCE8
         4EAOvzs7T5EA4UZud7lgWbuGPiq0wmYHOYBS0jjqiDryCVbQb4R7vqjlfvtvKCnKbD
         Y5TlloBzqSumcB1px5jIb4JtZS2OInRpdHzQrA1E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 128/671] spi/topcliff_pch: Fix potential NULL dereference on allocation error
Date:   Thu, 16 Jan 2020 11:50:37 -0500
Message-Id: <20200116165940.10720-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit e902cdcb5112b89ee445588147964723fd69ffb4 ]

In pch_spi_handle_dma, it doesn't check for NULL returns of kcalloc
so it would result in an Oops.

Fixes: c37f3c2749b5 ("spi/topcliff_pch: DMA support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-topcliff-pch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 4389ab80c23e..fa730a871d25 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1008,6 +1008,9 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 
 	/* RX */
 	dma->sg_rx_p = kcalloc(num, sizeof(*dma->sg_rx_p), GFP_ATOMIC);
+	if (!dma->sg_rx_p)
+		return;
+
 	sg_init_table(dma->sg_rx_p, num); /* Initialize SG table */
 	/* offset, length setting */
 	sg = dma->sg_rx_p;
@@ -1068,6 +1071,9 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	}
 
 	dma->sg_tx_p = kcalloc(num, sizeof(*dma->sg_tx_p), GFP_ATOMIC);
+	if (!dma->sg_tx_p)
+		return;
+
 	sg_init_table(dma->sg_tx_p, num); /* Initialize SG table */
 	/* offset, length setting */
 	sg = dma->sg_tx_p;
-- 
2.20.1


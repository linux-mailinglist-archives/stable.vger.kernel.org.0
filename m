Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1036E3F679D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241493AbhHXRgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241635AbhHXRbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 453F761B96;
        Tue, 24 Aug 2021 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824753;
        bh=oVLv5XqnepR4wcevdVsJ4IsJ/Y6XAJQam7Vejlf2kJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7srGjEiDUqwtjElX2n1/tXJQDVu+kssHazc6OZArUOojYtFxA92Jf83CoM+VhPie
         yJfjLnryaLA+RItG3Ufa61aO30N022aMIPgYV6cOqA3WZWAdt97tguWMQ8GDItfj6k
         UYKyAHRSvgiUc4fWVzIotrQmDUvsCjriZy2ksrtfvqNLCHRtkGxJe6/VtDOsYKUfDN
         OtzOS6PadzlIOiZTABn6gmR5AfLvtTa2NZOQ8JtlRCujT+xqug28ibtqDPicaclWeL
         Sq2ovd+Pw6v30sGEl7EhImGlSM6FRepGwyYKnZq3vNho8g0f58e/xOlLYgHSwcChdC
         IwxYdzsUGS+5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 56/64] mmc: dw_mmc: Fix hang on data CRC error
Date:   Tue, 24 Aug 2021 13:04:49 -0400
Message-Id: <20210824170457.710623-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 25f8203b4be1937c4939bb98623e67dcfd7da4d1 ]

When a Data CRC interrupt is received, the driver disables the DMA, then
sends the stop/abort command and then waits for Data Transfer Over.

However, sometimes, when a data CRC error is received in the middle of a
multi-block write transfer, the Data Transfer Over interrupt is never
received, and the driver hangs and never completes the request.

The driver sets the BMOD.SWR bit (SDMMC_IDMAC_SWRESET) when stopping the
DMA, but according to the manual CMD.STOP_ABORT_CMD should be programmed
"before assertion of SWR".  Do these operations in the recommended
order.  With this change the Data Transfer Over is always received
correctly in my tests.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210630102232.16011-1-vincent.whitchurch@axis.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 32001d43e453..bd994a8fce14 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2051,8 +2051,8 @@ static void dw_mci_tasklet_func(unsigned long priv)
 					continue;
 				}
 
-				dw_mci_stop_dma(host);
 				send_stop_abort(host, data);
+				dw_mci_stop_dma(host);
 				state = STATE_SENDING_STOP;
 				break;
 			}
@@ -2076,10 +2076,10 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			 */
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
-				dw_mci_stop_dma(host);
 				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
+				dw_mci_stop_dma(host);
 				state = STATE_DATA_ERROR;
 				break;
 			}
@@ -2112,10 +2112,10 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			 */
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
-				dw_mci_stop_dma(host);
 				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
+				dw_mci_stop_dma(host);
 				state = STATE_DATA_ERROR;
 				break;
 			}
-- 
2.30.2


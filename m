Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CD11B752D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgDXMXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbgDXMXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7394216FD;
        Fri, 24 Apr 2020 12:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730993;
        bh=/HD9MmdeIWifWlhK6G1FDWA7NHgdjdefK5EkIy2ZJyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCrakp+oqgOaa6fysldmxy4KTAfwwNRzwxVezEK8FVZSc9Xv/YoxLVq2Qw2LMjXOe
         9uSJlMGXOuztcrrQPb23/Vj/PiPjvIJ8pTbUeC8KmjH/mDpGPXAykeX74Vz7wZQ/nb
         HVXmrivk0Z2JGw0Vm3jeJdjktmpBw41AQI0JfOOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 31/38] i2c: tegra: Synchronize DMA before termination
Date:   Fri, 24 Apr 2020 08:22:29 -0400
Message-Id: <20200424122237.9831-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 8814044fe0fa182abc9ff818d3da562de98bc9a7 ]

DMA transfer could be completed, but CPU (which handles DMA interrupt)
may get too busy and can't handle the interrupt in a timely manner,
despite of DMA IRQ being raised. In this case the DMA state needs to
synchronized before terminating DMA transfer in order not to miss the
DMA transfer completion.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 0daa863fb26f2..0c6dac770fc3a 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1223,6 +1223,15 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 		time_left = tegra_i2c_wait_completion_timeout(
 				i2c_dev, &i2c_dev->dma_complete, xfer_time);
 
+		/*
+		 * Synchronize DMA first, since dmaengine_terminate_sync()
+		 * performs synchronization after the transfer's termination
+		 * and we want to get a completion if transfer succeeded.
+		 */
+		dmaengine_synchronize(i2c_dev->msg_read ?
+				      i2c_dev->rx_dma_chan :
+				      i2c_dev->tx_dma_chan);
+
 		dmaengine_terminate_sync(i2c_dev->msg_read ?
 					 i2c_dev->rx_dma_chan :
 					 i2c_dev->tx_dma_chan);
-- 
2.20.1


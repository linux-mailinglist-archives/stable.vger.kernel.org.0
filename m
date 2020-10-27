Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C735629BAF4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802751AbgJ0PvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802376AbgJ0PrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5B421D42;
        Tue, 27 Oct 2020 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813620;
        bh=ziHfpWGkJtAsYAAN9W6J1gWsroJz1GkIxQcvWyUHlvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKnrrWxpyna0UCmK59E7katXwjkaP7ahuiPDEXQsIFn4vSJY1c3LZ+CeFRadVuZkb
         +cgbE8OiIcxexTDHkUMfLxKRQqGT/1Arc1e5i0twCDFRoC94tU/f6loMbuDY7/zmlS
         a2c3b4JogURxWht3DzfLG7k8MzW1zxUuuClHNN2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 582/757] soc: xilinx: Fix error code in zynqmp_pm_probe()
Date:   Tue, 27 Oct 2020 14:53:52 +0100
Message-Id: <20201027135517.826541714@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a6f2f0fdc73aacc6e10ae48ae78634dba26702d4 ]

This should be returning PTR_ERR() but it returns IS_ERR() instead.

Fixes: ffdbae28d9d1 ("drivers: soc: xilinx: Use mailbox IPI callback")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20200605110020.GA978434@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/zynqmp_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/zynqmp_power.c b/drivers/soc/xilinx/zynqmp_power.c
index 31ff49fcd078b..c556623dae024 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -205,7 +205,7 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 		rx_chan = mbox_request_channel_byname(client, "rx");
 		if (IS_ERR(rx_chan)) {
 			dev_err(&pdev->dev, "Failed to request rx channel\n");
-			return IS_ERR(rx_chan);
+			return PTR_ERR(rx_chan);
 		}
 	} else if (of_find_property(pdev->dev.of_node, "interrupts", NULL)) {
 		irq = platform_get_irq(pdev, 0);
-- 
2.25.1




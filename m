Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF10D2E3B26
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405331AbgL1Nqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:46:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404870AbgL1Npm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61A17208BA;
        Mon, 28 Dec 2020 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163101;
        bh=kcQcT50e+KY9CvtMnXIEG9ksrtvfBy4mW+T/7NcRMfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaxIOTu7bdKvAzqdEc0a42vtTxFIyMe0aCn8NgLpiq2gG90ojppaQegJL4iNN3KnC
         dvuUUSCImEA4bZNE84qJl7NXu7ZRMvAJrnm/L96jCe/v5nr9SIYgHa0O3kFN/czid2
         B8pzKTf/d8VQNbZ1Xzkpjv73gbXeA0Us4hK4+pqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/453] dmaengine: mv_xor_v2: Fix error return code in mv_xor_v2_probe()
Date:   Mon, 28 Dec 2020 13:46:44 +0100
Message-Id: <20201228124945.280092805@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit c95e6515a8c065862361f7e0e452978ade7f94ec ]

Return the corresponding error code when first_msi_entry() returns
NULL in mv_xor_v2_probe().

Fixes: 19a340b1a820430 ("dmaengine: mv_xor_v2: new driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20201124010813.1939095-1-chengzhihao1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index e3850f04f6763..889a94af4c851 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -766,8 +766,10 @@ static int mv_xor_v2_probe(struct platform_device *pdev)
 		goto disable_clk;
 
 	msi_desc = first_msi_entry(&pdev->dev);
-	if (!msi_desc)
+	if (!msi_desc) {
+		ret = -ENODEV;
 		goto free_msi_irqs;
+	}
 	xor_dev->msi_desc = msi_desc;
 
 	ret = devm_request_irq(&pdev->dev, msi_desc->irq,
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08AD22707C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgGTVhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgGTVhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A914722BEF;
        Mon, 20 Jul 2020 21:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281043;
        bh=aDH47WXYmEoiCKBRtSqqp2kH1h4RsMqOn8BGWaxOkZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGTJPkjytxr6zjmp1387xvCN1CvTC9uHqw18iAjQSHzgGZnDQdPknHR7sHUyhURpr
         HTyuCgBn/SWKEnBEaL0jaXfkxReyIpvptKzg4L5LeyPbggC1GSaMiKMN3Peul2WPE8
         1Wj5N7v0zIXYFFoFdxShsUr+iHW3RC9fSeItpMaw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 06/40] dmaengine: ti: k3-udma: add missing put_device() call in of_xudma_dev_get()
Date:   Mon, 20 Jul 2020 17:36:41 -0400
Message-Id: <20200720213715.406997-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 1438cde8fe9cb709b569f5829c4c892c0f3f15b3 ]

if of_find_device_by_node() succeed and platform_get_drvdata() failed,
of_xudma_dev_get() will return without put_device(), which will leak
the memory.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200618130110.582543-1-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma-private.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ti/k3-udma-private.c b/drivers/dma/ti/k3-udma-private.c
index 0b8f3dd6b1463..77e8e67d995b3 100644
--- a/drivers/dma/ti/k3-udma-private.c
+++ b/drivers/dma/ti/k3-udma-private.c
@@ -42,6 +42,7 @@ struct udma_dev *of_xudma_dev_get(struct device_node *np, const char *property)
 	ud = platform_get_drvdata(pdev);
 	if (!ud) {
 		pr_debug("UDMA has not been probed\n");
+		put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-- 
2.25.1


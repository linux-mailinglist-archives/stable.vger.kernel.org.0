Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3FB22F115
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgG0OXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732017AbgG0OXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C83D2083E;
        Mon, 27 Jul 2020 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859787;
        bh=aDH47WXYmEoiCKBRtSqqp2kH1h4RsMqOn8BGWaxOkZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUaw1nwYw3n2a3ulRmqA4OUjo68FhNUbVrc5DKW9czYGySCfpUVnEwma5dLFI1ALL
         jjj64rDu9D0fk3VdmUkwkYWqo36HWbNtSslX2xt4pF0Xx0tWZPZT+QOQOgGz0GBvcX
         hrcYBKyTJj4Gyrmr/Bra3tQ+lgybcfkdRyCQKBFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 105/179] dmaengine: ti: k3-udma: add missing put_device() call in of_xudma_dev_get()
Date:   Mon, 27 Jul 2020 16:04:40 +0200
Message-Id: <20200727134937.766221623@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




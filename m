Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D3B8513
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392551AbfISWR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406460AbfISWRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECD620678;
        Thu, 19 Sep 2019 22:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931442;
        bh=dMmQ/8eCsAFOvBzLqKSRTPtQzG0tXkumYwZ1Un/PvgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0qhiJkjaU0MXXcDGkwYg8ykJcZ/fwktqKJ+3159J6aGawvsFbMWk8zLBzqaekmt/
         1fuP4HaZvVd2gLIkhcNmIBa6xevRICvwT4rNQC8dlU381cFwqhXIZHM7Il7eR9Ran/
         oPz5OaDO1fc+R0d2MdFmM6g8is8Xrwu8BPHEbTn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/59] dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()
Date:   Fri, 20 Sep 2019 00:04:03 +0200
Message-Id: <20190919214807.534286029@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 962411b05a6d3342aa649e39cda1704c1fc042c6 ]

If devm_request_irq() fails to disable all interrupts, no cleanup is
performed before retuning the error. To fix this issue, invoke
omap_dma_free() to do the cleanup.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/1565938570-7528-1-git-send-email-wenwen@cs.uga.edu
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/omap-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 8c1665c8fe33a..14b560facf779 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1534,8 +1534,10 @@ static int omap_dma_probe(struct platform_device *pdev)
 
 		rc = devm_request_irq(&pdev->dev, irq, omap_dma_irq,
 				      IRQF_SHARED, "omap-dma-engine", od);
-		if (rc)
+		if (rc) {
+			omap_dma_free(od);
 			return rc;
+		}
 	}
 
 	if (omap_dma_glbl_read(od, CAPS_0) & CAPS_0_SUPPORT_LL123)
-- 
2.20.1




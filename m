Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACF1B85AF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407040AbfISWXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407028AbfISWXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:23:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB27217D6;
        Thu, 19 Sep 2019 22:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931824;
        bh=L0xacNcsY2XpxXNLsk8K58LyQ1BNZxBNfKIvvTCiasE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lIpdG/ArJSs3J2cRfBIC9G5fcYDkgXSOxDzxk4kzWPfqu9ZMmcSF/Rr2jscfQc0Q
         HBfkR1B64a2GsG14gDKKxuv2duTgUMAVdSfDVuS0oL6bNmUlabnnRBc5My+uvNyzlV
         3Y/9I8JihUqzjpG1xxarm1NLpZOmGpawYTfmkdsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 52/56] dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()
Date:   Fri, 20 Sep 2019 00:04:33 +0200
Message-Id: <20190919214804.553605388@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
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
index 1dfc71c90123f..57b6e6ca14a88 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1199,8 +1199,10 @@ static int omap_dma_probe(struct platform_device *pdev)
 
 		rc = devm_request_irq(&pdev->dev, irq, omap_dma_irq,
 				      IRQF_SHARED, "omap-dma-engine", od);
-		if (rc)
+		if (rc) {
+			omap_dma_free(od);
 			return rc;
+		}
 	}
 
 	rc = dma_async_device_register(&od->ddev);
-- 
2.20.1




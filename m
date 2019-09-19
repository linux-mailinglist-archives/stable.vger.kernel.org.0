Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6F6B8571
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390813AbfISWVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404740AbfISWVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:21:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1BA921907;
        Thu, 19 Sep 2019 22:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931662;
        bh=diu1F0bK/0fL+YrFDsc1tuITKQzZqCAlrJih1cjftD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lME4PGDRPWIYps9OX1Q+BqXQb4W3BpWtlzAB9ZWmAAOXi3cSCQ2drgDbUwawBxiG8
         H4ZBrjAxD0lgxTRkDZbr0jVyxvIkY8HXZZSqSH9xOHhwqlj+7x4YL+Q8tGJUgjMAr9
         TiYZrnfteiu0d5a9Po6ki3VYj6PefYF1+BkBytH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 67/74] dmaengine: ti: dma-crossbar: Fix a memory leak bug
Date:   Fri, 20 Sep 2019 00:04:20 +0200
Message-Id: <20190919214810.976668709@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 2c231c0c1dec42192aca0f87f2dc68b8f0cbc7d2 ]

In ti_dra7_xbar_probe(), 'rsv_events' is allocated through kcalloc(). Then
of_property_read_u32_array() is invoked to search for the property.
However, if this process fails, 'rsv_events' is not deallocated, leading to
a memory leak bug. To fix this issue, free 'rsv_events' before returning
the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/1565938136-7249-1-git-send-email-wenwen@cs.uga.edu
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti-dma-crossbar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ti-dma-crossbar.c b/drivers/dma/ti-dma-crossbar.c
index 8c3c588834d2e..a7e1f6e17e3d1 100644
--- a/drivers/dma/ti-dma-crossbar.c
+++ b/drivers/dma/ti-dma-crossbar.c
@@ -395,8 +395,10 @@ static int ti_dra7_xbar_probe(struct platform_device *pdev)
 
 		ret = of_property_read_u32_array(node, pname, (u32 *)rsv_events,
 						 nelm * 2);
-		if (ret)
+		if (ret) {
+			kfree(rsv_events);
 			return ret;
+		}
 
 		for (i = 0; i < nelm; i++) {
 			ti_dra7_xbar_reserve(rsv_events[i][0], rsv_events[i][1],
-- 
2.20.1




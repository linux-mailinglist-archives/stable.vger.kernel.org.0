Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E1EB84D3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393795AbfISWOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393787AbfISWOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:14:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44B3A21920;
        Thu, 19 Sep 2019 22:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931276;
        bh=566Bz2o9qSdYSA2i4UQw+4bzvn1OWackuqqOtUWjLro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wf+7F/fomjdfPZ+9IB7wG/KwceUMeaB/qZO3JCJhxmk5u5NDdPbVRIWYssn8wOsh0
         9j1KgVfUS1FnlR3dz2xPIqlbiKjJM2Z+5wM5jd+PWU78y99g8kywBaSEExOayo3DnC
         VfzeWdOlz7yS5gDPCL8DN5Z6Vm7RmLW5DoMyzemg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 67/79] dmaengine: ti: dma-crossbar: Fix a memory leak bug
Date:   Fri, 20 Sep 2019 00:03:52 +0200
Message-Id: <20190919214813.573405650@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
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
 drivers/dma/ti/dma-crossbar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ti/dma-crossbar.c b/drivers/dma/ti/dma-crossbar.c
index 9272b173c7465..6574cb5a12fee 100644
--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
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




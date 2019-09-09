Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15315AE084
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391953AbfIIWQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388675AbfIIWQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:16:07 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52DEA2171F;
        Mon,  9 Sep 2019 22:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067366;
        bh=RuAsJbetNaqUvGAevgs5C+R+84pnOicaOUpUpk5K3oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggShM5UNlX7QYIxd5Foeg/dPvrljRAioKlmOU9bWzRvdJgK0Am/Kt7wvGTngJmYcy
         yMn8c0pkyj6/sNMdfKrHM/yBGKp1l+aBAMeJF7XvaiQK+LrSzpoMVA5yDAH1m+8kno
         ax15Mv1xpvzr3UUTd+BQ6q+4vmbEV7xdJb0dFxyA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 02/12] dmaengine: ti: dma-crossbar: Fix a memory leak bug
Date:   Mon,  9 Sep 2019 11:40:42 -0400
Message-Id: <20190909154052.30941-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154052.30941-1-sashal@kernel.org>
References: <20190909154052.30941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ad2f0a4cd6a4d..f255056696eec 100644
--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
@@ -391,8 +391,10 @@ static int ti_dra7_xbar_probe(struct platform_device *pdev)
 
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


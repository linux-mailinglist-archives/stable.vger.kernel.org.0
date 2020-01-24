Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0528148383
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404810AbgAXLgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391962AbgAXLgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:36:48 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCBE82075D;
        Fri, 24 Jan 2020 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865807;
        bh=BFvTo5ib+88QZ4+i3IbuWcI70HqA+S9+gl/ABkQJWRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NMP4LlABA1QJBy7MGVc1Mw3MkLnNsQSTK7gp4KY+tcFFzEMHkvwoaw60QTLBi6Qt
         y72xXOFNnyGpatgEAbpIbzp7ueULZigS0mGtGrM4O/5UmeRebchDgH37LVNG+621zf
         5MqQfsZBpckCM4SXTUHWwdRi1aIrD7ZUl0Z5Om6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 631/639] dmaengine: ti: edma: fix missed failure handling
Date:   Fri, 24 Jan 2020 10:33:21 +0100
Message-Id: <20200124093208.686655228@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 340049d453682a9fe8d91fe794dd091730f4bb25 ]

When devm_kcalloc fails, it forgets to call edma_free_slot.
Replace direct return with failure handler to fix it.

Fixes: 1be5336bc7ba ("dmaengine: edma: New device tree binding")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20191118073802.28424-1-hslester96@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 982631d4e1f8a..44158fa859737 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2345,8 +2345,10 @@ static int edma_probe(struct platform_device *pdev)
 
 		ecc->tc_list = devm_kcalloc(dev, ecc->num_tc,
 					    sizeof(*ecc->tc_list), GFP_KERNEL);
-		if (!ecc->tc_list)
-			return -ENOMEM;
+		if (!ecc->tc_list) {
+			ret = -ENOMEM;
+			goto err_reg1;
+		}
 
 		for (i = 0;; i++) {
 			ret = of_parse_phandle_with_fixed_args(node, "ti,tptcs",
-- 
2.20.1




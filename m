Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CCC20DF1E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbgF2UcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732417AbgF2TZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EECB25318;
        Mon, 29 Jun 2020 15:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445146;
        bh=QQjTy83/bItqKgEe9rfd0Yx/TjTAlqto0VCLdCQMsCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZxtp2jQY6bzSaWdhYyhZsU3UImWRUcT3YQ+Yh8T3VR+BagXF0qzrEIhW5/cV9cJx
         smM1rF4VvPsaMpVYJYv9q29gV1kX59q+XbCFQG96Lb6dDAwT7AroDOQB6I424p9tII
         0PYk0WzW7KCH86MxExUC6MJMO994M6/eQ5nzmQrE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 50/78] usb: gadget: udc: Potential Oops in error handling code
Date:   Mon, 29 Jun 2020 11:37:38 -0400
Message-Id: <20200629153806.2494953-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e55f3c37cb8d31c7e301f46396b2ac6a19eb3a7c ]

If this is in "transceiver" mode the the ->qwork isn't required and is
a NULL pointer.  This can lead to a NULL dereference when we call
destroy_workqueue(udc->qwork).

Fixes: 3517c31a8ece ("usb: gadget: mv_udc: use devm_xxx for probe")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/mv_udc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/mv_udc_core.c b/drivers/usb/gadget/udc/mv_udc_core.c
index 4103bf7cf52ab..62fad60d0c061 100644
--- a/drivers/usb/gadget/udc/mv_udc_core.c
+++ b/drivers/usb/gadget/udc/mv_udc_core.c
@@ -2317,7 +2317,8 @@ static int mv_udc_probe(struct platform_device *pdev)
 	return 0;
 
 err_create_workqueue:
-	destroy_workqueue(udc->qwork);
+	if (udc->qwork)
+		destroy_workqueue(udc->qwork);
 err_destroy_dma:
 	dma_pool_destroy(udc->dtd_pool);
 err_free_dma:
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014EA1C8ED9
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgEGO36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbgEGO35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9E1208D6;
        Thu,  7 May 2020 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861796;
        bh=zVxA+eF9Mh2qDI1R6r/LH9sbfii2D87bPxiJg1L2pFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTAM7iVCSGcXkWpsO9/OI1r5DkSr/MH3m6N3VwVSoHLGOm0QtC0MLA1TME/C5YWBj
         coJC+htaybJQD//pTFCOHQ1yrkAyJ1K3raQy+FbzcwP8yB+7rsyCpTKHsnEQl7dRkC
         knlQqNrloBOHodhLjjsz6el5cNzWg4o5/XJ0PujY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/16] dmaengine: dmatest: Fix iteration non-stop logic
Date:   Thu,  7 May 2020 10:29:38 -0400
Message-Id: <20200507142943.26848-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142943.26848-1-sashal@kernel.org>
References: <20200507142943.26848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b9f960201249f20deea586b4ec814669b4c6b1c0 ]

Under some circumstances, i.e. when test is still running and about to
time out and user runs, for example,

	grep -H . /sys/module/dmatest/parameters/*

the iterations parameter is not respected and test is going on and on until
user gives

	echo 0 > /sys/module/dmatest/parameters/run

This is not what expected.

The history of this bug is interesting. I though that the commit
  2d88ce76eb98 ("dmatest: add a 'wait' parameter")
is a culprit, but looking closer to the code I think it simple revealed the
broken logic from the day one, i.e. in the commit
  0a2ff57d6fba ("dmaengine: dmatest: add a maximum number of test iterations")
which adds iterations parameter.

So, to the point, the conditional of checking the thread to be stopped being
first part of conjunction logic prevents to check iterations. Thus, we have to
always check both conditions to be able to stop after given iterations.

Since it wasn't visible before second commit appeared, I add a respective
Fixes tag.

Fixes: 2d88ce76eb98 ("dmatest: add a 'wait' parameter")
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20200424161147.16895-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmatest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e393361277415..d19a602beebd1 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -552,8 +552,8 @@ static int dmatest_func(void *data)
 	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	ktime = ktime_get();
-	while (!kthread_should_stop()
-	       && !(params->iterations && total_tests >= params->iterations)) {
+	while (!(kthread_should_stop() ||
+	       (params->iterations && total_tests >= params->iterations))) {
 		struct dma_async_tx_descriptor *tx = NULL;
 		struct dmaengine_unmap_data *um;
 		dma_addr_t srcs[src_cnt];
-- 
2.20.1


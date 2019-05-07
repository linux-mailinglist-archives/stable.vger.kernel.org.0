Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E70215C66
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfEGGD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbfEGFfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39F9020C01;
        Tue,  7 May 2019 05:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207307;
        bh=2hlKV15dkf6OVVVvZVumgaT6f7V2OIqq3kDJNscJRKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQMsMX5TCfjXTKlSJp7jh6eGTExqJfB7Pzy3vtYzw1FQLLzYVYRLjdVFcOdfDbecL
         ykeum5fLAMlVpCPXrPmMm9cihWkNWGt7WtfMRrPviL6JuYtYJ6tDNXrl/p+EurK6xZ
         WexRM+1DvXqhSzDJgLduUkZPAhbcQ+FXPHdWRoNc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 76/99] dmaengine: bcm2835: Avoid GFP_KERNEL in device_prep_slave_sg
Date:   Tue,  7 May 2019 01:32:10 -0400
Message-Id: <20190507053235.29900-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit f147384774a7b24dda4783a3dcd61af272757ea8 ]

The commit af19b7ce76ba ("mmc: bcm2835: Avoid possible races on
data requests") introduces a possible circular locking dependency,
which is triggered by swapping to the sdhost interface.

So instead of reintroduce the race condition again, we could also
avoid this situation by using GFP_NOWAIT for the allocation of the
DMA buffer descriptors.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Fixes: af19b7ce76ba ("mmc: bcm2835: Avoid possible races on data requests")
Link: http://lists.infradead.org/pipermail/linux-rpi-kernel/2019-March/008615.html
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/bcm2835-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index ae10f5614f95..bf5119203637 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -674,7 +674,7 @@ static struct dma_async_tx_descriptor *bcm2835_dma_prep_slave_sg(
 	d = bcm2835_dma_create_cb_chain(chan, direction, false,
 					info, extra,
 					frames, src, dst, 0, 0,
-					GFP_KERNEL);
+					GFP_NOWAIT);
 	if (!d)
 		return NULL;
 
-- 
2.20.1


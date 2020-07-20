Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066532271D2
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGTVhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgGTVhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52D2F22BF5;
        Mon, 20 Jul 2020 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281041;
        bh=TDooSVtagYrP8aV1Wtx6+jqcdOwQWWJmfscT8kHFV70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuHGShs4lWN6B6aij3+1KgiHJYYt2gl4nBIymj+thloN9Tb4uTLcuynvfnEMSDiWn
         h+UQAxlno8nt9zj8bMi03rRlqfqPsRgbYS47WB3DSG7cI6qvOzeTkmPqZEgGFSCL0Y
         qPRAfOcy8FBBNuELIpp11O6T3Uf2wKtrJW3sBztE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 04/40] dmaengine: ti: k3-udma: Fix the running channel handling in alloc_chan_resources
Date:   Mon, 20 Jul 2020 17:36:39 -0400
Message-Id: <20200720213715.406997-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit b5b0180c2f767e90b4a6a885a0a2abaab6e3d48d ]

In the unlikely case when the channel is running (RT enabled) during
alloc_chan_resources then we should use udma_reset_chan() and not
udma_stop() as the later is trying to initiate a teardown on the channel,
which is not valid at this point.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200527070612.636-3-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 2e20fab413b94..48176938e49ca 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -1868,7 +1868,7 @@ static int udma_alloc_chan_resources(struct dma_chan *chan)
 
 	if (udma_is_chan_running(uc)) {
 		dev_warn(ud->dev, "chan%d: is running!\n", uc->id);
-		udma_stop(uc);
+		udma_reset_chan(uc, false);
 		if (udma_is_chan_running(uc)) {
 			dev_err(ud->dev, "chan%d: won't stop!\n", uc->id);
 			goto err_res_free;
-- 
2.25.1


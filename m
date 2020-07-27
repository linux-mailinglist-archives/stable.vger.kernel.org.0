Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3CE22F116
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbgG0OXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732004AbgG0OXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6194D2070A;
        Mon, 27 Jul 2020 14:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859782;
        bh=e9V3lPrkqDvI9PpIFRoLbKwiPOAE5nFcLwbfsSfpGZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9QdEFmXUUaCw6pViwV10r5Ua79rEAQW1nyOgAxHxOfUxcuNImnNa2s4tC+f5g/kt
         Lxo3JqQwB8vKfsicL7N5Z4fYAToo6BpZkXB9A64NjIOtzJqdKbCUUgMTWigaQsrN5C
         dA+rZzofdLT+Bk0heXmYXbr1LSebAIzErqI+XpCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 103/179] dmaengine: ti: k3-udma: Fix the running channel handling in alloc_chan_resources
Date:   Mon, 27 Jul 2020 16:04:38 +0200
Message-Id: <20200727134937.668966561@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 35f54a1af29d8..b777f1924968f 100644
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




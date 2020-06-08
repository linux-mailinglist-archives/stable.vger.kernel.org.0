Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D373E1F2810
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbgFHXs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731332AbgFHXZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B6E20812;
        Mon,  8 Jun 2020 23:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658745;
        bh=gurwdtib4L861NscFcX0tABfxzET9woljcbtDY2AjP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJjd5vCRnVZM8opQB2aMIgc9oDwPrwADeQTlIw5NxVWN7kv6cJ6i1T2kI7C1Jilb9
         4ivg0Z1y4elic79nDzXq9BPWGCEfHGY7lu3azYDlNacsNLwvKEFCmS467bxliodRmY
         KqcmiRqh/fLDU0FVFsM1sgauvwfi1a3j73fN7TK0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/72] media: platform: fcp: Set appropriate DMA parameters
Date:   Mon,  8 Jun 2020 19:24:19 -0400
Message-Id: <20200608232500.3369581-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

[ Upstream commit dd844fb8e50b12e65bbdc5746c9876c6735500df ]

Enabling CONFIG_DMA_API_DEBUG=y and CONFIG_DMA_API_DEBUG_SG=y will
enable extra validation on DMA operations ensuring that the size
restraints are met.

When using the FCP in conjunction with the VSP1/DU, and display frames,
the size of the DMA operations is larger than the default maximum
segment size reported by the DMA core (64K). With the DMA debug enabled,
this produces a warning such as the following:

"DMA-API: rcar-fcp fea27000.fcp: mapping sg segment longer than device
claims to support [len=3145728] [max=65536]"

We have no specific limitation on the segment size which isn't already
handled by the VSP1/DU which actually handles the DMA allcoations and
buffer management, so define a maximum segment size of up to 4GB (a 32
bit mask).

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 7b49235e83b2 ("[media] v4l: Add Renesas R-Car FCP driver")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-fcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 2988031d285d..0047d144c932 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -24,6 +25,7 @@
 struct rcar_fcp_device {
 	struct list_head list;
 	struct device *dev;
+	struct device_dma_parameters dma_parms;
 };
 
 static LIST_HEAD(fcp_devices);
@@ -139,6 +141,9 @@ static int rcar_fcp_probe(struct platform_device *pdev)
 
 	fcp->dev = &pdev->dev;
 
+	fcp->dev->dma_parms = &fcp->dma_parms;
+	dma_set_max_seg_size(fcp->dev, DMA_BIT_MASK(32));
+
 	pm_runtime_enable(&pdev->dev);
 
 	mutex_lock(&fcp_lock);
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA93201740
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395261AbgFSQgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389195AbgFSOtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:49:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250352158C;
        Fri, 19 Jun 2020 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578149;
        bh=gurwdtib4L861NscFcX0tABfxzET9woljcbtDY2AjP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXkRcPsjjHZbg++neV+3vH/3QR0xVO7WBlE85XdZcMYCkt1AqByQmo34TshBGtPKg
         xzxD35v4YkyxINMZJhq4/rIvH2uC1oqyfmkJtxKl/NVYKNLcrYCPFHymgdpzz76Sbd
         nxutiVfIstmypNis4zav44xrKFhAgzkjZM7CvoQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/190] media: platform: fcp: Set appropriate DMA parameters
Date:   Fri, 19 Jun 2020 16:32:27 +0200
Message-Id: <20200619141638.677857052@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




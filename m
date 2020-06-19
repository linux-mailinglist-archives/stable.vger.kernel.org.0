Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0287201450
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390386AbgFSQIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391616AbgFSPHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:07:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BFAC21852;
        Fri, 19 Jun 2020 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579261;
        bh=FmZBpMkmKEa+BWw2RykpSg1I5MeKBmsg8bPHuXEZEK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnmaGmTZ8/XqVcrrwJhF47OYdpWJKyDck0vDLlJLAFOiEOQ7iEZOb6lbwU47Qo9E+
         Swmileh/G29yiUuZzUp3XBRcFNwfWFe3gXpUyaHu6UDxXM2JLYz7+nTpdt/3jbh2kB
         R0fGM7UDz8ZXd0N0XJaeDhdFeezY+l5Oc2zZxap0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/261] media: platform: fcp: Set appropriate DMA parameters
Date:   Fri, 19 Jun 2020 16:31:20 +0200
Message-Id: <20200619141653.208069018@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
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
index 43c78620c9d8..5c6b00737fe7 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -21,6 +22,7 @@
 struct rcar_fcp_device {
 	struct list_head list;
 	struct device *dev;
+	struct device_dma_parameters dma_parms;
 };
 
 static LIST_HEAD(fcp_devices);
@@ -136,6 +138,9 @@ static int rcar_fcp_probe(struct platform_device *pdev)
 
 	fcp->dev = &pdev->dev;
 
+	fcp->dev->dma_parms = &fcp->dma_parms;
+	dma_set_max_seg_size(fcp->dev, DMA_BIT_MASK(32));
+
 	pm_runtime_enable(&pdev->dev);
 
 	mutex_lock(&fcp_lock);
-- 
2.25.1




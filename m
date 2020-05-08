Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA471CAF23
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgEHNPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgEHMqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67DD1208D6;
        Fri,  8 May 2020 12:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941973;
        bh=9Xkoiwf1YHVSbAnToLIFk9OZ5Xr8T1ZeV/4VA9TVvMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGCOQBaEcM2m78T6gz8wfWio+uYXnNqapJ40F8mK3fzi+w1PXRA5FZV02BJruck7N
         xv4iagLkJeScODNT17it1tHdKIDbjRxOzqv2YRe8ylXz/lv4hGonp+t6Akb4/Ll7ne
         eMRDYUsfX9qgzDfjEDxVLHlM0fFyURQnl9VvSKwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 4.4 247/312] dmaengine: edma: Add probe callback to edma_tptc_driver
Date:   Fri,  8 May 2020 14:33:58 +0200
Message-Id: <20200508123141.787484108@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 4fa2d09c1ae879c2ee2760ab419a4f97026dd97b upstream.

Due to changes in device and platform code drivers w/o probe will fail to
load. This means that the devices for eDMA TPTCs are goign to be without
driver and omap hwmod code will turn them off after the kernel finished
loading:
[    3.015900] platform 49800000.tptc: omap_device_late_idle: enabled but no driver.  Idling
[    3.024671] platform 49a00000.tptc: omap_device_late_idle: enabled but no driver.  Idling

This will prevent eDMA to work since the TPTCs are not enabled.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Fixes: 34635b1accb9 ("dmaengine: edma: Add dummy driver skeleton for edma3-tptc")
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/edma.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -2439,7 +2439,13 @@ static struct platform_driver edma_drive
 	},
 };
 
+static int edma_tptc_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
 static struct platform_driver edma_tptc_driver = {
+	.probe		= edma_tptc_probe,
 	.driver = {
 		.name	= "edma3-tptc",
 		.of_match_table = edma_tptc_of_ids,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDFEF7F65
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKKSa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:30:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbfKKSa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:30:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AAE221872;
        Mon, 11 Nov 2019 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497055;
        bh=CUXlu8NZW03WkyDCebKAp5bWiJQw0Dd3ZEeLxh35JVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdsvgeW7BWRUftlGNbbAGz+K6qZxfPe/AG8C8DeCzic7BMCquSIiv7PYqWrFEbKw9
         yTZQjQMC/tRpVlqj381HNENtQ9Sk2tY+05P5TdR3w6h+0R/HwBRXSdBPDydKgW7U5C
         vHxVQV2e4uWLzDuSjdyreS221z364cHDyWjtGc1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikhil Badola <nikhil.badola@freescale.com>,
        Ran Wang <ran.wang_1@nxp.com>, Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/43] usb: fsl: Check memory resource before releasing it
Date:   Mon, 11 Nov 2019 19:28:44 +0100
Message-Id: <20191111181320.739683111@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikhil Badola <nikhil.badola@freescale.com>

[ Upstream commit bc1e3a2dd0c9954fd956ac43ca2876bbea018c01 ]

Check memory resource existence before releasing it to avoid NULL
pointer dereference

Signed-off-by: Nikhil Badola <nikhil.badola@freescale.com>
Reviewed-by: Ran Wang <ran.wang_1@nxp.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fsl_udc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index 8991a40707926..bd98557caa280 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2570,7 +2570,7 @@ static int fsl_udc_remove(struct platform_device *pdev)
 	dma_pool_destroy(udc_controller->td_pool);
 	free_irq(udc_controller->irq, udc_controller);
 	iounmap(dr_regs);
-	if (pdata->operating_mode == FSL_USB2_DR_DEVICE)
+	if (res && (pdata->operating_mode == FSL_USB2_DR_DEVICE))
 		release_mem_region(res->start, resource_size(res));
 
 	/* free udc --wait for the release() finished */
-- 
2.20.1




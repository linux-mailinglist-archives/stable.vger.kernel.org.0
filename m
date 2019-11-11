Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D50FF7DD4
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfKKSzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730606AbfKKSzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDD0A2173B;
        Mon, 11 Nov 2019 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498507;
        bh=VbvCCvsiDambmPOvycY7w01iL2qd8YiBgIkPa7Jm3Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM952O+R/DFsHT7RXmMXpSSy5dbiN8pww4KQe/wQhf7bC66b599+XrXU9aUh1ivii
         YfjcjAERqVzBtQVzW5I5TnIGYDmFUrASdbEVhPrG2MzzS7zCK1z+aFa6AJaRcpA65K
         HTEbXK82SEZsFLUhMEkoIZ0IZbg6hK+WuR48Ji5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikhil Badola <nikhil.badola@freescale.com>,
        Ran Wang <ran.wang_1@nxp.com>, Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 138/193] usb: fsl: Check memory resource before releasing it
Date:   Mon, 11 Nov 2019 19:28:40 +0100
Message-Id: <20191111181511.353956200@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
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
index 20141c3096f68..9a05863b28768 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2576,7 +2576,7 @@ static int fsl_udc_remove(struct platform_device *pdev)
 	dma_pool_destroy(udc_controller->td_pool);
 	free_irq(udc_controller->irq, udc_controller);
 	iounmap(dr_regs);
-	if (pdata->operating_mode == FSL_USB2_DR_DEVICE)
+	if (res && (pdata->operating_mode == FSL_USB2_DR_DEVICE))
 		release_mem_region(res->start, resource_size(res));
 
 	/* free udc --wait for the release() finished */
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277C02A5504
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbgKCVLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388911AbgKCVLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:11:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CF8205ED;
        Tue,  3 Nov 2020 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437905;
        bh=XgqivWphlhBxKy56iG2H0agN9XDtO3Gpwbhw7LIjMNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHJn09dpSEyJD0Moo03gBSbE/z7f3atYmzx9mP/xHuluh19ZiF32kokmIB62WFH+B
         23x72Eq891gfVEregAUueZfSUnCeq1es0ZhNi78RtFoK/Y45mHsmoUiNKDEcKnP1V0
         S5N96Zsjcn/mB74fcZafylfZ4tpkXwNunejVj4bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Ran Wang <ran.wang_1@nxp.com>
Subject: [PATCH 4.14 082/125] usb: host: fsl-mph-dr-of: check return of dma_set_mask()
Date:   Tue,  3 Nov 2020 21:37:39 +0100
Message-Id: <20201103203208.800084716@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ran Wang <ran.wang_1@nxp.com>

commit 3cd54a618834430a26a648d880dd83d740f2ae30 upstream.

fsl_usb2_device_register() should stop init if dma_set_mask() return
error.

Fixes: cae058610465 ("drivers/usb/host: fsl: Set DMA_MASK of usb platform device")
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Link: https://lore.kernel.org/r/20201010060308.33693-1-ran.wang_1@nxp.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/fsl-mph-dr-of.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/fsl-mph-dr-of.c
+++ b/drivers/usb/host/fsl-mph-dr-of.c
@@ -98,10 +98,13 @@ static struct platform_device *fsl_usb2_
 
 	pdev->dev.coherent_dma_mask = ofdev->dev.coherent_dma_mask;
 
-	if (!pdev->dev.dma_mask)
+	if (!pdev->dev.dma_mask) {
 		pdev->dev.dma_mask = &ofdev->dev.coherent_dma_mask;
-	else
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+	} else {
+		retval = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (retval)
+			goto error;
+	}
 
 	retval = platform_device_add_data(pdev, pdata, sizeof(*pdata));
 	if (retval)



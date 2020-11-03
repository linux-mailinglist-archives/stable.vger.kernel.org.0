Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367402A5326
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbgKCU6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732116AbgKCU6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E509D2053B;
        Tue,  3 Nov 2020 20:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437095;
        bh=JhqZYrzLoq7d1IA7dJCErI9pM2rLwGx0q5SNQ8neXAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zV6Bgfqrclvqs79taYP41ddyEwhZBMhkCLZJNK8YiJ9gzIyViAio3IbHAZuaopXjZ
         L0iABn7dB0LvfF//aKVB99Sa1ZiUYBZQpR7f4Cm6mqeUUIjwv57QUGITIgT1y/3NDM
         CAuonkj44gAooIuIDmnciVShFDzeVL+ZLyA5bSQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Ran Wang <ran.wang_1@nxp.com>
Subject: [PATCH 5.4 143/214] usb: host: fsl-mph-dr-of: check return of dma_set_mask()
Date:   Tue,  3 Nov 2020 21:36:31 +0100
Message-Id: <20201103203304.218947273@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -94,10 +94,13 @@ static struct platform_device *fsl_usb2_
 
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



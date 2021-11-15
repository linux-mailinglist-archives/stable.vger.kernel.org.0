Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035A1452711
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345360AbhKPCPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:15:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238904AbhKORwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:52:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1768632AC;
        Mon, 15 Nov 2021 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997554;
        bh=+ZCuS/jyle/F5oQcp3L8uoU1f3CFUz1vHNZQeW79T8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bA7nkIqg7xmbgO9fIQqGh0TYTXwSVAZ61OGki8ycgkV+6CkD7tOFTVmQRsFxqQJfy
         db0qrlGfMRXGVDOYjZWQKI4tTMeSI5fPnPal9RYf/gGCLtKPYt4gFtGyBJreRgBR/b
         b+wPPm9/yiUG4GBvmuhYaQ77KrYvFEJx726Xc2Mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitriy Ulitin <ulitin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/575] media: stm32: Potential NULL pointer dereference in dcmi_irq_thread()
Date:   Mon, 15 Nov 2021 17:58:36 +0100
Message-Id: <20211115165350.310286070@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitriy Ulitin <ulitin@ispras.ru>

[ Upstream commit 548fa43a58696450c15b8f5564e99589c5144664 ]

At the moment of enabling irq handling:

1922 ret = devm_request_threaded_irq(&pdev->dev, irq, dcmi_irq_callback,
1923			dcmi_irq_thread, IRQF_ONESHOT,
1924			dev_name(&pdev->dev), dcmi);

there is still uninitialized field sd_format of struct stm32_dcmi *dcmi.
If an interrupt occurs in the interval between the installation of the
interrupt handler and the initialization of this field, NULL pointer
dereference happens.

This field is dereferenced in the handler function without any check:

457 if (dcmi->sd_format->fourcc == V4L2_PIX_FMT_JPEG &&
458	    dcmi->misr & IT_FRAME) {

The patch moves interrupt handler installation
after initialization of the sd_format field that happens in
dcmi_graph_notify_complete() via dcmi_set_default_fmt().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Dmitriy Ulitin <ulitin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index fd1c41cba52fc..233e4d3feacd9 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -135,6 +135,7 @@ struct stm32_dcmi {
 	int				sequence;
 	struct list_head		buffers;
 	struct dcmi_buf			*active;
+	int			irq;
 
 	struct v4l2_device		v4l2_dev;
 	struct video_device		*vdev;
@@ -1720,6 +1721,14 @@ static int dcmi_graph_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
+	ret = devm_request_threaded_irq(dcmi->dev, dcmi->irq, dcmi_irq_callback,
+					dcmi_irq_thread, IRQF_ONESHOT,
+					dev_name(dcmi->dev), dcmi);
+	if (ret) {
+		dev_err(dcmi->dev, "Unable to request irq %d\n", dcmi->irq);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -1881,6 +1890,8 @@ static int dcmi_probe(struct platform_device *pdev)
 	if (irq <= 0)
 		return irq ? irq : -ENXIO;
 
+	dcmi->irq = irq;
+
 	dcmi->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!dcmi->res) {
 		dev_err(&pdev->dev, "Could not get resource\n");
@@ -1893,14 +1904,6 @@ static int dcmi_probe(struct platform_device *pdev)
 		return PTR_ERR(dcmi->regs);
 	}
 
-	ret = devm_request_threaded_irq(&pdev->dev, irq, dcmi_irq_callback,
-					dcmi_irq_thread, IRQF_ONESHOT,
-					dev_name(&pdev->dev), dcmi);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
-		return ret;
-	}
-
 	mclk = devm_clk_get(&pdev->dev, "mclk");
 	if (IS_ERR(mclk)) {
 		if (PTR_ERR(mclk) != -EPROBE_DEFER)
-- 
2.33.0




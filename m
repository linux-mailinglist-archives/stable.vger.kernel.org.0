Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F1B2893B
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390356AbfEWTb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391242AbfEWTbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:31:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86802184E;
        Thu, 23 May 2019 19:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639869;
        bh=bieoZxUuM0eYUMgkc97RF8clTu3pxaHE+SnDROpgHX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAzSiODjBwELXeUVdWH14KY93rT+s3fbhNKB+CVW3javjVT2Xb4z2I8HmLzLyJ3F3
         CQB3nZn4caRWqxEmR5yMApCsHN3Qb4DyX8jBhrA5jgy6UVlWDH+1dNS+7hfM4HRddx
         qXe4+PWI85LZ3fb1xSID36ZZ1GcPDvnKl0ZGRVPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Richard Leitner <richard.leitner@skidata.com>
Subject: [PATCH 5.1 114/122] dmaengine: imx-sdma: Only check ratio on parts that support 1:1
Date:   Thu, 23 May 2019 21:07:16 +0200
Message-Id: <20190523181720.626436939@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angus Ainslie (Purism) <angus@akkea.ca>

commit 941acd566b1807b291bbdca31cc5158e26ffcf83 upstream.

On imx8mq B0 chip, AHB/SDMA clock ratio 2:1 can't be supported,
since SDMA clock ratio has to be increased to 250Mhz, AHB can't reach
to 500Mhz, so use 1:1 instead.

To limit this change to the imx8mq for now this patch also adds an
im8mq-sdma compatible string.

Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
Acked-by: Robin Gong <yibin.gong@nxp.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Cc: Richard Leitner <richard.leitner@skidata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/imx-sdma.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -419,6 +419,7 @@ struct sdma_driver_data {
 	int chnenbl0;
 	int num_events;
 	struct sdma_script_start_addrs	*script_addrs;
+	bool check_ratio;
 };
 
 struct sdma_engine {
@@ -557,6 +558,13 @@ static struct sdma_driver_data sdma_imx7
 	.script_addrs = &sdma_script_imx7d,
 };
 
+static struct sdma_driver_data sdma_imx8mq = {
+	.chnenbl0 = SDMA_CHNENBL0_IMX35,
+	.num_events = 48,
+	.script_addrs = &sdma_script_imx7d,
+	.check_ratio = 1,
+};
+
 static const struct platform_device_id sdma_devtypes[] = {
 	{
 		.name = "imx25-sdma",
@@ -580,6 +588,9 @@ static const struct platform_device_id s
 		.name = "imx7d-sdma",
 		.driver_data = (unsigned long)&sdma_imx7d,
 	}, {
+		.name = "imx8mq-sdma",
+		.driver_data = (unsigned long)&sdma_imx8mq,
+	}, {
 		/* sentinel */
 	}
 };
@@ -593,6 +604,7 @@ static const struct of_device_id sdma_dt
 	{ .compatible = "fsl,imx31-sdma", .data = &sdma_imx31, },
 	{ .compatible = "fsl,imx25-sdma", .data = &sdma_imx25, },
 	{ .compatible = "fsl,imx7d-sdma", .data = &sdma_imx7d, },
+	{ .compatible = "fsl,imx8mq-sdma", .data = &sdma_imx8mq, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, sdma_dt_ids);
@@ -1852,7 +1864,8 @@ static int sdma_init(struct sdma_engine
 	if (ret)
 		goto disable_clk_ipg;
 
-	if (clk_get_rate(sdma->clk_ahb) == clk_get_rate(sdma->clk_ipg))
+	if (sdma->drvdata->check_ratio &&
+	    (clk_get_rate(sdma->clk_ahb) == clk_get_rate(sdma->clk_ipg)))
 		sdma->clk_ratio = 1;
 
 	/* Be sure SDMA has not started yet */



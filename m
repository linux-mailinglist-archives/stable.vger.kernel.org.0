Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D1914B9F9
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgA1OXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:23:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgA1OXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:23:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C09624686;
        Tue, 28 Jan 2020 14:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221420;
        bh=WwZHyOY2VemlvryYFlEoA2dm0HI2D0kYuVp0LfkO2Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPEMN7Ds6LnTeW119sB7rHV88+M0S/YhMbHdb5/RiIkdwPRUOINvuMa9xROS0KA22
         WVx08OsFmkaRByRMA4CGPkrWQeZH7xQUwL0q3AhffUqC4oLDeCv4lx5N4nsSrV/kr/
         F/+gI95USi5E9Ubi2aSsnmb8J0836gNyGLDXN3Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@vger.kernel,
        Robin Gong <yibin.gong@nxp.com>,
        Jurgen Lambrecht <J.Lambrecht@TELEVIC.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 216/271] dmaengine: imx-sdma: fix size check for sdma script_number
Date:   Tue, 28 Jan 2020 15:06:05 +0100
Message-Id: <20200128135908.614440216@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

[ Upstream commit bd73dfabdda280fc5f05bdec79b6721b4b2f035f ]

Illegal memory will be touch if SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V3
(41) exceed the size of structure sdma_script_start_addrs(40),
thus cause memory corrupt such as slob block header so that kernel
trap into while() loop forever in slob_free(). Please refer to below
code piece in imx-sdma.c:
for (i = 0; i < sdma->script_number; i++)
	if (addr_arr[i] > 0)
		saddr_arr[i] = addr_arr[i]; /* memory corrupt here */
That issue was brought by commit a572460be9cf ("dmaengine: imx-sdma: Add
support for version 3 firmware") because SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V3
(38->41 3 scripts added) not align with script number added in
sdma_script_start_addrs(2 scripts).

Fixes: a572460be9cf ("dmaengine: imx-sdma: Add support for version 3 firmware")
Cc: stable@vger.kernel
Link: https://www.spinics.net/lists/arm-kernel/msg754895.html
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Reported-by: Jurgen Lambrecht <J.Lambrecht@TELEVIC.com>
Link: https://lore.kernel.org/r/1569347584-3478-1-git-send-email-yibin.gong@nxp.com
[vkoul: update the patch title]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c                     | 8 ++++++++
 include/linux/platform_data/dma-imx-sdma.h | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 9f240b2d85a54..558d509b7d855 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1441,6 +1441,14 @@ static void sdma_add_scripts(struct sdma_engine *sdma,
 	if (!sdma->script_number)
 		sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1;
 
+	if (sdma->script_number > sizeof(struct sdma_script_start_addrs)
+				  / sizeof(s32)) {
+		dev_err(sdma->dev,
+			"SDMA script number %d not match with firmware.\n",
+			sdma->script_number);
+		return;
+	}
+
 	for (i = 0; i < sdma->script_number; i++)
 		if (addr_arr[i] > 0)
 			saddr_arr[i] = addr_arr[i];
diff --git a/include/linux/platform_data/dma-imx-sdma.h b/include/linux/platform_data/dma-imx-sdma.h
index 2d08816720f6d..5bb0a119f39a3 100644
--- a/include/linux/platform_data/dma-imx-sdma.h
+++ b/include/linux/platform_data/dma-imx-sdma.h
@@ -50,7 +50,10 @@ struct sdma_script_start_addrs {
 	/* End of v2 array */
 	s32 zcanfd_2_mcu_addr;
 	s32 zqspi_2_mcu_addr;
+	s32 mcu_2_ecspi_addr;
 	/* End of v3 array */
+	s32 mcu_2_zqspi_addr;
+	/* End of v4 array */
 };
 
 /**
-- 
2.20.1




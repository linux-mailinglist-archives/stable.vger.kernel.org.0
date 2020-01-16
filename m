Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F51D13E72F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390635AbgAPRND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:13:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbgAPRNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F3BF24690;
        Thu, 16 Jan 2020 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194781;
        bh=X71KVo4xG0cjqx0gcs9hfFfsMPtQ4qoxi0HywtBXbOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZC+BGZ0iiiA1tSaElD3iPhuz1NR0W2+Xizz3BLsQ0qotj6Cdc8aGZ1iOPny0/WPpm
         cqgt1ZqfcKeyMNJyw5MYdlEuXWqOe4Ts2nxYKxu0BozXHhT4P4SZWPYrp/MT53/92i
         pmJzfKwe5SUc35jZ5MrgjAPGHQt9H6HOCi9F00sM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Gong <yibin.gong@nxp.com>, stable@vger.kernel,
        Jurgen Lambrecht <J.Lambrecht@TELEVIC.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 597/671] dmaengine: imx-sdma: fix size check for sdma script_number
Date:   Thu, 16 Jan 2020 12:03:55 -0500
Message-Id: <20200116170509.12787-334-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3f5a01cb4ab4..ceb82e74f5b4 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1662,6 +1662,14 @@ static void sdma_add_scripts(struct sdma_engine *sdma,
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
index 6eaa53cef0bd..30e676b36b24 100644
--- a/include/linux/platform_data/dma-imx-sdma.h
+++ b/include/linux/platform_data/dma-imx-sdma.h
@@ -51,7 +51,10 @@ struct sdma_script_start_addrs {
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


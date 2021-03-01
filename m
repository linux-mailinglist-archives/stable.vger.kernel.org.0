Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A162329096
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbhCAUKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236681AbhCAUBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:01:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C4706538A;
        Mon,  1 Mar 2021 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621436;
        bh=gS+09t6qDrpY8zaJLYH03eJ1SY1rrm2XqepLokM3m4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdAqnOirH0WFU0Mr4PNuAsYTqozVduyMp0Ne9BIoL3z0jTEQCWkTwgKfgHfYfQ0c9
         ZGiF4kv4zTKTVw8be7oZQ3bSGvi55P0iQLsmdZ/55abbz28E7QLur57FHjN1PMnf82
         M7dI7fOY3oAFLIBwi6N7QQ3IM4wvxlk5BKVVRDZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 515/775] remoteproc/mediatek: acknowledge watchdog IRQ after handled
Date:   Mon,  1 Mar 2021 17:11:23 +0100
Message-Id: <20210301161226.974242136@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 8c545f52dce44368fff524e13116e696e005c074 ]

Acknowledges watchdog IRQ after handled or kernel keeps receiving the
interrupt.

Fixes: fd0b6c1ff85a ("remoteproc/mediatek: Add support for mt8192 SCP")
Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20210127082046.3735157-1-tzungbi@google.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_common.h |  1 +
 drivers/remoteproc/mtk_scp.c    | 20 +++++++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/mtk_common.h b/drivers/remoteproc/mtk_common.h
index 988edb4977c31..bcab38511bf31 100644
--- a/drivers/remoteproc/mtk_common.h
+++ b/drivers/remoteproc/mtk_common.h
@@ -47,6 +47,7 @@
 
 #define MT8192_CORE0_SW_RSTN_CLR	0x10000
 #define MT8192_CORE0_SW_RSTN_SET	0x10004
+#define MT8192_CORE0_WDT_IRQ		0x10030
 #define MT8192_CORE0_WDT_CFG		0x10034
 
 #define SCP_FW_VER_LEN			32
diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index e0c2356903616..eba825b46696e 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -197,17 +197,19 @@ static void mt8192_scp_irq_handler(struct mtk_scp *scp)
 
 	scp_to_host = readl(scp->reg_base + MT8192_SCP2APMCU_IPC_SET);
 
-	if (scp_to_host & MT8192_SCP_IPC_INT_BIT)
+	if (scp_to_host & MT8192_SCP_IPC_INT_BIT) {
 		scp_ipi_handler(scp);
-	else
-		scp_wdt_handler(scp, scp_to_host);
 
-	/*
-	 * SCP won't send another interrupt until we clear
-	 * MT8192_SCP2APMCU_IPC.
-	 */
-	writel(MT8192_SCP_IPC_INT_BIT,
-	       scp->reg_base + MT8192_SCP2APMCU_IPC_CLR);
+		/*
+		 * SCP won't send another interrupt until we clear
+		 * MT8192_SCP2APMCU_IPC.
+		 */
+		writel(MT8192_SCP_IPC_INT_BIT,
+		       scp->reg_base + MT8192_SCP2APMCU_IPC_CLR);
+	} else {
+		scp_wdt_handler(scp, scp_to_host);
+		writel(1, scp->reg_base + MT8192_CORE0_WDT_IRQ);
+	}
 }
 
 static irqreturn_t scp_irq_handler(int irq, void *priv)
-- 
2.27.0




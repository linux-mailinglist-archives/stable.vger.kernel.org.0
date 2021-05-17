Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97ECD383068
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbhEQO0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239731AbhEQOYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94B5161468;
        Mon, 17 May 2021 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260787;
        bh=IW3qTF8Pc10N5Jh1/q7Dj1ZdQhjrIiziEjyYlFZMsEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXtIAzSlfLgSLJ3utuELZIoV1wIE7jYnNnuTmknfyYEHE9zLZzWM4rig4aYrVPKgh
         W6hIxJqvAgTDqjS3lv7X+58+Jm7m6JUs9V1yb/7GJtipqm2wHl50kKyT2mUrLtgkeF
         J6mpF3AlWGZCRNkPQy3l+1Qzn8KwoFYIxptjgwSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 236/363] net: ipa: fix inter-EE IRQ register definitions
Date:   Mon, 17 May 2021 16:01:42 +0200
Message-Id: <20210517140310.564727583@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 6a780f51f87b430cc69ebf4e859e7e9be720b283 ]

In gsi_irq_setup(), two registers are written with the intention of
disabling inter-EE channel and event IRQs.

But the wrong registers are used (and defined); the ones used are
read-only registers that indicate whether the interrupt condition is
present.

Define the mask registers instead of the status registers, and use
them to disable the inter-EE interrupt types.

Fixes: 46f748ccaf01 ("net: ipa: explicitly disallow inter-EE interrupts")
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20210505223636.232527-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c     |  4 ++--
 drivers/net/ipa/gsi_reg.h | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 390d3403386a..144892060718 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -211,8 +211,8 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 
 	/* The inter-EE registers are in the non-adjusted address range */
-	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
-	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 1622d8cf8dea..48ef04afab79 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -53,15 +53,15 @@
 #define GSI_EE_REG_ADJUST			0x0000d000	/* IPA v4.5+ */
 
 /* The two inter-EE IRQ register offsets are relative to gsi->virt_raw */
-#define GSI_INTER_EE_SRC_CH_IRQ_OFFSET \
-			GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(ee) \
-			(0x0000c018 + 0x1000 * (ee))
-
-#define GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET \
-			GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(ee) \
-			(0x0000c01c + 0x1000 * (ee))
+#define GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET \
+			GSI_INTER_EE_N_SRC_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_CH_IRQ_MSK_OFFSET(ee) \
+			(0x0000c020 + 0x1000 * (ee))
+
+#define GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET \
+			GSI_INTER_EE_N_SRC_EV_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_MSK_OFFSET(ee) \
+			(0x0000c024 + 0x1000 * (ee))
 
 /* All other register offsets are relative to gsi->virt */
 #define GSI_CH_C_CNTXT_0_OFFSET(ch) \
-- 
2.30.2




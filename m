Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E3410CD38
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK1QvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:51:15 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43394 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfK1QuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:06 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so13124457pgq.10
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h4A+UA0S3l+ls0zS2Gq9BFaj9JODH97JG2yHCpwCb+s=;
        b=Wx+K86GxA+4smpBpiOHAUU4+1Q2OkAURYY7uZaNtD0cSSiGuNbCLz8fajRC7wmZ7DU
         rsdklNwN1J1GqRb/PAmQ/dqp42ravrSDKYRfy8b145fzDNOFjMFzq1kFiZnjo7xqN9fn
         Jz0KRWdykjc1YY6lrHhFY9J9VvKxdIcUIKihIImElhcWco9EODzGGIeieUieUmhPXkgX
         rdLSL1uLi8lCNEbNnElgBaV/BmBJKlg8iMYAJTKXFiGXg5DC1jLwD36gHhHy4GodjD9a
         9dRXiDvOg86GKf5nPK2NEnYEYM+z72ORSvlPE0v4bFbBuJqnGEBykAMJLiolwfZBJ0hg
         gyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h4A+UA0S3l+ls0zS2Gq9BFaj9JODH97JG2yHCpwCb+s=;
        b=ZOP64MNivhUsAmY3pUsymlvsOj0E3DyPkBK6iF0bGpFZOI/4+1pahYD3jAt4ZpHr/l
         mZl8sqkFohhwzFT6I4rpHz/o4HXXGWQ20g+NMgOuho/rBLZCpDQ8ZiFpck/iNYdvaesu
         e0E9BwC1B2x+BjNDYyZNIetEXG8/bvy7ipgDsw1GN6zaaFdkSVMgdlk5OndcDwVMIQjg
         sCSbDHZs/A/Xrs4Nl+gm/JY6XxAbG/tjZa+wqdjVDUC128it/CPY7TiFYF2x0Lx8VnXF
         4MsuGpuQ6Y0ARnQl26fgZfpR0Nx8mf3AHjabVtOiz/a7JCl5+sIuWpCgx32HD1JdEvG6
         C1ng==
X-Gm-Message-State: APjAAAV99GnSjhLoPoZtj76wtpofYXXhOY2dKY45IA7VxrxZCdBmI6Wk
        KwPh+or2hWHwxfU89OETK8reWY9AODc=
X-Google-Smtp-Source: APXvYqySksv89mq7ZXiuB7jRWQXMsodrA1Fn5AXVdxQeQ0hmfOmPumNTFWUfdW/n9qVFY/Xf8muSig==
X-Received: by 2002:a63:fc13:: with SMTP id j19mr11884281pgi.327.1574959805234;
        Thu, 28 Nov 2019 08:50:05 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:04 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 01/17] mailbox: stm32_ipcc: add spinlock to fix channels concurrent access
Date:   Thu, 28 Nov 2019 09:49:46 -0700
Message-Id: <20191128165002.6234-2-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Pouliquen <arnaud.pouliquen@st.com>

commit dba9a3dfe912dc47c9dbc9ba1f5f65adbf9aea0f upstream

Add spinlock protection on IPCC register update to avoid race condition.
Without this fix, stm32_ipcc_set_bits and stm32_ipcc_clr_bits can be
called in parallel for different channels. This results in register
corruptions.

Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/mailbox/stm32-ipcc.c | 37 ++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/mailbox/stm32-ipcc.c b/drivers/mailbox/stm32-ipcc.c
index ca1f993c0de3..e31322225e93 100644
--- a/drivers/mailbox/stm32-ipcc.c
+++ b/drivers/mailbox/stm32-ipcc.c
@@ -50,6 +50,7 @@ struct stm32_ipcc {
 	void __iomem *reg_base;
 	void __iomem *reg_proc;
 	struct clk *clk;
+	spinlock_t lock; /* protect access to IPCC registers */
 	int irqs[IPCC_IRQ_NUM];
 	int wkp;
 	u32 proc_id;
@@ -58,14 +59,24 @@ struct stm32_ipcc {
 	u32 xmr;
 };
 
-static inline void stm32_ipcc_set_bits(void __iomem *reg, u32 mask)
+static inline void stm32_ipcc_set_bits(spinlock_t *lock, void __iomem *reg,
+				       u32 mask)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(lock, flags);
 	writel_relaxed(readl_relaxed(reg) | mask, reg);
+	spin_unlock_irqrestore(lock, flags);
 }
 
-static inline void stm32_ipcc_clr_bits(void __iomem *reg, u32 mask)
+static inline void stm32_ipcc_clr_bits(spinlock_t *lock, void __iomem *reg,
+				       u32 mask)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(lock, flags);
 	writel_relaxed(readl_relaxed(reg) & ~mask, reg);
+	spin_unlock_irqrestore(lock, flags);
 }
 
 static irqreturn_t stm32_ipcc_rx_irq(int irq, void *data)
@@ -92,7 +103,7 @@ static irqreturn_t stm32_ipcc_rx_irq(int irq, void *data)
 
 		mbox_chan_received_data(&ipcc->controller.chans[chan], NULL);
 
-		stm32_ipcc_set_bits(ipcc->reg_proc + IPCC_XSCR,
+		stm32_ipcc_set_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XSCR,
 				    RX_BIT_CHAN(chan));
 
 		ret = IRQ_HANDLED;
@@ -121,7 +132,7 @@ static irqreturn_t stm32_ipcc_tx_irq(int irq, void *data)
 		dev_dbg(dev, "%s: chan:%d tx\n", __func__, chan);
 
 		/* mask 'tx channel free' interrupt */
-		stm32_ipcc_set_bits(ipcc->reg_proc + IPCC_XMR,
+		stm32_ipcc_set_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XMR,
 				    TX_BIT_CHAN(chan));
 
 		mbox_chan_txdone(&ipcc->controller.chans[chan], 0);
@@ -141,10 +152,12 @@ static int stm32_ipcc_send_data(struct mbox_chan *link, void *data)
 	dev_dbg(ipcc->controller.dev, "%s: chan:%d\n", __func__, chan);
 
 	/* set channel n occupied */
-	stm32_ipcc_set_bits(ipcc->reg_proc + IPCC_XSCR, TX_BIT_CHAN(chan));
+	stm32_ipcc_set_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XSCR,
+			    TX_BIT_CHAN(chan));
 
 	/* unmask 'tx channel free' interrupt */
-	stm32_ipcc_clr_bits(ipcc->reg_proc + IPCC_XMR, TX_BIT_CHAN(chan));
+	stm32_ipcc_clr_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XMR,
+			    TX_BIT_CHAN(chan));
 
 	return 0;
 }
@@ -163,7 +176,8 @@ static int stm32_ipcc_startup(struct mbox_chan *link)
 	}
 
 	/* unmask 'rx channel occupied' interrupt */
-	stm32_ipcc_clr_bits(ipcc->reg_proc + IPCC_XMR, RX_BIT_CHAN(chan));
+	stm32_ipcc_clr_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XMR,
+			    RX_BIT_CHAN(chan));
 
 	return 0;
 }
@@ -175,7 +189,7 @@ static void stm32_ipcc_shutdown(struct mbox_chan *link)
 					       controller);
 
 	/* mask rx/tx interrupt */
-	stm32_ipcc_set_bits(ipcc->reg_proc + IPCC_XMR,
+	stm32_ipcc_set_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XMR,
 			    RX_BIT_CHAN(chan) | TX_BIT_CHAN(chan));
 
 	clk_disable_unprepare(ipcc->clk);
@@ -208,6 +222,8 @@ static int stm32_ipcc_probe(struct platform_device *pdev)
 	if (!ipcc)
 		return -ENOMEM;
 
+	spin_lock_init(&ipcc->lock);
+
 	/* proc_id */
 	if (of_property_read_u32(np, "st,proc-id", &ipcc->proc_id)) {
 		dev_err(dev, "Missing st,proc-id\n");
@@ -259,9 +275,10 @@ static int stm32_ipcc_probe(struct platform_device *pdev)
 	}
 
 	/* mask and enable rx/tx irq */
-	stm32_ipcc_set_bits(ipcc->reg_proc + IPCC_XMR,
+	stm32_ipcc_set_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XMR,
 			    RX_BIT_MASK | TX_BIT_MASK);
-	stm32_ipcc_set_bits(ipcc->reg_proc + IPCC_XCR, XCR_RXOIE | XCR_TXOIE);
+	stm32_ipcc_set_bits(&ipcc->lock, ipcc->reg_proc + IPCC_XCR,
+			    XCR_RXOIE | XCR_TXOIE);
 
 	/* wakeup */
 	if (of_property_read_bool(np, "wakeup-source")) {
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7C910CD1C
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfK1QuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:50:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45955 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfK1QuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:16 -0500
Received: by mail-pf1-f196.google.com with SMTP id z4so13367112pfn.12
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dfqbr0RxajlO5BfpaJ+gj/cruGVf9oBCHGspuRMYLGM=;
        b=O9JevNY1LOgHwoZQBP3JRCrkxMNX7g335LWvtIGE8TSf0gdh7CvuTTvGfjm78nXgUM
         +p1zMhh+nbn6ISXwf21PH0Z60BkeYpF4a6JzV8KEkI2WqyswsIDCbpxjl7X+PRhKCzIs
         DXpIhvG/INtLpkzRZFie2gEw9yF+o67uC62GGi7F3QILehtJeR3fMeC9qJxpd4Rb5bQn
         9z5+WTrOoWg7fT07bhstV28T/EBnSeUD0loJ3jbO1F/0igGdeu3+T9Nt13ydF/Z+DFFs
         rkThpEXWnl23uu7cSgvOhyGVz2L72jGZfYqVGe0hqI/1KBTny0XVSPtvXsQb4D+rZIxg
         X5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dfqbr0RxajlO5BfpaJ+gj/cruGVf9oBCHGspuRMYLGM=;
        b=Irc2rV5FO6EeeSCHIP/PAyt05AM95e2qPngSUsZqs3Zhby1HAAB0tjMP8l+mQffKgs
         +ih3rSccx70HiSCGX0nht6zsLuuQW5xQXr4ls5TFHJfv058/29CQ4qfZUnJ92b/EyWeV
         FL75zjKsLge3wsikL/vuryI4h2M8l1wW+qO+dGOUYL1y+n1Dqrfq7zoMy7gFEz96LR1s
         AqpxDLkfdanrFuhkyUta5XNBCYYzL7qZBgUPhyJ6HIX8QHHlmpy5ZyRast9wEAGV0dQY
         z4xie9oPWkA91KJ7Mu7oCi6UkLuj6Wbr+7KDOlkcg7wt+FRecBnXLA5t95FtNZZGuXIL
         vMMg==
X-Gm-Message-State: APjAAAWSTySh98nyoiRC3G65sqIuGrmfsH3ymQu0K9RZZjalat/s58oI
        A9hGInKL7WAJbVAWAilrpuWmbGUm7Gc=
X-Google-Smtp-Source: APXvYqz1CZkfXWlCWREUSYNgSlKLOyyH6hBE4kK1EF/EFkOotdf16LQQAGFxMXT09S3PLDy00ju7iA==
X-Received: by 2002:a63:907:: with SMTP id 7mr11914734pgj.361.1574959814421;
        Thu, 28 Nov 2019 08:50:14 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:14 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 11/17] mailbox: mailbox-test: fix null pointer if no mmio
Date:   Thu, 28 Nov 2019 09:49:56 -0700
Message-Id: <20191128165002.6234-12-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@st.com>

commit 6899b4f7c99c72968e58e502f96084f74f6e5e86 upstream

Fix null pointer issue if resource_size is called with no ioresource.

Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/mailbox/mailbox-test.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 58bfafc34bc4..129b3656c453 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -363,22 +363,24 @@ static int mbox_test_probe(struct platform_device *pdev)
 
 	/* It's okay for MMIO to be NULL */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	size = resource_size(res);
 	tdev->tx_mmio = devm_ioremap_resource(&pdev->dev, res);
-	if (PTR_ERR(tdev->tx_mmio) == -EBUSY)
+	if (PTR_ERR(tdev->tx_mmio) == -EBUSY) {
 		/* if reserved area in SRAM, try just ioremap */
+		size = resource_size(res);
 		tdev->tx_mmio = devm_ioremap(&pdev->dev, res->start, size);
-	else if (IS_ERR(tdev->tx_mmio))
+	} else if (IS_ERR(tdev->tx_mmio)) {
 		tdev->tx_mmio = NULL;
+	}
 
 	/* If specified, second reg entry is Rx MMIO */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	size = resource_size(res);
 	tdev->rx_mmio = devm_ioremap_resource(&pdev->dev, res);
-	if (PTR_ERR(tdev->rx_mmio) == -EBUSY)
+	if (PTR_ERR(tdev->rx_mmio) == -EBUSY) {
+		size = resource_size(res);
 		tdev->rx_mmio = devm_ioremap(&pdev->dev, res->start, size);
-	else if (IS_ERR(tdev->rx_mmio))
+	} else if (IS_ERR(tdev->rx_mmio)) {
 		tdev->rx_mmio = tdev->tx_mmio;
+	}
 
 	tdev->tx_channel = mbox_test_request_channel(pdev, "tx");
 	tdev->rx_channel = mbox_test_request_channel(pdev, "rx");
-- 
2.17.1


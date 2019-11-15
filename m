Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E19FE7DD
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfKOWeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:11 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44130 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfKOWeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id f19so6611849pgk.11
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4OAg+K/MSQ8LDMB5QZGzBoNYfURH+sTBMSUExg9URq0=;
        b=WeIJk6lIxyCTX4RCndZxDj9cy9KCsTub6pTQq4mdaj3dFRpi65OWFqCZRA44CBtrxD
         wyRa0X0CmZhRMy5Zc5o6LHi1MH3tbcQL0cv6gNCqqSz1J3XAMtx2zhJ2JtE+s68O47NN
         zHR5m5wI7wETwcEBKNsfebJLtuRqn3mfOO7V8dd30qDbuXTHtB4c9BgZjgnwNq49NE0s
         sHN1LPoBsVxzNYQxP/EzcPTZ08HKWeXQ0I/7fV81CBePfnFtSebCvvcctt33pVFHmB1t
         3cJcol2P9GoSGYES+I95jsL41GuvG8R4/j9nrA8bdohfjWKd0oseIzbWJkGjljUdRMSA
         KFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4OAg+K/MSQ8LDMB5QZGzBoNYfURH+sTBMSUExg9URq0=;
        b=WDZLI/64w+aCs+DeuqwrpBLSCg//8t6NM1RF3t2EJdUtw8dUV0gD1DlptboflC4/LK
         dSHGKc4hC29iVTQcud3WJoBZpZSCMrsoj7fneV2ftIndgdXRsspkpd9uR3WsSMBWgkfY
         sDBp/+saoRYcoreWUPWp5e92o6nDXoOKxOHY4CcgwreB+1UOVXsDHUxgeZhgNBId0PQA
         88BJTiKIYcyrGSLtbiyLqE9LAFZtTbwa7gtFs5+4HAKRIqcrZE4MxpcBxPu2xFE38lht
         tZTMIDo1qgWkwomfSIP1QmsrKo6BmkDd+AfkxQXtRxzHoWFJdX4nRbDxqFfx4cSDzToW
         vYSQ==
X-Gm-Message-State: APjAAAXUe+bzUKPzqstQqfD09TGb2DfAn7TNxMKpKnriMnSsf2yrRkYL
        W0kLaQbwbvL+nW6dulybAvBUnRpRycM=
X-Google-Smtp-Source: APXvYqwvPO8gcw50QrAb2M5Uc8qjsXNsBlM/blU4way61lTUGihMhTmdns75zP4KkzdAtC6LmJhrrQ==
X-Received: by 2002:a62:1e42:: with SMTP id e63mr7219946pfe.25.1573857248667;
        Fri, 15 Nov 2019 14:34:08 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:08 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 13/20] mailbox: mailbox-test: fix null pointer if no mmio
Date:   Fri, 15 Nov 2019 15:33:49 -0700
Message-Id: <20191115223356.27675-13-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
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
Cc: stable <stable@vger.kernel.org> # 4.19+
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


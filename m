Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29C010E82B
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfLBKEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:04:05 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40991 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfLBKEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:04:05 -0500
Received: by mail-wr1-f68.google.com with SMTP id b18so43406601wrj.8
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=uGmSZAgZbIPTFW/8TzESt4bSkErTu3s+CBvxeawC76U=;
        b=qZQhHd96YfEe19rtRg6iNa++tihwY8CHECx4KbrjLJlEmqMJhBSn4SpuI9n8+WoaQx
         gDANsHELWRcQqS8tPF25suuZ6Ez+ih9SxwuGo+J21SGyfG01L01wm9fzdkYUyVjteXgU
         ANO5am48bCZMyy33fU+ye6z/DmcApTUzgqFmd2TrodfW3N5Xy8XnEZDOJro4Ox3vTADz
         2QMhGvCdaqiWXI8VZNWqmhhW5LPzjvF2usv13rPmmnPgj74uuXnAOQfDxVb0MIWk7Eep
         ZFSd/fed2Tud029RnxK8KSb/6lKY6pkwjS0FceK/4d3eN5tSos/hvNV74KAUVDxiJ+Cc
         xhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGmSZAgZbIPTFW/8TzESt4bSkErTu3s+CBvxeawC76U=;
        b=F45wc7VNPrGBHe/SJO6hCiAuNzuWbY6p1bqS5EdqjVAxMC+XY0jG1xe/q6c0cDDfmO
         sPxUb5VldMmNpX4bcDnjzr4Abj8IfxUviXdcHh050uI2/xCdmUVBsYKim2kBYTxJUXA2
         TEpcMLPx2vURNyYYFJ0Prt6WQFApCsGSqiRAf4Dt27BVE9ZaAzhSxkfB/pRbwP8GXGOb
         gWe9lEGhXhxs6ZsGwsWj0ahn8DRhaNo9KG7rPc+YzYXApxKUUCpOHqwYK9qeBTB0Hcqw
         Ttbi1UBGaX3fK6Wv4W030QGT+MOXEjaegHu2k9XskO10kz6LHgwGVvJte9nKVXTousll
         +VEQ==
X-Gm-Message-State: APjAAAVVAu1lSDRSZI4ZGYIHzmqeNRMTRGqFPC5b2mv8KtVsKiPEWM6S
        iQCxspJan5dJ2IdHglH1+9CcCBwOodI=
X-Google-Smtp-Source: APXvYqyyAq0dLZUfQmld1ZEYbb9BxVWUeZu67Zoy9qMbzoEz6YTBJ22KbeDZkBYFDgNPQnTfY2Xn1A==
X-Received: by 2002:adf:fd07:: with SMTP id e7mr16765754wrr.21.1575281042914;
        Mon, 02 Dec 2019 02:04:02 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:04:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 12/14] mtd: rawnand: atmel: fix possible object reference leak
Date:   Mon,  2 Dec 2019 10:03:10 +0000
Message-Id: <20191202100312.1397-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <yellowriver2010@hotmail.com>

[ Upstream commit a12085d13997ed15f745f33a0e01002541160179 ]

of_find_device_by_node() takes a reference to the struct device
when it finds a match via get_device, there is no need to call
get_device() twice.
We also should make sure to drop the reference to the device
taken by of_find_device_by_node() on driver unbind.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>
Suggested-by: Boris Brezillon <bbrezillon@kernel.org>
Reviewed-by: Boris Brezillon <bbrezillon@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: linux-mtd@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/atmel/pmecc.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/atmel/pmecc.c b/drivers/mtd/nand/atmel/pmecc.c
index 4124bf91bee6..8cd153974e8d 100644
--- a/drivers/mtd/nand/atmel/pmecc.c
+++ b/drivers/mtd/nand/atmel/pmecc.c
@@ -875,23 +875,32 @@ static struct atmel_pmecc *atmel_pmecc_get_by_node(struct device *userdev,
 {
 	struct platform_device *pdev;
 	struct atmel_pmecc *pmecc, **ptr;
+	int ret;
 
 	pdev = of_find_device_by_node(np);
-	if (!pdev || !platform_get_drvdata(pdev))
+	if (!pdev)
 		return ERR_PTR(-EPROBE_DEFER);
+	pmecc = platform_get_drvdata(pdev);
+	if (!pmecc) {
+		ret = -EPROBE_DEFER;
+		goto err_put_device;
+	}
 
 	ptr = devres_alloc(devm_atmel_pmecc_put, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
-
-	get_device(&pdev->dev);
-	pmecc = platform_get_drvdata(pdev);
+	if (!ptr) {
+		ret = -ENOMEM;
+		goto err_put_device;
+	}
 
 	*ptr = pmecc;
 
 	devres_add(userdev, ptr);
 
 	return pmecc;
+
+err_put_device:
+	put_device(&pdev->dev);
+	return ERR_PTR(ret);
 }
 
 static const int atmel_pmecc_strengths[] = { 2, 4, 8, 12, 24, 32 };
-- 
2.24.0


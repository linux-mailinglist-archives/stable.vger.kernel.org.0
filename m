Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1260410E8ED
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLBKbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41766 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbfLBKbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id b18so43525198wrj.8
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SLTAktNqJAQh6GulSxLAW//F9vtP2hMwMcX3jpbTse4=;
        b=UkZbcSi6Lcdqyraq6F9a5xkKfpr+sLTLgB7Nnfe70/RU73xqNCwJk1vIbls2U/g9Od
         Wtcf/U67Li7ibBpteEfopiR5ASjR0VT31jdwyRUBqrewZLDAvVufgwRHn8SWUBobnyIM
         46qNA/Mx8MzLFrvGoFKXvhvUBAI95u1FcAD/7FOHRrxkEySY/lsNJnXZ3lgeoq+TD6qP
         sJwwPDdhT7xldJN7p7+uL/zTlARWW9gPkhI1coaOSJkEP8gAa4ZrbppDWQe2ODIDvjeG
         SwXdIzfXzwyXMUB8eK7+e/a/QuqK0pw281kOm6/bj88B2FIJYuD5TORerXD6cNd6JckC
         h94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SLTAktNqJAQh6GulSxLAW//F9vtP2hMwMcX3jpbTse4=;
        b=mcfhwbtuWiVhjxpEiWE5l930hET/ogURQE+Wj/dzzw+8Icdbt6xop8al++XIlBCcIq
         dEgEJkjH0RChEEM1Xsrf3Y2P6f7IZP7ji/rm95pvcnStc4duH2yMc+kMt6JL2WQgVg4A
         2uag038XpZ76Re908mxxEu0oJavuwzN7FyuWpifjCQlXQmf3qZipYeITztkOjrLu5mix
         Mq/NJ7YXlAZEDC/vv9OI5flKDwd8oCwbCeod3ago/e8xsBOGfXqPyhjZ+LNIPuxO8pJm
         KLLU0LJcvhB0X7NJpkKnRTdTXCSzYoy2r45j6zKumWrf/j389ndfQV9zPFEzpFeIoCz4
         s79A==
X-Gm-Message-State: APjAAAVKvTclF+ws+dEKiZ1uOOMQ6St+pXuQiVZYYJbBw3ZAdRe67MHQ
        +w1suugjhnmEsoTtFlDgRDCdBB5GYNY=
X-Google-Smtp-Source: APXvYqzCCOIYqFv7ECd5Ehktbv51Doiy6J60G5NlgFW3RE+OK521Lk+OgEb6vsHMmDlJyg88MwaRaA==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr17191227wru.297.1575282681360;
        Mon, 02 Dec 2019 02:31:21 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:20 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 13/15] mtd: rawnand: atmel: fix possible object reference leak
Date:   Mon,  2 Dec 2019 10:30:48 +0000
Message-Id: <20191202103050.2668-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
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
 drivers/mtd/nand/raw/atmel/pmecc.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/pmecc.c b/drivers/mtd/nand/raw/atmel/pmecc.c
index 555a74e15269..9d3997840889 100644
--- a/drivers/mtd/nand/raw/atmel/pmecc.c
+++ b/drivers/mtd/nand/raw/atmel/pmecc.c
@@ -876,23 +876,32 @@ static struct atmel_pmecc *atmel_pmecc_get_by_node(struct device *userdev,
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F3410E8E6
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfLBKbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52481 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfLBKbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so6157311wmc.2
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eFBFGv//5UKtfgO4bFKkyNYQ6cGLJVbXdL6jceejJm8=;
        b=lW8yAxXH4zi4M/hvk9KeDdBoZMCYUOMLZIdhW7BvUuXAttcVTc/RPkPZIZe76elInO
         gbcnrMAO5EgV0B+TkTcUnHeTGbonQ1auQYWunEKlX/dqnEmG+kXKzpiWQ4eNchncjTKU
         scvpe4avMcGDklJzTNcAsnEXL3hpkHrOAzmiD43rwfzLcpopCjwWpjMCXvKn/p9aR0Xr
         7EkiBie9VrunVBM382X5iIQrnXseCDkKTu5BffhCI0o4xib5XHQn4+PPSo63D4iq1yBV
         oJSRL9YRruSv6CJV4/XDodnufkAxmt1QCALMKuMGI4wPS7dl/5chm5tYQaQm/JAGjSHT
         irEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eFBFGv//5UKtfgO4bFKkyNYQ6cGLJVbXdL6jceejJm8=;
        b=UrzSieaQypd/i5+XJn8yt5urLjzhQfJCDBiuft0sUDuRfBnczTT3Emda5nhl5mqrn5
         YUKeIhRXY5cttas2VdKA6dfhgi5eAh3QiNVDiu1tLmgv0CZiEf3YtoeZsGh8a8es72pf
         VOOhODY5s+tGlQFUxgUrQHrn9QzLNMw0zGhX+Ay1jXbu9I/bMktjxglqlaIHOt0QePAK
         oWMina0p3+Ut4qqJp3HLUTVU5UkT52yATPcq85O9yOVbGHqH/I5KF2qjFRwfMgbyiMKK
         DgcWf0LiW6RzamFV9gqGGewAei1Lx2VCBz6rpasY1++wjuO9xFvqODo1B18i1P43xUzg
         RZYg==
X-Gm-Message-State: APjAAAVkQUgIPagJJQqAnBpX+u0O4x2xpa5cGt2pGmRaoQbCMEV5K3MK
        whHgjg7HkhuJF30SsUQLdzzETSFOcZ4=
X-Google-Smtp-Source: APXvYqybMAbjwvb8zKvuBNdxnkWXcBoICugjBEsWeXDn65ptW0IpC/QgJkD+BTN963LsgQgPYgSb8Q==
X-Received: by 2002:a1c:5451:: with SMTP id p17mr17281456wmi.57.1575282673781;
        Mon, 02 Dec 2019 02:31:13 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:13 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 08/15] media: atmel: atmel-isc: fix asd memory allocation
Date:   Mon,  2 Dec 2019 10:30:43 +0000
Message-Id: <20191202103050.2668-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 1e4e25c4959c10728fbfcc6a286f9503d32dfe02 ]

The subsystem will free the asd memory on notifier cleanup, if the asd is
added to the notifier.
However the memory is freed using kfree.
Thus, we cannot allocate the asd using devm_*
This can lead to crashes and problems.
To test this issue, just return an error at probe, but cleanup the
notifier beforehand.

Fixes: 106267444f ("[media] atmel-isc: add the Image Sensor Controller code")

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/platform/atmel/atmel-isc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d89e14524d42..f2b09ea107b1 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -2062,8 +2062,11 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 			break;
 		}
 
-		subdev_entity->asd = devm_kzalloc(dev,
-				     sizeof(*subdev_entity->asd), GFP_KERNEL);
+		/* asd will be freed by the subsystem once it's added to the
+		 * notifier list
+		 */
+		subdev_entity->asd = kzalloc(sizeof(*subdev_entity->asd),
+					     GFP_KERNEL);
 		if (!subdev_entity->asd) {
 			of_node_put(rem);
 			ret = -ENOMEM;
@@ -2209,6 +2212,7 @@ static int atmel_isc_probe(struct platform_device *pdev)
 						   &subdev_entity->notifier);
 		if (ret) {
 			dev_err(dev, "fail to register async notifier\n");
+			kfree(subdev_entity->asd);
 			goto cleanup_subdev;
 		}
 
-- 
2.24.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCD19C99F
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbgDBTNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54070 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388892AbgDBTNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id d77so4637744wmd.3
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=egX0tfu7NRZXkI34xEHvcmq3oOPGI9lnyNWYVxggksI=;
        b=QyA6kDP3OuolBTM4wZKQ5XR/SXjBor1lsQYRPLNbseQuwHzEyQ3D+TY/y38laQSqCP
         PmVkmcnKw23Mt1CbqDkyOtJhpDt55uaS7TWWpNsqz9BPUzo5MVxy/Xvwcl5v4Cft+74b
         FhwLTivmMKs76QJ96UdxKYVx9R2lx1H3XsnNeeNMc0nEQvqJcPQ7qR2pnbHJn9JoEDU9
         UOu57XI3O1cZ0QPvq7ZjAWkt2vONq4Eq44hMQX8xQ0IzYNJ5TX97Gj++l0HS2Jp6p16m
         WzbQdp3F9LMhzUzsDjvi7nqy+klWyk9vnxQDfFlSGb+ZRGMwwFM/QVQVFYzWPT189HNG
         p8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egX0tfu7NRZXkI34xEHvcmq3oOPGI9lnyNWYVxggksI=;
        b=IZ6gA67PnvUgonZyySUbJfEscMro2u3OGNQMQk8uK8ChYFHxIqPx/FKIIMyq2lOnG2
         pMQogF+9zZ22ldK89nKlwrDl/9Eub+jlWgZziMYVc7+ZvydWEb2/PE6hwPm2H/+zbPSL
         7+LSEij+SGv5SpGY/VYLoYBZ6Mnd34qsTfzV9gnXBRVmSeuizPSKfP6tUsePOEcHq7YN
         ExHbe4hSMG4pQ7B4tTOISln0U+28XzET2QMgzpXImeTmaHHsp5rv1i0p2pc9zHoGY75t
         xGp8hZIIJ6qBm8K0lO1NuMFilq2hQLYi6bYum2rTCVd/wOLySrwqNLcGlLIHGSxD859f
         ONLg==
X-Gm-Message-State: AGi0PubVTjFZeZcEpy6M7XNRkPcoj1eY1uBtu+oZtUx7epFlCebaX09N
        2dBt56gMKyRK6XGsfVSkcZO4PrEw3XEHJg==
X-Google-Smtp-Source: APiQypKN8C1IpyZIJ10CSGDIEt6oRFvBdloAarbpayhkr+I4JVffX/xFfNXbJ0/4X1IXTzrvYjV5Xw==
X-Received: by 2002:a1c:1d93:: with SMTP id d141mr5036381wmd.134.1585854801064;
        Thu, 02 Apr 2020 12:13:21 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 22/33] rpmsg: glink: Fix missing mutex_init() in qcom_glink_alloc_channel()
Date:   Thu,  2 Apr 2020 20:13:42 +0100
Message-Id: <20200402191353.787836-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit fb416f69900773d5a6030c909114099f92d07ab9 ]

qcom_glink_alloc_channel() allocates the mutex but not initialize it.
Use mutex_init() on it to initialize it correctly.

This is detected by Coccinelle semantic patch.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rpmsg/qcom_glink_native.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 114481c9fba12..7802663efe332 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -221,6 +221,7 @@ static struct glink_channel *qcom_glink_alloc_channel(struct qcom_glink *glink,
 	/* Setup glink internal glink_channel data */
 	spin_lock_init(&channel->recv_lock);
 	spin_lock_init(&channel->intent_lock);
+	mutex_init(&channel->intent_req_lock);
 
 	channel->glink = glink;
 	channel->name = kstrdup(name, GFP_KERNEL);
-- 
2.25.1


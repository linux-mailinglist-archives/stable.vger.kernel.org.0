Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2A2339F7F
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 18:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhCMRaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 12:30:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43864 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbhCMRaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 12:30:00 -0500
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lL85P-00028A-7c
        for stable@vger.kernel.org; Sat, 13 Mar 2021 17:29:59 +0000
Received: by mail-wm1-f71.google.com with SMTP id c7so6677433wml.8
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 09:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zbNJZwfk33XcctxVNMosq8ay2IhFDGVQF+hwhksKIMI=;
        b=BsAWOnni7DZJq5l5yu/Jn2iHJ8TsBtvddh9FwRI+jRl7AciZEnu2dVNdh5j1uaZUO/
         xwzb6BqVvW2QJ4iHSxfwSMz6FT64AcGp3hDscVs2kdLaf/OCLx/zeOelHf193tL2uVjv
         XLAlc9CE2uYkpsvu98wlAzGqZnk3bWM9BqR8ZWVIWxbCrnNzkMKqbIAOFBC81KAo/buf
         CC+J3qDRPTGfBPJGngxzpesHYtD1wQ+j8uqDz+zMt4X33D6F1b9LSMIlZk3+NodR0H+1
         DbuXxu7G4cAFzitA7EuYvd92m1b5Ws9uWw89Mh48PYi6DhulsHOXI7xG6hHvyTSHc2VT
         FreA==
X-Gm-Message-State: AOAM531und16peFdU6IJdo6x4csvK8eCpHSb8k9voKtYhd5WHtBJMZDz
        dXKOKm/HuvKNzj2zsoyJkPn6W+2oBBIfMjTxo8kPUCpIb4Icph7HLEkI5qaciWdSFX7G6iRa9u3
        nb8S/B1KrCm32M20eHdHv2tkAXcnVOz6+Gg==
X-Received: by 2002:a1c:7e82:: with SMTP id z124mr7055250wmc.51.1615656598582;
        Sat, 13 Mar 2021 09:29:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSKAsKeGZuU84FFNAwruzH91oMnrxOeuPnbpeIvXqEGbGaKpoq69YxH+zm0CJMf3NbuApkiA==
X-Received: by 2002:a1c:7e82:: with SMTP id z124mr7055242wmc.51.1615656598420;
        Sat, 13 Mar 2021 09:29:58 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id k12sm13725493wrx.7.2021.03.13.09.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 09:29:57 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v2 stable v4.4+ 1/2] iio: imu: adis16400: release allocated memory on failure
Date:   Sat, 13 Mar 2021 18:29:49 +0100
Message-Id: <20210313172950.6224-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit ab612b1daf415b62c58e130cb3d0f30b255a14d0 upstream.

In adis_update_scan_mode, if allocation for adis->buffer fails,
previously allocated adis->xfer needs to be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Changes since v1:
1. Add also this one for backport: v4.4 - v4.14. Newer should take
direct cherry pick
---
 drivers/iio/imu/adis_buffer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis_buffer.c b/drivers/iio/imu/adis_buffer.c
index 36607d52fee0..9de553e8c214 100644
--- a/drivers/iio/imu/adis_buffer.c
+++ b/drivers/iio/imu/adis_buffer.c
@@ -39,8 +39,11 @@ int adis_update_scan_mode(struct iio_dev *indio_dev,
 		return -ENOMEM;
 
 	adis->buffer = kzalloc(indio_dev->scan_bytes * 2, GFP_KERNEL);
-	if (!adis->buffer)
+	if (!adis->buffer) {
+		kfree(adis->xfer);
+		adis->xfer = NULL;
 		return -ENOMEM;
+	}
 
 	rx = adis->buffer;
 	tx = rx + scan_count;
-- 
2.25.1


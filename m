Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34585339F82
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhCMRaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 12:30:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43867 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhCMRaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 12:30:00 -0500
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lL85P-00028N-Vb
        for stable@vger.kernel.org; Sat, 13 Mar 2021 17:30:00 +0000
Received: by mail-wr1-f71.google.com with SMTP id s10so12746998wre.0
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 09:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s2YUIjGBOIYV+Vfc4AGyj8fEm10QEMZxYaROv4tplEE=;
        b=rheAaqu2tQGD2EK/RI7ZjrQEzXctatrDMaG08U+KZ9xdWGsNDgReNqUx0zv7IWamoB
         n5T52/Ziv5wsjG1Wjz/ilqBf0kvaqHnCfajWdxAD0s1xCGbA7Hc6a8CZ1Jrdn/st5iWs
         iSQPcox+EcwtkWnufckicNe0hvFGMY/Pu4ls1Sxb98WU39CxG0PPIywM00V0g9qbEkjQ
         6dR3e0wMpgru4NwJ4oh0LaEOM8zV6V7DoxcNML+TRYH8R+cqLqp6YMkrh4G4hwG/0Q6v
         /tZ07kaNazckJ80N0sKMJ5C5JhUIPEZi27w6LBEWtsLgISBVNZ+9rnSDgei1yOjhwTjE
         /WbA==
X-Gm-Message-State: AOAM530gBUbeQXQfnYznfucEV/bZ6Pj2Tl9N/6R+MFla6G5gHl0JOTld
        DM7nQoWLvoQhf2FcRuzDNzqqEdE8fhD1kWpWjSk2+nNC8LSpIhLsd5S681+ZZuzBtohvJCawfjJ
        rju8xVa3Ghvn03E2vlUbEDHFjyn9JjgvBFQ==
X-Received: by 2002:a1c:400b:: with SMTP id n11mr18411729wma.167.1615656599513;
        Sat, 13 Mar 2021 09:29:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0fAoocnvMk5fURSnIYfet0D7ms9ineGlUeaTIzRu5exBSqbYEvL8JgCyUgJY5/YgwNzX2Ww==
X-Received: by 2002:a1c:400b:: with SMTP id n11mr18411720wma.167.1615656599401;
        Sat, 13 Mar 2021 09:29:59 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id k12sm13725493wrx.7.2021.03.13.09.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 09:29:58 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v2 stable v4.4+ 2/2] iio: imu: adis16400: fix memory leak
Date:   Sat, 13 Mar 2021 18:29:50 +0100
Message-Id: <20210313172950.6224-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210313172950.6224-1-krzysztof.kozlowski@canonical.com>
References: <20210313172950.6224-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 9c0530e898f384c5d279bfcebd8bb17af1105873 upstream.

In adis_update_scan_mode_burst, if adis->buffer allocation fails release
the adis->xfer.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[krzk: backport applied to adis16400_buffer.c instead of adis_buffer.c]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Changes since v1:
1. Remove "cherry-picked" in log

This should apply from v4.4 to v4.19. Newer I think should take direct
cherry-pick.
---
 drivers/iio/imu/adis16400_buffer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400_buffer.c b/drivers/iio/imu/adis16400_buffer.c
index 90c24a23c679..c0eb9dfd1c45 100644
--- a/drivers/iio/imu/adis16400_buffer.c
+++ b/drivers/iio/imu/adis16400_buffer.c
@@ -37,8 +37,11 @@ int adis16400_update_scan_mode(struct iio_dev *indio_dev,
 		return -ENOMEM;
 
 	adis->buffer = kzalloc(burst_length + sizeof(u16), GFP_KERNEL);
-	if (!adis->buffer)
+	if (!adis->buffer) {
+		kfree(adis->xfer);
+		adis->xfer = NULL;
 		return -ENOMEM;
+	}
 
 	tx = adis->buffer + burst_length;
 	tx[0] = ADIS_READ_REG(ADIS16400_GLOB_CMD);
-- 
2.25.1


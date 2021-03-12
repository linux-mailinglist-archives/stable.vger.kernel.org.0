Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D6339437
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 18:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhCLRDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 12:03:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47487 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhCLRDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 12:03:19 -0500
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKlC2-0007hS-Pc
        for stable@vger.kernel.org; Fri, 12 Mar 2021 17:03:18 +0000
Received: by mail-wr1-f70.google.com with SMTP id m9so11442433wrx.6
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 09:03:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q9Si3P9xn1fyl7+Pl1eKHeH3/uCSKLYl0ZR8qsuF1A0=;
        b=dOFCDJaeMgejlOXE/LU596/uCGx96+nAcmMxrGoEwFDHzhF1+bdnXuGTrUOPHvYvvi
         XZdljHFrQ7qjNWRr+guSX4t6j15OM+C47WzZ/Vv6FxRmjsf8crRoGiaONmyOx+GeetDO
         uVtBB4qBLElFX1DsTpadDu8cd05rdWhr6eZSUchmCbXGTminCFxc5HjCDS4AAjNvp5WN
         I79YJfOnOxai3Nk0XuW4b0cuiu8jWpyBBBCJbaLZaOoIMtLhAQbhiwu4N9mKNH2Qxtyg
         EYabwr/CwX+tDX1qXxvTa3bEfsLFv6gNW8scbhpRyV/u/4zHp/YJ5vd1N0Npq+moXxak
         lJnQ==
X-Gm-Message-State: AOAM531v2y0nf+InK7gGahRVz2dXaboo80jw/ChExivHZ3rxkNqbHX/L
        mwoi+BI2iKikQpA/GblA0JioM2Czv+fWzCYTP9wxJxSreP/sT2m0uv0r4vs5oyk+HvU/tulgfk8
        MYUgYRyceX5pNo7fxdYrYv2nShRun0nKheQ==
X-Received: by 2002:adf:e70a:: with SMTP id c10mr14767170wrm.85.1615568598243;
        Fri, 12 Mar 2021 09:03:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLEqxDF5QPw2Y48bItkMG+3mYbKHOjVdG5uwMClJmH/vSwQUtbMUIGgIYsVNDDIN1rSPlPJw==
X-Received: by 2002:adf:e70a:: with SMTP id c10mr14767153wrm.85.1615568598124;
        Fri, 12 Mar 2021 09:03:18 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id w11sm9401803wrv.88.2021.03.12.09.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:03:17 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v4.4] iio: imu: adis16400: fix memory leak
Date:   Fri, 12 Mar 2021 18:03:11 +0100
Message-Id: <20210312170311.17464-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
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
(cherry picked from commit 9c0530e898f384c5d279bfcebd8bb17af1105873)
[krzk: backport applied to adis16400_buffer.c instead of adis_buffer.c]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
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


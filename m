Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E219354791
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240872AbhDEU3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbhDEU3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:29:11 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51739C06178C
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:29:02 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so6456281pjv.1
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ONE9SgRu2tAB0bKzuvFoPjlBosnX6JZfWs8NKXHvA4Q=;
        b=FfymRgM824j1zYBR0q6aKkMArv3x6ubHtrtPSsl9WewyXQ0FoXuCeszFRgOa6u/QEq
         7r8mLzV8QfCds35XqsmCS9JmsEIrmRLqDQ8kvBmxFIYJ09h8ud1aiYtiIhwgDQRwFWyb
         guEXtqoWZNOrBMa49L6RkNZJKz1UAeHzTfQuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ONE9SgRu2tAB0bKzuvFoPjlBosnX6JZfWs8NKXHvA4Q=;
        b=rfj/EOy2oWM4NKyngUsA6stDeZ1opWqlOW53JIfei6g04D/9Y5qJN0R2cVTpHSs6Qq
         Fz4i1pAMG727NUqBU4ebiQ3xRE7ms1v9XWjIx2bk5KkOXYT5NZwbbk9LPVgBx49BBL+2
         0qsRj+XX6IW5/E01hvM7/k3XTnFUtI6T+9WuhXOiAtdKLZjpCsCxDfV0yoXsXVyQw+zm
         6Hp20LzHsIhAYEZfpD7FtB4wpZWPGTksCOfK3FArfyGVwyGDPXp8LlAs70/ZSSdA7+fB
         AmA/N/nO8YzB3R40O9Kt7F0I1aSWt4fEa+WqrXabPg4QpH5s5ZW6rmDkq6Cj2xJSNKEK
         Npsw==
X-Gm-Message-State: AOAM530XFszhcfE0xr3iaeHhROTtJ8MsLocLkVPwHF1wx7vfumO0sMq+
        K27I1g6IG2+L7zy6n6H9P6GfZQ==
X-Google-Smtp-Source: ABdhPJyGGY8DkT+f5kXmdRJ7zwVBTbVaoWRky8rP+wx7GbePeebTDoSqQ6aIjbnQlLUSfxp54eSLPQ==
X-Received: by 2002:a17:902:e54c:b029:e5:e7cf:d746 with SMTP id n12-20020a170902e54cb02900e5e7cfd746mr25759673plf.56.1617654541797;
        Mon, 05 Apr 2021 13:29:01 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:2926:73d2:2f29:3222])
        by smtp.gmail.com with UTF8SMTPSA id w15sm16035054pfn.84.2021.04.05.13.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 13:29:01 -0700 (PDT)
From:   Gwendal Grignou <gwendal@chromium.org>
X-Google-Original-From: Gwendal Grignou <gwendal@google.com>
To:     bleung@chromium.org, enric.balletbo@collabora.com,
        groeck@chromium.org
Cc:     linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@google.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] platform/chrome: Use dev_groups to set device sysfs attributes
Date:   Mon,  5 Apr 2021 13:28:56 -0700
Message-Id: <20210405202857.1265308-2-gwendal@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
In-Reply-To: <20210405202857.1265308-1-gwendal@google.com>
References: <20210405202857.1265308-1-gwendal@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of manually call sysfs_create_group()/sysfs_remove_group(), set
.dev_groups driver data structure, and let the bus base code create
sysfs attributes.

Fixes: 6fd7f2bbd442 ("mfd / platform: cros_ec: Move device sysfs attributes to its own driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 New in v2.

 drivers/platform/chrome/cros_ec_sysfs.c | 28 +++++--------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_sysfs.c b/drivers/platform/chrome/cros_ec_sysfs.c
index f07eabcf9494c..114b9dbe981e7 100644
--- a/drivers/platform/chrome/cros_ec_sysfs.c
+++ b/drivers/platform/chrome/cros_ec_sysfs.c
@@ -335,34 +335,16 @@ static const struct attribute_group cros_ec_attr_group = {
 	.is_visible = cros_ec_ctrl_visible,
 };
 
-static int cros_ec_sysfs_probe(struct platform_device *pd)
-{
-	struct cros_ec_dev *ec_dev = dev_get_drvdata(pd->dev.parent);
-	struct device *dev = &pd->dev;
-	int ret;
-
-	ret = sysfs_create_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
-	if (ret < 0)
-		dev_err(dev, "failed to create attributes. err=%d\n", ret);
-
-	return ret;
-}
-
-static int cros_ec_sysfs_remove(struct platform_device *pd)
-{
-	struct cros_ec_dev *ec_dev = dev_get_drvdata(pd->dev.parent);
-
-	sysfs_remove_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
-
-	return 0;
-}
+static const struct attribute_group *cros_ec_attr_groups[] = {
+	&cros_ec_attr_group,
+	NULL,
+};
 
 static struct platform_driver cros_ec_sysfs_driver = {
 	.driver = {
 		.name = DRV_NAME,
+		.dev_groups = cros_ec_attr_groups,
 	},
-	.probe = cros_ec_sysfs_probe,
-	.remove = cros_ec_sysfs_remove,
 };
 
 module_platform_driver(cros_ec_sysfs_driver);
-- 
2.31.0.208.g409f899ff0-goog


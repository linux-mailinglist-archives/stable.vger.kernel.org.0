Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2F13AC9FA
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 13:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhFRLi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 07:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhFRLi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 07:38:26 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC904C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 04:36:16 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z8so10387138wrp.12
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 04:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lud/fYFD+N/SWgHkdFFeYBIaF2nobhuT1e/M1H5atWU=;
        b=IfePwxiJUb69H2NzVNd2Ays4KLKF1AZQk3rHb1BkYzAIjK4udY25MQFjF0lUFH+LYd
         v13BjDDrUyuKiFTN6CiCxcjSVW5gjDvBLkpYnn0ug/vEHXNZJb8Hu8qrTDJ77T8GhN8o
         Sap+69mBmZX6w1pco3jqWQnfPOflCHNT8zK8oQQl+2B8IPYvDuLFgYvRLbni8VOaLX15
         MnsbtbRdg1TW+fFvMO6zAhuaVVqBaP8ZI/Ck+d7gJKXYHg48lP+EaVZg2+K9TjXbI45E
         AUIhjCAc75Ra/NHv9m1ENy+n0132yJ3jUPgkCsJ5Wqqw2S8HwW3XKgEqI0ObNKMzngR1
         T2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lud/fYFD+N/SWgHkdFFeYBIaF2nobhuT1e/M1H5atWU=;
        b=jaTyqeCyxpYHUBg7WGs87u/GyE6udeRxUJiqt2l+rq7IkCsZaQn7cjwIT8lhmUiZ3s
         BUOKS2KcwNFLphvoJA01NISk5C79qdnEzsE1FhSzvoE8/NrZxNgqhAhJ/i/DXxreWIgI
         PJ6PxewYRVRkUbKw1ilf7GtZ3mS7elRweaAw1+v/IVOMejiizZb9jjNlD5uPXsDCvYah
         b3FYMboyBHxeYzXKn+uapBi0UjGLsjfQSnnazIYBXkWeCl9gWZJErvY7MxcUZVM996gR
         yj9gOqaeyQ8+88REBxahuZ+mLgw0BJ56BkY7NdOZdnPvEzEpXiNHvqJbQyaKrhGg6oTG
         7LXw==
X-Gm-Message-State: AOAM533HSidOzUQUloithiIjElr8vaNKCfM0HuBynS68G6o3Lc4xRmN5
        s3w5lEHIIAGPxZAPcYwhD/ZVAw==
X-Google-Smtp-Source: ABdhPJxrphdmhkj6dMmS0Wi+Afel5vE8/r90luzHUGKbH8ekTPgGS0LXzmdbSnWomZKlZUUHVXxbaw==
X-Received: by 2002:adf:d1e4:: with SMTP id g4mr11903148wrd.405.1624016175378;
        Fri, 18 Jun 2021 04:36:15 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id a1sm10977602wra.63.2021.06.18.04.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 04:36:14 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     broonie@kernel.org
Cc:     srivasam@codeaurora.org, rafael@kernel.org,
        dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] regmap: move readable check before accessing regcache.
Date:   Fri, 18 Jun 2021 12:35:58 +0100
Message-Id: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The issue that I encountered is when doing regmap_update_bits on
a write only register. In regcache path this will not do the right
thing as the register is not readable and driver which is using
regmap_update_bits will never notice that it can not do a update
bits on write only register leading to inconsistent writes and
random hardware behavior.

There seems to be missing checks in regcache_read() which is
now added by moving the orignal check in _regmap_read() before
accessing regcache.

Cc: stable@vger.kernel.org
Fixes: 5d1729e7f02f ("regmap: Incorporate the regcache core into regmap")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/base/regmap/regmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 297e95be25b3..3ed37a09a8e9 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2677,6 +2677,9 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	int ret;
 	void *context = _regmap_map_get_context(map);
 
+	if (!regmap_readable(map, reg))
+		return -EIO;
+
 	if (!map->cache_bypass) {
 		ret = regcache_read(map, reg, val);
 		if (ret == 0)
@@ -2686,9 +2689,6 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	if (map->cache_only)
 		return -EBUSY;
 
-	if (!regmap_readable(map, reg))
-		return -EIO;
-
 	ret = map->reg_read(context, reg, val);
 	if (ret == 0) {
 		if (regmap_should_log(map))
-- 
2.21.0


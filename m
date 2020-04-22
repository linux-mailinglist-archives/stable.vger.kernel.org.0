Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205C41B4318
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgDVLUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726732AbgDVLUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D66AC03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:30 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so1901016wmh.3
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+fghok1gB+76TrHDpTqaBXzeyc4G/qE0r24JbvN7snI=;
        b=tDv6eQ0fHI/FQGeqqz0RpVlVnXWDecIRaiirD6+U51tERPNBcqy8Xn/KgTff1LVI2+
         JG1Rn1RwW6Q18Ncq1NEPWczTGjK17ui9dM8wbJ0eaww7oiFWy6JlNiu8pNWWVPQNO+4F
         cwoBLj7/2y3SAL0Hrl3Yti9bwW58Pu7xTTIgFvZGgsubUR4+CXy1ZpxnHQF4Yqw9CO1c
         4E/NXlcXwRQ+CjiaqClRJE9mCr9REppMQpdCjptVgP8x2nHDN/wiUn+B+cVWdkYa4d1x
         lDBKnmYBdYMHNl5MOf+9fAVpJYIJ0V4pZTAnTK52o/NTt/bkk+79hZTDcNOgt1K7IF8t
         HD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+fghok1gB+76TrHDpTqaBXzeyc4G/qE0r24JbvN7snI=;
        b=H4RFb76UZImwEnChIaHUH2FGDHQ4PHuMhY8auCbPm3egdmSrl0Q9EWgqSeDCDTwve0
         7JIpnlwMsyxrik4ZEGp+OXuUKZUtSmJ1bjX1+w6jJjfy759IqkXLoXSCMn06YeWnVA6t
         s4/ZLmKVEUUwgO7YGXVV9XIL5M/WefQnsHUzE35/wsFCXM32x3Ke55jYpJnE873ct4Hh
         dkaqISkIdRwnXtoZglQiVuElggN3agUcoQP97V2+h6G43A8cPB2IxLVbqITIp2eXb805
         vZbiNIxRydvNsRzJHsw323cOrAgpXt/Ouz/ZgkiWiukR7nbvoXtRd/rWB0kInlhuS/tV
         GFUA==
X-Gm-Message-State: AGi0PuajhvK4g73PWnHISbljKZ40csqXUkQRvjvBbN0dMyLWKcSeWKiO
        D2rLdiP1zguVK/sA6XHMKlUveFeylfM=
X-Google-Smtp-Source: APiQypLBvTruPICr9W7IPRofF+TB73mh91zn1Kf8vBZKhctoqxtEdLntsOwvmWG3gBKHon92KlZ2NQ==
X-Received: by 2002:a1c:9816:: with SMTP id a22mr9687239wme.125.1587554428973;
        Wed, 22 Apr 2020 04:20:28 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:28 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Nicolas Pitre <nico@linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 19/21] of: fix missing kobject init for !SYSFS && OF_DYNAMIC config
Date:   Wed, 22 Apr 2020 12:19:55 +0100
Message-Id: <20200422111957.569589-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit bd82bbf38cbe27f2c65660da801900d71bcc5cc8 ]

The ref counting is broken for OF_DYNAMIC when sysfs is disabled because
the kobject initialization is skipped. Only the properties
add/remove/update should be skipped for !SYSFS config.

Tested-by: Nicolas Pitre <nico@linaro.org>
Reviewed-by: Frank Rowand <frowand.list@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index c66cdc4307fd7..af80e3d34eda7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -170,9 +170,6 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!IS_ENABLED(CONFIG_SYSFS))
-		return 0;
-
 	if (!of_kset)
 		return 0;
 
-- 
2.25.1


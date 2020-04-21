Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7871B2674
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgDUMlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728952AbgDUMlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:16 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B8AC061A41
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:16 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y24so3497114wma.4
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2MkvQNPZKVczY76MLBPwTTDhOiywokrQfHFs6PMyPNM=;
        b=PhXWnPpFuOUegCXMQ5cwj0q/7w+f4VNdKY7aMhZhjx/6osmt4CDaP043oTtflofMpO
         iY1g8nEFZClSNEr3ZZF0G4RywUZOOIfYixMSU7seo7s4iy1jduciJnxE0sI5AGWhQGPC
         d87rclswvREq2MIOU6e6K9YI1MuH9/sGxoDwsqbuV+Hlwae0xcINphcqdXSFOpSgqluT
         90zoMEthkv1QWgoIVmzmEfjYuJ5q0c0VbMds5LkCeTnK0QrEaLh8nMg/ispYzadqWj2m
         1YVVBiKoiDJXmfy068VOXJ3VVSTFrtj3skqrcvA70ozKVoGlopZpV0TZxP02YMzIpC4j
         pE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2MkvQNPZKVczY76MLBPwTTDhOiywokrQfHFs6PMyPNM=;
        b=UcjQcP+ApuofW+gBTNxHGrtZamrPTK06+0Gjv/N6PmUB3G5IdEZPhjhNnREtohQ0Rj
         hRmAdHtw8CCZ7vONi/kljpSL6gELdWhRiRbZ8iMCHhW2BYb/g5bHGvwyu4+rCEwcfNvN
         UbfhPDY20i9TvyukfIu/RNZ/Qjn6EUV3QKiEWrO7OJmokrFkMd9Um9s48+POZe3iicLZ
         3hu43Mw+t/ChXo0Bq3IDosWX7THuKL96xtD4KE8VDIp1l39vpWEGgr4ptdTN6h21w0dK
         cBciPiBQsLG5O84ITVZ/DPtRYH+R72OdPpjyoWxu8PYL/eCm+3Owlgm/2Tl3ZadSqaaA
         58HQ==
X-Gm-Message-State: AGi0Pub8QMxWoP1phi7US68W8tqQiIS+9RfkzpvUVHUB1at7ktDoeMZR
        hZTLPGDJ3yItPplHA/xx6oaw/OyBHY4=
X-Google-Smtp-Source: APiQypIKWjq1M0aHXWByTxZ6sZ25t97hjDc2G73vcCJtEYyU81LY3xNZCv1MaRJNsyd7Wjrt/YcDKg==
X-Received: by 2002:a05:600c:2903:: with SMTP id i3mr4663876wmd.65.1587472874563;
        Tue, 21 Apr 2020 05:41:14 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Nicolas Pitre <nico@linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 23/24] of: fix missing kobject init for !SYSFS && OF_DYNAMIC config
Date:   Tue, 21 Apr 2020 13:40:16 +0100
Message-Id: <20200421124017.272694-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
index 41b254be02954..c0281be8e0611 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -169,9 +169,6 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!IS_ENABLED(CONFIG_SYSFS))
-		return 0;
-
 	if (!of_kset)
 		return 0;
 
-- 
2.25.1


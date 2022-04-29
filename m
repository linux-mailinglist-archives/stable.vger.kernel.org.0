Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DFD515122
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 18:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379299AbiD2Qxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 12:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379300AbiD2Qxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 12:53:43 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E03AB85A
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:50:24 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i5so11508393wrc.13
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hR+ipPq2gap4bXepi4EzWC/gfjexmZUBGu30czl6wWU=;
        b=vaItMW+1gyLuD6nhgipRjoSdUBqBq1APnbecLpaCBuq9hU/b9Ir0ZoimHT8smyU7qh
         wGrNrckEtlos5Fp6ugNuUsP0qrUwso3UoN5DODnpxSoylbN//uXifD8PThUirbJvmNKB
         8Lxmn0pX3jb98je+cnJozRPkTvr19ia4C1N3CWcEiSHjPp6RcuOhpILSetKfW3krfT+b
         s8BddRpIT6rWEIfSPhWjN9o9BRIIhIOm46mn37L31KBCqajlJlwRpjuifNwEIeVaL8/e
         LMuhj/RHTMN3o3FmRI95pVr44xspL4GO3cq7q/XrXQWB6hzpFBOSaRkb12striwDmzMP
         2I/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hR+ipPq2gap4bXepi4EzWC/gfjexmZUBGu30czl6wWU=;
        b=M2GUeHdRo72sTQjKSLKWlhhzTI20STukRenRYewhEArC7VJiucmx9ZJh6W4ZT/aUkn
         B0SWiskBqK0oQQFsl3UsGTFfY2DqxHX/8dMXcN8p/NQBdZxgvsDJqTsc4eTo6EjgKIBf
         6uZimnewX89uhJnoK1PZ+rWLrrzs0KZjgxya61XW33+e6vTvSAypNv49i9jWLjLeZ6dq
         h13qIeK4l+3ZmAT8CfZrwBpTkNhqITdk+LUgXeoCGIHBdMJGofQ98pRoGYHtNK0ER1ah
         SAVNmkBeYGss0kdTfiIyaYydCxgJ3K6WM3ZQz+QKl9kLs60n2qEz3xRyPDGF3PRw8+nP
         0pjg==
X-Gm-Message-State: AOAM531b4hqnbuLWYyDtvQldSJB6hEM3vFGOVzJG335rdhxCTJ2kOF3a
        ESvYv69ZAxejYC+QciyBlA9b2g==
X-Google-Smtp-Source: ABdhPJyIo9jrETp7GhL4hPuJ3ZBGxPtVsk20rwc3r57n+zFu7eQ798UJGZjnHlP7ppITNRBXF+eo5Q==
X-Received: by 2002:a5d:4a84:0:b0:20c:47b6:61ee with SMTP id o4-20020a5d4a84000000b0020c47b661eemr51638wrq.68.1651251022697;
        Fri, 29 Apr 2022 09:50:22 -0700 (PDT)
Received: from srini-hackbox.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id f1-20020a1c6a01000000b0038c9f6a3634sm6846906wmc.7.2022.04.29.09.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 09:50:22 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 1/1] slimbus: qcom: Fix IRQ check in qcom_slim_probe
Date:   Fri, 29 Apr 2022 17:49:17 +0100
Message-Id: <20220429164917.5202-2-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220429164917.5202-1-srinivas.kandagatla@linaro.org>
References: <20220429164917.5202-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

platform_get_irq() returns non-zero IRQ number on success,
negative error number on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Cc: stable@vger.kernel.org
Fixes: ad7fcbc308b0 ("slimbus: qcom: Add Qualcomm Slimbus controller driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/slimbus/qcom-ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/qcom-ctrl.c b/drivers/slimbus/qcom-ctrl.c
index f04b961b96cd..ec58091fc948 100644
--- a/drivers/slimbus/qcom-ctrl.c
+++ b/drivers/slimbus/qcom-ctrl.c
@@ -510,9 +510,9 @@ static int qcom_slim_probe(struct platform_device *pdev)
 	}
 
 	ctrl->irq = platform_get_irq(pdev, 0);
-	if (!ctrl->irq) {
+	if (ctrl->irq < 0) {
 		dev_err(&pdev->dev, "no slimbus IRQ\n");
-		return -ENODEV;
+		return ctrl->irq;
 	}
 
 	sctrl = &ctrl->ctrl;
-- 
2.21.0


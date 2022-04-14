Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B745500552
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 07:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiDNFLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 01:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiDNFLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 01:11:12 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282933C4B5;
        Wed, 13 Apr 2022 22:08:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id u2so3806239pgq.10;
        Wed, 13 Apr 2022 22:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BXdefmByfbS7iadyHNuWA+1dWRCSn9oFrWGYl5Fm5mk=;
        b=QC4YhFn1wllW1lC8gGSTmQFcF7BKiGku0fd0KEfKjckRUB1fOizADvm++YKwNJFLc6
         +p3eYn++B8ekg9AlERZxlEGP4EGWCW45H3Bh0NIKjNlicWv3ADwMzRdciFPgkUxy7TdQ
         MyvYxZSnGgTqL7PvRoNpEbyabTi2MfWPgu764RWig9VQDiYv19sPLGNZKNOxurugG7YF
         AFSaTnD3n21Zot+8WlvXif9ut80zGJ6kaZJiHH5Toc+jTNzMkEMZwCaxnQDvT2RVDOtN
         bxxfEe9q4xMbuhbDRm1KRN3eMUJa2yHoxSJKU84eH5BkDlP232pGpxWaO6+1UgaIeHu1
         p2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BXdefmByfbS7iadyHNuWA+1dWRCSn9oFrWGYl5Fm5mk=;
        b=RobqDztKqjR/Yaveg8hY1y92wPrp/ZmXybjLXYXTBk7K+dcFo2lpDI3ETbiD1Kao6J
         SJF8VHHM1LwGCkKsOx7SDkhc+pEZxgSrVhesm+0IOf0AhLbmjRYyrEN4Vt7t4yabp46c
         gvCDuCDty2nOJpprbOwa/MrYi89P7dGOnKN0kfeOmK4WrSe/V/HcsqQDkVLGF5iQztCP
         P03lc7yuTig0A8D3iWk2pUaX3LG08XPKqCi/urJQJ6bNnUrETNM5yffDnHbvh+E6gO4u
         iJfEeqQ+7lDFYXASqHpVMt0ysgXI3mbWAB/aozHJNVoNt42rINQAmqAze9mxt6MOtx0B
         ki7A==
X-Gm-Message-State: AOAM530fqranKXGHpIpNMInbZ+sj/Cx/OSccga0vwkTkQ/VwMMyG7NJO
        aM7WvAbQ9OBTKWHlCfeYN7w=
X-Google-Smtp-Source: ABdhPJw2MWj6GujCGgHKVad2Vx8MRhaCT+wPaYACtZPvQZoVgZALyIcPZCbAatA+aPcL59Ad7T7eBA==
X-Received: by 2002:a63:78f:0:b0:39e:11d0:daa4 with SMTP id 137-20020a63078f000000b0039e11d0daa4mr942690pgh.36.1649912928665;
        Wed, 13 Apr 2022 22:08:48 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm763936pfl.135.2022.04.13.22.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 22:08:48 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     agross@kernel.org, bjorn.andersson@linaro.org, joro@8bytes.org,
        will@kernel.org, sricharan@codeaurora.org
Cc:     linux-arm-msm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [RESEND][PATCH] iommu: fix an incorrect NULL check on list iterator
Date:   Thu, 14 Apr 2022 13:08:40 +0800
Message-Id: <20220414050840.5691-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (!iommu || iommu->dev->of_node != spec->np) {

The list iterator value 'iommu' will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found (in fact,
it will point to a invalid structure object containing HEAD).

To fix the bug, run insert_iommu_master(dev, &iommu, spec); unlock and
return 0 when found, otherwise unlock and return -ENODEV.

Cc: stable@vger.kernel.org
Fixes: f78ebca8ff3d6 ("iommu/msm: Add support for generic master bindings")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/iommu/msm_iommu.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 3a38352b603f..1dbb8b0695ec 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -617,23 +617,17 @@ static int qcom_iommu_of_xlate(struct device *dev,
 {
 	struct msm_iommu_dev *iommu;
 	unsigned long flags;
-	int ret = 0;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
 	list_for_each_entry(iommu, &qcom_iommu_devices, dev_node)
-		if (iommu->dev->of_node == spec->np)
-			break;
-
-	if (!iommu || iommu->dev->of_node != spec->np) {
-		ret = -ENODEV;
-		goto fail;
-	}
-
-	insert_iommu_master(dev, &iommu, spec);
-fail:
+		if (iommu->dev->of_node == spec->np) {
+			insert_iommu_master(dev, &iommu, spec);
+			spin_unlock_irqrestore(&msm_iommu_lock, flags);
+			return 0;
+		}
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 
-	return ret;
+	return -ENODEV;
 }
 
 irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
-- 
2.17.1


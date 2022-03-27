Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42C34E85FA
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiC0Fhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiC0Fhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:37:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4FC192B2;
        Sat, 26 Mar 2022 22:36:05 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m22so11165167pja.0;
        Sat, 26 Mar 2022 22:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BXdefmByfbS7iadyHNuWA+1dWRCSn9oFrWGYl5Fm5mk=;
        b=WD/emqxoTCqSinxwNm9zYC0BhVut37NKvVjalaC3AKb8//RwbBJ0HSEAfuKaQ4TRfn
         6kwLAZMOADsCvtCO24agk+3gzGKGTzkJYK5VEESmUvDd0AwLk8MOqqqbGIxQADK8aLnO
         cnQOeYl0dNZheOli0EHPxR4XCURTaCEwk+DA6AttIClrfhjRFRZ7eNgaXmT3Q5TRifxb
         oWKTyZ27SYlho/bS0fQMj4jMBTHcATU1sYK+99WO7WA4uv1bNod4RcYqMHfWk7DyqCSQ
         Qc0paAN62/Th0TsFECWtb5Pb6fzEURwe3BBOKcRwTf5utyKHkZHcplpnGv6lEJDDO1pv
         w6fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BXdefmByfbS7iadyHNuWA+1dWRCSn9oFrWGYl5Fm5mk=;
        b=P2eXbLVIvLcgAalByEPWZnhoFnawXEylRhe0z2noWo4yOrPMGVu/01L3yPcaOqb+XS
         n1SqcmkSAHLPl9Di1+aIIDsMxqBuNfVuvh1Sarl1pqYXVlMdOMU1DeK+mxaMRIFifULX
         gt1sPM4rXcN2ti00p6wvuJaN7S1/q9nAcj73OcVtrtaThuR1x+IJ29O4ZsBYkHSpWBTG
         tfnC6uzoeN1/Cj6ELeBQKQcCG2H+YalibJHjbZouce4LZS0EiVACijYE9dSjoMY+DNHT
         KpUE1pTYMb05txIn5dF5uviULgt8ecsTXcXyz2UEunX4St20W0lj5XTYCeXe3HN9KwMk
         C9xQ==
X-Gm-Message-State: AOAM530WUB8PQlyswbBb2seSfIdsw0tOnQ2s74swFdUd2RJl8q9uLost
        yBEg3vfa5tQFcP66qnj6zes=
X-Google-Smtp-Source: ABdhPJzLDpKQkrWzztdlJpJD0lzsWQyEl0Qpi9c3Hry9x9AKCEmmWC14C7eZiUH7Vhej5pAm1C+3YQ==
X-Received: by 2002:a17:90a:4217:b0:1c7:c203:b4f3 with SMTP id o23-20020a17090a421700b001c7c203b4f3mr18995680pjg.177.1648359364587;
        Sat, 26 Mar 2022 22:36:04 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id u10-20020a63b54a000000b00380ea901cd2sm9296275pgo.6.2022.03.26.22.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:36:04 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     agross@kernel.org
Cc:     bjorn.andersson@linaro.org, joro@8bytes.org, will@kernel.org,
        sricharan@codeaurora.org, linux-arm-msm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] iommu: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 13:35:58 +0800
Message-Id: <20220327053558.2821-1-xiam0nd.tong@gmail.com>
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


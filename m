Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF56C51649E
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347559AbiEANb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 09:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237373AbiEANb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 09:31:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EDB3299E;
        Sun,  1 May 2022 06:28:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x52so8917905pfu.11;
        Sun, 01 May 2022 06:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=x+vci/WgeFLOKqYpeTUy1SURtAS8ymBmeID88rAjgkc=;
        b=bM8iqxP4M9Z194v2N+8fzrKbhIUmYbFhD5PD/psBUU4LAYGEduO+ctl5Vq5fmJn3tL
         GKZzVDz+toPsKUYHhtTL6PCtbsDSEgmc4L9HQxSBTd0muq8GOwjCktlcdvB19nN9vYt3
         azAKSdiMTYT7vy2jZPdXkhesSJweTCbQIC8u8dtep/lbnvjAPVsW1h9ikPjxT5ZodDyj
         pBrNN6Y8NzJ9p/RY6gsAp5AjaUdklNYeuG7imrVtRIQjRjSu/TtBmNqIptBaCbxasYju
         u59C2FFF0vNYEluUavlH2QxrP14cGLsuDtB3UpT2NGjZAyUBm8RRo+ComzIci+RpDtUX
         ds+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x+vci/WgeFLOKqYpeTUy1SURtAS8ymBmeID88rAjgkc=;
        b=Wpy8ZSr1s0ItmQuw0bVVRXgZn0nYvurpMtglV7xRxYjcabjMoDHwkzFDPofiKmJDzz
         La1gKaPO83V6+LkPmPZYuXxy7wGnNc1rTZDImiMTrHz0OPu+94zc44HDSbysjClrolqW
         LRU2+mE4LPPjaPGZRSuBphuG9pyaiBRUhtanAYlmGGBR0zvL8t3zoX1hmp2IkcOHjORs
         KPtq+XkJbeF0rKbkpQ4gZAEAPvTcTWrHpnuqHVuQhGeVxEvQUCednYzxLuelxD25IUqa
         cV70UC5eCKgr/EECxkcWHRwAd4widdQaYJ0zV83wcFoOGOUMpU1At/ntdupEumNEq3wg
         Lthg==
X-Gm-Message-State: AOAM53134ovYnIjytgoEGT4nGRYeSsy1woh09xtpUHZOJiUlGd7exySf
        9QdrhWRyn0AJvLmcSnM6PxqGE0oHVKECVjQ0
X-Google-Smtp-Source: ABdhPJzEhlGOrpTMwLWuERZKarhCsmpznSPi4Fgvsc3is6rS2xJrZLchrffVrkCQe5f9WqywiWcfqQ==
X-Received: by 2002:a63:1c0d:0:b0:3ab:1a76:953f with SMTP id c13-20020a631c0d000000b003ab1a76953fmr6142860pgc.73.1651411710432;
        Sun, 01 May 2022 06:28:30 -0700 (PDT)
Received: from localhost.localdomain ([122.233.238.54])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902864500b0015e8d4eb229sm2877019plt.115.2022.05.01.06.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 06:28:30 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     agross@kernel.org, bjorn.andersson@linaro.org, joro@8bytes.org,
        will@kernel.org, sricharan@codeaurora.org
Cc:     linux-arm-msm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] iommu: fix an incorrect NULL check on list iterator
Date:   Sun,  1 May 2022 21:28:23 +0800
Message-Id: <20220501132823.12714-1-xiam0nd.tong@gmail.com>
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

To fix the bug, use a new value 'iter' as the list iterator, while use
the old value 'iommu' as a dedicated variable to point to the found one,
and remove the unneeded check for 'iommu->dev->of_node != spec->np'
outside the loop.

Cc: stable@vger.kernel.org
Fixes: f78ebca8ff3d6 ("iommu/msm: Add support for generic master bindings")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
changes since v1:
 - add a new iter variable (suggested by Joerg Roedel)

v1: https://lore.kernel.org/all/20220327053558.2821-1-xiam0nd.tong@gmail.com/
---
 drivers/iommu/msm_iommu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 3a38352b603f..41a3231a6d13 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -615,16 +615,17 @@ static void insert_iommu_master(struct device *dev,
 static int qcom_iommu_of_xlate(struct device *dev,
 			       struct of_phandle_args *spec)
 {
-	struct msm_iommu_dev *iommu;
+	struct msm_iommu_dev *iommu = NULL, *iter;
 	unsigned long flags;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
-	list_for_each_entry(iommu, &qcom_iommu_devices, dev_node)
-		if (iommu->dev->of_node == spec->np)
+	list_for_each_entry(iter, &qcom_iommu_devices, dev_node)
+		if (iter->dev->of_node == spec->np) {
+			iommu = iter;
 			break;
+		}
 
-	if (!iommu || iommu->dev->of_node != spec->np) {
+	if (!iommu) {
 		ret = -ENODEV;
 		goto fail;
 	}
-- 
2.17.1


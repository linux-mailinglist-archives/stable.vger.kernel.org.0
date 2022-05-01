Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA5516482
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 15:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347229AbiEANQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 09:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345720AbiEANQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 09:16:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC58121278;
        Sun,  1 May 2022 06:13:08 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so14209505pjq.0;
        Sun, 01 May 2022 06:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=dJZi+/WPdcKxjEapwSjUsXGWCJvPbK+sm/8N0ec5JVY=;
        b=Jskd7h6x/6zw2xzs8eqnb0NFuea/abFEwnRJTo/pxFCDlXX7fzm8k0E1uG+6zWlQnR
         8IRq9pZyxa+ObcYF+gD/i8OryJpGhh3o7bf/ghJYSmxxEapNTEBuOh22JNAl4U9ROWb6
         PY2st7shkaVyIwnLgYDTVD2S28x++/9ClFWdquJbJiMzHpsUkIw1WpprK/pj0NwC7fTX
         5q+xnbpTkwIn6l0bOLFZ9ngY/mleoXvfvZshSEMo6VAGwnsW8IxIzYTY9AHa6ehX0CnN
         jic7d/pQKTkVLLgB5BanvFMdcjfAziOoWKPQ9q8QO2XBEoYlrdI6+m6IY5gA9nhiogkK
         JUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dJZi+/WPdcKxjEapwSjUsXGWCJvPbK+sm/8N0ec5JVY=;
        b=JHK+l0s10LeYljtzKHbwF3FSgT87fW0xyJY50Ru2jEH+gsqEMv5VPOy0OzQWOkNwOY
         xiOro3Gd5lNZK3IZpuuy2QZxQkjxa2rHCqEDwuzrEOjfO/kCkkXW1nXpittkGt63gBBJ
         IKM6Rq9z4zXdCNrGyadz/duuNyWdxMmjTDhZeF6xp0Y4+oCo8nnXYhl6anyetz6vnjm+
         fTKwSHuJ59Xvu2PsSVSlwz6aE0AZw9HbGTSc8MbSJqf/UeCmr00Mce0r4+sDoAoh8yW+
         ZVWWY3d/qswADjYHe26YkO93qWNx86IkPpDNH1Qxl2ols/komj0CSLAjMG83JjIsnXYZ
         weeA==
X-Gm-Message-State: AOAM530v069sfYtk+j667eRUPYAiUbq0O+hHgNkO4eqpCJDuE9WBZ6wH
        3jfxluYJbyJgyulmydM9OFU=
X-Google-Smtp-Source: ABdhPJyqTwaVt+oGV9vys0cmrU4vLLMTpOIRjlB/xJbxkk1sPItJb9mAls593fhVzKrnghUOS9+W1w==
X-Received: by 2002:a17:90b:4b81:b0:1dc:4dfe:9b01 with SMTP id lr1-20020a17090b4b8100b001dc4dfe9b01mr2896477pjb.110.1651410788431;
        Sun, 01 May 2022 06:13:08 -0700 (PDT)
Received: from localhost.localdomain ([122.233.238.54])
        by smtp.gmail.com with ESMTPSA id 7-20020a631347000000b003c14af505fcsm9561252pgt.20.2022.05.01.06.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 06:13:07 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     agross@kernel.org, bjorn.andersson@linaro.org, joro@8bytes.org,
        will@kernel.org, sricharan@codeaurora.org
Cc:     linux-arm-msm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] iommu: fix an incorrect NULL check on list iterator
Date:   Sun,  1 May 2022 21:12:59 +0800
Message-Id: <20220501131259.11529-1-xiam0nd.tong@gmail.com>
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
-	int ret = 0;
 
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


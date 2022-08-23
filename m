Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB9E59D6DD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbiHWJ5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351651AbiHWJzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:55:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA64C7B79C;
        Tue, 23 Aug 2022 01:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31391611DD;
        Tue, 23 Aug 2022 08:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A025C433C1;
        Tue, 23 Aug 2022 08:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244402;
        bh=N9LI/p3/ykPwVyJdtF3lXCtojiqsjqPQIXbLITIPqhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGVDTExJuqYajGh9p7Px+R4eIX5lUKMRDQVQqnDHW00gXhQI2373lS3JrIxXRFT7w
         SmmAux0oy5lAttULTIEJtX840moEMl7IJOJKn4UEACpa3zGyc1PU9eCwVd6EgaKC6r
         SKyDaA0MidBArOfNNRK8nEGeWziMh/VysuJNOv0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 132/229] iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
Date:   Tue, 23 Aug 2022 10:24:53 +0200
Message-Id: <20220823080058.423359732@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit a91eb6803c1c715738682fece095145cbd68fe0b ]

In qcom_iommu_has_secure_context(), we should call of_node_put()
for the reference 'child' when breaking out of for_each_child_of_node()
which will automatically increase and decrease the refcount.

Fixes: d051f28c8807 ("iommu/qcom: Initialize secure page table")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220719124955.1242171-1-windhl@126.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/qcom_iommu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/qcom_iommu.c b/drivers/iommu/qcom_iommu.c
index 920a5df319bc..ad74f64d8876 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -745,9 +745,12 @@ static bool qcom_iommu_has_secure_context(struct qcom_iommu_dev *qcom_iommu)
 {
 	struct device_node *child;
 
-	for_each_child_of_node(qcom_iommu->dev->of_node, child)
-		if (of_device_is_compatible(child, "qcom,msm-iommu-v1-sec"))
+	for_each_child_of_node(qcom_iommu->dev->of_node, child) {
+		if (of_device_is_compatible(child, "qcom,msm-iommu-v1-sec")) {
+			of_node_put(child);
 			return true;
+		}
+	}
 
 	return false;
 }
-- 
2.35.1




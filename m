Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2A759DDA6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbiHWLeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358059AbiHWLcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADDB75FFB;
        Tue, 23 Aug 2022 02:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B1D96126A;
        Tue, 23 Aug 2022 09:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2405FC433C1;
        Tue, 23 Aug 2022 09:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246804;
        bh=nlZ0MR4wZADSln3mC3C9MdSprJkx7c6lJDIz81a123o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsT99HW+e0cakV37tcRZUpD/78zUXj1Q+njR/mBgH6xXci/uBc1TFf+QcnL80KznH
         Zqywyv1UWlz/GDKIjsp6Do/WBcfJh4K8oRpEnFHpoDMpJkYYyfaD55KKkPf/eWbhO+
         AxDFvJE6q3PRqGLM7ZVLG9fdSz0ooxGbbZ0bY07E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/389] iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
Date:   Tue, 23 Aug 2022 10:25:02 +0200
Message-Id: <20220823080124.953975239@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 280de92b332e..b6e546b62a7c 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -785,9 +785,12 @@ static bool qcom_iommu_has_secure_context(struct qcom_iommu_dev *qcom_iommu)
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




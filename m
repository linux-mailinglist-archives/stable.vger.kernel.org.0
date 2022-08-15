Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34B5594D91
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbiHPArJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244497AbiHPApc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E913B4E868;
        Mon, 15 Aug 2022 13:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC64FB80EA9;
        Mon, 15 Aug 2022 20:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E2CC433C1;
        Mon, 15 Aug 2022 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596120;
        bh=lCT1j9g6C8VJGJ3kCsSS9uDzFCCqHmR/3FmqLXKyelw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+xJip+soStYJCJpSs0mEBC3q1l7vyari3bEnQ+GOBPSUEG4UXdPTZDcXGdc4c2j3
         ALMy6q9fF9VGAoSOF+/6Pib4S9wZsSIt46+VW8ZAoY78rUw7o4od0RZ8hJnKt7jJ6Q
         xobTTPbdFfOXSFIJGS+sCn3vIsexlkTaRJfs0VFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0972/1157] iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
Date:   Mon, 15 Aug 2022 20:05:28 +0200
Message-Id: <20220815180518.588991920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 4c077c38fbd6..c11d2c2cbb62 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -750,9 +750,12 @@ static bool qcom_iommu_has_secure_context(struct qcom_iommu_dev *qcom_iommu)
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




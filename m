Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE8549559
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiFMNAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356323AbiFMM4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B62813DE3;
        Mon, 13 Jun 2022 04:17:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5F2060F0F;
        Mon, 13 Jun 2022 11:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E302FC34114;
        Mon, 13 Jun 2022 11:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119034;
        bh=rjxsIwg46VZA4ILaUjf3PFMiMW6Z/2VxOFD/CXfhqF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vbhisusi0eLCJpIR2KY37lkngzCOv+2enxZQyEgLS1hPMhSDNWX9XShZPEhujNSsj
         k7oov+wfhnHDOXXetLQomhmDJf90hhaabiv7xFnnDcBzD7v1GG1x+tfwl7IwQjDkrM
         Tt5AE4RaKmEuyppczRjmqPijTfdE7eCwr46c4q0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/247] iommu/arm-smmu-v3: check return value after calling platform_get_resource()
Date:   Mon, 13 Jun 2022 12:10:19 +0200
Message-Id: <20220613094926.512273643@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b131fa8c1d2afd05d0b7598621114674289c2fbb ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220425114525.2651143-1-yangyingliang@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 430315135cff..79edfdca6607 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3786,6 +3786,8 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 
 	/* Base address */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	if (resource_size(res) < arm_smmu_resource_size(smmu)) {
 		dev_err(dev, "MMIO region too small (%pr)\n", res);
 		return -EINVAL;
-- 
2.35.1




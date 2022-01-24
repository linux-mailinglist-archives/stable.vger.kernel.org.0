Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1220E499529
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392359AbiAXUvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390178AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8279C06138E;
        Mon, 24 Jan 2022 11:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55BE760989;
        Mon, 24 Jan 2022 19:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2E1C340E5;
        Mon, 24 Jan 2022 19:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054099;
        bh=KuJpflFQSegupwZxZ5OZ91OVC0jVZr/s65fvB8KorQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7GZumRpUpyLpt2s41trLYGjETyB9EgLCI+rfyjH75caoZ+aBebafAGx/atOjhV9l
         8sMR4cX6JmrtufxPMiwYyIHhoCaEQEk8ur9gu48POdt5LoTa63T2dA7pjxSmrV8+3V
         Avizt1S9yP+i0EyL4X+P+49jBRh/FerUKA4jr7tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/563] iommu/amd: Remove iommu_init_ga()
Date:   Mon, 24 Jan 2022 19:40:42 +0100
Message-Id: <20220124184034.018563907@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit eb03f2d2f6a4da25d286613717d10add9ce9f175 ]

Since the function has been simplified and only call iommu_init_ga_log(),
remove the function and replace with iommu_init_ga_log() instead.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20210820202957.187572-4-suravee.suthikulpanit@amd.com
Fixes: 8bda0cfbdc1a ("iommu/amd: Detect and initialize guest vAPIC log")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 28de889aa5164..c82f8ab4783c0 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -830,9 +830,9 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 	return 0;
 }
 
-#ifdef CONFIG_IRQ_REMAP
 static int iommu_init_ga_log(struct amd_iommu *iommu)
 {
+#ifdef CONFIG_IRQ_REMAP
 	u64 entry;
 
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
@@ -862,18 +862,9 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 err_out:
 	free_ga_log(iommu);
 	return -EINVAL;
-}
-#endif /* CONFIG_IRQ_REMAP */
-
-static int iommu_init_ga(struct amd_iommu *iommu)
-{
-	int ret = 0;
-
-#ifdef CONFIG_IRQ_REMAP
-	ret = iommu_init_ga_log(iommu);
+#else
+	return 0;
 #endif /* CONFIG_IRQ_REMAP */
-
-	return ret;
 }
 
 static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
@@ -1860,7 +1851,7 @@ static int __init iommu_init_pci(struct amd_iommu *iommu)
 	if (iommu_feature(iommu, FEATURE_PPR) && alloc_ppr_log(iommu))
 		return -ENOMEM;
 
-	ret = iommu_init_ga(iommu);
+	ret = iommu_init_ga_log(iommu);
 	if (ret)
 		return ret;
 
-- 
2.34.1




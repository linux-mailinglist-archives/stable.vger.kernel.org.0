Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE2253A83D
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354206AbiFAOGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354685AbiFAOFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:05:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE86ABF5F;
        Wed,  1 Jun 2022 06:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 15C5DCE1A1F;
        Wed,  1 Jun 2022 13:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963F7C385A5;
        Wed,  1 Jun 2022 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091938;
        bh=BaKhQqgyfbfjuRLsJf8naFAGGNIsWBbdAWduy+Wsrg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZyJ4SIHLPYcbV+STHXeCMVlciIvTDT6ZYq1M2OMU7Z4Z8+j53cnhizfg+GVRBn6l
         J0dVE7tw+1otyZN7bChtS85PO7lOsM6eFwo/GkW8X6wiE+4tzF9YA2xM+Id91prq/H
         XHFhUY5NqXNThRHlqwoEeG6bL9blEDP/gmLqbs/oYTGiPHlQ/MQ2CROqHzklgenvRH
         en1BQ5PEYjSTCa0qT4nx2jePaudG1n6bUW6Wdm2LHkHzsWrTDCyd9faH9c/IDWqjDt
         UqE1eDLRBG9rqjRsruUSfqPZ7ZLhzFNQ2qZNADLpPHkC7itACVdRWSA3OBmtN0DdQ+
         7d0KKQMwspieQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Wu <wupeng58@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 24/26] powerpc/iommu: Add missing of_node_put in iommu_init_early_dart
Date:   Wed,  1 Jun 2022 09:57:57 -0400
Message-Id: <20220601135759.2004435-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135759.2004435-1-sashal@kernel.org>
References: <20220601135759.2004435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Wu <wupeng58@huawei.com>

[ Upstream commit 57b742a5b8945118022973e6416b71351df512fb ]

The device_node pointer is returned by of_find_compatible_node
with refcount incremented. We should use of_node_put() to avoid
the refcount leak.

Signed-off-by: Peng Wu <wupeng58@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220425081245.21705-1-wupeng58@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/dart_iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index 6b4a34b36d98..8ff9bcfe4b8d 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -403,9 +403,10 @@ void __init iommu_init_early_dart(struct pci_controller_ops *controller_ops)
 	}
 
 	/* Initialize the DART HW */
-	if (dart_init(dn) != 0)
+	if (dart_init(dn) != 0) {
+		of_node_put(dn);
 		return;
-
+	}
 	/*
 	 * U4 supports a DART bypass, we use it for 64-bit capable devices to
 	 * improve performance.  However, that only works for devices connected
@@ -418,6 +419,7 @@ void __init iommu_init_early_dart(struct pci_controller_ops *controller_ops)
 
 	/* Setup pci_dma ops */
 	set_pci_dma_ops(&dma_iommu_ops);
+	of_node_put(dn);
 }
 
 #ifdef CONFIG_PM
-- 
2.35.1


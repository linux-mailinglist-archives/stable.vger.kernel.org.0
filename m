Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537CC540A2B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350476AbiFGSS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350762AbiFGSNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:13:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50708113FB6;
        Tue,  7 Jun 2022 10:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E72BBB8234E;
        Tue,  7 Jun 2022 17:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5652CC385A5;
        Tue,  7 Jun 2022 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624139;
        bh=ECd6Aicrn/3hNiarGoTPZt4Prq14+yb8QnQNVxzNFr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEZhWc4ITWUxLGF8Izh9auY3WNytxycKqtRFiNrNgKISzqppQLOjbWV1vPqNpm+Z7
         j+NMJSVJ2xe9mWN8nG1VRBZCtO6h0D6vwFTallLLr66+1ixe1/HMKxtTEaTSTjZZno
         Bi5M0hRpIgwWaiRMsN1b6ixbUCWxUNIIRulKKoak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Wu <wupeng58@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/667] powerpc/iommu: Add missing of_node_put in iommu_init_early_dart
Date:   Tue,  7 Jun 2022 18:57:23 +0200
Message-Id: <20220607164940.148068392@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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
index 1d33b7a5ea83..dc774b204c06 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -404,9 +404,10 @@ void __init iommu_init_early_dart(struct pci_controller_ops *controller_ops)
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
@@ -419,6 +420,7 @@ void __init iommu_init_early_dart(struct pci_controller_ops *controller_ops)
 
 	/* Setup pci_dma ops */
 	set_pci_dma_ops(&dma_iommu_ops);
+	of_node_put(dn);
 }
 
 #ifdef CONFIG_PM
-- 
2.35.1




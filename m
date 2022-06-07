Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76A540634
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347200AbiFGRdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346984AbiFGR3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:29:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5928A47ACA;
        Tue,  7 Jun 2022 10:25:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB82960BC6;
        Tue,  7 Jun 2022 17:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048C2C385A5;
        Tue,  7 Jun 2022 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622719;
        bh=BaKhQqgyfbfjuRLsJf8naFAGGNIsWBbdAWduy+Wsrg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6zWPcoj/I76zo9aXfV2r+YD4bKJd6BFRS5nW9t//zd17cnuAdRkDvxU8OoRddNrl
         CtUkJG7e71BYwsRNNJjKdSUug2wBt/SXQwlxwK43VMMd7ZiuVducc/DGZNgvTenyBK
         TxWQOEomKIjL2Dcqd9jCi7bZTUEbBAKFHK64BJfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Wu <wupeng58@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/452] powerpc/iommu: Add missing of_node_put in iommu_init_early_dart
Date:   Tue,  7 Jun 2022 18:59:35 +0200
Message-Id: <20220607164912.075552885@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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




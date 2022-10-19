Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589D6603EF7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiJSJZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiJSJYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:24:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFE2C4D9A;
        Wed, 19 Oct 2022 02:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C597B61750;
        Wed, 19 Oct 2022 09:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD321C433D7;
        Wed, 19 Oct 2022 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170449;
        bh=CDFKxDXed4seug1ukSk9Zm+SmC8qh5flXF0DuqIbwBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FeNp7U5kpEwGIQSux/oUB7J9rZ1sgOgQJ+3A/cQqS7aS4e13GoNXxTYzfK3Qmz5uT
         c7G2ThgjRlE1UoZxg3o570gtgCgtXdAW4TsMx6lDTTf31b+K+5hRUp1ezG3uNs+21v
         6T73J3U44xhRWO4EX8OHrC/fTOHLsdWGKuDGf8tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=206=2E0=20659/862=5D=20=3D=3FUTF-8=3Fq=3FARM/dma-mapp=3DD1=3D96ng=3A=3D20dont=3D20override=3D20-=3Edma=3D5Fcohe=3F=3D=20=3D=3FUTF-8=3Fq=3Frent=3D20when=3D20set=3D20from=3D20a=3D20bus=3D20notifier=3F=3D?=
Date:   Wed, 19 Oct 2022 10:32:26 +0200
Message-Id: <20221019083319.087440003@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 49bc8bebae79c8516cb12f91818f3a7907e3ebce ]

Commit ae626eb97376 ("ARM/dma-mapping: use dma-direct unconditionally")
caused a regression on the mvebu platform, wherein devices that are
dma-coherent are marked as dma-noncoherent, because although
mvebu_hwcc_notifier() after that commit still marks then as coherent,
the arm_coherent_dma_ops() function, which is called later, overwrites
this setting, since it is being called from drivers/of/device.c with
coherency parameter determined by of_dma_is_coherent(), and the
device-trees do not declare the 'dma-coherent' property.

Fix this by defaulting never clearing the dma_coherent flag in
arm_coherent_dma_ops().

Fixes: ae626eb97376 ("ARM/dma-mapping: use dma-direct unconditionally")
Reported-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/dma-mapping.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 089c9c644cce..bfc7476f1411 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1769,8 +1769,16 @@ static void arm_teardown_iommu_dma_ops(struct device *dev) { }
 void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 			const struct iommu_ops *iommu, bool coherent)
 {
-	dev->archdata.dma_coherent = coherent;
-	dev->dma_coherent = coherent;
+	/*
+	 * Due to legacy code that sets the ->dma_coherent flag from a bus
+	 * notifier we can't just assign coherent to the ->dma_coherent flag
+	 * here, but instead have to make sure we only set but never clear it
+	 * for now.
+	 */
+	if (coherent) {
+		dev->archdata.dma_coherent = true;
+		dev->dma_coherent = true;
+	}
 
 	/*
 	 * Don't override the dma_ops if they have already been set. Ideally
-- 
2.35.1




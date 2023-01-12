Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0F66765C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbjALObH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbjALOaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:30:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C2658FA7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:21:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3ECC6CE1E76
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B695C433F0;
        Thu, 12 Jan 2023 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533316;
        bh=WlntQYq2ET4+G4/bvns+M52mIGL4kPhXSzFcUq7WN18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Te/JP6A5NfH/Uppoy2DMby05FsRDj7SjSdA9iTru5k4VEwImCnDbENs69ev1MMuWU
         AU4Y/8zSAFENd2C9TF43WiPAgJX3M4DSVJCNglvQrb3RQym/7ZwT4dEI2Yhr+DQxz4
         rttGi7NgaFi9r18fnTI0raxcC7MBGi2D7s/ELRPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/783] iommu/sun50i: Fix reset release
Date:   Thu, 12 Jan 2023 14:52:05 +0100
Message-Id: <20230112135543.276075165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 9ad0c1252e84dbc664f0462707182245ed603237 ]

Reset signal is asserted by writing 0 to the corresponding locations of
masters we want to reset. So in order to deassert all reset signals, we
should write 1's to all locations.

Current code writes 1's to locations of masters which were just reset
which is good. However, at the same time it also writes 0's to other
locations and thus asserts reset signals of remaining masters. Fix code
by writing all 1's when we want to deassert all reset signals.

This bug was discovered when working with Cedrus (video decoder). When
it faulted, display went blank due to reset signal assertion.

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221025165415.307591-2-jernej.skrabec@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index ea6db1341916..3dead4f91420 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 
 #define IOMMU_RESET_REG			0x010
+#define IOMMU_RESET_RELEASE_ALL			0xffffffff
 #define IOMMU_ENABLE_REG		0x020
 #define IOMMU_ENABLE_ENABLE			BIT(0)
 
@@ -905,7 +906,7 @@ static irqreturn_t sun50i_iommu_irq(int irq, void *dev_id)
 	iommu_write(iommu, IOMMU_INT_CLR_REG, status);
 
 	iommu_write(iommu, IOMMU_RESET_REG, ~status);
-	iommu_write(iommu, IOMMU_RESET_REG, status);
+	iommu_write(iommu, IOMMU_RESET_REG, IOMMU_RESET_RELEASE_ALL);
 
 	spin_unlock(&iommu->iommu_lock);
 
-- 
2.35.1




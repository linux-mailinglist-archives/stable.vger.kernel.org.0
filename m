Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97379537DBC
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbiE3Nln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237840AbiE3NkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:40:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FB973793;
        Mon, 30 May 2022 06:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22B10B80DA8;
        Mon, 30 May 2022 13:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4C5C3411A;
        Mon, 30 May 2022 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917501;
        bh=3I8H0PKM1ZKkpegr2SIeaLTg+u2o3waLBCs6UGZmtm8=;
        h=From:To:Cc:Subject:Date:From;
        b=spFoAy6VxhS2tgl1gn1QcqoSLDQPrFBj2FtJeYfk4mR3ZcRhabSiCwpkmXyq0Q3XH
         /nZ9x1bFQE5orIwg8XsKPtBYMmufCN42LYJFVCcOIJFOKPfBKOtQEIZ8iK6X/+X4x1
         7iyszL0rREg6XfduRDMAEPrJwLneAa59OYJDlqOUJ4wAqnu1/bPOlynAmzX05zGD6W
         8r1c4oj2ypkvjdR8daaxHDGbBBxmUFbunZCe3n/7HXf563RAW+av76u09WrCmseMUu
         R/Q3T4lgWosk/Q9kJFJix2q/CpA92EYyyRwKvghRCXgte7aY0NdwMzoY0mYLWx1pxH
         1fODEy65V7ECQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Raviteja Goud Talla <ravitejax.goud.talla@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, dwmw2@infradead.org,
        joro@8bytes.org, will@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.17 001/135] iommu/vt-d: Add RPLS to quirk list to skip TE disabling
Date:   Mon, 30 May 2022 09:29:19 -0400
Message-Id: <20220530133133.1931716-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

From: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>

[ Upstream commit 0a967f5bfd9134b89681cae58deb222e20840e76 ]

The VT-d spec requires (10.4.4 Global Command Register, TE
field) that:

Hardware implementations supporting DMA draining must drain
any in-flight DMA read/write requests queued within the
Root-Complex before completing the translation enable
command and reflecting the status of the command through
the TES field in the Global Status register.

Unfortunately, some integrated graphic devices fail to do
so after some kind of power state transition. As the
result, the system might stuck in iommu_disable_translati
on(), waiting for the completion of TE transition.

This adds RPLS to a quirk list for those devices and skips
TE disabling if the qurik hits.

Link: https://gitlab.freedesktop.org/drm/intel/-/issues/4898
Tested-by: Raviteja Goud Talla <ravitejax.goud.talla@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220302043256.191529-1-tejaskumarx.surendrakumar.upadhyay@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ab2273300346..e3f15e0cae34 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5764,7 +5764,7 @@ static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
 	ver = (dev->device >> 8) & 0xff;
 	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
 	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
-	    ver != 0x9a)
+	    ver != 0x9a && ver != 0xa7)
 		return;
 
 	if (risky_device(dev))
-- 
2.35.1


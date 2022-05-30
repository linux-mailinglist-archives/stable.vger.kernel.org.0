Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA57538247
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241343AbiE3OWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240913AbiE3OQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADBD106543;
        Mon, 30 May 2022 06:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FBFB60F47;
        Mon, 30 May 2022 13:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E098C3411A;
        Mon, 30 May 2022 13:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918249;
        bh=fsc6IIIk1awweZ+LPL499ZV/HHQ210t5VuqTymzmdZw=;
        h=From:To:Cc:Subject:Date:From;
        b=CoAnx3Z6+FkEB0I2L3tZgc1H0suyzS5p7ZZZOFwvifmWZl8ZbdZX5dZwfkg+dgFKN
         85bKyyTEVTMCzZN41iMLUJ+MLrLuHF/rWeWZVnFfmbh8OoJSw44Twb1F2AJm5oOiXA
         MOVGH/6jgclhy3nJS/KahzMyNLosiHCmFpgX9rcm3GbyJvHv5vx3eOhfIXHd+7DjU4
         89QBhRVSMoGZGeao+lml9+zUfElgwU1i/fOePT3tIkSI+xATlJkl9vo+0FX3Eh07fi
         T0BAAlsZV7mXmonEUK2XpFej4EZz4RInfwaPjLbtpqQsFmodKRloayULAInE6MvGaM
         EpAdyL6PbW0nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Raviteja Goud Talla <ravitejax.goud.talla@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, dwmw2@infradead.org,
        joro@8bytes.org, will@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 01/76] iommu/vt-d: Add RPLS to quirk list to skip TE disabling
Date:   Mon, 30 May 2022 09:42:51 -0400
Message-Id: <20220530134406.1934928-1-sashal@kernel.org>
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
index 21749859ad45..477dde39823c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -6296,7 +6296,7 @@ static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
 	ver = (dev->device >> 8) & 0xff;
 	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
 	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
-	    ver != 0x9a)
+	    ver != 0x9a && ver != 0xa7)
 		return;
 
 	if (risky_device(dev))
-- 
2.35.1


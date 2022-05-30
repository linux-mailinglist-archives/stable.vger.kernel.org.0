Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C191537B5C
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiE3NYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiE3NYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85C162F6;
        Mon, 30 May 2022 06:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8262FB80D84;
        Mon, 30 May 2022 13:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BABC385B8;
        Mon, 30 May 2022 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917068;
        bh=v6STE/M7umHmQhXZl5W6Am/3Zz1pQY0LUnmLP5HuXO8=;
        h=From:To:Cc:Subject:Date:From;
        b=PSH1Y5HK/smNoPMvz4Yg5A+BFRA46DwGlSgwBfM3AVYTZulg5alVgvdbLn03ROotT
         hDZrojGNubPP8GSMntc1dji17j4hszFJ/ctOsRpD022Gn29DTLkuxyNMAExaWXvQW8
         6W7XYfYWklKlXoK/So3Xubh5/LA+xxjO43TxBMoFLHePf42+2CtTity04YMG3+Lkp8
         GseBofE6XQWSSYQDpjXlRVfTvL7dgyRKUSpS4tEO0heFlH6LJ8t5wNckMoJO3T7b+c
         HlH31PfRdhiNp03k89eJWrH5IyuBkwP7jK3NPK52WVdFllnCmat01RrzUgWAaK/NUG
         A/eLeVeCA20Ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Raviteja Goud Talla <ravitejax.goud.talla@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, dwmw2@infradead.org,
        joro@8bytes.org, will@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.18 001/159] iommu/vt-d: Add RPLS to quirk list to skip TE disabling
Date:   Mon, 30 May 2022 09:21:46 -0400
Message-Id: <20220530132425.1929512-1-sashal@kernel.org>
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
index 0ea47e17b379..ba9a63cac47c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5031,7 +5031,7 @@ static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
 	ver = (dev->device >> 8) & 0xff;
 	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
 	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
-	    ver != 0x9a)
+	    ver != 0x9a && ver != 0xa7)
 		return;
 
 	if (risky_device(dev))
-- 
2.35.1


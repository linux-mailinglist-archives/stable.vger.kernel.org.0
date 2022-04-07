Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70D14F6FF6
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiDGBQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236936AbiDGBPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:15:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAD418FAD7;
        Wed,  6 Apr 2022 18:12:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7B6261DB0;
        Thu,  7 Apr 2022 01:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2339DC385A7;
        Thu,  7 Apr 2022 01:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293923;
        bh=yKyYHVZeUbRYReCQgBvc2qrRWwD3Cz7cLVDukRxXuOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8Ie+3mOr6WemlUZ39zHw8kPtDKBFnhiCRVcd7yB6r0uFomhOMWAkOkhUL50l6jMd
         bkcfOMu24jW7GbhMyV0FK/mEJZ23TyBL2GcKb80Ly+kC1/27JUsUWlGy+F1elZSnqH
         OQ2M2xkRZVfgekw8/xq48OV2JI9TuNVmJb/aacEJ38w/7W9/YxNNDuA4btBY60wGWb
         rpmXruKLo3QvkrocjEZvOWPVnDZYPOqn03KBIZNiiFV0F9hR/CxTbxypGcHq3aUt06
         a7Z7DdEm14pn9HR0b0xQrB+nHRYNY9INQ81ev7XtaYf9qfn4Kqgp8eI6vGHQQbtGE4
         TF8dbmbHjPKzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Monish Kumar R <monish.kumar.r@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 11/30] nvme-pci: add quirks for Samsung X5 SSDs
Date:   Wed,  6 Apr 2022 21:11:21 -0400
Message-Id: <20220407011140.113856-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011140.113856-1-sashal@kernel.org>
References: <20220407011140.113856-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Monish Kumar R <monish.kumar.r@intel.com>

[ Upstream commit bc360b0b1611566e1bd47384daf49af6a1c51837 ]

Add quirks to not fail the initialization and to have quick resume
latency after cold/warm reboot.

Signed-off-by: Monish Kumar R <monish.kumar.r@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 953ea3d5d4bf..84f6c116338a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3398,7 +3398,10 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS |
 				NVME_QUIRK_SKIP_CID_GEN },
-
+	{ PCI_DEVICE(0x144d, 0xa808),   /* Samsung X5 */
+		.driver_data =  NVME_QUIRK_DELAY_BEFORE_CHK_RDY|
+				NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
-- 
2.35.1


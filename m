Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA76E5074
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 20:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjDQSz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 14:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjDQSz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 14:55:56 -0400
Received: from mail.bakkin.moe (mail.bakkin.moe [107.173.146.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F8F171A
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dory.moe; s=bakkinselector;
        t=1681757850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tgx2HMGIPIuMqmn4yN/WyN5Xlwe7YLVaoJwihie3au0=;
        b=KwnsaM+tL0LBTpowm7VTNt00bf+YVKbFLFQ+b8PN6ja2O1BLbdzZfTSkscnpQXzzEv4De2
        x7v0k1Ee6+QH9gjaCxDxb29YFCipy5ZfOfWOrvE2Tu/2E71toUQdGZbMQHQZtOB+MRUpzL
        aCGZfv5POxKeeBxDb/KS0LWFiElsw9zAzfFW6Z1OcAwP07fsmVp3aVdb7xjXPhhtn9WnyT
        gL5knmbTZBwCm91/gSASC0YpngmFRBcjGQ0G80zthuo59c5eHEWvLtSGu6f/FEHOAiBiIh
        xFlC5nfUcL0NK3fy/lo3rt7ip5VNtyI+gdf76AFEXIc7lBZlGBc8Kj/S7SneaA==
Received: by bakkin.moe (OpenSMTPD) with ESMTPSA id eb0bdfff (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 17 Apr 2023 18:57:29 +0000 (UTC)
From:   Duy Truong <dory@dory.moe>
To:     stable@vger.kernel.org
Cc:     Duy Truong <dory@dory.moe>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.15.y] nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD
Date:   Mon, 17 Apr 2023 11:56:24 -0700
Message-Id: <20230417185624.366852-1-dory@dory.moe>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023041705-dreaded-verify-10da@gregkh>
References: <2023041705-dreaded-verify-10da@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Added a quirk to fix the TeamGroup T-Force Cardea Zero Z330 SSDs reporting
duplicate NGUIDs.

Signed-off-by: Duy Truong <dory@dory.moe>
Cc: stable@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
(cherry picked from commit 74391b3e69855e7dd65a9cef36baf5fc1345affd)
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6539332b42b3..2459c82b4312 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3388,6 +3388,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x10ec, 0x5763), /* TEAMGROUP T-FORCE CARDEA ZERO Z330 SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.40.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C566E5059
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 20:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjDQSmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 14:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQSmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 14:42:17 -0400
Received: from mail.bakkin.moe (mail.bakkin.moe [107.173.146.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3CC44BE
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 11:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dory.moe; s=bakkinselector;
        t=1681757033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Es6EqQTXqTn2PTsUf4Sx6on8j5t1jC5CR1RQomoz3Bo=;
        b=OhkhIE7HZeJDe5s/a8GnVSbFnOG9bjQWlphBaDQOCKi8wy8/+3ZW3frfFCIaF/T/n8V1aW
        wb8+U5Z2bPps78QFuWl84Yw11Rh3S7jPLmhahp8i8q+ggyGz2oN73SIS/ktjjsaDijmwQv
        xdbe6FcuGljHn+Q77+vGHX0gkFCvn60uuq7BhT6pD8Wu/phkEKgS1bLCB8o56TqGEtWc48
        +88TCGRuQWHKM3LegH16Evp3/+WLBZrNvfZ9iPcd97t1DC5OOCnLVQ8HHfltnsc4yzBiif
        k7q5JSLg6tLeH6cdJnwmJypJlR9w8HMXphXX68VFHRfE6rjPpIFUSz5irHalYw==
Received: by bakkin.moe (OpenSMTPD) with ESMTPSA id 286e37cc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 17 Apr 2023 18:43:53 +0000 (UTC)
From:   Duy Truong <dory@dory.moe>
To:     stable@vger.kernel.org
Cc:     Duy Truong <dory@dory.moe>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1.y] nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD
Date:   Mon, 17 Apr 2023 11:42:49 -0700
Message-Id: <20230417184249.366591-1-dory@dory.moe>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023041704-perch-bullion-073e@gregkh>
References: <2023041704-perch-bullion-073e@gregkh>
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
index 60452f6a9f71..8f06b5a9996f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3551,6 +3551,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x10ec, 0x5763), /* TEAMGROUP T-FORCE CARDEA ZERO Z330 SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.40.0


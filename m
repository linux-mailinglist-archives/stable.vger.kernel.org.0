Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5BC6E1966
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 03:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjDNBCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 21:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNBCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 21:02:53 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 18:02:52 PDT
Received: from mail.bakkin.moe (mail.bakkin.moe [107.173.146.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309372738
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 18:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dory.moe; s=bakkinselector;
        t=1681433865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7mOoC0r8zllUiWXDJ1hTEOYTwfoq/RwV/PhlcywX7jk=;
        b=FXlswQLUxZzHipiv1AYGvhew5yvqM8Sw4D9hxUcjEFPwdo56oGzf9p+fcD+P9RbGgh09NN
        oKPNuLPddQmJF2SIF5xxCm5ftCTKhY2DewSoVQrHAffTsaqFm7pG7ZqXxdP/tV7MvRiH4v
        6EopSkIHjmE3djL52bzC9MUpnDpZ0T24Z1Sugyyums1DNRHGIL1/gDymSm05aykRUIoguA
        eIcJCfqXhwmfgZktzphZQyQkFyKfe1aICGCQdDuSSikDkpqm3BSvTNetmQrDi/LSMn0qs9
        q8dDDw4Wixagug+05fKNncDGKXt/oVxuP76PwWPiXLym2pY07nH7paqLFXG5rg==
Received: by bakkin.moe (OpenSMTPD) with ESMTPSA id eaf535d7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 14 Apr 2023 00:57:45 +0000 (UTC)
From:   Duy Truong <dory@dory.moe>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org, axboe@fb.com,
        hch@lst.de, sagi@grimberg.me
Cc:     Duy Truong <dory@dory.moe>, stable@vger.kernel.org
Subject: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD
Date:   Thu, 13 Apr 2023 17:55:48 -0700
Message-Id: <20230414005548.300794-1-dory@dory.moe>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Added a quirk to fix the TeamGroup T-Force Cardea Zero Z330 SSDs reporting
duplicate NGUIDs.

Signed-off-by: Duy Truong <dory@dory.moe>
Cc: stable@vger.kernel.org
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 282d808400c5..cd7873de3121 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3443,6 +3443,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
 		.driver_data = NVME_QUIRK_BOGUS_NID |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x10ec, 0x5763), /* TEAMGROUP T-FORCE CARDEA ZERO Z330 SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.40.0


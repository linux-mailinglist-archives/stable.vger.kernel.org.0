Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F4C42698D
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbhJHLjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240934AbhJHLgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B041861183;
        Fri,  8 Oct 2021 11:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692730;
        bh=6Ax/kxMoUUwKjmT5bIwfNhAeU8X6vvnp0Cpm0l6vz30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=at/YXHpd9QFo4hr9KK3h40W9QFhvHSxD3kVUE/dPsBa8KjC7a37C7PisZruEVjVp1
         xs3QyY9E2ylboYgFZN5/SKCr8LTuULV3bGqQZAuKN5baJglA71fmJYC0lUFi+hxtX7
         m6VJCCAmxRpOgBgbbWgko4ATGzS7BR9qTHFqD1Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 19/48] habanalabs/gaudi: use direct MSI in single mode
Date:   Fri,  8 Oct 2021 13:27:55 +0200
Message-Id: <20211008112720.658942876@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

[ Upstream commit 3e08f157c2587fc7ada93abed41aae19bcbf8a6b ]

Due to FLR scenario when running inside a VM, we must not use indirect
MSI because it might cause some issues on VM destroy.
In a VM we use single MSI mode in contrary to multi MSI mode which is
used in bare-metal.
Hence direct MSI should be used in single MSI mode only.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c                    | 9 ++++++---
 .../misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h  | 2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 409f05c962f2..8a9c4f0f37f9 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -5620,6 +5620,7 @@ static void gaudi_add_end_of_cb_packets(struct hl_device *hdev,
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
 	struct packet_msg_prot *cq_pkt;
+	u64 msi_addr;
 	u32 tmp;
 
 	cq_pkt = kernel_address + len - (sizeof(struct packet_msg_prot) * 2);
@@ -5641,10 +5642,12 @@ static void gaudi_add_end_of_cb_packets(struct hl_device *hdev,
 	cq_pkt->ctl = cpu_to_le32(tmp);
 	cq_pkt->value = cpu_to_le32(1);
 
-	if (!gaudi->multi_msi_mode)
-		msi_vec = 0;
+	if (gaudi->multi_msi_mode)
+		msi_addr = mmPCIE_MSI_INTR_0 + msi_vec * 4;
+	else
+		msi_addr = mmPCIE_CORE_MSI_REQ;
 
-	cq_pkt->addr = cpu_to_le64(CFG_BASE + mmPCIE_MSI_INTR_0 + msi_vec * 4);
+	cq_pkt->addr = cpu_to_le64(CFG_BASE + msi_addr);
 }
 
 static void gaudi_update_eq_ci(struct hl_device *hdev, u32 val)
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h
index 5bb54b34a8ae..907644202b0c 100644
--- a/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h
@@ -305,6 +305,8 @@
 #define mmPCIE_AUX_FLR_CTRL                                          0xC07394
 #define mmPCIE_AUX_DBI                                               0xC07490
 
+#define mmPCIE_CORE_MSI_REQ                                          0xC04100
+
 #define mmPSOC_PCI_PLL_NR                                            0xC72100
 #define mmSRAM_W_PLL_NR                                              0x4C8100
 #define mmPSOC_HBM_PLL_NR                                            0xC74100
-- 
2.33.0




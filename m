Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6903341A796
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbhI1F6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239144AbhI1F5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11A48611BD;
        Tue, 28 Sep 2021 05:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808568;
        bh=6Ax/kxMoUUwKjmT5bIwfNhAeU8X6vvnp0Cpm0l6vz30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6aeRRFgIzDkzQsOCKCjeKGDjO3cg8BqsbdzfIJBN5fS6Jfrgk5Ui3nnqaah8WIw4
         IkHNcRusQX2hOWTkLehiLWr8OJPuZxS78GxASYtL190G96qdj88W4E0Jnd7cwOslS6
         HStX02NHQKB4RUnKIXiHK3GkNjwcFT6naT3pkbJWpQ51ilrcE7cKBHZxsQEUSHMHd7
         3Utq8CRebV6919fGam5XlO7QQnJtuH9uQgcHsl6SwHzqC0H/BbTRXlEeJlabzBGIiw
         I7JUXcFUK8+23jzS9qYQgRmotCqq+x6VP5FLhv5MN1IUX1Txn5qtlqnunfujwKr7od
         1/Y9wCrzifuKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, obitton@habana.ai, osharabi@habana.ai,
        kelbaz@habana.ai, fkassabri@habana.ai, ynudelman@habana.ai,
        amizrahi@habana.ai
Subject: [PATCH AUTOSEL 5.14 20/40] habanalabs/gaudi: use direct MSI in single mode
Date:   Tue, 28 Sep 2021 01:55:04 -0400
Message-Id: <20210928055524.172051-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


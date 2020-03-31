Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3954F199197
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbgCaJO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730391AbgCaJO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:14:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 999122072E;
        Tue, 31 Mar 2020 09:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646065;
        bh=l6DvBGw4cKYvjyvNNBYmUeY/T80hQ8zM0ealCYAMkT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxp7pjgC4getO6scqwh7xv0DHIzLD/oKR798saECooSPCeuP8t34HmRqIN4OzKRjM
         AfuR8LnmHSP2EuZ55oSnucpoDYewIgV09qmdv+jR4g4sGwT7YITVwE9ceH4+dwu0d4
         3/rZttJFs2gZHd9H02lXchVMQF64nhfWaY8gfjuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Megha Dey <megha.dey@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/155] iommu/vt-d: Fix debugfs register reads
Date:   Tue, 31 Mar 2020 10:58:33 +0200
Message-Id: <20200331085426.574364408@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

[ Upstream commit ba3b01d7a6f4ab9f8a0557044c9a7678f64ae070 ]

Commit 6825d3ea6cde ("iommu/vt-d: Add debugfs support to show register
contents") dumps the register contents for all IOMMU devices.

Currently, a 64 bit read(dmar_readq) is done for all the IOMMU registers,
even though some of the registers are 32 bits, which is incorrect.

Use the correct read function variant (dmar_readl/dmar_readq) while
reading the contents of 32/64 bit registers respectively.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Link: https://lore.kernel.org/r/1583784587-26126-2-git-send-email-megha.dey@linux.intel.com
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu-debugfs.c | 40 ++++++++++++++++++-----------
 include/linux/intel-iommu.h         |  2 ++
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/intel-iommu-debugfs.c b/drivers/iommu/intel-iommu-debugfs.c
index 471f05d452e01..80378c10dd77a 100644
--- a/drivers/iommu/intel-iommu-debugfs.c
+++ b/drivers/iommu/intel-iommu-debugfs.c
@@ -32,38 +32,42 @@ struct iommu_regset {
 
 #define IOMMU_REGSET_ENTRY(_reg_)					\
 	{ DMAR_##_reg_##_REG, __stringify(_reg_) }
-static const struct iommu_regset iommu_regs[] = {
+
+static const struct iommu_regset iommu_regs_32[] = {
 	IOMMU_REGSET_ENTRY(VER),
-	IOMMU_REGSET_ENTRY(CAP),
-	IOMMU_REGSET_ENTRY(ECAP),
 	IOMMU_REGSET_ENTRY(GCMD),
 	IOMMU_REGSET_ENTRY(GSTS),
-	IOMMU_REGSET_ENTRY(RTADDR),
-	IOMMU_REGSET_ENTRY(CCMD),
 	IOMMU_REGSET_ENTRY(FSTS),
 	IOMMU_REGSET_ENTRY(FECTL),
 	IOMMU_REGSET_ENTRY(FEDATA),
 	IOMMU_REGSET_ENTRY(FEADDR),
 	IOMMU_REGSET_ENTRY(FEUADDR),
-	IOMMU_REGSET_ENTRY(AFLOG),
 	IOMMU_REGSET_ENTRY(PMEN),
 	IOMMU_REGSET_ENTRY(PLMBASE),
 	IOMMU_REGSET_ENTRY(PLMLIMIT),
+	IOMMU_REGSET_ENTRY(ICS),
+	IOMMU_REGSET_ENTRY(PRS),
+	IOMMU_REGSET_ENTRY(PECTL),
+	IOMMU_REGSET_ENTRY(PEDATA),
+	IOMMU_REGSET_ENTRY(PEADDR),
+	IOMMU_REGSET_ENTRY(PEUADDR),
+};
+
+static const struct iommu_regset iommu_regs_64[] = {
+	IOMMU_REGSET_ENTRY(CAP),
+	IOMMU_REGSET_ENTRY(ECAP),
+	IOMMU_REGSET_ENTRY(RTADDR),
+	IOMMU_REGSET_ENTRY(CCMD),
+	IOMMU_REGSET_ENTRY(AFLOG),
 	IOMMU_REGSET_ENTRY(PHMBASE),
 	IOMMU_REGSET_ENTRY(PHMLIMIT),
 	IOMMU_REGSET_ENTRY(IQH),
 	IOMMU_REGSET_ENTRY(IQT),
 	IOMMU_REGSET_ENTRY(IQA),
-	IOMMU_REGSET_ENTRY(ICS),
 	IOMMU_REGSET_ENTRY(IRTA),
 	IOMMU_REGSET_ENTRY(PQH),
 	IOMMU_REGSET_ENTRY(PQT),
 	IOMMU_REGSET_ENTRY(PQA),
-	IOMMU_REGSET_ENTRY(PRS),
-	IOMMU_REGSET_ENTRY(PECTL),
-	IOMMU_REGSET_ENTRY(PEDATA),
-	IOMMU_REGSET_ENTRY(PEADDR),
-	IOMMU_REGSET_ENTRY(PEUADDR),
 	IOMMU_REGSET_ENTRY(MTRRCAP),
 	IOMMU_REGSET_ENTRY(MTRRDEF),
 	IOMMU_REGSET_ENTRY(MTRR_FIX64K_00000),
@@ -126,10 +130,16 @@ static int iommu_regset_show(struct seq_file *m, void *unused)
 		 * by adding the offset to the pointer (virtual address).
 		 */
 		raw_spin_lock_irqsave(&iommu->register_lock, flag);
-		for (i = 0 ; i < ARRAY_SIZE(iommu_regs); i++) {
-			value = dmar_readq(iommu->reg + iommu_regs[i].offset);
+		for (i = 0 ; i < ARRAY_SIZE(iommu_regs_32); i++) {
+			value = dmar_readl(iommu->reg + iommu_regs_32[i].offset);
+			seq_printf(m, "%-16s\t0x%02x\t\t0x%016llx\n",
+				   iommu_regs_32[i].regs, iommu_regs_32[i].offset,
+				   value);
+		}
+		for (i = 0 ; i < ARRAY_SIZE(iommu_regs_64); i++) {
+			value = dmar_readq(iommu->reg + iommu_regs_64[i].offset);
 			seq_printf(m, "%-16s\t0x%02x\t\t0x%016llx\n",
-				   iommu_regs[i].regs, iommu_regs[i].offset,
+				   iommu_regs_64[i].regs, iommu_regs_64[i].offset,
 				   value);
 		}
 		raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 6d8bf4bdf240d..1e5dad8b8e59b 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -120,6 +120,8 @@
 
 #define dmar_readq(a) readq(a)
 #define dmar_writeq(a,v) writeq(v,a)
+#define dmar_readl(a) readl(a)
+#define dmar_writel(a, v) writel(v, a)
 
 #define DMAR_VER_MAJOR(v)		(((v) & 0xf0) >> 4)
 #define DMAR_VER_MINOR(v)		((v) & 0x0f)
-- 
2.20.1




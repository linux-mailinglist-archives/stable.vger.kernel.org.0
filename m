Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ECA490DEC
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbiAQRGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52218 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242460AbiAQREc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:04:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C158B8114A;
        Mon, 17 Jan 2022 17:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B15C36AEF;
        Mon, 17 Jan 2022 17:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439069;
        bh=TCMAxjkJB9dgoIXSVmuuBks01Ti+Fg5Kyhrp6E1okHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQ+EDwaa9ZsIx0ouOYzzO4tq80aFsB677SzMKGqxoK8f6DfOd0MyNAflOHlo9WYfc
         u1xyuNeDLfZxzMLLMRu/Cy4jnqrBMV+hZlfgGrZK6ZQNf3Y9AMP+r5Mm9qGifjHVdG
         E49k9wdndo8ZbQeNMT21N3zjXDPfEqy3pX5VSYlojvGvYvTdkKi75HYDGYjgU2SMZS
         Y5LVmsKyciKxaiPPjrVjHw8pZwJzivgEn0+AnBHLvsIzBtj0mLHDlau4z3RJwjeaSF
         iSgulIZuwkgPElLRyoAC9G4nVkg1/LZACLnz2p9UUdY8IG8bv2YltRPmWNmsmxwPaj
         EWjYmX/nfWYIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Jay Chen <jkchen@linux.alibaba.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.10 27/34] irqchip/gic-v4: Disable redistributors' view of the VPE table at boot time
Date:   Mon, 17 Jan 2022 12:03:17 -0500
Message-Id: <20220117170326.1471712-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 79a7f77b9b154d572bd9d2f1eecf58c4d018d8e2 ]

Jay Chen reported that using a kdump kernel on a GICv4.1 system
results in a RAS error being delivered when the secondary kernel
configures the ITS's view of the new VPE table.

As it turns out, that's because each RD still has a pointer to
the previous instance of the VPE table, and that particular
implementation is very upset by seeing two bits of the HW that
should point to the same table with different values.

To solve this, let's invalidate any reference that any RD has to
the VPE table when discovering the RDs. The ITS can then be
programmed as expected.

Reported-by: Jay Chen <jkchen@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/20211214064716.21407-1-jkchen@linux.alibaba.com
Link: https://lore.kernel.org/r/20211216144804.1578566-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 1bdb7acf445f4..04d1b3963b6ba 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -915,6 +915,22 @@ static int __gic_update_rdist_properties(struct redist_region *region,
 {
 	u64 typer = gic_read_typer(ptr + GICR_TYPER);
 
+	/* Boot-time cleanip */
+	if ((typer & GICR_TYPER_VLPIS) && (typer & GICR_TYPER_RVPEID)) {
+		u64 val;
+
+		/* Deactivate any present vPE */
+		val = gicr_read_vpendbaser(ptr + SZ_128K + GICR_VPENDBASER);
+		if (val & GICR_VPENDBASER_Valid)
+			gicr_write_vpendbaser(GICR_VPENDBASER_PendingLast,
+					      ptr + SZ_128K + GICR_VPENDBASER);
+
+		/* Mark the VPE table as invalid */
+		val = gicr_read_vpropbaser(ptr + SZ_128K + GICR_VPROPBASER);
+		val &= ~GICR_VPROPBASER_4_1_VALID;
+		gicr_write_vpropbaser(val, ptr + SZ_128K + GICR_VPROPBASER);
+	}
+
 	gic_data.rdists.has_vlpis &= !!(typer & GICR_TYPER_VLPIS);
 
 	/* RVPEID implies some form of DirectLPI, no matter what the doc says... :-/ */
-- 
2.34.1


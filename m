Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144E449A9D7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323730AbiAYD3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347317AbiAXVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C712C055A97;
        Mon, 24 Jan 2022 12:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09BF161357;
        Mon, 24 Jan 2022 20:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB007C340E5;
        Mon, 24 Jan 2022 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054671;
        bh=TCMAxjkJB9dgoIXSVmuuBks01Ti+Fg5Kyhrp6E1okHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlqVVy0Ri6sg23/kQTRjdVd/x31vNOqjesvEa0NlsqOD4GYPRA7DDaZJtJxJwjVKa
         EA+ehfVAXiU3c3O7MXaTgfFrsvJTKbvLT46WsyfxDMVyKa3u6gCHgorvLh3kkYgiN0
         RrWanrZ/q3Kk/ad3fuwHELo0lf85K6PsrkoKbdSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Chen <jkchen@linux.alibaba.com>,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/563] irqchip/gic-v4: Disable redistributors view of the VPE table at boot time
Date:   Mon, 24 Jan 2022 19:43:18 +0100
Message-Id: <20220124184039.425602485@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




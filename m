Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02950167229
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbgBUIAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730649AbgBUIAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:00:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB4F4206ED;
        Fri, 21 Feb 2020 08:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272048;
        bh=TWzxZdh+1w/QN9Qql6vnCAe/bCVTUibqvLYrczzLyag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWni3B6WyJfZeTLItnORaIyUmkPLOmlPEic644lXPPgTdIFQ7m0b/S92TLZ7e2HDR
         lHemk/04rWYDXAcm2D52N/VtvksXsXkERIQXq+YD9W5ISmST2vFKlfjwXs0ksFDr5h
         wdeG3mxa6MfgKXDgPzIXXWhwAT1+CZdrTfRvINAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Heyi Guo <guoheyi@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 359/399] irqchip/gic-v3: Only provision redistributors that are enabled in ACPI
Date:   Fri, 21 Feb 2020 08:41:24 +0100
Message-Id: <20200221072435.666064688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 926b5dfa6b8dc666ff398044af6906b156e1d949 ]

We currently allocate redistributor region structures for
individual redistributors when ACPI doesn't present us with
compact MMIO regions covering multiple redistributors.

It turns out that we allocate these structures even when
the redistributor is flagged as disabled by ACPI. It works
fine until someone actually tries to tarse one of these
structures, and access the corresponding MMIO region.

Instead, track the number of enabled redistributors, and
only allocate what is required. This makes sure that there
is no invalid data to misuse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reported-by: Heyi Guo <guoheyi@huawei.com>
Tested-by: Heyi Guo <guoheyi@huawei.com>
Link: https://lore.kernel.org/r/20191216062745.63397-1-guoheyi@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index d6218012097b4..3f5baa5043db4 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1821,6 +1821,7 @@ static struct
 	struct redist_region *redist_regs;
 	u32 nr_redist_regions;
 	bool single_redist;
+	int enabled_rdists;
 	u32 maint_irq;
 	int maint_irq_mode;
 	phys_addr_t vcpu_base;
@@ -1915,8 +1916,10 @@ static int __init gic_acpi_match_gicc(union acpi_subtable_headers *header,
 	 * If GICC is enabled and has valid gicr base address, then it means
 	 * GICR base is presented via GICC
 	 */
-	if ((gicc->flags & ACPI_MADT_ENABLED) && gicc->gicr_base_address)
+	if ((gicc->flags & ACPI_MADT_ENABLED) && gicc->gicr_base_address) {
+		acpi_data.enabled_rdists++;
 		return 0;
+	}
 
 	/*
 	 * It's perfectly valid firmware can pass disabled GICC entry, driver
@@ -1946,8 +1949,10 @@ static int __init gic_acpi_count_gicr_regions(void)
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
 				      gic_acpi_match_gicc, 0);
-	if (count > 0)
+	if (count > 0) {
 		acpi_data.single_redist = true;
+		count = acpi_data.enabled_rdists;
+	}
 
 	return count;
 }
-- 
2.20.1




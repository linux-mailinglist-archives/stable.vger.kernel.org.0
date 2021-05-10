Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C723E3788DA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhEJLY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhEJLLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 707FA60FEF;
        Mon, 10 May 2021 11:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644971;
        bh=8TUX8ebQCnnosyGIob6anlDtDbTdnqT6huL51mjRUGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvY6VMTIEEAyRqsv6012+0xZw2KGmcPeNO2DKfKgDmeqAtst4dZUlWhOIi4vs3Cws
         Z1j5qhsIDcYBXpN/gUrWviqOy0yc2emwJoEI3yM6ZoMhctLtXibE5RFNLq+fsGnSY4
         9t2YMW1CJD+9owJsZBU2iCYFyTCMFfLOjlv71IB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dann frazier <dann.frazier@canonical.com>,
        Marc Zyngier <maz@kernel.org>, Fu Wei <wefu@redhat.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.12 297/384] ACPI: GTDT: Dont corrupt interrupt mappings on watchdow probe failure
Date:   Mon, 10 May 2021 12:21:26 +0200
Message-Id: <20210510102024.600221970@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 1ecd5b129252249b9bc03d7645a7bda512747277 upstream.

When failing the driver probe because of invalid firmware properties,
the GTDT driver unmaps the interrupt that it mapped earlier.

However, it never checks whether the mapping of the interrupt actially
succeeded. Even more, should the firmware report an illegal interrupt
number that overlaps with the GIC SGI range, this can result in an
IPI being unmapped, and subsequent fireworks (as reported by Dann
Frazier).

Rework the driver to have a slightly saner behaviour and actually
check whether the interrupt has been mapped before unmapping things.

Reported-by: dann frazier <dann.frazier@canonical.com>
Fixes: ca9ae5ec4ef0 ("acpi/arm64: Add SBSA Generic Watchdog support in GTDT driver")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/YH87dtTfwYgavusz@xps13.dannf
Cc: <stable@vger.kernel.org>
Cc: Fu Wei <wefu@redhat.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: dann frazier <dann.frazier@canonical.com>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/20210421164317.1718831-2-maz@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/gtdt.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/acpi/arm64/gtdt.c
+++ b/drivers/acpi/arm64/gtdt.c
@@ -329,7 +329,7 @@ static int __init gtdt_import_sbsa_gwdt(
 					int index)
 {
 	struct platform_device *pdev;
-	int irq = map_gt_gsi(wd->timer_interrupt, wd->timer_flags);
+	int irq;
 
 	/*
 	 * According to SBSA specification the size of refresh and control
@@ -338,7 +338,7 @@ static int __init gtdt_import_sbsa_gwdt(
 	struct resource res[] = {
 		DEFINE_RES_MEM(wd->control_frame_address, SZ_4K),
 		DEFINE_RES_MEM(wd->refresh_frame_address, SZ_4K),
-		DEFINE_RES_IRQ(irq),
+		{},
 	};
 	int nr_res = ARRAY_SIZE(res);
 
@@ -348,10 +348,11 @@ static int __init gtdt_import_sbsa_gwdt(
 
 	if (!(wd->refresh_frame_address && wd->control_frame_address)) {
 		pr_err(FW_BUG "failed to get the Watchdog base address.\n");
-		acpi_unregister_gsi(wd->timer_interrupt);
 		return -EINVAL;
 	}
 
+	irq = map_gt_gsi(wd->timer_interrupt, wd->timer_flags);
+	res[2] = (struct resource)DEFINE_RES_IRQ(irq);
 	if (irq <= 0) {
 		pr_warn("failed to map the Watchdog interrupt.\n");
 		nr_res--;
@@ -364,7 +365,8 @@ static int __init gtdt_import_sbsa_gwdt(
 	 */
 	pdev = platform_device_register_simple("sbsa-gwdt", index, res, nr_res);
 	if (IS_ERR(pdev)) {
-		acpi_unregister_gsi(wd->timer_interrupt);
+		if (irq > 0)
+			acpi_unregister_gsi(wd->timer_interrupt);
 		return PTR_ERR(pdev);
 	}
 



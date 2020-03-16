Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B3E1861FD
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgCPCfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbgCPCfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:35:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFCC2072A;
        Mon, 16 Mar 2020 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326106;
        bh=2hY2yy0nVV7zzzENxHxzh6cBEDGz8r3oejDRBC2kBmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ejjmdy/mLDF6FL3tWsus3qlbfqR1b2xvGIj5mn1H8S4rGpIIb0KbKlMCgD3c5CAtk
         Kcq1rqua0Tw0r+PCr4CIjO4KC+blzj62cGwvRLOF8S0Z+kwuQLE3QVo/IXmqy+iGHK
         99laEcqw1NPj+OPA5nroxDHyxXCL/7M5vUPWvW7E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     luanshi <zhangliguang@linux.alibaba.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 10/20] drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer
Date:   Sun, 15 Mar 2020 22:34:43 -0400
Message-Id: <20200316023453.1800-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023453.1800-1-sashal@kernel.org>
References: <20200316023453.1800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: luanshi <zhangliguang@linux.alibaba.com>

[ Upstream commit 3ba52ad55b533760a1f65836aa0ec9d35e36bb4f ]

Fix bogus NULL checks on the return value of acpi_cpu_get_madt_gicc()
by checking for a 0 'gicc->performance_interrupt' value instead.

Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmu_acpi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/arm_pmu_acpi.c b/drivers/perf/arm_pmu_acpi.c
index 0f197516d7089..9a6f7f822566f 100644
--- a/drivers/perf/arm_pmu_acpi.c
+++ b/drivers/perf/arm_pmu_acpi.c
@@ -27,8 +27,6 @@ static int arm_pmu_acpi_register_irq(int cpu)
 	int gsi, trigger;
 
 	gicc = acpi_cpu_get_madt_gicc(cpu);
-	if (WARN_ON(!gicc))
-		return -EINVAL;
 
 	gsi = gicc->performance_interrupt;
 
@@ -67,11 +65,10 @@ static void arm_pmu_acpi_unregister_irq(int cpu)
 	int gsi;
 
 	gicc = acpi_cpu_get_madt_gicc(cpu);
-	if (!gicc)
-		return;
 
 	gsi = gicc->performance_interrupt;
-	acpi_unregister_gsi(gsi);
+	if (gsi)
+		acpi_unregister_gsi(gsi);
 }
 
 static int arm_pmu_acpi_parse_irqs(void)
-- 
2.20.1


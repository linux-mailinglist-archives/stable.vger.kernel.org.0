Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E202186300
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgCPCjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729893AbgCPCef (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616012073C;
        Mon, 16 Mar 2020 02:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326075;
        bh=jM7Fews3e1MESegyezgjrz7anoNSo3IuYP4oG7HKigc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/Et20zv5LYIKr4B0pRC7OO8Ocx8P8xsuhVVoZiAfOv3/xi/lu/5+HP9A/IugNq2O
         sj8em3dC1PhBTD/cKDPNef9w1WAk6v0WFRyUDqpaJI0vN5onMjA+TwbKl3jeVf173f
         vARlKQxVLTOgZQfX+a+4gm1BoaCgN6atYwnHpbnc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     luanshi <zhangliguang@linux.alibaba.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 20/35] drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer
Date:   Sun, 15 Mar 2020 22:33:56 -0400
Message-Id: <20200316023411.1263-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
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
index acce8781c456c..f5c7a845cd7bf 100644
--- a/drivers/perf/arm_pmu_acpi.c
+++ b/drivers/perf/arm_pmu_acpi.c
@@ -24,8 +24,6 @@ static int arm_pmu_acpi_register_irq(int cpu)
 	int gsi, trigger;
 
 	gicc = acpi_cpu_get_madt_gicc(cpu);
-	if (WARN_ON(!gicc))
-		return -EINVAL;
 
 	gsi = gicc->performance_interrupt;
 
@@ -64,11 +62,10 @@ static void arm_pmu_acpi_unregister_irq(int cpu)
 	int gsi;
 
 	gicc = acpi_cpu_get_madt_gicc(cpu);
-	if (!gicc)
-		return;
 
 	gsi = gicc->performance_interrupt;
-	acpi_unregister_gsi(gsi);
+	if (gsi)
+		acpi_unregister_gsi(gsi);
 }
 
 #if IS_ENABLED(CONFIG_ARM_SPE_PMU)
-- 
2.20.1


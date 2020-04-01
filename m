Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FA519B22D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389164AbgDAQlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388265AbgDAQll (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:41:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09AA320719;
        Wed,  1 Apr 2020 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759300;
        bh=43+7cUiKLkoOj2SVKxaj6tMcNBy8dpXDhSh3pCvkzNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1OUMYls6IlWymdjJlSAsUpg5hgq3UZGnJCyC5tetQt661tdE/57aRyXnv9m1blEjd
         6eDWCpsohDamZ+TqMknDMOgKcI0CPk3Xxe6HcPyQkR/1apEBWBI7QsanXeCJfGOQZJ
         1rTExxXjOyrAmW/fDIOd7Qry0mRWvuJUxY3A1B3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 008/148] drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer
Date:   Wed,  1 Apr 2020 18:16:40 +0200
Message-Id: <20200401161553.004464575@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3303dd8d8eb57..604e549a9a47d 100644
--- a/drivers/perf/arm_pmu_acpi.c
+++ b/drivers/perf/arm_pmu_acpi.c
@@ -25,8 +25,6 @@ static int arm_pmu_acpi_register_irq(int cpu)
 	int gsi, trigger;
 
 	gicc = acpi_cpu_get_madt_gicc(cpu);
-	if (WARN_ON(!gicc))
-		return -EINVAL;
 
 	gsi = gicc->performance_interrupt;
 
@@ -65,11 +63,10 @@ static void arm_pmu_acpi_unregister_irq(int cpu)
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




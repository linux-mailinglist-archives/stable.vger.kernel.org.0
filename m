Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A32CFA5D7
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfKMCZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727968AbfKMBvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549F6222CA;
        Wed, 13 Nov 2019 01:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609906;
        bh=8OznHZtnyeuyoa0ykOvMSTWxOaJVdKSRPp8ZeapPiWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uj0RSs9XuIVRP7q2bMKCOdR3bkkVmZ7rnV0HUBJZMAK1nANR/opiCnF1oIg+tF18W
         dlzIdQnM75jzJ6llPm7qy6FMM2ghrC8EP3XgeY0BwvbZhhSV36tSsxLRWvMxtV0NcY
         mS89atsdcuYlam6B6hUG+mrhEiP41FA73JcbzjiQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhong jiang <zhongjiang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 057/209] powerpc/xive: Move a dereference below a NULL test
Date:   Tue, 12 Nov 2019 20:47:53 -0500
Message-Id: <20191113015025.9685-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit cd5ff94577e004e0a4457e70d0ef3a030f4010b8 ]

Move the dereference of xc below the NULL test.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/common.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 0b24b10312213..f3af53abd40fb 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1009,12 +1009,13 @@ static void xive_ipi_eoi(struct irq_data *d)
 {
 	struct xive_cpu *xc = __this_cpu_read(xive_cpu);
 
-	DBG_VERBOSE("IPI eoi: irq=%d [0x%lx] (HW IRQ 0x%x) pending=%02x\n",
-		    d->irq, irqd_to_hwirq(d), xc->hw_ipi, xc->pending_prio);
-
 	/* Handle possible race with unplug and drop stale IPIs */
 	if (!xc)
 		return;
+
+	DBG_VERBOSE("IPI eoi: irq=%d [0x%lx] (HW IRQ 0x%x) pending=%02x\n",
+		    d->irq, irqd_to_hwirq(d), xc->hw_ipi, xc->pending_prio);
+
 	xive_do_source_eoi(xc->hw_ipi, &xc->ipi_data);
 	xive_do_queue_eoi(xc);
 }
-- 
2.20.1


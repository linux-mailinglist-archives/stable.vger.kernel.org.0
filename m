Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4A1FA427
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbfKMCO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfKMB5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B5E22469;
        Wed, 13 Nov 2019 01:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610232;
        bh=HSeu81ZhvvwV6IqE4gBPPXBakWr3J/9nmvn+yNdGt48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrgtWJ912rclita6SWeMSRhb7BQx7SMk58yTD/vL5ivtMegO34p5my+4zCdTpblNQ
         pZy1NJqOrdR3zu3eJe0raM8LqnEJePYOej2ibhfuwCeah4tuDI2+0UPwZRhPq1YHuL
         pF8sT+3TlYGUfL22DjN67/10kH1ShdpC/V/HGBwc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhong jiang <zhongjiang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 033/115] powerpc/xive: Move a dereference below a NULL test
Date:   Tue, 12 Nov 2019 20:55:00 -0500
Message-Id: <20191113015622.11592-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
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
index 818fc5351591c..110d8bb16ebbb 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1008,12 +1008,13 @@ static void xive_ipi_eoi(struct irq_data *d)
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


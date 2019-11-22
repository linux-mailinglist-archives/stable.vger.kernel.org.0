Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55D106D4B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfKVK6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730840AbfKVK6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A584A20706;
        Fri, 22 Nov 2019 10:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420333;
        bh=8OznHZtnyeuyoa0ykOvMSTWxOaJVdKSRPp8ZeapPiWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ygc2jkj+yf0pL8lwLClt7y6F6xwpM/9SdAXj+8yfS6WLMXIeWx7QBRa2d71AfBrGm
         SX8/fDKGRQW7EMujV+Jp6QCUMjCd2q60iGHYR4k76/4MRu0opz09D6DumPwdOyk51Y
         JZwmN8lxYUU0imRxwTQGF72fo8SGkJdHYnfMv3Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhong jiang <zhongjiang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/220] powerpc/xive: Move a dereference below a NULL test
Date:   Fri, 22 Nov 2019 11:27:14 +0100
Message-Id: <20191122100917.144994583@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




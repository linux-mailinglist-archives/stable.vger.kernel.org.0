Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1C837CE49
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbhELREs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237819AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1698461D44;
        Wed, 12 May 2021 16:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836007;
        bh=fn2UXp4y+X5dMIm/b0g4wq0k+lSsScQT3f2YLLZgeBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAJTdKGmoGWXlXJccLdNta8JlzqDhDz8X6wIHW9lee26mVmw1evnFeaHPQsm68q8X
         s54ZKqpPVR9SHqR/L41VW5++Y9VczxjVcqRNccZu7nGXj3kJiXcl9L/F0l+FnSuN+e
         rzIFY5yJt4Obe64gLEenPvCjLmWwLLxbAH73Lqyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 573/677] powerpc/xive: Drop check on irq_data in xive_core_debug_show()
Date:   Wed, 12 May 2021 16:50:19 +0200
Message-Id: <20210512144856.430303852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit a74ce5926b20cd0e6d624a9b2527073a96dfed7f ]

When looping on IRQ descriptor, irq_data is always valid.

Fixes: 930914b7d528 ("powerpc/xive: Add a debugfs file to dump internal XIVE state")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210331144514.892250-6-clg@kaod.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/common.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 595310e056f4..6e43bba80707 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1599,6 +1599,8 @@ static void xive_debug_show_irq(struct seq_file *m, u32 hw_irq, struct irq_data
 	u32 target;
 	u8 prio;
 	u32 lirq;
+	struct xive_irq_data *xd;
+	u64 val;
 
 	if (!is_xive_irq(chip))
 		return;
@@ -1612,17 +1614,14 @@ static void xive_debug_show_irq(struct seq_file *m, u32 hw_irq, struct irq_data
 	seq_printf(m, "IRQ 0x%08x : target=0x%x prio=%02x lirq=0x%x ",
 		   hw_irq, target, prio, lirq);
 
-	if (d) {
-		struct xive_irq_data *xd = irq_data_get_irq_handler_data(d);
-		u64 val = xive_esb_read(xd, XIVE_ESB_GET);
-
-		seq_printf(m, "flags=%c%c%c PQ=%c%c",
-			   xd->flags & XIVE_IRQ_FLAG_STORE_EOI ? 'S' : ' ',
-			   xd->flags & XIVE_IRQ_FLAG_LSI ? 'L' : ' ',
-			   xd->flags & XIVE_IRQ_FLAG_H_INT_ESB ? 'H' : ' ',
-			   val & XIVE_ESB_VAL_P ? 'P' : '-',
-			   val & XIVE_ESB_VAL_Q ? 'Q' : '-');
-	}
+	xd = irq_data_get_irq_handler_data(d);
+	val = xive_esb_read(xd, XIVE_ESB_GET);
+	seq_printf(m, "flags=%c%c%c PQ=%c%c",
+		   xd->flags & XIVE_IRQ_FLAG_STORE_EOI ? 'S' : ' ',
+		   xd->flags & XIVE_IRQ_FLAG_LSI ? 'L' : ' ',
+		   xd->flags & XIVE_IRQ_FLAG_H_INT_ESB ? 'H' : ' ',
+		   val & XIVE_ESB_VAL_P ? 'P' : '-',
+		   val & XIVE_ESB_VAL_Q ? 'Q' : '-');
 	seq_puts(m, "\n");
 }
 
-- 
2.30.2




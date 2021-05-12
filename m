Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DF437C631
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbhELPta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233618AbhELPm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0A6D610F7;
        Wed, 12 May 2021 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832930;
        bh=nCrJ70O1uu7ssqKv0fZP2QVi2fD1GPLlergpqbbqiZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSbdvHht6zMmalT42eJapTIOTmgnQ4Rnhq4Wa34pPaddfF/BgAMzLpZPdCQj/lMNB
         6vfZIg3U6HAA4feh0dqKvTBNmM4f+b3/lkKud8jT5RmpMaH6sInMPNqfMIfwIoZC75
         0Qm7s6aPfpdpCzjTJPmfZSSlHxy9qiPmz5SErQ84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/530] powerpc/xive: Fix xmon command "dxi"
Date:   Wed, 12 May 2021 16:49:15 +0200
Message-Id: <20210512144834.398352746@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit 33e4bc5946432a4ac173fd08e8e30a13ab94d06d ]

When under xmon, the "dxi" command dumps the state of the XIVE
interrupts. If an interrupt number is specified, only the state of
the associated XIVE interrupt is dumped. This form of the command
lacks an irq_data parameter which is nevertheless used by
xmon_xive_get_irq_config(), leading to an xmon crash.

Fix that by doing a lookup in the system IRQ mapping to query the IRQ
descriptor data. Invalid interrupt numbers, or not belonging to the
XIVE IRQ domain, OPAL event interrupt number for instance, should be
caught by the previous query done at the firmware level.

Fixes: 97ef27507793 ("powerpc/xive: Fix xmon support on the PowerNV platform")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Tested-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210331144514.892250-8-clg@kaod.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/common.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 5899ffb28c58..5b0f6b6278e3 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -261,17 +261,20 @@ notrace void xmon_xive_do_dump(int cpu)
 	xmon_printf("\n");
 }
 
+static struct irq_data *xive_get_irq_data(u32 hw_irq)
+{
+	unsigned int irq = irq_find_mapping(xive_irq_domain, hw_irq);
+
+	return irq ? irq_get_irq_data(irq) : NULL;
+}
+
 int xmon_xive_get_irq_config(u32 hw_irq, struct irq_data *d)
 {
-	struct irq_chip *chip = irq_data_get_irq_chip(d);
 	int rc;
 	u32 target;
 	u8 prio;
 	u32 lirq;
 
-	if (!is_xive_irq(chip))
-		return -EINVAL;
-
 	rc = xive_ops->get_irq_config(hw_irq, &target, &prio, &lirq);
 	if (rc) {
 		xmon_printf("IRQ 0x%08x : no config rc=%d\n", hw_irq, rc);
@@ -281,6 +284,9 @@ int xmon_xive_get_irq_config(u32 hw_irq, struct irq_data *d)
 	xmon_printf("IRQ 0x%08x : target=0x%x prio=%02x lirq=0x%x ",
 		    hw_irq, target, prio, lirq);
 
+	if (!d)
+		d = xive_get_irq_data(hw_irq);
+
 	if (d) {
 		struct xive_irq_data *xd = irq_data_get_irq_handler_data(d);
 		u64 val = xive_esb_read(xd, XIVE_ESB_GET);
-- 
2.30.2




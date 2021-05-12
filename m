Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C31E37C235
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhELPHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232444AbhELPGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2B7561955;
        Wed, 12 May 2021 15:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831648;
        bh=/16dDmNvYVlxnKuY4DJUg6LCH4aOE9dIxnPsFX9iCeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myl6zSMBoIeUvXszYwkKlm5Mhbbh851vGl4XGHzVpVhLpjQvpRxzpqJB3pPtpNDDU
         hOjGhdHGMRmTkt162FBWLteTUTdSZ9n3QG0u0uivOaeAMIRy+UekVJKaYu3FZmo4V4
         0awmbUtFMQhIW+aWkjZuwGnQal18CEGCf+raRffg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/244] powerpc/xive: Fix xmon command "dxi"
Date:   Wed, 12 May 2021 16:49:36 +0200
Message-Id: <20210512144749.555504757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 16df9cc8f360..2d4c09a77910 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -257,17 +257,20 @@ notrace void xmon_xive_do_dump(int cpu)
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
@@ -277,6 +280,9 @@ int xmon_xive_get_irq_config(u32 hw_irq, struct irq_data *d)
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




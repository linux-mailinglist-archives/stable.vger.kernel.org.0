Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCA917C1F6
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 16:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCFPil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 10:38:41 -0500
Received: from 8.mo177.mail-out.ovh.net ([46.105.61.98]:41265 "EHLO
        8.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgCFPil (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 10:38:41 -0500
X-Greylist: delayed 2197 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2020 10:38:40 EST
Received: from player758.ha.ovh.net (unknown [10.108.42.228])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id E576D127791
        for <stable@vger.kernel.org>; Fri,  6 Mar 2020 16:02:01 +0100 (CET)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player758.ha.ovh.net (Postfix) with ESMTPSA id 5EBB1102B4F93;
        Fri,  6 Mar 2020 15:01:56 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Greg Kurz <groug@kaod.org>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] powerpc/xive: Fix xmon support on the PowerNV platform
Date:   Fri,  6 Mar 2020 16:01:41 +0100
Message-Id: <20200306150143.5551-3-clg@kaod.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200306150143.5551-1-clg@kaod.org>
References: <20200306150143.5551-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7343400669491530673
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrudduvddgjeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrieegrddvhedtrddujedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeehkedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PowerNV platform has multiple IRQ chips and the xmon command
dumping the state of the XIVE interrupt should only operate on the
XIVE IRQ chip.

Fixes: 5896163f7f91 ("powerpc/xmon: Improve output of XIVE interrupts")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/sysdev/xive/common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 550baba98ec9..8155adc2225a 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -261,11 +261,15 @@ notrace void xmon_xive_do_dump(int cpu)
 
 int xmon_xive_get_irq_config(u32 hw_irq, struct irq_data *d)
 {
+	struct irq_chip *chip = irq_data_get_irq_chip(d);
 	int rc;
 	u32 target;
 	u8 prio;
 	u32 lirq;
 
+	if (!is_xive_irq(chip))
+		return -EINVAL;
+
 	rc = xive_ops->get_irq_config(hw_irq, &target, &prio, &lirq);
 	if (rc) {
 		xmon_printf("IRQ 0x%08x : no config rc=%d\n", hw_irq, rc);
-- 
2.21.1


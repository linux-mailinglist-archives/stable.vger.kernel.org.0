Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3A6C0FF0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCTK62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCTK5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:57:50 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF3066EAE;
        Mon, 20 Mar 2023 03:54:38 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,274,1673881200"; 
   d="scan'208";a="156562966"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 20 Mar 2023 19:53:49 +0900
Received: from localhost.localdomain (unknown [10.226.92.205])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2A7E54004937;
        Mon, 20 Mar 2023 19:53:45 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 1/5] tty: serial: sh-sci: Fix transmit end interrupt handler
Date:   Mon, 20 Mar 2023 10:53:35 +0000
Message-Id: <20230320105339.236279-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230320105339.236279-1-biju.das.jz@bp.renesas.com>
References: <20230320105339.236279-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The fourth interrupt on SCI port is transmit end interrupt compared to
the break interrupt on other port types. So, shuffle the interrupts to fix
the transmit end interrupt handler.

Fixes: e1d0be616186 ("sh-sci: Add h8300 SCI")
Cc: stable@vger.kernel.org
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v2->v3:
 * Cced stable@vger.kernel.org
v1->v2:
 * Replaced the wrong fixes tag
 * Added a simpler check in sci_init_single() and added a check in
   probe to catch invalid interrupt count.
Tested the SCI0 interface on RZ/G2UL by connecting to PMOD USBUART.
 39:          0     GICv3 437 Level     1004d000.serial:rx err
 40:         12     GICv3 438 Edge      1004d000.serial:rx full
 41:         70     GICv3 439 Edge      1004d000.serial:tx empty
 42:         18     GICv3 440 Level     1004d000.serial:tx end
---
 drivers/tty/serial/sh-sci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index af4a7a865764..616041faab55 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -31,6 +31,7 @@
 #include <linux/ioport.h>
 #include <linux/ktime.h>
 #include <linux/major.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/of.h>
@@ -2864,6 +2865,13 @@ static int sci_init_single(struct platform_device *dev,
 			sci_port->irqs[i] = platform_get_irq(dev, i);
 	}
 
+	/*
+	 * The fourth interrupt on SCI port is transmit end interrupt, so
+	 * shuffle the interrupts.
+	 */
+	if (p->type == PORT_SCI)
+		swap(sci_port->irqs[SCIx_BRI_IRQ], sci_port->irqs[SCIx_TEI_IRQ]);
+
 	/* The SCI generates several interrupts. They can be muxed together or
 	 * connected to different interrupt lines. In the muxed case only one
 	 * interrupt resource is specified as there is only one interrupt ID.
-- 
2.25.1


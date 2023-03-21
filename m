Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0808E6C30B8
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjCULsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjCULsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:48:09 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF69D4A1DD;
        Tue, 21 Mar 2023 04:48:06 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,278,1673881200"; 
   d="scan'208";a="156652132"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 21 Mar 2023 20:48:06 +0900
Received: from localhost.localdomain (unknown [10.226.93.140])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id ECA8241E388B;
        Tue, 21 Mar 2023 20:48:03 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v4 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Date:   Tue, 21 Mar 2023 11:47:50 +0000
Message-Id: <20230321114753.75038-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SCI IP on RZ/G2L alike SoCs do not need regshift compared to other SCI
IPs on the SH platform. Currently, it does regshift and configuring Rx
wrongly. Drop adding regshift for RZ/G2L alike SoCs.

Fixes: dfc80387aefb ("serial: sh-sci: Compute the regshift value for SCI ports")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v3->v4:
 * Updated the fixes tag
 * Replaced sci_port->is_rz_sci with dev->dev.of_node as regshift are only needed
   for sh770x/sh7750/sh7760, which don't use DT yet.
 * Dropped is_rz_sci variable from struct sci_port.
v3:
 * New patch.
---
 drivers/tty/serial/sh-sci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 616041faab55..15954ca3e9dc 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2937,7 +2937,7 @@ static int sci_init_single(struct platform_device *dev,
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !dev->dev.of_node) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else
-- 
2.25.1


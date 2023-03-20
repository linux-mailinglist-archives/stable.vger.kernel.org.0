Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683F56C0FF2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCTK6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjCTK5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:57:52 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 106641ADFC;
        Mon, 20 Mar 2023 03:54:45 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,274,1673881200"; 
   d="scan'208";a="156562974"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 20 Mar 2023 19:53:52 +0900
Received: from localhost.localdomain (unknown [10.226.92.205])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 8356C4004937;
        Mon, 20 Mar 2023 19:53:49 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 2/5] tty: serial: sh-sci: Fix Rx on RZ/G2L SCI
Date:   Mon, 20 Mar 2023 10:53:36 +0000
Message-Id: <20230320105339.236279-3-biju.das.jz@bp.renesas.com>
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

SCI IP on RZ/G2L alike SoCs do not need regshift compared to other SCI
IPs on the SH platform. Currently, it does regshift and configuring Rx
wrongly. Drop adding regshift for RZ/G2L alike SoCs.

Fixes: f9a2adcc9e90 ("arm64: dts: renesas: r9a07g044: Add SCI[0-1] nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v3:
 * New patch.
---
 drivers/tty/serial/sh-sci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 616041faab55..b9cd27451f90 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -158,6 +158,7 @@ struct sci_port {
 
 	bool has_rtscts;
 	bool autorts;
+	bool is_rz_sci;
 };
 
 #define SCI_NPORTS CONFIG_SERIAL_SH_SCI_NR_UARTS
@@ -2937,7 +2938,7 @@ static int sci_init_single(struct platform_device *dev,
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !sci_port->is_rz_sci) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else
@@ -3353,6 +3354,11 @@ static int sci_probe(struct platform_device *dev)
 	sp = &sci_ports[dev_id];
 	platform_set_drvdata(dev, sp);
 
+	if (of_device_is_compatible(dev->dev.of_node, "renesas,r9a07g043-sci") ||
+	    of_device_is_compatible(dev->dev.of_node, "renesas,r9a07g044-sci") ||
+	    of_device_is_compatible(dev->dev.of_node, "renesas,r9a07g054-sci"))
+		sp->is_rz_sci = 1;
+
 	ret = sci_probe_single(dev, dev_id, p, sp);
 	if (ret)
 		return ret;
-- 
2.25.1


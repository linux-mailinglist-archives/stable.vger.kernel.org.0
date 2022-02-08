Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D7E4ADE66
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 17:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358445AbiBHQeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 11:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352030AbiBHQeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 11:34:09 -0500
Received: from nef.ens.fr (nef2.ens.fr [129.199.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CD6C061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 08:34:07 -0800 (PST)
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1644338045; bh=7rYuhnqGY9QBQAkxrvaw+ERLB3yk36ozkehRGe9pK6A=;
        h=From:To:Cc:Subject:Date:From;
        b=XKNpr2I82WLAsdveAPcMIhDYnkItTc3oTxDLaALw2yqMZvjaS6MyW95tKgtz6AL0h
         mGuiCy7Hl7kctffNEuKbtNRoAZyIqZhXOu8I/G5/vPbKCxYGYm3beHsvqdXP4P0Fce
         Ec+Ex56KG0qcSiky21yXTIEs9hxgYwyeqpGeU2qE=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 218GY4bZ013605
          ; Tue, 8 Feb 2022 17:34:05 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 218GY0FZ100888 ; Tue, 8 Feb 2022 17:34:04 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: [PATCH 4.9] serial: sh-sci: Fix misplaced backport of "Fix late enablement of AUTORTS"
Date:   Tue,  8 Feb 2022 17:33:56 +0100
Message-Id: <1644338036-24080-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 08 Feb 2022 17:34:05 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit 5f76895e4c71 ("serial: sh-sci: Fix late enablement of
AUTORTS") inserted a new call to .set_mctrl().
However the backported version in stable (commit ad3faea03fdf ("serial:
sh-sci: Fix late enablement of AUTORTS")) does not insert it at the same
position.

This patch moves the added instructions back to where they should be
according to the upsteam patch.

Fixes: ad3faea03fdf ("serial: sh-sci: Fix late enablement of AUTORTS")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 drivers/tty/serial/sh-sci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index b4f528d..5c6243a 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2377,6 +2377,10 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,

 		serial_port_out(port, SCFCR, ctrl);
 	}
+	if (port->flags & UPF_HARD_FLOW) {
+		/* Refresh (Auto) RTS */
+		sci_set_mctrl(port, port->mctrl);
+	}

 	scr_val |= s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0);
 	dev_dbg(port->dev, "SCSCR 0x%x\n", scr_val);
@@ -2391,10 +2395,6 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
 		 */
 		udelay(DIV_ROUND_UP(10 * 1000000, baud));
 	}
-	if (port->flags & UPF_HARD_FLOW) {
-		/* Refresh (Auto) RTS */
-		sci_set_mctrl(port, port->mctrl);
-	}

 #ifdef CONFIG_SERIAL_SH_SCI_DMA
 	/*
--
2.7.4


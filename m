Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092E46C116D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 13:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCTMEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 08:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjCTMEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 08:04:12 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 809321024B;
        Mon, 20 Mar 2023 05:04:09 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,274,1673881200"; 
   d="scan'208";a="153192534"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 20 Mar 2023 21:04:08 +0900
Received: from localhost.localdomain (unknown [10.226.92.205])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id EE82E41F14B7;
        Mon, 20 Mar 2023 21:04:05 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jiri Slaby <jslaby@suse.com>, linux-serial@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] serial: 8250_em: Fix UART port type
Date:   Mon, 20 Mar 2023 12:04:02 +0000
Message-Id: <20230320120402.359614-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 32e293be736b853f168cd065d9cbc1b0c69f545d upstream.

As per HW manual for  EMEV2 "R19UH0040EJ0400 Rev.4.00", the UART
IP found on EMMA mobile SoC is Register-compatible with the
general-purpose 16750 UART chip. Fix UART port type as 16750 and
enable 64-bytes fifo support.

Fixes: 22886ee96895 ("serial8250-em: Emma Mobile UART driver V2")
Cc: stable@vger.kernel.org # 5.4.y
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230227114152.22265-2-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[biju: manually fixed the conflicts]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
Resending to 5.4 with confilcts [1] fixed.
[1] https://lore.kernel.org/stable/167930353815674@kroah.com/
---
 drivers/tty/serial/8250/8250_em.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index 2a76e22d2ec0..5670c8a267d8 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -102,8 +102,8 @@ static int serial8250_em_probe(struct platform_device *pdev)
 	memset(&up, 0, sizeof(up));
 	up.port.mapbase = regs->start;
 	up.port.irq = irq->start;
-	up.port.type = PORT_UNKNOWN;
-	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.type = PORT_16750;
+	up.port.flags = UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
 	up.port.dev = &pdev->dev;
 	up.port.private_data = priv;
 
-- 
2.25.1


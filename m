Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496156171B
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGGTp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:45:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57078 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727516AbfGGTiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:05 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0006fL-D8; Sun, 07 Jul 2019 20:38:01 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0005Yv-PN; Sun, 07 Jul 2019 20:37:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        "Simon Horman" <horms+renesas@verge.net.au>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.873269503@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 033/129] pinctrl: sh-pfc: r8a7778: Fix HSPI pin
 numbers and names
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 8e32e881947be98abaa917157fefc4a3319e90af upstream.

When declaring the HSPI RX1_B and TX1_B pins, two mistakes were made:
  - the rows and columns in the BGA pin matrix, from which the pin
    numbers are derived, were exchanged,
  - it was not taken into account that pin row labelling skips
    characters I, O, Q, and S.

Fix the order, and the corresponding pin names.

Notes:
  - The actual values of the pin numbers don't really matter (they just
    have to be unique), so the wrong order didn't have any impact,
  - Changing the names of the pins is user-visible, but there are no
    users in (upstream) DTS files.

Fixes: 4f82e3ee724f1712 ("sh-pfc: Support pins not associated with a GPIO port")
Fixes: 09cc76a95802e87d ("sh-pfc: r8a7778: add HSPI pin groups")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
@@ -1265,8 +1265,8 @@ static const struct sh_pfc_pin pinmux_pi
 
 	/* Pins not associated with a GPIO port */
 	SH_PFC_PIN_NAMED(3, 20, C20),
-	SH_PFC_PIN_NAMED(20, 1, T1),
-	SH_PFC_PIN_NAMED(25, 2, Y2),
+	SH_PFC_PIN_NAMED(1, 20, A20),
+	SH_PFC_PIN_NAMED(2, 25, B25),
 };
 
 /* - macro */
@@ -1401,7 +1401,7 @@ HSPI_PFC_DAT(hspi1_a,	HSPI_CLK1_A,		HSPI
 			HSPI_RX1_A,		HSPI_TX1_A);
 
 HSPI_PFC_PIN(hspi1_b,	RCAR_GP_PIN(0, 27),	RCAR_GP_PIN(0, 26),
-			PIN_NUMBER(20, 1),	PIN_NUMBER(25, 2));
+			PIN_NUMBER(1, 20),	PIN_NUMBER(2, 25));
 HSPI_PFC_DAT(hspi1_b,	HSPI_CLK1_B,		HSPI_CS1_B,
 			HSPI_RX1_B,		HSPI_TX1_B);
 


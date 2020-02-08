Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013E61566F0
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgBHSiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:38:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33692 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727682AbgBHS3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:36 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrF-0003cT-Qz; Sat, 08 Feb 2020 18:29:33 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrE-000CKn-S1; Sat, 08 Feb 2020 18:29:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Mans Rullgard" <mans@mansr.com>,
        "Gregory CLEMENT" <gregory.clement@bootlin.com>
Date:   Sat, 08 Feb 2020 18:19:29 +0000
Message-ID: <lsq.1581185940.540120808@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 030/148] spi: atmel: fix handling of cs_change set on
 non-last xfer
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mans Rullgard <mans@mansr.com>

commit fed8d8c7a6dc2a76d7764842853d81c770b0788e upstream.

The driver does the wrong thing when cs_change is set on a non-last
xfer in a message.  When cs_change is set, the driver deactivates the
CS and leaves it off until a later xfer again has cs_change set whereas
it should be briefly toggling CS off and on again.

This patch brings the behaviour of the driver back in line with the
documentation and common sense.  The delay of 10 us is the same as is
used by the default spi_transfer_one_message() function in spi.c.
[gregory: rebased on for-5.5 from spi tree]
Fixes: 8090d6d1a415 ("spi: atmel: Refactor spi-atmel to use SPI framework queue")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191018153504.4249-1-gregory.clement@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[bwhh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-atmel.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -242,7 +242,6 @@ struct atmel_spi {
 	struct atmel_spi_dma	dma;
 
 	bool			keep_cs;
-	bool			cs_active;
 };
 
 /* Controller-specific per-slave state */
@@ -1190,11 +1189,9 @@ static int atmel_spi_one_transfer(struct
 				 &msg->transfers)) {
 			as->keep_cs = true;
 		} else {
-			as->cs_active = !as->cs_active;
-			if (as->cs_active)
-				cs_activate(as, msg->spi);
-			else
-				cs_deactivate(as, msg->spi);
+			cs_deactivate(as, msg->spi);
+			udelay(10);
+			cs_activate(as, msg->spi);
 		}
 	}
 
@@ -1217,7 +1214,6 @@ static int atmel_spi_transfer_one_messag
 	atmel_spi_lock(as);
 	cs_activate(as, spi);
 
-	as->cs_active = true;
 	as->keep_cs = false;
 
 	msg->status = 0;


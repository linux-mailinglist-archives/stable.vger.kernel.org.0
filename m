Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405BD616C9
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfGGTiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57498 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727588AbfGGTiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:11 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0006iz-AP; Sun, 07 Jul 2019 20:38:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005cz-3r; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Aaro Koskinen" <aaro.koskinen@iki.fi>,
        "Ulf Hansson" <ulf.hansson@linaro.org>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.999453514@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 083/129] mmc: omap: fix the maximum timeout setting
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

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit a6327b5e57fdc679c842588c3be046c0b39cc127 upstream.

When running OMAP1 kernel on QEMU, MMC access is annoyingly noisy:

	MMC: CTO of 0xff and 0xfe cannot be used!
	MMC: CTO of 0xff and 0xfe cannot be used!
	MMC: CTO of 0xff and 0xfe cannot be used!
	[ad inf.]

Emulator warnings appear to be valid. The TI document SPRU680 [1]
("OMAP5910 Dual-Core Processor MultiMedia Card/Secure Data Memory Card
(MMC/SD) Reference Guide") page 36 states that the maximum timeout is 253
cycles and "0xff and 0xfe cannot be used".

Fix by using 0xfd as the maximum timeout.

Tested using QEMU 2.5 (Siemens SX1 machine, OMAP310), and also checked on
real hardware using Palm TE (OMAP310), Nokia 770 (OMAP1710) and Nokia N810
(OMAP2420) that MMC works as before.

[1] http://www.ti.com/lit/ug/spru680/spru680.pdf

Fixes: 730c9b7e6630f ("[MMC] Add OMAP MMC host driver")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -921,7 +921,7 @@ static inline void set_cmd_timeout(struc
 	reg &= ~(1 << 5);
 	OMAP_MMC_WRITE(host, SDIO, reg);
 	/* Set maximum timeout */
-	OMAP_MMC_WRITE(host, CTO, 0xff);
+	OMAP_MMC_WRITE(host, CTO, 0xfd);
 }
 
 static inline void set_data_timeout(struct mmc_omap_host *host, struct mmc_request *req)


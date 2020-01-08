Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AAD134C2A
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgAHTuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:50:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43412 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730396AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006o3-55; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dlZ-F0; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Dong Aisheng" <aisheng.dong@nxp.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:12 +0000
Message-ID: <lsq.1578512578.854529422@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 14/63] mmc: core: fix using wrong io voltage if
 mmc_select_hs200 fails
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Aisheng <aisheng.dong@nxp.com>

commit e51534c806609c806d81bfb034f02737461f855c upstream.

Currently MMC core will keep going if HS200/HS timing switch failed
with -EBADMSG error by the assumption that the old timing is still valid.

However, for mmc_select_hs200 case, the signal voltage may have already
been switched. If the timing switch failed, we should fall back to
the old voltage in case the card is continue run with legacy timing.

If fall back signal voltage failed, we explicitly report an EIO error
to force retry during the next power cycle.

Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
[bwh: Backported to 3.16:
 - Delete now-unused err label
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1079,8 +1079,10 @@ static int mmc_select_hs400(struct mmc_c
 static int mmc_select_hs200(struct mmc_card *card)
 {
 	struct mmc_host *host = card->host;
+	unsigned int old_signal_voltage;
 	int err = -EINVAL;
 
+	old_signal_voltage = host->ios.signal_voltage;
 	if (card->mmc_avail_type & EXT_CSD_CARD_TYPE_HS200_1_2V)
 		err = __mmc_set_signal_voltage(host, MMC_SIGNAL_VOLTAGE_120);
 
@@ -1089,7 +1091,7 @@ static int mmc_select_hs200(struct mmc_c
 
 	/* If fails try again during next card power cycle */
 	if (err)
-		goto err;
+		return err;
 
 	/*
 	 * Set the bus width(4 or 8) with host's support and
@@ -1104,7 +1106,12 @@ static int mmc_select_hs200(struct mmc_c
 		if (!err)
 			mmc_set_timing(host, MMC_TIMING_MMC_HS200);
 	}
-err:
+
+	if (err) {
+		/* fall back to the old signal voltage, if fails report error */
+		if (__mmc_set_signal_voltage(host, old_signal_voltage))
+			err = -EIO;
+	}
 	return err;
 }
 


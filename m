Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E283C3820
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhGJXx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhGJXx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18EDF613BF;
        Sat, 10 Jul 2021 23:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961041;
        bh=QhVqUl8pjetORR/OsaENFqVeoLCVyMoIvyUo2BlxV5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShoZwhU1q3f50NTvvPnW5SpZF8+efm5RP32V/Kpmef8HrzIcKmau1bAmvgm/a7i/C
         FoU9pkWQ+kR38Y/OvLBJsUKmAf0XxSCGIUXLj9g2VSlccv+uLv4T1n1teF57IvKxL2
         f1aY7f06PLC67PQghTrgrq70BsR7tTntTPHfTtyVTSyCxgTSkiySlQIJ0g4fAGhSWj
         cHlh5tSN1822bxCHdeC63e0jyY/41UyWTtwCgg8irAeMq87tBsdxGEXMB85KSAoqfE
         vSbcNz1kUAcnXCVt1BhXFHTefbB5dsvD1HQ34za4C/uwRVxwCG6TZU+arGh6kYW1di
         bClMJBuL/aUQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/37] watchdog: iTCO_wdt: Account for rebooting on second timeout
Date:   Sat, 10 Jul 2021 19:49:56 -0400
Message-Id: <20210710235016.3221124-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit cb011044e34c293e139570ce5c01aed66a34345c ]

This was already attempted to fix via 1fccb73011ea: If the BIOS did not
enable TCO SMIs, the timer definitely needs to trigger twice in order to
cause a reboot. If TCO SMIs are on, as well as SMIs in general, we can
continue to assume that the BIOS will perform a reboot on the first
timeout.

QEMU with its ICH9 and related BIOS falls into the former category,
currently taking twice the configured timeout in order to reboot the
machine. For iTCO version that fall under turn_SMI_watchdog_clear_off,
this is also true and was currently only addressed for v1, irrespective
of the turn_SMI_watchdog_clear_off value.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/0b8bb307-d08b-41b5-696c-305cdac6789c@siemens.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/iTCO_wdt.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index a370a185a41c..519a539eeb9e 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -73,6 +73,8 @@
 #define TCOBASE(p)	((p)->tco_res->start)
 /* SMI Control and Enable Register */
 #define SMI_EN(p)	((p)->smi_res->start)
+#define TCO_EN		(1 << 13)
+#define GBL_SMI_EN	(1 << 0)
 
 #define TCO_RLD(p)	(TCOBASE(p) + 0x00) /* TCO Timer Reload/Curr. Value */
 #define TCOv1_TMR(p)	(TCOBASE(p) + 0x01) /* TCOv1 Timer Initial Value*/
@@ -357,8 +359,12 @@ static int iTCO_wdt_set_timeout(struct watchdog_device *wd_dev, unsigned int t)
 
 	tmrval = seconds_to_ticks(p, t);
 
-	/* For TCO v1 the timer counts down twice before rebooting */
-	if (p->iTCO_version == 1)
+	/*
+	 * If TCO SMIs are off, the timer counts down twice before rebooting.
+	 * Otherwise, the BIOS generally reboots when the SMI triggers.
+	 */
+	if (p->smi_res &&
+	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
 		tmrval /= 2;
 
 	/* from the specs: */
@@ -523,7 +529,7 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 		 * Disables TCO logic generating an SMI#
 		 */
 		val32 = inl(SMI_EN(p));
-		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+		val32 &= ~TCO_EN;	/* Turn off SMI clearing watchdog */
 		outl(val32, SMI_EN(p));
 	}
 
-- 
2.30.2


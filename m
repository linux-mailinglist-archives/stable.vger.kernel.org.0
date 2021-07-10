Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62483C37AA
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhGJXwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232448AbhGJXwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CEF961184;
        Sat, 10 Jul 2021 23:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960985;
        bh=96LjCpP+q2lNFwkuwSh8WkFF0CnkOkRCU0meSQEXn2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1hYjV4+cZESIsRRAiuRevXwDp6R2FZj2X0ivwOBv8j91KicCIStlYbHZWJGjnaku
         o6nexiSFr9ca9/z1pB8ZwxkqOySxrkhnS59fTrM7jDyDLomCbx25DqDzLRBMjNaZlr
         ZFBuFw//oW1bP9Ac4CoWNrJXkDKx8MAPFm0cAhDs5EqcU+hF85yh+hqR3z7X4AmYmV
         UhkVEmw1DjcH23+xY7lOaIL5mObuOeVr2rzrd0BvClJBFe6UrYJpTRAsv5ABziapvp
         m7kxQ6dU9q6rJFOV5h7RcaMRaRXBvB9okUFg/F+nB3seI79H/KfZqrwQD2HxQLM+yQ
         p6NbrLdkAHU9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 19/43] watchdog: iTCO_wdt: Account for rebooting on second timeout
Date:   Sat, 10 Jul 2021 19:48:51 -0400
Message-Id: <20210710234915.3220342-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
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
index bf31d7b67a69..3f1324871cfd 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -71,6 +71,8 @@
 #define TCOBASE(p)	((p)->tco_res->start)
 /* SMI Control and Enable Register */
 #define SMI_EN(p)	((p)->smi_res->start)
+#define TCO_EN		(1 << 13)
+#define GBL_SMI_EN	(1 << 0)
 
 #define TCO_RLD(p)	(TCOBASE(p) + 0x00) /* TCO Timer Reload/Curr. Value */
 #define TCOv1_TMR(p)	(TCOBASE(p) + 0x01) /* TCOv1 Timer Initial Value*/
@@ -355,8 +357,12 @@ static int iTCO_wdt_set_timeout(struct watchdog_device *wd_dev, unsigned int t)
 
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
@@ -521,7 +527,7 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 		 * Disables TCO logic generating an SMI#
 		 */
 		val32 = inl(SMI_EN(p));
-		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+		val32 &= ~TCO_EN;	/* Turn off SMI clearing watchdog */
 		outl(val32, SMI_EN(p));
 	}
 
-- 
2.30.2


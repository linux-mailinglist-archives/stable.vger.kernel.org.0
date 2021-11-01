Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF471441844
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhKAJp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234071AbhKAJoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98ACB613A4;
        Mon,  1 Nov 2021 09:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758966;
        bh=lupnL6TaCmkoQPb3WZhdGjlX6X2St7+f5b1FvgLxB1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRWpA/n5v4lS4hEqXKFKU5TdilRzPZsYPnQaIlWPTVA1FknbBkquE/gWnMivIOsrW
         TbxeypDKpeOJy+H61sE9NU/w12qFZZm6vFdRzSYbQUZ3mZeUDtreZyJx6ygMf5MDDe
         wTZFrFeMr+e33uHk5OPmX+/rWbU+y1TmvBz1fZUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>,
        "Javier S. Pedro" <debbugs@javispedro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.14 057/125] Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
Date:   Mon,  1 Nov 2021 10:17:10 +0100
Message-Id: <20211101082543.957189543@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 6e7733ef0bb9372d5491168635f6ecba8ac3cb8a upstream.

This reverts commit cb011044e34c ("watchdog: iTCO_wdt: Account for
rebooting on second timeout") and commit aec42642d91f ("watchdog: iTCO_wdt:
Fix detection of SMI-off case") since those patches cause a regression
on certain boards (https://bugzilla.kernel.org/show_bug.cgi?id=213809).

While this revert may result in some boards to only reset after twice
the configured timeout value, that is still better than a watchdog reset
after half the configured value.

Fixes: cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on second timeout")
Fixes: aec42642d91f ("watchdog: iTCO_wdt: Fix detection of SMI-off case")
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Mantas Mikulėnas <grawity@gmail.com>
Reported-by: Javier S. Pedro <debbugs@javispedro.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20211008003302.1461733-1-linux@roeck-us.net
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/iTCO_wdt.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -71,8 +71,6 @@
 #define TCOBASE(p)	((p)->tco_res->start)
 /* SMI Control and Enable Register */
 #define SMI_EN(p)	((p)->smi_res->start)
-#define TCO_EN		(1 << 13)
-#define GBL_SMI_EN	(1 << 0)
 
 #define TCO_RLD(p)	(TCOBASE(p) + 0x00) /* TCO Timer Reload/Curr. Value */
 #define TCOv1_TMR(p)	(TCOBASE(p) + 0x01) /* TCOv1 Timer Initial Value*/
@@ -357,12 +355,8 @@ static int iTCO_wdt_set_timeout(struct w
 
 	tmrval = seconds_to_ticks(p, t);
 
-	/*
-	 * If TCO SMIs are off, the timer counts down twice before rebooting.
-	 * Otherwise, the BIOS generally reboots when the SMI triggers.
-	 */
-	if (p->smi_res &&
-	    (inl(SMI_EN(p)) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
+	/* For TCO v1 the timer counts down twice before rebooting */
+	if (p->iTCO_version == 1)
 		tmrval /= 2;
 
 	/* from the specs: */
@@ -527,7 +521,7 @@ static int iTCO_wdt_probe(struct platfor
 		 * Disables TCO logic generating an SMI#
 		 */
 		val32 = inl(SMI_EN(p));
-		val32 &= ~TCO_EN;	/* Turn off SMI clearing watchdog */
+		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
 		outl(val32, SMI_EN(p));
 	}
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42AA3E2509
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243704AbhHFIQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243754AbhHFIPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A30A611EF;
        Fri,  6 Aug 2021 08:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237730;
        bh=vL86lfOE7JC3lJEcAvz+Tt8sBvNAnOM7RLXKepKXRr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsjKYd/0V20U1LZpMT9fAJycjoBZWzTVCrlajqmp6PzOilAuSW3HybVjkyMyPaG6M
         epfb0YyLwABFzSnO6oxiBZz9MQCY20PZrWQfal/mjLoWeFuel9N/kYH7Vz4uQq8e1f
         G3Alq+rrKlbSLljFeESvI7WIN8Dfx0AA1ORJXT20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/11] Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
Date:   Fri,  6 Aug 2021 10:14:54 +0200
Message-Id: <20210806081110.877458732@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081110.511221879@linuxfoundation.org>
References: <20210806081110.511221879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit cb1bdbfad648aa32c43bec6ef6d03e1c9d434393 which is
commit cb011044e34c293e139570ce5c01aed66a34345c upstream.

It is reported to cause problems with systems and probably should not
have been backported in the first place :(

Link: https://lore.kernel.org/r/20210803165108.4154cd52@endymion
Reported-by: Jean Delvare <jdelvare@suse.de>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/iTCO_wdt.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -75,8 +75,6 @@
 #define TCOBASE(p)	((p)->tco_res->start)
 /* SMI Control and Enable Register */
 #define SMI_EN(p)	((p)->smi_res->start)
-#define TCO_EN		(1 << 13)
-#define GBL_SMI_EN	(1 << 0)
 
 #define TCO_RLD(p)	(TCOBASE(p) + 0x00) /* TCO Timer Reload/Curr. Value */
 #define TCOv1_TMR(p)	(TCOBASE(p) + 0x01) /* TCOv1 Timer Initial Value*/
@@ -332,12 +330,8 @@ static int iTCO_wdt_set_timeout(struct w
 
 	tmrval = seconds_to_ticks(p, t);
 
-	/*
-	 * If TCO SMIs are off, the timer counts down twice before rebooting.
-	 * Otherwise, the BIOS generally reboots when the SMI triggers.
-	 */
-	if (p->smi_res &&
-	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
+	/* For TCO v1 the timer counts down twice before rebooting */
+	if (p->iTCO_version == 1)
 		tmrval /= 2;
 
 	/* from the specs: */
@@ -499,7 +493,7 @@ static int iTCO_wdt_probe(struct platfor
 		 * Disables TCO logic generating an SMI#
 		 */
 		val32 = inl(SMI_EN(p));
-		val32 &= ~TCO_EN;	/* Turn off SMI clearing watchdog */
+		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
 		outl(val32, SMI_EN(p));
 	}
 



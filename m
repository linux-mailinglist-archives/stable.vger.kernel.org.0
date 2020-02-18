Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BDF163295
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgBRUI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgBRT55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:57:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F9F620659;
        Tue, 18 Feb 2020 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055877;
        bh=EmGc26XpQQJRxz7sKbnLLn5rH2g2hZ9Ry83rw/3dFPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlKd5mHPugw/zUM+17umTO3ti0f2tBr3lQNfVDrouSFlyRUTO4hUgR83F4VslJ2Gn
         TfdKnEzrCTspaRdcOXkPYZmWUVce6ADaEDOUKeAsvDCD3yRwN0zebUCWjxvtrMbYw/
         oTwDqpoC4oeQ71eUro6F6Iobi68r15K5OsEzMfI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 09/66] ACPI: PM: s2idle: Avoid possible race related to the EC GPE
Date:   Tue, 18 Feb 2020 20:54:36 +0100
Message-Id: <20200218190428.963951947@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e3728b50cd9be7d4b1469447cdf1feb93e3b7adb upstream.

It is theoretically possible for the ACPI EC GPE to be set after the
s2idle_ops->wake() called from s2idle_loop() has returned and before
the subsequent pm_wakeup_pending() check is carried out.  If that
happens, the resulting wakeup event will cause the system to resume
even though it may be a spurious one.

To avoid that race, first make the ->wake() callback in struct
platform_s2idle_ops return a bool value indicating whether or not
to let the system resume and rearrange s2idle_loop() to use that
value instad of the direct pm_wakeup_pending() call if ->wake() is
present.

Next, rework acpi_s2idle_wake() to process EC events and check
pm_wakeup_pending() before re-arming the SCI for system wakeup
to prevent it from triggering prematurely and add comments to
that function to explain the rationale for the new code flow.

Fixes: 56b991849009 ("PM: sleep: Simplify suspend-to-idle control flow")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c    |   46 ++++++++++++++++++++++++++++++++--------------
 include/linux/suspend.h |    2 +-
 kernel/power/suspend.c  |    9 +++++----
 3 files changed, 38 insertions(+), 19 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -977,21 +977,28 @@ static int acpi_s2idle_prepare_late(void
 	return 0;
 }
 
-static void acpi_s2idle_wake(void)
+static bool acpi_s2idle_wake(void)
 {
-	/*
-	 * If IRQD_WAKEUP_ARMED is set for the SCI at this point, the SCI has
-	 * not triggered while suspended, so bail out.
-	 */
-	if (!acpi_sci_irq_valid() ||
-	    irqd_is_wakeup_armed(irq_get_irq_data(acpi_sci_irq)))
-		return;
-
-	/*
-	 * If there are EC events to process, the wakeup may be a spurious one
-	 * coming from the EC.
-	 */
-	if (acpi_ec_dispatch_gpe()) {
+	if (!acpi_sci_irq_valid())
+		return pm_wakeup_pending();
+
+	while (pm_wakeup_pending()) {
+		/*
+		 * If IRQD_WAKEUP_ARMED is set for the SCI at this point, the
+		 * SCI has not triggered while suspended, so bail out (the
+		 * wakeup is pending anyway and the SCI is not the source of
+		 * it).
+		 */
+		if (irqd_is_wakeup_armed(irq_get_irq_data(acpi_sci_irq)))
+			return true;
+
+		/*
+		 * If there are no EC events to process, the wakeup is regarded
+		 * as a genuine one.
+		 */
+		if (!acpi_ec_dispatch_gpe())
+			return true;
+
 		/*
 		 * Cancel the wakeup and process all pending events in case
 		 * there are any wakeup ones in there.
@@ -1009,8 +1016,19 @@ static void acpi_s2idle_wake(void)
 		acpi_ec_flush_work();
 		acpi_os_wait_events_complete(); /* synchronize Notify handling */
 
+		/*
+		 * The SCI is in the "suspended" state now and it cannot produce
+		 * new wakeup events till the rearming below, so if any of them
+		 * are pending here, they must be resulting from the processing
+		 * of EC events above or coming from somewhere else.
+		 */
+		if (pm_wakeup_pending())
+			return true;
+
 		rearm_wake_irq(acpi_sci_irq);
 	}
+
+	return false;
 }
 
 static void acpi_s2idle_restore_early(void)
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -191,7 +191,7 @@ struct platform_s2idle_ops {
 	int (*begin)(void);
 	int (*prepare)(void);
 	int (*prepare_late)(void);
-	void (*wake)(void);
+	bool (*wake)(void);
 	void (*restore_early)(void);
 	void (*restore)(void);
 	void (*end)(void);
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -131,11 +131,12 @@ static void s2idle_loop(void)
 	 * to avoid them upfront.
 	 */
 	for (;;) {
-		if (s2idle_ops && s2idle_ops->wake)
-			s2idle_ops->wake();
-
-		if (pm_wakeup_pending())
+		if (s2idle_ops && s2idle_ops->wake) {
+			if (s2idle_ops->wake())
+				break;
+		} else if (pm_wakeup_pending()) {
 			break;
+		}
 
 		pm_wakeup_clear(false);
 



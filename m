Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD411E2BA7
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391580AbgEZTHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391565AbgEZTHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:07:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DB8E208DB;
        Tue, 26 May 2020 19:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520033;
        bh=nRPM9PV4jpPC0mNS8K3Zc9qkLQPWhOLjwNbkPPAeyWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpa6Mt+8e3/OiG1s4oZfNl7Uf22Nb7QVgHSij5R2eyUWR/HzE7rKZAtkxVzG7o9oH
         Fe8QzDNlPpAsVWDsKlgIXdKFd96G1BDXSzAWcIOsLxhKcvrLUF59XQsI61Am0NZfSb
         lH/BpBaa/xdsY5OKe4WiuVH9oVnuEHg4g1tj2srk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Chiu <chiu@endlessm.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/111] ACPI: EC: PM: Avoid flushing EC work when EC GPE is inactive
Date:   Tue, 26 May 2020 20:52:25 +0200
Message-Id: <20200526183933.172093325@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 607b9df63057a56f6172d560d5366cca6a030c76 ]

Flushing the EC work while suspended to idle when the EC GPE status
is not set causes some EC wakeup events (notably power button and
lid ones) to be missed after a series of spurious wakeups on the Dell
XPS13 9360 in my office.

If that happens, the machine cannot be woken up from suspend-to-idle
by the power button or lid status change and it needs to be woken up
in some other way (eg. by a key press).

Flushing the EC work only after successful dispatching the EC GPE,
which means that its status has been set, avoids the issue, so change
the code in question accordingly.

Fixes: 7b301750f7f8 ("ACPI: EC: PM: Avoid premature returns from acpi_s2idle_wake()")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c    |  6 +++++-
 drivers/acpi/sleep.c | 15 ++++-----------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5b53a66d403d..57eacdcbf820 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1984,9 +1984,13 @@ bool acpi_ec_dispatch_gpe(void)
 	 * to allow the caller to process events properly after that.
 	 */
 	ret = acpi_dispatch_gpe(NULL, first_ec->gpe);
-	if (ret == ACPI_INTERRUPT_HANDLED)
+	if (ret == ACPI_INTERRUPT_HANDLED) {
 		pm_pr_dbg("EC GPE dispatched\n");
 
+		/* Flush the event and query workqueues. */
+		acpi_ec_flush_work();
+	}
+
 	return false;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 85514c0f3aa5..d1b74179d217 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -977,13 +977,6 @@ static int acpi_s2idle_prepare_late(void)
 	return 0;
 }
 
-static void acpi_s2idle_sync(void)
-{
-	/* The EC driver uses special workqueues that need to be flushed. */
-	acpi_ec_flush_work();
-	acpi_os_wait_events_complete(); /* synchronize Notify handling */
-}
-
 static bool acpi_s2idle_wake(void)
 {
 	if (!acpi_sci_irq_valid())
@@ -1015,7 +1008,7 @@ static bool acpi_s2idle_wake(void)
 			return true;
 
 		/*
-		 * Cancel the wakeup and process all pending events in case
+		 * Cancel the SCI wakeup and process all pending events in case
 		 * there are any wakeup ones in there.
 		 *
 		 * Note that if any non-EC GPEs are active at this point, the
@@ -1023,8 +1016,7 @@ static bool acpi_s2idle_wake(void)
 		 * should be missed by canceling the wakeup here.
 		 */
 		pm_system_cancel_wakeup();
-
-		acpi_s2idle_sync();
+		acpi_os_wait_events_complete();
 
 		/*
 		 * The SCI is in the "suspended" state now and it cannot produce
@@ -1057,7 +1049,8 @@ static void acpi_s2idle_restore(void)
 	 * of GPEs.
 	 */
 	acpi_os_wait_events_complete(); /* synchronize GPE processing */
-	acpi_s2idle_sync();
+	acpi_ec_flush_work(); /* flush the EC driver's workqueues */
+	acpi_os_wait_events_complete(); /* synchronize Notify handling */
 
 	s2idle_wakeup = false;
 
-- 
2.25.1




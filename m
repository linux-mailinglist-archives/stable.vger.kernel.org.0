Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5194B1F2DDB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgFIAgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729642AbgFHXN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F99720897;
        Mon,  8 Jun 2020 23:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658037;
        bh=3UDru9ZOSPC+MuQO+dsJTBvtZevlnZ7rS4IL9vdTvZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h75ETAWzxSlcEoBOroFYVeaAH6dO7vUYJ6Mes7Z6hdCMzWs/jpxEUL6fQeXeNPWcl
         LwcWK6bwq3L+JLzKmtUvBOazQ5Ve3JlvNQLGPR4BRalRsrW3QjXjrUPqbE3foy8+k3
         Uar5X28Uhf8xgectVTwDoM5SZofbDWDN7pNRhpy8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Chiu <chiu@endlessm.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 087/606] ACPI: EC: PM: Avoid flushing EC work when EC GPE is inactive
Date:   Mon,  8 Jun 2020 19:03:32 -0400
Message-Id: <20200608231211.3363633-87-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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
index 03b3067811c9..2713ddb3348c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2064,9 +2064,13 @@ bool acpi_ec_dispatch_gpe(void)
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
index 3850704570c0..fd9d4e8318e9 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -980,13 +980,6 @@ static int acpi_s2idle_prepare_late(void)
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
@@ -1018,7 +1011,7 @@ static bool acpi_s2idle_wake(void)
 			return true;
 
 		/*
-		 * Cancel the wakeup and process all pending events in case
+		 * Cancel the SCI wakeup and process all pending events in case
 		 * there are any wakeup ones in there.
 		 *
 		 * Note that if any non-EC GPEs are active at this point, the
@@ -1026,8 +1019,7 @@ static bool acpi_s2idle_wake(void)
 		 * should be missed by canceling the wakeup here.
 		 */
 		pm_system_cancel_wakeup();
-
-		acpi_s2idle_sync();
+		acpi_os_wait_events_complete();
 
 		/*
 		 * The SCI is in the "suspended" state now and it cannot produce
@@ -1060,7 +1052,8 @@ static void acpi_s2idle_restore(void)
 	 * of GPEs.
 	 */
 	acpi_os_wait_events_complete(); /* synchronize GPE processing */
-	acpi_s2idle_sync();
+	acpi_ec_flush_work(); /* flush the EC driver's workqueues */
+	acpi_os_wait_events_complete(); /* synchronize Notify handling */
 
 	s2idle_wakeup = false;
 
-- 
2.25.1


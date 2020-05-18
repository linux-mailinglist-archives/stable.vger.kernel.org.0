Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E208F1D8333
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgERSCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732573AbgERSCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D534C20715;
        Mon, 18 May 2020 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824966;
        bh=Hj7HmATqitQOrextsJJ4opt0C/dkn/Vl8y5f30JReP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pa5F3OkHjBP9PdyKrkSXmK8uzVBmUG1X0jVgk8bBZ7X30LuK3LmBHSxhIB5MXlGfj
         sFGmuDiCrCAPBqTV51yEQMQxBf8cY/3C9mVUIWOcLWdw7T5NKAvO8zmhRcNNvnSh0Z
         evXAWr5477eA8u491+bkp2NauHQw/qfPjLKj1unM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Chris Chiu <chiu@endlessm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 074/194] ACPI: EC: PM: Avoid premature returns from acpi_s2idle_wake()
Date:   Mon, 18 May 2020 19:36:04 +0200
Message-Id: <20200518173537.955194367@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 7b301750f7f8f6503e11f1af4a03832525f58c66 ]

If the EC GPE status is not set after checking all of the other GPEs,
acpi_s2idle_wake() returns 'false', to indicate that the SCI event
that has just triggered is not a system wakeup one, but it does that
without canceling the pending wakeup and re-arming the SCI for system
wakeup which is a mistake, because it may cause s2idle_loop() to busy
spin until the next valid wakeup event.  [If that happens, the first
spurious wakeup is still pending after acpi_s2idle_wake() has
returned, so s2idle_enter() does nothing, acpi_s2idle_wake()
is called again and it sees that the SCI has triggered, but no GPEs
are active, so 'false' is returned again, and so on.]

Fix that by moving all of the GPE checking logic from
acpi_s2idle_wake() to acpi_ec_dispatch_gpe() and making the
latter return 'true' only if a non-EC GPE has triggered and
'false' otherwise, which will cause acpi_s2idle_wake() to
cancel the pending SCI wakeup and re-arm the SCI for system
wakeup regardless of the EC GPE status.

This also addresses a lockup observed on an Elitegroup EF20EA laptop
after attempting to wake it up from suspend-to-idle by a key press.

Fixes: d5406284ff80 ("ACPI: PM: s2idle: Refine active GPEs check")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=207603
Reported-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
Link: https://lore.kernel.org/linux-acpi/CAB4CAwdqo7=MvyG_PE+PGVfeA17AHF5i5JucgaKqqMX6mjArbQ@mail.gmail.com/
Reported-by: Chris Chiu <chiu@endlessm.com>
Tested-by: Chris Chiu <chiu@endlessm.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c       | 24 ++++++++++++++++--------
 drivers/acpi/internal.h |  1 -
 drivers/acpi/sleep.c    | 14 ++------------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 35dd2f1fb0e61..03b3067811c99 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2042,23 +2042,31 @@ void acpi_ec_set_gpe_wake_mask(u8 action)
 		acpi_set_gpe_wake_mask(NULL, first_ec->gpe, action);
 }
 
-bool acpi_ec_other_gpes_active(void)
-{
-	return acpi_any_gpe_status_set(first_ec ? first_ec->gpe : U32_MAX);
-}
-
 bool acpi_ec_dispatch_gpe(void)
 {
 	u32 ret;
 
 	if (!first_ec)
+		return acpi_any_gpe_status_set(U32_MAX);
+
+	/*
+	 * Report wakeup if the status bit is set for any enabled GPE other
+	 * than the EC one.
+	 */
+	if (acpi_any_gpe_status_set(first_ec->gpe))
+		return true;
+
+	if (ec_no_wakeup)
 		return false;
 
+	/*
+	 * Dispatch the EC GPE in-band, but do not report wakeup in any case
+	 * to allow the caller to process events properly after that.
+	 */
 	ret = acpi_dispatch_gpe(NULL, first_ec->gpe);
-	if (ret == ACPI_INTERRUPT_HANDLED) {
+	if (ret == ACPI_INTERRUPT_HANDLED)
 		pm_pr_dbg("EC GPE dispatched\n");
-		return true;
-	}
+
 	return false;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index d44c591c4ee4d..3616daec650b1 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -202,7 +202,6 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit);
 
 #ifdef CONFIG_PM_SLEEP
 void acpi_ec_flush_work(void);
-bool acpi_ec_other_gpes_active(void);
 bool acpi_ec_dispatch_gpe(void);
 #endif
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 4edc8a3ce40fd..3850704570c0c 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1013,20 +1013,10 @@ static bool acpi_s2idle_wake(void)
 		if (acpi_check_wakeup_handlers())
 			return true;
 
-		/*
-		 * If the status bit is set for any enabled GPE other than the
-		 * EC one, the wakeup is regarded as a genuine one.
-		 */
-		if (acpi_ec_other_gpes_active())
+		/* Check non-EC GPE wakeups and dispatch the EC GPE. */
+		if (acpi_ec_dispatch_gpe())
 			return true;
 
-		/*
-		 * If the EC GPE status bit has not been set, the wakeup is
-		 * regarded as a spurious one.
-		 */
-		if (!acpi_ec_dispatch_gpe())
-			return false;
-
 		/*
 		 * Cancel the wakeup and process all pending events in case
 		 * there are any wakeup ones in there.
-- 
2.20.1




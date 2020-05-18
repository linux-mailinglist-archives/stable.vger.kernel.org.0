Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40A01D8565
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgERRzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731476AbgERRzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D070220715;
        Mon, 18 May 2020 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824545;
        bh=xqU7XTG8IrFP4wWzrQNI/Jhvc1jweG7tHLqA+M523ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R03FpKkX9qpBy3enh30mbmZgxDvfpJLOMqKo6+HcRpXTo1u2RNc4/PRvbC7LnY6tl
         Uk/4pPB3nAhLMreNu5jbaQ8hc6XomL0BOnxMgdpswo0hFIbMnC3RL2ezwFmXAMi8qa
         hMFgpICHStmg3Sy8eqqqdlnJlyrOB+7biexXVudA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Chris Chiu <chiu@endlessm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/147] ACPI: EC: PM: Avoid premature returns from acpi_s2idle_wake()
Date:   Mon, 18 May 2020 19:36:18 +0200
Message-Id: <20200518173520.835382245@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
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
index 5e6c8bfc66125..5b53a66d403df 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1962,23 +1962,31 @@ void acpi_ec_set_gpe_wake_mask(u8 action)
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
index cbf7f34c3ce76..afe6636f9ad39 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -201,7 +201,6 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit);
 
 #ifdef CONFIG_PM_SLEEP
 void acpi_ec_flush_work(void);
-bool acpi_ec_other_gpes_active(void);
 bool acpi_ec_dispatch_gpe(void);
 #endif
 
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index edad89e58c580..85514c0f3aa53 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1010,20 +1010,10 @@ static bool acpi_s2idle_wake(void)
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




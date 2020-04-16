Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9C1AC2FD
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897309AbgDPNgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897277AbgDPNgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:36:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474C521BE5;
        Thu, 16 Apr 2020 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044170;
        bh=wiq00+a0rQKfRniK04x21me3Tx711ZcZNXnWvLov+ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhXfMhQbqH/4iMwnkclXmGcg1o7+SqLBMt7JN7Q9k9F1Ax5ku+kEpowRc/Lv0axio
         w8bsYRH+iZXNz/ONJ5cY4eddMQ84nH5IZ5ZURBQ2xPJKyDS9DpGyByno8p8uMdUrPw
         kTrtHEBAyZE8T4DUOeCBqE5kcWsqQbQXgEMt9UFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ond=C5=99ej=20Caletka?= <ondrej@caletka.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.5 108/257] ACPI: PM: s2idle: Refine active GPEs check
Date:   Thu, 16 Apr 2020 15:22:39 +0200
Message-Id: <20200416131339.689197762@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit d5406284ff803a578ca503373624312770319054 upstream.

The check for any active GPEs added by commit fdde0ff8590b ("ACPI:
PM: s2idle: Prevent spurious SCIs from waking up the system") turns
out to be insufficiently precise to prevent some systems from
resuming prematurely due to a spurious EC wakeup, so refine it
by first checking if any GPEs other than the EC GPE are active
and skipping all of the SCIs coming from the EC that do not produce
any genuine wakeup events after processing.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206629
Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
Reported-by: Ondřej Caletka <ondrej@caletka.cz>
Tested-by: Ondřej Caletka <ondrej@caletka.cz>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c       |    5 +++++
 drivers/acpi/internal.h |    1 +
 drivers/acpi/sleep.c    |   19 ++++++++++---------
 3 files changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2052,6 +2052,11 @@ void acpi_ec_set_gpe_wake_mask(u8 action
 		acpi_set_gpe_wake_mask(NULL, first_ec->gpe, action);
 }
 
+bool acpi_ec_other_gpes_active(void)
+{
+	return acpi_any_gpe_status_set(first_ec ? first_ec->gpe : U32_MAX);
+}
+
 bool acpi_ec_dispatch_gpe(void)
 {
 	u32 ret;
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -202,6 +202,7 @@ void acpi_ec_remove_query_handler(struct
 
 #ifdef CONFIG_PM_SLEEP
 void acpi_ec_flush_work(void);
+bool acpi_ec_other_gpes_active(void);
 bool acpi_ec_dispatch_gpe(void);
 #endif
 
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1014,19 +1014,20 @@ static bool acpi_s2idle_wake(void)
 			return true;
 
 		/*
-		 * If there are no EC events to process and at least one of the
-		 * other enabled GPEs is active, the wakeup is regarded as a
-		 * genuine one.
-		 *
-		 * Note that the checks below must be carried out in this order
-		 * to avoid returning prematurely due to a change of the EC GPE
-		 * status bit from unset to set between the checks with the
-		 * status bits of all the other GPEs unset.
+		 * If the status bit is set for any enabled GPE other than the
+		 * EC one, the wakeup is regarded as a genuine one.
 		 */
-		if (acpi_any_gpe_status_set(U32_MAX) && !acpi_ec_dispatch_gpe())
+		if (acpi_ec_other_gpes_active())
 			return true;
 
 		/*
+		 * If the EC GPE status bit has not been set, the wakeup is
+		 * regarded as a spurious one.
+		 */
+		if (!acpi_ec_dispatch_gpe())
+			return false;
+
+		/*
 		 * Cancel the wakeup and process all pending events in case
 		 * there are any wakeup ones in there.
 		 *



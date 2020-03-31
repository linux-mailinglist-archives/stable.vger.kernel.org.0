Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE5619905E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbgCaJLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731460AbgCaJLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:11:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BFDD20675;
        Tue, 31 Mar 2020 09:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645879;
        bh=3mVnKTF2uYAXRjiu36c2VE+rQ9dRUSV0W8Csiw4csOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwyjIy9X86lHD9B3x1r1ay6dy2hRHu01ZSrkHRI12OFWTha1+Msy2qv4HfzPAugVb
         6o3lWWICoucFHKoKTTW5uZSMyHD1bbcUoVdm2c8hmMPVpYrMJONkWGQ7bXIoCvrT73
         Yihd09viiFMUf0B1LB2adUcUCwDJbRWwPRpLlku8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kenneth R. Crudup" <kenny@panix.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 006/155] ACPI: PM: s2idle: Rework ACPI events synchronization
Date:   Tue, 31 Mar 2020 10:57:26 +0200
Message-Id: <20200331085419.054651700@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 024aa8732acb7d2503eae43c3fe3504d0a8646d0 upstream.

Note that the EC GPE processing need not be synchronized in
acpi_s2idle_wake() after invoking acpi_ec_dispatch_gpe(), because
that function checks the GPE status and dispatches its handler if
need be and the SCI action handler is not going to run anyway at
that point.

Moreover, it is better to drain all of the pending ACPI events
before restoring the working-state configuration of GPEs in
acpi_s2idle_restore(), because those events are likely to be related
to system wakeup, in which case they will not be relevant going
forward.

Rework the code to take these observations into account.

Tested-by: Kenneth R. Crudup <kenny@panix.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -977,6 +977,16 @@ static int acpi_s2idle_prepare_late(void
 	return 0;
 }
 
+static void acpi_s2idle_sync(void)
+{
+	/*
+	 * The EC driver uses the system workqueue and an additional special
+	 * one, so those need to be flushed too.
+	 */
+	acpi_ec_flush_work();
+	acpi_os_wait_events_complete(); /* synchronize Notify handling */
+}
+
 static bool acpi_s2idle_wake(void)
 {
 	if (!acpi_sci_irq_valid())
@@ -1021,13 +1031,8 @@ static bool acpi_s2idle_wake(void)
 		 * should be missed by canceling the wakeup here.
 		 */
 		pm_system_cancel_wakeup();
-		/*
-		 * The EC driver uses the system workqueue and an additional
-		 * special one, so those need to be flushed too.
-		 */
-		acpi_os_wait_events_complete(); /* synchronize EC GPE processing */
-		acpi_ec_flush_work();
-		acpi_os_wait_events_complete(); /* synchronize Notify handling */
+
+		acpi_s2idle_sync();
 
 		/*
 		 * The SCI is in the "suspended" state now and it cannot produce
@@ -1055,6 +1060,13 @@ static void acpi_s2idle_restore_early(vo
 
 static void acpi_s2idle_restore(void)
 {
+	/*
+	 * Drain pending events before restoring the working-state configuration
+	 * of GPEs.
+	 */
+	acpi_os_wait_events_complete(); /* synchronize GPE processing */
+	acpi_s2idle_sync();
+
 	s2idle_wakeup = false;
 
 	acpi_enable_all_runtime_gpes();



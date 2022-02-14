Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3280C4B47C7
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243286AbiBNJou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:44:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245111AbiBNJoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:44:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F53C6D18E;
        Mon, 14 Feb 2022 01:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4C7EB80DC4;
        Mon, 14 Feb 2022 09:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017F6C340E9;
        Mon, 14 Feb 2022 09:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831488;
        bh=ZSq3veFCTru8SYDIQac3U/vHQgYxxYNddu41EAVyz4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8gMYdluW3RMHK14cxzkVCKJYBmw7SUSWsEPX2Kjra+J4vhgZVz5y+XoEXKjHbuY9
         70+3JdoS8OKPFhaX23zgh/HZNJF2zwCZYHGqF6IPlqfymRMVMhVRAF9ChHoxufNVm1
         /wJ1MtzgHfQHBy+duo7SnOI25A4zCtfjWrCM04kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 71/71] ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE
Date:   Mon, 14 Feb 2022 10:26:39 +0100
Message-Id: <20220214092454.423611860@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit dc0075ba7f387fe4c48a8c674b11ab6f374a6acc upstream.

Commit 4a9af6cac050 ("ACPI: EC: Rework flushing of EC work while
suspended to idle") made acpi_ec_dispatch_gpe() check
pm_wakeup_pending(), but that is before canceling the SCI wakeup,
so pm_wakeup_pending() is always true.  This causes the loop in
acpi_ec_dispatch_gpe() to always terminate after one iteration which
may not be correct.

Address this issue by canceling the SCI wakeup earlier, from
acpi_ec_dispatch_gpe() itself.

Fixes: 4a9af6cac050 ("ACPI: EC: Rework flushing of EC work while suspended to idle")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c    |   10 ++++++++++
 drivers/acpi/sleep.c |   14 ++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2003,6 +2003,16 @@ bool acpi_ec_dispatch_gpe(void)
 		return true;
 
 	/*
+	 * Cancel the SCI wakeup and process all pending events in case there
+	 * are any wakeup ones in there.
+	 *
+	 * Note that if any non-EC GPEs are active at this point, the SCI will
+	 * retrigger after the rearming in acpi_s2idle_wake(), so no events
+	 * should be missed by canceling the wakeup here.
+	 */
+	pm_system_cancel_wakeup();
+
+	/*
 	 * Dispatch the EC GPE in-band, but do not report wakeup in any case
 	 * to allow the caller to process events properly after that.
 	 */
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1003,19 +1003,13 @@ static bool acpi_s2idle_wake(void)
 		if (acpi_check_wakeup_handlers())
 			return true;
 
-		/* Check non-EC GPE wakeups and dispatch the EC GPE. */
+		/*
+		 * Check non-EC GPE wakeups and if there are none, cancel the
+		 * SCI-related wakeup and dispatch the EC GPE.
+		 */
 		if (acpi_ec_dispatch_gpe())
 			return true;
 
-		/*
-		 * Cancel the SCI wakeup and process all pending events in case
-		 * there are any wakeup ones in there.
-		 *
-		 * Note that if any non-EC GPEs are active at this point, the
-		 * SCI will retrigger after the rearming below, so no events
-		 * should be missed by canceling the wakeup here.
-		 */
-		pm_system_cancel_wakeup();
 		acpi_os_wait_events_complete();
 
 		/*



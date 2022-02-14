Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27CB4B470F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245543AbiBNJwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343510AbiBNJur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:50:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0208654BE;
        Mon, 14 Feb 2022 01:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BE3461190;
        Mon, 14 Feb 2022 09:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD5BC340E9;
        Mon, 14 Feb 2022 09:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831699;
        bh=tvJGlZcKHMJrtQcp+CZ4xSeF/sEJb4vveouu65YICaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvD08sAeQ3rbnjEcNH0gFGCXkmieTb5O6S6703LJ2WMGY6JUV3R7snXFYHqPawQ+k
         Qzy9I7Pro2WZ10DsONQE2eJy8bnkJaaBSW/60KR04Ew1Q+WyM54o6XCzvpHFz3ejXt
         +ynAIJa8WZe4/zuj9l4Z3Yc70Sg2+hT0jbkExYMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/116] ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE
Date:   Mon, 14 Feb 2022 10:26:05 +0100
Message-Id: <20220214092501.027060564@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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

[ Upstream commit dc0075ba7f387fe4c48a8c674b11ab6f374a6acc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c    | 10 ++++++++++
 drivers/acpi/sleep.c | 14 ++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 3f2e5ea9ab6b7..8347eaee679c8 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2064,6 +2064,16 @@ bool acpi_ec_dispatch_gpe(void)
 	if (acpi_any_gpe_status_set(first_ec->gpe))
 		return true;
 
+	/*
+	 * Cancel the SCI wakeup and process all pending events in case there
+	 * are any wakeup ones in there.
+	 *
+	 * Note that if any non-EC GPEs are active at this point, the SCI will
+	 * retrigger after the rearming in acpi_s2idle_wake(), so no events
+	 * should be missed by canceling the wakeup here.
+	 */
+	pm_system_cancel_wakeup();
+
 	/*
 	 * Dispatch the EC GPE in-band, but do not report wakeup in any case
 	 * to allow the caller to process events properly after that.
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 503935b1deeb1..e2614ea820bb8 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1012,21 +1012,15 @@ static bool acpi_s2idle_wake(void)
 			return true;
 		}
 
-		/* Check non-EC GPE wakeups and dispatch the EC GPE. */
+		/*
+		 * Check non-EC GPE wakeups and if there are none, cancel the
+		 * SCI-related wakeup and dispatch the EC GPE.
+		 */
 		if (acpi_ec_dispatch_gpe()) {
 			pm_pr_dbg("ACPI non-EC GPE wakeup\n");
 			return true;
 		}
 
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
-- 
2.34.1




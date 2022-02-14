Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC2B4B4952
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347775AbiBNKbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348959AbiBNKbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9819DD6D;
        Mon, 14 Feb 2022 01:59:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D7D560C38;
        Mon, 14 Feb 2022 09:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5CCC340F0;
        Mon, 14 Feb 2022 09:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832797;
        bh=fgTxHlgAuSLN0JbaPkeomaLEwcnrryB9lPiCvLTAvSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/TR2+VXMUgFS9mYyP34RC9ClyoCYqQSSap7gzDSyIsSmfFjjN8qxkXYybexhFlyS
         2XTt0qdx+ywQoCU6zAAFtkNpOgX/uyGz9m4iv92viXKAWDhzNLPwXM3DFnxBWsUPLa
         AqEx9z4XQFLi2N1N7iPokHhz6abeC0kTRJ9ViCpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 127/203] ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE
Date:   Mon, 14 Feb 2022 10:26:11 +0100
Message-Id: <20220214092514.556008650@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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
index b9c44e6c5e400..1712990bf2ad8 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2051,6 +2051,16 @@ bool acpi_ec_dispatch_gpe(void)
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
index 9f237dc9d45fc..8513410ca2fc2 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -739,21 +739,15 @@ bool acpi_s2idle_wake(void)
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




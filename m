Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16F74B499C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344966AbiBNKH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:07:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345888AbiBNKHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:07:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9C674DE5;
        Mon, 14 Feb 2022 01:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47EAEB80DC4;
        Mon, 14 Feb 2022 09:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AED6C340E9;
        Mon, 14 Feb 2022 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832184;
        bh=xgvGDpPtHORyw1EJlVVMNsL8hLWusH/bXXGoEfhnHQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkUMiNTbatu78ZTd+KOLbXPMmGdlWmFbbiec7tpBQYzlO4uHQ3Q4nJuuFp3T/FYC2
         Tnmunj235cCKdTCJRQXKY500aiV0FmhRKE2kih8/UuS+h8MtX5eObxt6X6rNRvdxA/
         naAiWMnEVihVqgoUFkjOxotZfQiboSqvPoUGpf0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/172] ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE
Date:   Mon, 14 Feb 2022 10:26:04 +0100
Message-Id: <20220214092510.074083242@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index 9b859ff976e89..98d1782275440 100644
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
index 7ae09e4b45927..245a0fa979cbb 100644
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




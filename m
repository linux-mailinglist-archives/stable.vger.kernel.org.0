Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5584D4C27
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbiCJOdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343917AbiCJOb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BC8E3C76;
        Thu, 10 Mar 2022 06:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 632D1B82544;
        Thu, 10 Mar 2022 14:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F38C340E8;
        Thu, 10 Mar 2022 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922491;
        bh=hcmMPrD/HN9xwyxoEWxYnoKf3Q5krhbZGmA8gMdOtgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCEta4gtzYRt/eLXwYR+QwDex85u0di6JhF4IXeoXlJLTuWyf91ZjnONh6G8zU3yi
         uZwtgDuT4BW7p0gpg15WPLok2NpBjAi1XTs0q4mh0HzxXk2vRPbKMXK48YhcuOnKuQ
         ojDfKSKJJK7QA023RbER4U4rNAro0cbXQEYK7R6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>
Subject: [PATCH 5.4 33/33] Revert "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
Date:   Thu, 10 Mar 2022 15:19:34 +0100
Message-Id: <20220310140809.711995140@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 9d09cb110868f027d015fbc6c64ba1e45a69a192 which is
commit dc0075ba7f387fe4c48a8c674b11ab6f374a6acc upstream.

It's been reported to cause problems with a number of Fedora and Arch
Linux users, so drop it for now until that is resolved.

Link: https://lore.kernel.org/r/CAJZ5v0gE52NT=4kN4MkhV3Gx=M5CeMGVHOF0jgTXDb5WwAMs_Q@mail.gmail.com
Link: https://lore.kernel.org/r/31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com
Reported-by: Hans de Goede <hdegoede@redhat.com>
Reported-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>
Cc: Mark Pearson <markpearson@lenovo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c    |   10 ----------
 drivers/acpi/sleep.c |   14 ++++++++++----
 2 files changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2003,16 +2003,6 @@ bool acpi_ec_dispatch_gpe(void)
 		return true;
 
 	/*
-	 * Cancel the SCI wakeup and process all pending events in case there
-	 * are any wakeup ones in there.
-	 *
-	 * Note that if any non-EC GPEs are active at this point, the SCI will
-	 * retrigger after the rearming in acpi_s2idle_wake(), so no events
-	 * should be missed by canceling the wakeup here.
-	 */
-	pm_system_cancel_wakeup();
-
-	/*
 	 * Dispatch the EC GPE in-band, but do not report wakeup in any case
 	 * to allow the caller to process events properly after that.
 	 */
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1003,13 +1003,19 @@ static bool acpi_s2idle_wake(void)
 		if (acpi_check_wakeup_handlers())
 			return true;
 
-		/*
-		 * Check non-EC GPE wakeups and if there are none, cancel the
-		 * SCI-related wakeup and dispatch the EC GPE.
-		 */
+		/* Check non-EC GPE wakeups and dispatch the EC GPE. */
 		if (acpi_ec_dispatch_gpe())
 			return true;
 
+		/*
+		 * Cancel the SCI wakeup and process all pending events in case
+		 * there are any wakeup ones in there.
+		 *
+		 * Note that if any non-EC GPEs are active at this point, the
+		 * SCI will retrigger after the rearming below, so no events
+		 * should be missed by canceling the wakeup here.
+		 */
+		pm_system_cancel_wakeup();
 		acpi_os_wait_events_complete();
 
 		/*



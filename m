Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C48565D38C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjADM5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjADM5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:57:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210E1EE12
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCA75B81629
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D48FC433D2;
        Wed,  4 Jan 2023 12:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672837060;
        bh=2/dzY9qLYO4AJpqHDHfui33vaYahtNlzjyU/5/HvTP4=;
        h=Subject:To:Cc:From:Date:From;
        b=rZuodK0kbpxVBUK9/mPB33lqWzqGyOOx6mxIYIbEjpRf2ZxdjqKjIVxB7BJD0h6Ox
         Wg+6oK6iOE1UEUO0RpaWFXpWG8JmMgobdqWtNkkd0ucpaEJhTYDXvzFwsKFbUXKuLe
         fKdQG9PReoQoOobSAwkwH1Zu+kUuHM5XoxGB9XqU=
Subject: FAILED: patch "[PATCH] x86/MCE/AMD: Clear DFR errors found in THR handler" failed to apply to 5.15-stable tree
To:     yazen.ghannam@amd.com, bp@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:57:32 +0100
Message-ID: <1672837052164212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

bc1b705b0eee ("x86/MCE/AMD: Clear DFR errors found in THR handler")
8121b8f947be ("x86/mce: Get rid of msr_ops")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bc1b705b0eee4c645ad8b3bbff3c8a66e9688362 Mon Sep 17 00:00:00 2001
From: Yazen Ghannam <yazen.ghannam@amd.com>
Date: Tue, 21 Jun 2022 15:59:43 +0000
Subject: [PATCH] x86/MCE/AMD: Clear DFR errors found in THR handler

AMD's MCA Thresholding feature counts errors of all severity levels, not
just correctable errors. If a deferred error causes the threshold limit
to be reached (it was the error that caused the overflow), then both a
deferred error interrupt and a thresholding interrupt will be triggered.

The order of the interrupts is not guaranteed. If the threshold
interrupt handler is executed first, then it will clear MCA_STATUS for
the error. It will not check or clear MCA_DESTAT which also holds a copy
of the deferred error. When the deferred error interrupt handler runs it
will not find an error in MCA_STATUS, but it will find the error in
MCA_DESTAT. This will cause two errors to be logged.

Check for deferred errors when handling a threshold interrupt. If a bank
contains a deferred error, then clear the bank's MCA_DESTAT register.

Define a new helper function to do the deferred error check and clearing
of MCA_DESTAT.

  [ bp: Simplify, convert comment to passive voice. ]

Fixes: 37d43acfd79f ("x86/mce/AMD: Redo error logging from APIC LVT interrupt handlers")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220621155943.33623-1-yazen.ghannam@amd.com

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 1c87501e0fa3..10fb5b5c9efa 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -788,6 +788,24 @@ _log_error_bank(unsigned int bank, u32 msr_stat, u32 msr_addr, u64 misc)
 	return status & MCI_STATUS_DEFERRED;
 }
 
+static bool _log_error_deferred(unsigned int bank, u32 misc)
+{
+	if (!_log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS),
+			     mca_msr_reg(bank, MCA_ADDR), misc))
+		return false;
+
+	/*
+	 * Non-SMCA systems don't have MCA_DESTAT/MCA_DEADDR registers.
+	 * Return true here to avoid accessing these registers.
+	 */
+	if (!mce_flags.smca)
+		return true;
+
+	/* Clear MCA_DESTAT if the deferred error was logged from MCA_STATUS. */
+	wrmsrl(MSR_AMD64_SMCA_MCx_DESTAT(bank), 0);
+	return true;
+}
+
 /*
  * We have three scenarios for checking for Deferred errors:
  *
@@ -799,19 +817,8 @@ _log_error_bank(unsigned int bank, u32 msr_stat, u32 msr_addr, u64 misc)
  */
 static void log_error_deferred(unsigned int bank)
 {
-	bool defrd;
-
-	defrd = _log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS),
-				mca_msr_reg(bank, MCA_ADDR), 0);
-
-	if (!mce_flags.smca)
-		return;
-
-	/* Clear MCA_DESTAT if we logged the deferred error from MCA_STATUS. */
-	if (defrd) {
-		wrmsrl(MSR_AMD64_SMCA_MCx_DESTAT(bank), 0);
+	if (_log_error_deferred(bank, 0))
 		return;
-	}
 
 	/*
 	 * Only deferred errors are logged in MCA_DE{STAT,ADDR} so just check
@@ -832,7 +839,7 @@ static void amd_deferred_error_interrupt(void)
 
 static void log_error_thresholding(unsigned int bank, u64 misc)
 {
-	_log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS), mca_msr_reg(bank, MCA_ADDR), misc);
+	_log_error_deferred(bank, misc);
 }
 
 static void log_and_reset_block(struct threshold_block *block)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E4865D87D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbjADQPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239926AbjADQPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:15:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA543E0EE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:14:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFCD3B81732
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0836DC433EF;
        Wed,  4 Jan 2023 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848874;
        bh=wme1ajKnHr9x60woycRFxX2ffEgpDURTOm80zlSt2V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDzKHFaqREZpKm6qhqnYpflpH45/SUyGDntTwyTxhgWzX2Wbf61UkluY1aOuGAETo
         R2RS2qz5gQqC6GFtHG/3e8eumlXQfO9xiZ/RbQSSgLzjPyF5EMXt5jkBSds0dIyHZA
         ZmQrbRv8xFI0TR+AHqkJRLHcvgXfiKFXsoDtqsNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.0 028/177] x86/MCE/AMD: Clear DFR errors found in THR handler
Date:   Wed,  4 Jan 2023 17:05:19 +0100
Message-Id: <20230104160508.518582331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit bc1b705b0eee4c645ad8b3bbff3c8a66e9688362 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -788,6 +788,24 @@ _log_error_bank(unsigned int bank, u32 m
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
@@ -799,19 +817,8 @@ _log_error_bank(unsigned int bank, u32 m
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
@@ -832,7 +839,7 @@ static void amd_deferred_error_interrupt
 
 static void log_error_thresholding(unsigned int bank, u64 misc)
 {
-	_log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS), mca_msr_reg(bank, MCA_ADDR), misc);
+	_log_error_deferred(bank, misc);
 }
 
 static void log_and_reset_block(struct threshold_block *block)



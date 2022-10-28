Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C83610A66
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 08:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJ1GmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 02:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJ1Glc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 02:41:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E476B8F2;
        Thu, 27 Oct 2022 23:41:21 -0700 (PDT)
Date:   Fri, 28 Oct 2022 06:41:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666939279;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G66XG9gLBxL7ayzwcWq/23hJvItsciCHWB9RfR+j2i4=;
        b=FUMEyRbm3jWkbleEcg+oEr0KhLAOceC3tjtjDDflRHBN07EOkWNt72NQaCjynARJ283r/O
        6KC5UtXMHwOYWKL8Eggfp1Wv4bwDIwjk735nHVCeUDKihTQFNt6MeEsge5DGZZZSmeCHky
        Mq0nxvOgp3QiFAz73tOY/gcSPtgCzGIkT3rXye5NNv8xlZiCTpR8e72XdphaePz32W6/+m
        roDARgsgNBmRn1A21Rzp5M2jzRpXz9E6pC6t/vUMQitV66r6OdUnmo1wzlQnilA7quvuMQ
        UbDmHQPho6Y2wTKa6fsFSUJyAlZyUdOZmPFJ2kzmKhzCm81zQqmPWTWUX5ePZw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666939279;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G66XG9gLBxL7ayzwcWq/23hJvItsciCHWB9RfR+j2i4=;
        b=1gTDZ4GRJ0JhSKHFD0FQSMDNLWhbcNJSpGGuqTPm5vbGITbgfI33lyNWPWV+ZT0yjL8GaI
        RqMsv0aOJDDzgLBA==
From:   "tip-bot2 for Yazen Ghannam" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/core] x86/MCE/AMD: Clear DFR errors found in THR handler
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220621155943.33623-1-yazen.ghannam@amd.com>
References: <20220621155943.33623-1-yazen.ghannam@amd.com>
MIME-Version: 1.0
Message-ID: <166693927682.29415.17717990197566504986.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/core branch of tip:

Commit-ID:     bc1b705b0eee4c645ad8b3bbff3c8a66e9688362
Gitweb:        https://git.kernel.org/tip/bc1b705b0eee4c645ad8b3bbff3c8a66e9688362
Author:        Yazen Ghannam <yazen.ghannam@amd.com>
AuthorDate:    Tue, 21 Jun 2022 15:59:43 
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 27 Oct 2022 17:01:25 +02:00

x86/MCE/AMD: Clear DFR errors found in THR handler

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
---
 arch/x86/kernel/cpu/mce/amd.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 1c87501..10fb5b5 100644
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

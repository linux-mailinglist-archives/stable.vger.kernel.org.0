Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACD9CE5F8
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfJGOvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:51:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44388 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbfJGOte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:49:34 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iHUJy-0005pR-3u; Mon, 07 Oct 2019 16:49:10 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id B08421C0895;
        Mon,  7 Oct 2019 16:49:09 +0200 (CEST)
Date:   Mon, 07 Oct 2019 14:49:09 -0000
From:   "tip-bot2 for Jerry Snitselaar" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/tpm: Only set 'efi_tpm_final_log_size' after
 successful event log parsing
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Wunner <lukas@wunner.de>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20191002165904.8819-6-ard.biesheuvel@linaro.org>
References: <20191002165904.8819-6-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Message-ID: <157045974966.9978.8246206842413529379.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     e658c82be5561412c5e83b5e74e9da4830593f3e
Gitweb:        https://git.kernel.org/tip/e658c82be5561412c5e83b5e74e9da4830593f3e
Author:        Jerry Snitselaar <jsnitsel@redhat.com>
AuthorDate:    Wed, 02 Oct 2019 18:59:02 +02:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Mon, 07 Oct 2019 15:24:36 +02:00

efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing

If __calc_tpm2_event_size() fails to parse an event it will return 0,
resulting tpm2_calc_event_log_size() returning -1. Currently there is
no check of this return value, and 'efi_tpm_final_log_size' can end up
being set to this negative value resulting in a crash like this one:

  BUG: unable to handle page fault for address: ffffbc8fc00866ad
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page

  RIP: 0010:memcpy_erms+0x6/0x10
  Call Trace:
   tpm_read_log_efi()
   tpm_bios_log_setup()
   tpm_chip_register()
   tpm_tis_core_init.cold.9+0x28c/0x466
   tpm_tis_plat_probe()
   platform_drv_probe()
   ...

Also __calc_tpm2_event_size() returns a size of 0 when it fails
to parse an event, so update function documentation to reflect this.

The root cause of the issue that caused the failure of event parsing
in this case is resolved by Peter Jone's patchset dealing with large
event logs where crossing over a page boundary causes the page with
the event count to be unmapped.

Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Scott Talbert <swt@techie.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: c46f3405692de ("tpm: Reserve the TPM final events table")
Link: https://lkml.kernel.org/r/20191002165904.8819-6-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/firmware/efi/tpm.c   |  9 ++++++++-
 include/linux/tpm_eventlog.h |  2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index b9ae5c6..703469c 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -85,11 +85,18 @@ int __init efi_tpm_eventlog_init(void)
 						    final_tbl->nr_events,
 						    log_tbl->log);
 	}
+
+	if (tbl_size < 0) {
+		pr_err(FW_BUG "Failed to parse event in TPM Final Events Log\n");
+		goto out_calc;
+	}
+
 	memblock_reserve((unsigned long)final_tbl,
 			 tbl_size + sizeof(*final_tbl));
-	early_memunmap(final_tbl, sizeof(*final_tbl));
 	efi_tpm_final_log_size = tbl_size;
 
+out_calc:
+	early_memunmap(final_tbl, sizeof(*final_tbl));
 out:
 	early_memunmap(log_tbl, sizeof(*log_tbl));
 	return ret;
diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index b50cc3a..131ea1b 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -152,7 +152,7 @@ struct tcg_algorithm_info {
  * total. Once we've done this we know the offset of the data length field,
  * and can calculate the total size of the event.
  *
- * Return: size of the event on success, <0 on failure
+ * Return: size of the event on success, 0 on failure
  */
 
 static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,

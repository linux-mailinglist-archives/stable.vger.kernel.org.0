Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C03D9E70
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438374AbfJPV7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438364AbfJPV7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:02 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FD221E6F;
        Wed, 16 Oct 2019 21:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263141;
        bh=NXQkog5XLhxkoS1MMABH5+Ooyaj6tXLdrLg3O7FuWrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0+ZYR0u1ZXhD4aRzP/+FtcB78EUWE1DYoEtGzAQmGL8T1GaPkwB4u7kaPs+QpeDZ
         x6NdzKnAzIVmdG0/lH1JgdDsKZ5MR/eVv/oXGxw78jt2rUkxrDUcWjQIhUq5CkgWwS
         oH+lH1LsPsD5rCwWLFCILTQ3daPRKkpJKnbEjjpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
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
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.3 065/112] efi/tpm: Only set efi_tpm_final_log_size after successful event log parsing
Date:   Wed, 16 Oct 2019 14:50:57 -0700
Message-Id: <20191016214901.944210386@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

commit e658c82be5561412c5e83b5e74e9da4830593f3e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/tpm.c   |    9 ++++++++-
 include/linux/tpm_eventlog.h |    2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

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



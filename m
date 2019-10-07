Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D43CE5D2
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfJGOtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:49:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44463 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfJGOtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:49:40 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iHUJy-0005pU-64; Mon, 07 Oct 2019 16:49:10 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id D3C031C08B0;
        Mon,  7 Oct 2019 16:49:09 +0200 (CEST)
Date:   Mon, 07 Oct 2019 14:49:09 -0000
From:   "tip-bot2 for Peter Jones" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/tpm: Don't traverse an event log with no events
Cc:     Lyude Paul <lyude@redhat.com>, Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matthew Garrett <mjg59@google.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Wunner <lukas@wunner.de>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20191002165904.8819-5-ard.biesheuvel@linaro.org>
References: <20191002165904.8819-5-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Message-ID: <157045974981.9978.10521392421826592930.tip-bot2@tip-bot2>
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

Commit-ID:     05c8c1ff81ed2eb9bad7c27cf92e55c864c16df8
Gitweb:        https://git.kernel.org/tip/05c8c1ff81ed2eb9bad7c27cf92e55c864c16df8
Author:        Peter Jones <pjones@redhat.com>
AuthorDate:    Wed, 02 Oct 2019 18:59:01 +02:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Mon, 07 Oct 2019 15:24:35 +02:00

efi/tpm: Don't traverse an event log with no events

When there are no entries to put into the final event log, some machines
will return the template they would have populated anyway.  In this case
the nr_events field is 0, but the rest of the log is just garbage.

This patch stops us from trying to iterate the table with
__calc_tpm2_event_size() when the number of events in the table is 0.

Tested-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Acked-by: Matthew Garrett <mjg59@google.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Scott Talbert <swt@techie.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: c46f3405692d ("tpm: Reserve the TPM final events table")
Link: https://lkml.kernel.org/r/20191002165904.8819-5-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/firmware/efi/tpm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 1d3f5ca..b9ae5c6 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -75,11 +75,16 @@ int __init efi_tpm_eventlog_init(void)
 		goto out;
 	}
 
-	tbl_size = tpm2_calc_event_log_size((void *)efi.tpm_final_log
-					    + sizeof(final_tbl->version)
-					    + sizeof(final_tbl->nr_events),
-					    final_tbl->nr_events,
-					    log_tbl->log);
+	tbl_size = 0;
+	if (final_tbl->nr_events != 0) {
+		void *events = (void *)efi.tpm_final_log
+				+ sizeof(final_tbl->version)
+				+ sizeof(final_tbl->nr_events);
+
+		tbl_size = tpm2_calc_event_log_size(events,
+						    final_tbl->nr_events,
+						    log_tbl->log);
+	}
 	memblock_reserve((unsigned long)final_tbl,
 			 tbl_size + sizeof(*final_tbl));
 	early_memunmap(final_tbl, sizeof(*final_tbl));

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1E7D9F0D
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406868AbfJPWEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438357AbfJPV7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:01 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D96221A49;
        Wed, 16 Oct 2019 21:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263140;
        bh=4xJdH9kiHe2LVsMTel/OrXlDj2ZKHxjrUQ6T4JRXoFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=De6ExkF7wVeRRDdy58ATeybhFXTE+n8SMTprMei9r9u8MpT6tet/tiK9J5V4fDe7c
         qNi7JEuiL4QNNKmYfefq4sXUB0BW9vXDli0SZPQ8zG3+E8uMdM1tw4vheH2XmBCDhB
         bClbO3RykCYJPYzpPPFRp1nCb3YCkOP/hvFynsJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Peter Jones <pjones@redhat.com>,
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
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.3 064/112] efi/tpm: Dont traverse an event log with no events
Date:   Wed, 16 Oct 2019 14:50:56 -0700
Message-Id: <20191016214901.749711997@linuxfoundation.org>
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

From: Peter Jones <pjones@redhat.com>

commit 05c8c1ff81ed2eb9bad7c27cf92e55c864c16df8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/tpm.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

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



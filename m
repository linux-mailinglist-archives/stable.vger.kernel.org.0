Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAAB6BDBFE
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 12:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389161AbfIYKQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 06:16:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:21948 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfIYKQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 06:16:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 03:16:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="340366339"
Received: from dariusvo-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.150])
  by orsmga004.jf.intel.com with ESMTP; 25 Sep 2019 03:16:35 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Peter Jones <pjones@redhat.com>, linux-efi@vger.kernel.org,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Matthew Garrett <mjg59@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] efi+tpm: don't traverse an event log with no events
Date:   Wed, 25 Sep 2019 13:16:19 +0300
Message-Id: <20190925101622.31457-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
References: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

When there are no entries to put into the final event log, some machines
will return the template they would have populated anyway.  In this case
the nr_events field is 0, but the rest of the log is just garbage.

This patch stops us from trying to iterate the table with
__calc_tpm2_event_size() when the number of events in the table is 0.

Fixes: c46f3405692d ("tpm: Reserve the TPM final events table")
Cc: linux-efi@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Peter Jones <pjones@redhat.com>
Tested-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Acked-by: Matthew Garrett <mjg59@google.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/firmware/efi/tpm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 1d3f5ca3eaaf..b9ae5c6f9b9c 100644
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
-- 
2.20.1


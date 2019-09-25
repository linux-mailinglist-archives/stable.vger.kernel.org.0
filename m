Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2387BDBFA
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 12:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbfIYKQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 06:16:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:40402 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfIYKQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 06:16:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 03:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="193723106"
Received: from dariusvo-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.150])
  by orsmga006.jf.intel.com with ESMTP; 25 Sep 2019 03:16:27 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Peter Jones <pjones@redhat.com>, linux-efi@vger.kernel.org,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Matthew Garrett <mjg59@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] efi+tpm: Don't access event->count when it isn't mapped.
Date:   Wed, 25 Sep 2019 13:16:18 +0300
Message-Id: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

Some machines generate a lot of event log entries.  When we're
iterating over them, the code removes the old mapping and adds a
new one, so once we cross the page boundary we're unmapping the page
with the count on it.  Hilarity ensues.

This patch keeps the info from the header in local variables so we don't
need to access that page again or keep track of if it's mapped.

Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
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
 include/linux/tpm_eventlog.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 63238c84dc0b..12584b69a3f3 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -170,6 +170,7 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	u16 halg;
 	int i;
 	int j;
+	u32 count, event_type;
 
 	marker = event;
 	marker_start = marker;
@@ -190,16 +191,22 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	}
 
 	event = (struct tcg_pcr_event2_head *)mapping;
+	/*
+	 * the loop below will unmap these fields if the log is larger than
+	 * one page, so save them here for reference.
+	 */
+	count = READ_ONCE(event->count);
+	event_type = READ_ONCE(event->event_type);
 
 	efispecid = (struct tcg_efi_specid_event_head *)event_header->event;
 
 	/* Check if event is malformed. */
-	if (event->count > efispecid->num_algs) {
+	if (count > efispecid->num_algs) {
 		size = 0;
 		goto out;
 	}
 
-	for (i = 0; i < event->count; i++) {
+	for (i = 0; i < count; i++) {
 		halg_size = sizeof(event->digests[i].alg_id);
 
 		/* Map the digest's algorithm identifier */
@@ -256,8 +263,9 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 		+ event_field->event_size;
 	size = marker - marker_start;
 
-	if ((event->event_type == 0) && (event_field->event_size == 0))
+	if (event_type == 0 && event_field->event_size == 0)
 		size = 0;
+
 out:
 	if (do_mapping)
 		TPM_MEMUNMAP(mapping, mapping_size);
-- 
2.20.1


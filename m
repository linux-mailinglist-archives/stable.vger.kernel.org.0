Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D256D9F13
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390633AbfJPWEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438354AbfJPV7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:00 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 979B2218DE;
        Wed, 16 Oct 2019 21:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263139;
        bh=zDAyQj87Ix+mlCwGZuPzUCOe+91kc9aoAPI8vKo9zP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYulFleah8emP24FFJPI2rc7LrYUVllvon1X7iISzg5qgb/wZDrd2ukTgiLzclxQS
         6aEY5aVQ5VNDSG6AFz2hwRlza1mp3btWRDZNu/B+zX3ooo7AVDeY4lGIK1QKNxr5Oy
         8izx7lw3dcmHPRS7VyBGsgrgAGyltNlHv/nJX9Ak=
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
Subject: [PATCH 5.3 063/112] efi/tpm: Dont access event->count when it isnt mapped
Date:   Wed, 16 Oct 2019 14:50:55 -0700
Message-Id: <20191016214901.201583264@linuxfoundation.org>
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

commit 047d50aee341d940350897c85799e56ae57c3849 upstream.

Some machines generate a lot of event log entries.  When we're
iterating over them, the code removes the old mapping and adds a
new one, so once we cross the page boundary we're unmapping the page
with the count on it.  Hilarity ensues.

This patch keeps the info from the header in local variables so we don't
need to access that page again or keep track of if it's mapped.

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
Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
Link: https://lkml.kernel.org/r/20191002165904.8819-4-ard.biesheuvel@linaro.org
[ Minor edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/tpm_eventlog.h |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -170,6 +170,7 @@ static inline int __calc_tpm2_event_size
 	u16 halg;
 	int i;
 	int j;
+	u32 count, event_type;
 
 	marker = event;
 	marker_start = marker;
@@ -190,16 +191,22 @@ static inline int __calc_tpm2_event_size
 	}
 
 	event = (struct tcg_pcr_event2_head *)mapping;
+	/*
+	 * The loop below will unmap these fields if the log is larger than
+	 * one page, so save them here for reference:
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
@@ -256,8 +263,9 @@ static inline int __calc_tpm2_event_size
 		+ event_field->event_size;
 	size = marker - marker_start;
 
-	if ((event->event_type == 0) && (event_field->event_size == 0))
+	if (event_type == 0 && event_field->event_size == 0)
 		size = 0;
+
 out:
 	if (do_mapping)
 		TPM_MEMUNMAP(mapping, mapping_size);



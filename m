Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3B20D94F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbgF2Tqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387792AbgF2Tkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BBBC24890;
        Mon, 29 Jun 2020 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444389;
        bh=hSAK8Mcvp45jbcUJDk/GAFg+Sn0L3Ei1iFMlI2KVjU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuOu0XFgRd6i5d7EFGCVlCu+cO/VO2z0fnrXdrTAFZ/t5DlqVhj7zJMTpOvQf7xOr
         4ZeOOTYP06AWVYugI0T9cHEm3wQpGk0R5H6xpCJt1E3UTl0vRIVT6bx7RF9QMgzw8l
         L11f6fYXVqk5DTMtOv1D3xesqKbxbkUSME4wMlvU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabian Vogt <fvogt@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/178] efi/tpm: Verify event log header before parsing
Date:   Mon, 29 Jun 2020 11:23:31 -0400
Message-Id: <20200629152523.2494198-67-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Vogt <fvogt@suse.de>

[ Upstream commit 7dfc06a0f25b593a9f51992f540c0f80a57f3629 ]

It is possible that the first event in the event log is not actually a
log header at all, but rather a normal event. This leads to the cast in
__calc_tpm2_event_size being an invalid conversion, which means that
the values read are effectively garbage. Depending on the first event's
contents, this leads either to apparently normal behaviour, a crash or
a freeze.

While this behaviour of the firmware is not in accordance with the
TCG Client EFI Specification, this happens on a Dell Precision 5510
with the TPM enabled but hidden from the OS ("TPM On" disabled, state
otherwise untouched). The EFI firmware claims that the TPM is present
and active and that it supports the TCG 2.0 event log format.

Fortunately, this can be worked around by simply checking the header
of the first event and the event log header signature itself.

Commit b4f1874c6216 ("tpm: check event log version before reading final
events") addressed a similar issue also found on Dell models.

Fixes: 6b0326190205 ("efi: Attempt to get the TCG2 event log in the boot stub")
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Link: https://lore.kernel.org/r/1927248.evlx2EsYKh@linux-e202.suse.de
Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1165773
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tpm_eventlog.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 131ea1bad458b..eccfd3a4e4c85 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -81,6 +81,8 @@ struct tcg_efi_specid_event_algs {
 	u16 digest_size;
 } __packed;
 
+#define TCG_SPECID_SIG "Spec ID Event03"
+
 struct tcg_efi_specid_event_head {
 	u8 signature[16];
 	u32 platform_class;
@@ -171,6 +173,7 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	int i;
 	int j;
 	u32 count, event_type;
+	const u8 zero_digest[sizeof(event_header->digest)] = {0};
 
 	marker = event;
 	marker_start = marker;
@@ -198,10 +201,19 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	count = READ_ONCE(event->count);
 	event_type = READ_ONCE(event->event_type);
 
+	/* Verify that it's the log header */
+	if (event_header->pcr_idx != 0 ||
+	    event_header->event_type != NO_ACTION ||
+	    memcmp(event_header->digest, zero_digest, sizeof(zero_digest))) {
+		size = 0;
+		goto out;
+	}
+
 	efispecid = (struct tcg_efi_specid_event_head *)event_header->event;
 
 	/* Check if event is malformed. */
-	if (count > efispecid->num_algs) {
+	if (memcmp(efispecid->signature, TCG_SPECID_SIG,
+		   sizeof(TCG_SPECID_SIG)) || count > efispecid->num_algs) {
 		size = 0;
 		goto out;
 	}
-- 
2.25.1


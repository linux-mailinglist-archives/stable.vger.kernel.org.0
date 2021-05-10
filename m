Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F642378500
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhEJK6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhEJKwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:52:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35FAD6186A;
        Mon, 10 May 2021 10:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643263;
        bh=Jt5EiUEh7mJTWxku/OtT7jTesUR66OVrgO5rF0CQvAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+5nsvqV1PmqLnLIFFoPy8nFs/SK6XzF9+HPVp1TpdGINBsStGDR6lMOsKfqzZkX7
         QF7ZnefvbVHVbxwNVJkyQ6cRu8Ze84xZbg+NmbHQhrzAnI+HuVbTXHghZ6rrD/YpEO
         Iqmniz00vcnm6Qr/yCQrvVUuhKTtiJvL7Iwnokhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 245/299] tpm: efi: Use local variable for calculating final log size
Date:   Mon, 10 May 2021 12:20:42 +0200
Message-Id: <20210510102013.049951750@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

commit 48cff270b037022e37835d93361646205ca25101 upstream.

When tpm_read_log_efi is called multiple times, which happens when
one loads and unloads a TPM2 driver multiple times, then the global
variable efi_tpm_final_log_size will at some point become a negative
number due to the subtraction of final_events_preboot_size occurring
each time. Use a local variable to avoid this integer underflow.

The following issue is now resolved:

Mar  8 15:35:12 hibinst kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
Mar  8 15:35:12 hibinst kernel: Workqueue: tpm-vtpm vtpm_proxy_work [tpm_vtpm_proxy]
Mar  8 15:35:12 hibinst kernel: RIP: 0010:__memcpy+0x12/0x20
Mar  8 15:35:12 hibinst kernel: Code: 00 b8 01 00 00 00 85 d2 74 0a c7 05 44 7b ef 00 0f 00 00 00 c3 cc cc cc 66 66 90 66 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 f3 a4
Mar  8 15:35:12 hibinst kernel: RSP: 0018:ffff9ac4c0fcfde0 EFLAGS: 00010206
Mar  8 15:35:12 hibinst kernel: RAX: ffff88f878cefed5 RBX: ffff88f878ce9000 RCX: 1ffffffffffffe0f
Mar  8 15:35:12 hibinst kernel: RDX: 0000000000000003 RSI: ffff9ac4c003bff9 RDI: ffff88f878cf0e4d
Mar  8 15:35:12 hibinst kernel: RBP: ffff9ac4c003b000 R08: 0000000000001000 R09: 000000007e9d6073
Mar  8 15:35:12 hibinst kernel: R10: ffff9ac4c003b000 R11: ffff88f879ad3500 R12: 0000000000000ed5
Mar  8 15:35:12 hibinst kernel: R13: ffff88f878ce9760 R14: 0000000000000002 R15: ffff88f77de7f018
Mar  8 15:35:12 hibinst kernel: FS:  0000000000000000(0000) GS:ffff88f87bd00000(0000) knlGS:0000000000000000
Mar  8 15:35:12 hibinst kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar  8 15:35:12 hibinst kernel: CR2: ffff9ac4c003c000 CR3: 00000001785a6004 CR4: 0000000000060ee0
Mar  8 15:35:12 hibinst kernel: Call Trace:
Mar  8 15:35:12 hibinst kernel: tpm_read_log_efi+0x152/0x1a7
Mar  8 15:35:12 hibinst kernel: tpm_bios_log_setup+0xc8/0x1c0
Mar  8 15:35:12 hibinst kernel: tpm_chip_register+0x8f/0x260
Mar  8 15:35:12 hibinst kernel: vtpm_proxy_work+0x16/0x60 [tpm_vtpm_proxy]
Mar  8 15:35:12 hibinst kernel: process_one_work+0x1b4/0x370
Mar  8 15:35:12 hibinst kernel: worker_thread+0x53/0x3e0
Mar  8 15:35:12 hibinst kernel: ? process_one_work+0x370/0x370

Cc: stable@vger.kernel.org
Fixes: 166a2809d65b ("tpm: Don't duplicate events from the final event log in the TCG2 log")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/efi.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/char/tpm/eventlog/efi.c
+++ b/drivers/char/tpm/eventlog/efi.c
@@ -17,6 +17,7 @@ int tpm_read_log_efi(struct tpm_chip *ch
 {
 
 	struct efi_tcg2_final_events_table *final_tbl = NULL;
+	int final_events_log_size = efi_tpm_final_log_size;
 	struct linux_efi_tpm_eventlog *log_tbl;
 	struct tpm_bios_log *log;
 	u32 log_size;
@@ -66,12 +67,12 @@ int tpm_read_log_efi(struct tpm_chip *ch
 	ret = tpm_log_version;
 
 	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR ||
-	    efi_tpm_final_log_size == 0 ||
+	    final_events_log_size == 0 ||
 	    tpm_log_version != EFI_TCG2_EVENT_LOG_FORMAT_TCG_2)
 		goto out;
 
 	final_tbl = memremap(efi.tpm_final_log,
-			     sizeof(*final_tbl) + efi_tpm_final_log_size,
+			     sizeof(*final_tbl) + final_events_log_size,
 			     MEMREMAP_WB);
 	if (!final_tbl) {
 		pr_err("Could not map UEFI TPM final log\n");
@@ -80,10 +81,18 @@ int tpm_read_log_efi(struct tpm_chip *ch
 		goto out;
 	}
 
-	efi_tpm_final_log_size -= log_tbl->final_events_preboot_size;
+	/*
+	 * The 'final events log' size excludes the 'final events preboot log'
+	 * at its beginning.
+	 */
+	final_events_log_size -= log_tbl->final_events_preboot_size;
 
+	/*
+	 * Allocate memory for the 'combined log' where we will append the
+	 * 'final events log' to.
+	 */
 	tmp = krealloc(log->bios_event_log,
-		       log_size + efi_tpm_final_log_size,
+		       log_size + final_events_log_size,
 		       GFP_KERNEL);
 	if (!tmp) {
 		kfree(log->bios_event_log);
@@ -94,15 +103,19 @@ int tpm_read_log_efi(struct tpm_chip *ch
 	log->bios_event_log = tmp;
 
 	/*
-	 * Copy any of the final events log that didn't also end up in the
-	 * main log. Events can be logged in both if events are generated
+	 * Append any of the 'final events log' that didn't also end up in the
+	 * 'main log'. Events can be logged in both if events are generated
 	 * between GetEventLog() and ExitBootServices().
 	 */
 	memcpy((void *)log->bios_event_log + log_size,
 	       final_tbl->events + log_tbl->final_events_preboot_size,
-	       efi_tpm_final_log_size);
+	       final_events_log_size);
+	/*
+	 * The size of the 'combined log' is the size of the 'main log' plus
+	 * the size of the 'final events log'.
+	 */
 	log->bios_event_log_end = log->bios_event_log +
-		log_size + efi_tpm_final_log_size;
+		log_size + final_events_log_size;
 
 out:
 	memunmap(final_tbl);



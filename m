Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD81E2C9F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392264AbgEZTQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392259AbgEZTQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62761208B3;
        Tue, 26 May 2020 19:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520568;
        bh=xYLMfo3x4uc56u3Wk4lKOOqV55aywVzsQJbqVj9oIg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUOMpemlq8t7vNO1tfD06FoFach4zAIPqXIpQlmioTT5+CiPLjh4cwcL+RwTmNiCZ
         rbgH0kEyXfV9lL8yeqGJD9hlk4ytRAD3W/prxBjXulnx+OdMfxp5d0UwAiiIstrdMf
         G9V5n3RJbhlvUFXGKFHv+8WZWIAwHDWkS+gllIGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lo=C3=AFc=20Yhuel?= <loic.yhuel@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.6 117/126] tpm: check event log version before reading final events
Date:   Tue, 26 May 2020 20:54:14 +0200
Message-Id: <20200526183947.274351163@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loïc Yhuel <loic.yhuel@gmail.com>

commit b4f1874c62168159fdb419ced4afc77c1b51c475 upstream.

This fixes the boot issues since 5.3 on several Dell models when the TPM
is enabled. Depending on the exact grub binary, booting the kernel would
freeze early, or just report an error parsing the final events log.

We get an event log in the SHA-1 format, which doesn't have a
tcg_efi_specid_event_head in the first event, and there is a final events
table which doesn't match the crypto agile format.
__calc_tpm2_event_size reads bad "count" and "efispecid->num_algs", and
either fails, or loops long enough for the machine to be appear frozen.

So we now only parse the final events table, which is per the spec always
supposed to be in the crypto agile format, when we got a event log in this
format.

Fixes: c46f3405692de ("tpm: Reserve the TPM final events table")
Fixes: 166a2809d65b2 ("tpm: Don't duplicate events from the final event log in the TCG2 log")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1779611
Signed-off-by: Loïc Yhuel <loic.yhuel@gmail.com>
Link: https://lore.kernel.org/r/20200512040113.277768-1-loic.yhuel@gmail.com
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Matthew Garrett <mjg59@google.com>
[ardb: warn when final events table is missing or in the wrong format]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/libstub/tpm.c |    5 +++--
 drivers/firmware/efi/tpm.c         |    5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -54,7 +54,7 @@ void efi_retrieve_tpm2_eventlog(void)
 	efi_status_t status;
 	efi_physical_addr_t log_location = 0, log_last_entry = 0;
 	struct linux_efi_tpm_eventlog *log_tbl = NULL;
-	struct efi_tcg2_final_events_table *final_events_table;
+	struct efi_tcg2_final_events_table *final_events_table = NULL;
 	unsigned long first_entry_addr, last_entry_addr;
 	size_t log_size, last_entry_size;
 	efi_bool_t truncated;
@@ -127,7 +127,8 @@ void efi_retrieve_tpm2_eventlog(void)
 	 * Figure out whether any events have already been logged to the
 	 * final events structure, and if so how much space they take up
 	 */
-	final_events_table = get_efi_config_table(LINUX_EFI_TPM_FINAL_LOG_GUID);
+	if (version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2)
+		final_events_table = get_efi_config_table(LINUX_EFI_TPM_FINAL_LOG_GUID);
 	if (final_events_table && final_events_table->nr_events) {
 		struct tcg_pcr_event2_head *header;
 		int offset;
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -62,8 +62,11 @@ int __init efi_tpm_eventlog_init(void)
 	tbl_size = sizeof(*log_tbl) + log_tbl->size;
 	memblock_reserve(efi.tpm_log, tbl_size);
 
-	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR)
+	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR ||
+	    log_tbl->version != EFI_TCG2_EVENT_LOG_FORMAT_TCG_2) {
+		pr_warn(FW_BUG "TPM Final Events table missing or invalid\n");
 		goto out;
+	}
 
 	final_tbl = early_memremap(efi.tpm_final_log, sizeof(*final_tbl));
 



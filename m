Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A724B540F52
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353046AbiFGTGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352875AbiFGTD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:03:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F90E15877E;
        Tue,  7 Jun 2022 11:05:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35E7761883;
        Tue,  7 Jun 2022 18:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40406C385A5;
        Tue,  7 Jun 2022 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625114;
        bh=J6+5wNIGk5VQH6bbzau39NXxNcohMGEmwwQLsllSQM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3N9dj91YDgYe65K0KBNPdc9z/gn0qKw2tMp1ZCEc7NavajRrXwAcWLOCP+Vnnn8Y
         Y6OY/XOrOHs5cq3aBJWqSzlrPHFrFMCzXl00qxieMBSS/rDpE6jqFre9FL4npNoG6B
         ob1alXbdVLHfrCCBrr6Nlew9iXsOCRtfBT1uSMuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Garg <gargaditya08@live.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 530/667] efi: Do not import certificates from UEFI Secure Boot for T2 Macs
Date:   Tue,  7 Jun 2022 19:03:15 +0200
Message-Id: <20220607164950.599331902@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

commit 155ca952c7ca19aa32ecfb7373a32bbc2e1ec6eb upstream.

On Apple T2 Macs, when Linux attempts to read the db and dbx efi variables
at early boot to load UEFI Secure Boot certificates, a page fault occurs
in Apple firmware code and EFI runtime services are disabled with the
following logs:

[Firmware Bug]: Page fault caused by firmware at PA: 0xffffb1edc0068000
WARNING: CPU: 3 PID: 104 at arch/x86/platform/efi/quirks.c:735 efi_crash_gracefully_on_page_fault+0x50/0xf0
(Removed some logs from here)
Call Trace:
 <TASK>
 page_fault_oops+0x4f/0x2c0
 ? search_bpf_extables+0x6b/0x80
 ? search_module_extables+0x50/0x80
 ? search_exception_tables+0x5b/0x60
 kernelmode_fixup_or_oops+0x9e/0x110
 __bad_area_nosemaphore+0x155/0x190
 bad_area_nosemaphore+0x16/0x20
 do_kern_addr_fault+0x8c/0xa0
 exc_page_fault+0xd8/0x180
 asm_exc_page_fault+0x1e/0x30
(Removed some logs from here)
 ? __efi_call+0x28/0x30
 ? switch_mm+0x20/0x30
 ? efi_call_rts+0x19a/0x8e0
 ? process_one_work+0x222/0x3f0
 ? worker_thread+0x4a/0x3d0
 ? kthread+0x17a/0x1a0
 ? process_one_work+0x3f0/0x3f0
 ? set_kthread_struct+0x40/0x40
 ? ret_from_fork+0x22/0x30
 </TASK>
---[ end trace 1f82023595a5927f ]---
efi: Froze efi_rts_wq and disabled EFI Runtime Services
integrity: Couldn't get size: 0x8000000000000015
integrity: MODSIGN: Couldn't get UEFI db list
efi: EFI Runtime Services are disabled!
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get UEFI dbx list
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get mokx list
integrity: Couldn't get size: 0x80000000

So we avoid reading these UEFI variables and thus prevent the crash.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/platform_certs/keyring_handler.h |    8 ++++
 security/integrity/platform_certs/load_uefi.c       |   33 ++++++++++++++++++++
 2 files changed, 41 insertions(+)

--- a/security/integrity/platform_certs/keyring_handler.h
+++ b/security/integrity/platform_certs/keyring_handler.h
@@ -30,3 +30,11 @@ efi_element_handler_t get_handler_for_db
 efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_type);
 
 #endif
+
+#ifndef UEFI_QUIRK_SKIP_CERT
+#define UEFI_QUIRK_SKIP_CERT(vendor, product) \
+		 .matches = { \
+			DMI_MATCH(DMI_BOARD_VENDOR, vendor), \
+			DMI_MATCH(DMI_PRODUCT_NAME, product), \
+		},
+#endif
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/cred.h>
+#include <linux/dmi.h>
 #include <linux/err.h>
 #include <linux/efi.h>
 #include <linux/slab.h>
@@ -12,6 +13,31 @@
 #include "keyring_handler.h"
 
 /*
+ * On T2 Macs reading the db and dbx efi variables to load UEFI Secure Boot
+ * certificates causes occurrence of a page fault in Apple's firmware and
+ * a crash disabling EFI runtime services. The following quirk skips reading
+ * these variables.
+ */
+static const struct dmi_system_id uefi_skip_cert[] = {
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,3") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,4") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,3") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,4") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ }
+};
+
+/*
  * Look to see if a UEFI variable called MokIgnoreDB exists and return true if
  * it does.
  *
@@ -137,6 +163,13 @@ static int __init load_uefi_certs(void)
 	unsigned long dbsize = 0, dbxsize = 0, mokxsize = 0;
 	efi_status_t status;
 	int rc = 0;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id = dmi_first_match(uefi_skip_cert);
+	if (dmi_id) {
+		pr_err("Reading UEFI Secure Boot Certs is not supported on T2 Macs.\n");
+		return false;
+	}
 
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return false;



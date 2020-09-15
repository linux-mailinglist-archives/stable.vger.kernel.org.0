Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0841D26B3F5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgIOXNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED732256B;
        Tue, 15 Sep 2020 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180233;
        bh=+66TmlmFmovP6U/2Irep0baBCy+0U+6zTkryoL1Nzbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOiH1tGZEPVEtLue1DC/b/qfiyft+aZtnyPtZxrH1f2gUvWN/veev2Q9ZYXLHBCjy
         m5UOsWeB2dwGwpo67Ab8pGTjHIx7I16dPcw050NFJoAT5H2gGxKqvlyRF3y1/BlJG+
         MjoqVMnPKjTtKsfdgdQN21KllQ/6zZcWbEqNZpQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.8 161/177] test_firmware: Test platform fw loading on non-EFI systems
Date:   Tue, 15 Sep 2020 16:13:52 +0200
Message-Id: <20200915140701.410816228@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit baaabecfc80fad255f866563b53b8c7a3eec176e upstream.

On non-EFI systems, it wasn't possible to test the platform firmware
loader because it will have never set "checked_fw" during __init.
Instead, allow the test code to override this check. Additionally split
the declarations into a private symbol namespace so there is greater
enforcement of the symbol visibility.

Fixes: 548193cba2a7 ("test_firmware: add support for firmware_request_platform")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20200909225354.3118328-1-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/embedded-firmware.c |   10 +++++-----
 include/linux/efi_embedded_fw.h          |    6 ++----
 lib/test_firmware.c                      |    9 +++++++++
 3 files changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/firmware/efi/embedded-firmware.c
+++ b/drivers/firmware/efi/embedded-firmware.c
@@ -16,9 +16,9 @@
 
 /* Exported for use by lib/test_firmware.c only */
 LIST_HEAD(efi_embedded_fw_list);
-EXPORT_SYMBOL_GPL(efi_embedded_fw_list);
-
-static bool checked_for_fw;
+EXPORT_SYMBOL_NS_GPL(efi_embedded_fw_list, TEST_FIRMWARE);
+bool efi_embedded_fw_checked;
+EXPORT_SYMBOL_NS_GPL(efi_embedded_fw_checked, TEST_FIRMWARE);
 
 static const struct dmi_system_id * const embedded_fw_table[] = {
 #ifdef CONFIG_TOUCHSCREEN_DMI
@@ -119,14 +119,14 @@ void __init efi_check_for_embedded_firmw
 		}
 	}
 
-	checked_for_fw = true;
+	efi_embedded_fw_checked = true;
 }
 
 int efi_get_embedded_fw(const char *name, const u8 **data, size_t *size)
 {
 	struct efi_embedded_fw *iter, *fw = NULL;
 
-	if (!checked_for_fw) {
+	if (!efi_embedded_fw_checked) {
 		pr_warn("Warning %s called while we did not check for embedded fw\n",
 			__func__);
 		return -ENOENT;
--- a/include/linux/efi_embedded_fw.h
+++ b/include/linux/efi_embedded_fw.h
@@ -8,8 +8,8 @@
 #define EFI_EMBEDDED_FW_PREFIX_LEN		8
 
 /*
- * This struct and efi_embedded_fw_list are private to the efi-embedded fw
- * implementation they are in this header for use by lib/test_firmware.c only!
+ * This struct is private to the efi-embedded fw implementation.
+ * They are in this header for use by lib/test_firmware.c only!
  */
 struct efi_embedded_fw {
 	struct list_head list;
@@ -18,8 +18,6 @@ struct efi_embedded_fw {
 	size_t length;
 };
 
-extern struct list_head efi_embedded_fw_list;
-
 /**
  * struct efi_embedded_fw_desc - This struct is used by the EFI embedded-fw
  *                               code to search for embedded firmwares.
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -26,6 +26,8 @@
 #include <linux/vmalloc.h>
 #include <linux/efi_embedded_fw.h>
 
+MODULE_IMPORT_NS(TEST_FIRMWARE);
+
 #define TEST_FIRMWARE_NAME	"test-firmware.bin"
 #define TEST_FIRMWARE_NUM_REQS	4
 #define TEST_FIRMWARE_BUF_SIZE	SZ_1K
@@ -489,6 +491,9 @@ out:
 static DEVICE_ATTR_WO(trigger_request);
 
 #ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
+extern struct list_head efi_embedded_fw_list;
+extern bool efi_embedded_fw_checked;
+
 static ssize_t trigger_request_platform_store(struct device *dev,
 					      struct device_attribute *attr,
 					      const char *buf, size_t count)
@@ -501,6 +506,7 @@ static ssize_t trigger_request_platform_
 	};
 	struct efi_embedded_fw efi_embedded_fw;
 	const struct firmware *firmware = NULL;
+	bool saved_efi_embedded_fw_checked;
 	char *name;
 	int rc;
 
@@ -513,6 +519,8 @@ static ssize_t trigger_request_platform_
 	efi_embedded_fw.data = (void *)test_data;
 	efi_embedded_fw.length = sizeof(test_data);
 	list_add(&efi_embedded_fw.list, &efi_embedded_fw_list);
+	saved_efi_embedded_fw_checked = efi_embedded_fw_checked;
+	efi_embedded_fw_checked = true;
 
 	pr_info("loading '%s'\n", name);
 	rc = firmware_request_platform(&firmware, name, dev);
@@ -530,6 +538,7 @@ static ssize_t trigger_request_platform_
 	rc = count;
 
 out:
+	efi_embedded_fw_checked = saved_efi_embedded_fw_checked;
 	release_firmware(firmware);
 	list_del(&efi_embedded_fw.list);
 	kfree(name);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE5E263B11
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 04:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIJCyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 22:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730200AbgIJB5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 21:57:30 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185BEC0617AA
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 16:31:20 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id y6so4142408oie.5
        for <stable@vger.kernel.org>; Wed, 09 Sep 2020 16:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W8U1jYmGQsABtWWZIHjJcbSUPYX8H1lkM9t5aCaoW3I=;
        b=cRuit1DNZLA4HKnCBu/n1m0b6iCQzsccDidM6wlk+tUh+fvI8dyeinymrzQA1kx+o2
         +czV3bjgIfaFgIjzX1imrn/OqH3jj6yyTGtNrsq9n89xqGa/Yyq0hbND6xTE5gyWBIGu
         201nKz8B44z5vwZdwJ2NhSmvufdQxQD4tNhfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W8U1jYmGQsABtWWZIHjJcbSUPYX8H1lkM9t5aCaoW3I=;
        b=h1R1W8rK6ksbGkbj/0j7jxmJnPfxR+cqcCrfuEkgNrX9Zow4XvHwooXOiO0Fw0jIL6
         XpO0PUOKegyLsIfCoe23rvNyOjNkj0epjGhO6/YTyqLf/JeUyC+dHz5Z4ZO6UWFCN1Za
         kKcZH0FOcl0D3EHpcl2E++DV/rK2OhDTBs/UhG8avlCfdGAe+F1OzUzA54CdSCs1JVkJ
         gCj1wQtyA93omBJa/9fcnnr8CXGOdjboDHdhZ/ZcFQ5JGF0V6VZfX1O45yoy/Q0HqkqS
         FICedhYcTilmzCqN6du96guwfFcBXHg4cGcMXeI/q2Pui3kjkK8scgVhvrLIO83JIUIV
         hiXw==
X-Gm-Message-State: AOAM5301+dKhuiVzANxmDQc1lSL9ERRNd2IMxfDuzHAVgH7bTV+znR7N
        7C2c9ZHYcmMQFhM7XVlWZKl2vs1ALN386VgD
X-Google-Smtp-Source: ABdhPJyTVLrYU7ymbQNEluaTJ+ppf+b6PT7wu76PwJgMCfLRmOpqETGxWRyiwrxF+9tnVlDqhSWkyw==
X-Received: by 2002:a17:90b:4018:: with SMTP id ie24mr2720669pjb.9.1599692043805;
        Wed, 09 Sep 2020 15:54:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s20sm3746072pfu.112.2020.09.09.15.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 15:54:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5] test_firmware: Test platform fw loading on non-EFI systems
Date:   Wed,  9 Sep 2020 15:53:54 -0700
Message-Id: <20200909225354.3118328-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On non-EFI systems, it wasn't possible to test the platform firmware
loader because it will have never set "checked_fw" during __init.
Instead, allow the test code to override this check. Additionally split
the declarations into a private symbol namespace so there is greater
enforcement of the symbol visibility.

Fixes: 548193cba2a7 ("test_firmware: add support for firmware_request_platform")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is split out from the larger kernel_read_file series:
    https://lore.kernel.org/lkml/20200729175845.1745471-1-keescook@chromium.org/
specifically this was:
    https://lore.kernel.org/lkml/20200729175845.1745471-2-keescook@chromium.org/

I've dropped the review tags, since this is changing the "how" of the patch...
---
 drivers/firmware/efi/embedded-firmware.c | 10 +++++-----
 include/linux/efi_embedded_fw.h          |  6 ++----
 lib/test_firmware.c                      |  9 +++++++++
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
index a1b199de9006..84e32634ed6c 100644
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
@@ -119,14 +119,14 @@ void __init efi_check_for_embedded_firmwares(void)
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
diff --git a/include/linux/efi_embedded_fw.h b/include/linux/efi_embedded_fw.h
index 57eac5241303..a97a12bb2c9e 100644
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
diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 9fee2b93a8d1..06c955057756 100644
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
@@ -489,6 +491,9 @@ static ssize_t trigger_request_store(struct device *dev,
 static DEVICE_ATTR_WO(trigger_request);
 
 #ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
+extern struct list_head efi_embedded_fw_list;
+extern bool efi_embedded_fw_checked;
+
 static ssize_t trigger_request_platform_store(struct device *dev,
 					      struct device_attribute *attr,
 					      const char *buf, size_t count)
@@ -501,6 +506,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
 	};
 	struct efi_embedded_fw efi_embedded_fw;
 	const struct firmware *firmware = NULL;
+	bool saved_efi_embedded_fw_checked;
 	char *name;
 	int rc;
 
@@ -513,6 +519,8 @@ static ssize_t trigger_request_platform_store(struct device *dev,
 	efi_embedded_fw.data = (void *)test_data;
 	efi_embedded_fw.length = sizeof(test_data);
 	list_add(&efi_embedded_fw.list, &efi_embedded_fw_list);
+	saved_efi_embedded_fw_checked = efi_embedded_fw_checked;
+	efi_embedded_fw_checked = true;
 
 	pr_info("loading '%s'\n", name);
 	rc = firmware_request_platform(&firmware, name, dev);
@@ -530,6 +538,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
 	rc = count;
 
 out:
+	efi_embedded_fw_checked = saved_efi_embedded_fw_checked;
 	release_firmware(firmware);
 	list_del(&efi_embedded_fw.list);
 	kfree(name);
-- 
2.25.1


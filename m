Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870432323D8
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 19:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgG2R6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 13:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgG2R6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 13:58:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284B1C061794
        for <stable@vger.kernel.org>; Wed, 29 Jul 2020 10:58:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id k27so14689442pgm.2
        for <stable@vger.kernel.org>; Wed, 29 Jul 2020 10:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DgMrXVVefzee5XLvUUvLofSlFR2vFY36qKFP1IS3s/M=;
        b=ecnAksZk8u482WqjHzXgmErEsJOgZFCFls0F0FtO7QmdHTAAGDaWiu+nlxfcYYLD/d
         vOqlPliWbWinlSxtuqmjAy7Ruxwd6be6qQHWGBiByabdvGPPs65frNOVSJCZRjLZGs7F
         RFwB+vTeBV8v3277ad97fHgeSGQl8zzdLnaqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DgMrXVVefzee5XLvUUvLofSlFR2vFY36qKFP1IS3s/M=;
        b=Vz4wFXWibOlJ33HMq+y975TWNLAUCVTgZs/OkXdxdXM4KSH2r4N5pP9+RQrTY/mZyX
         4oJ2YRxL/UXLGDe0+qY3tZ5pL6WvB5BFLhoyLV0nPUGssKO5jBDecgNQDR703aSY6+Zj
         Nfp78GjZpkeO8v4rijFH8VscyR8gYE7dUXx5fHYtqvqsG//yYpVvD6hsVZmWDy5VEWBd
         fv6BzSxrSa0j29j0wlndGmGio2BMz5mkh93EuYObkoHCByqvgaykCtSwVyyJmLqxRhyZ
         TOK7goYL880KC9uuIDBQgDdhgwSphxnqRI04vQcwapyr0qmp7h9tyZbfjqvt00zGQcHr
         K3wQ==
X-Gm-Message-State: AOAM530eOSjW0fNYZv0UD5XxZ3A2QN8thA1ZgLnb1KNvX43NNJhAmd+I
        2NKksUFKSPdrfuW7j+BdgNZiOg==
X-Google-Smtp-Source: ABdhPJxhdO2MgDtr62Uppf9UbFVzy8Bb9dXdsSesClNEHtIm2RElCtl0XV+rgMZUKEUflFVUEOGjEg==
X-Received: by 2002:a63:5349:: with SMTP id t9mr2901760pgl.204.1596045534650;
        Wed, 29 Jul 2020 10:58:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b82sm3185975pfb.215.2020.07.29.10.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 10:58:53 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Scott Branden <scott.branden@broadcom.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>, Takashi Iwai <tiwai@suse.de>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/17] test_firmware: Test platform fw loading on non-EFI systems
Date:   Wed, 29 Jul 2020 10:58:29 -0700
Message-Id: <20200729175845.1745471-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200729175845.1745471-1-keescook@chromium.org>
References: <20200729175845.1745471-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On non-EFI systems, it wasn't possible to test the platform firmware
loader because it will have never set "checked_fw" during __init.
Instead, allow the test code to override this check. Additionally split
the declarations into a private header file so it there is greater
enforcement of the symbol visibility.

Fixes: 548193cba2a7 ("test_firmware: add support for firmware_request_platform")
Cc: stable@vger.kernel.org
Acked-by: Scott Branden <scott.branden@broadcom.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/firmware/efi/embedded-firmware.c | 21 ++++++++++++++++-----
 drivers/firmware/efi/embedded-firmware.h | 21 +++++++++++++++++++++
 include/linux/efi_embedded_fw.h          | 13 -------------
 lib/test_firmware.c                      |  5 +++++
 4 files changed, 42 insertions(+), 18 deletions(-)
 create mode 100644 drivers/firmware/efi/embedded-firmware.h

diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
index a1b199de9006..0fb03cd0a5a2 100644
--- a/drivers/firmware/efi/embedded-firmware.c
+++ b/drivers/firmware/efi/embedded-firmware.c
@@ -14,11 +14,22 @@
 #include <linux/vmalloc.h>
 #include <crypto/sha.h>
 
+#include "embedded-firmware.h"
+
+#ifdef CONFIG_TEST_FIRMWARE
+# define EFI_EMBEDDED_FW_VISIBILITY
+#else
+# define EFI_EMBEDDED_FW_VISIBILITY static
+#endif
+
+EFI_EMBEDDED_FW_VISIBILITY LIST_HEAD(efi_embedded_fw_list);
+EFI_EMBEDDED_FW_VISIBILITY bool efi_embedded_fw_checked;
+
 /* Exported for use by lib/test_firmware.c only */
-LIST_HEAD(efi_embedded_fw_list);
+#ifdef CONFIG_TEST_FIRMWARE
 EXPORT_SYMBOL_GPL(efi_embedded_fw_list);
-
-static bool checked_for_fw;
+EXPORT_SYMBOL_GPL(efi_embedded_fw_checked);
+#endif
 
 static const struct dmi_system_id * const embedded_fw_table[] = {
 #ifdef CONFIG_TOUCHSCREEN_DMI
@@ -119,14 +130,14 @@ void __init efi_check_for_embedded_firmwares(void)
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
diff --git a/drivers/firmware/efi/embedded-firmware.h b/drivers/firmware/efi/embedded-firmware.h
new file mode 100644
index 000000000000..bb894eae0906
--- /dev/null
+++ b/drivers/firmware/efi/embedded-firmware.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _EFI_EMBEDDED_FW_INTERNAL_H_
+#define _EFI_EMBEDDED_FW_INTERNAL_H_
+
+/*
+ * This struct and efi_embedded_fw_list are private to the efi-embedded fw
+ * implementation they only in separate header for use by lib/test_firmware.c.
+ */
+struct efi_embedded_fw {
+	struct list_head list;
+	const char *name;
+	const u8 *data;
+	size_t length;
+};
+
+#ifdef CONFIG_TEST_FIRMWARE
+extern struct list_head efi_embedded_fw_list;
+extern bool efi_embedded_fw_checked;
+#endif
+
+#endif /* _EFI_EMBEDDED_FW_INTERNAL_H_ */
diff --git a/include/linux/efi_embedded_fw.h b/include/linux/efi_embedded_fw.h
index 57eac5241303..4ad5db9f5312 100644
--- a/include/linux/efi_embedded_fw.h
+++ b/include/linux/efi_embedded_fw.h
@@ -7,19 +7,6 @@
 
 #define EFI_EMBEDDED_FW_PREFIX_LEN		8
 
-/*
- * This struct and efi_embedded_fw_list are private to the efi-embedded fw
- * implementation they are in this header for use by lib/test_firmware.c only!
- */
-struct efi_embedded_fw {
-	struct list_head list;
-	const char *name;
-	const u8 *data;
-	size_t length;
-};
-
-extern struct list_head efi_embedded_fw_list;
-
 /**
  * struct efi_embedded_fw_desc - This struct is used by the EFI embedded-fw
  *                               code to search for embedded firmwares.
diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 9fee2b93a8d1..62af792e151c 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -489,6 +489,7 @@ static ssize_t trigger_request_store(struct device *dev,
 static DEVICE_ATTR_WO(trigger_request);
 
 #ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
+#include "../drivers/firmware/efi/embedded-firmware.h"
 static ssize_t trigger_request_platform_store(struct device *dev,
 					      struct device_attribute *attr,
 					      const char *buf, size_t count)
@@ -501,6 +502,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
 	};
 	struct efi_embedded_fw efi_embedded_fw;
 	const struct firmware *firmware = NULL;
+	bool saved_efi_embedded_fw_checked;
 	char *name;
 	int rc;
 
@@ -513,6 +515,8 @@ static ssize_t trigger_request_platform_store(struct device *dev,
 	efi_embedded_fw.data = (void *)test_data;
 	efi_embedded_fw.length = sizeof(test_data);
 	list_add(&efi_embedded_fw.list, &efi_embedded_fw_list);
+	saved_efi_embedded_fw_checked = efi_embedded_fw_checked;
+	efi_embedded_fw_checked = true;
 
 	pr_info("loading '%s'\n", name);
 	rc = firmware_request_platform(&firmware, name, dev);
@@ -530,6 +534,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
 	rc = count;
 
 out:
+	efi_embedded_fw_checked = saved_efi_embedded_fw_checked;
 	release_firmware(firmware);
 	list_del(&efi_embedded_fw.list);
 	kfree(name);
-- 
2.25.1


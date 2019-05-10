Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56821A275
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 19:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfEJRhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 13:37:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:17666 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfEJRhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 13:37:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 May 2019 10:37:41 -0700
X-ExtLoop1: 1
Received: from bartok.jf.intel.com ([10.54.75.137])
  by fmsmga007.fm.intel.com with ESMTP; 10 May 2019 10:37:41 -0700
From:   Erik Schmauss <erik.schmauss@intel.com>
To:     rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Cc:     Erik Schmauss <erik.schmauss@intel.com>,
        Stable <stable@vger.kernel.org>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 1/2] ACPICA: Linux: move ACPI_DEBUG_DEFAULT flag out of ifndef
Date:   Fri, 10 May 2019 10:25:42 -0700
Message-Id: <20190510172543.9831-2-erik.schmauss@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190510172543.9831-1-erik.schmauss@intel.com>
References: <20190510172543.9831-1-erik.schmauss@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ACPICA commit c14f17fa0acf8c93497ce04b9a7f4ada51b69383

This flag should not be included in #ifndef CONFIG_ACPI. It should be
used unconditionally.

Link: https://github.com/acpica/acpica/commit/c14f17fa
Fixes: aa9aaa4d61c0 ("ACPI: use different default debug value than ACPICA")
CC: Stable <stable@vger.kernel.org> 5.1+
Reported-by: Gabriel C <nix.or.die@gmail.com>
Tested-by: Gabriel C <nix.or.die@gmail.com>
Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 include/acpi/platform/aclinux.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 624b90b34085..310501994c02 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -66,6 +66,11 @@
 
 #define ACPI_INIT_FUNCTION __init
 
+/* Use a specific bugging default separate from ACPICA */
+
+#undef ACPI_DEBUG_DEFAULT
+#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INFO | ACPI_LV_REPAIR)
+
 #ifndef CONFIG_ACPI
 
 /* External globals for __KERNEL__, stubs is needed */
@@ -82,11 +87,6 @@
 #define ACPI_NO_ERROR_MESSAGES
 #undef ACPI_DEBUG_OUTPUT
 
-/* Use a specific bugging default separate from ACPICA */
-
-#undef ACPI_DEBUG_DEFAULT
-#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INFO | ACPI_LV_REPAIR)
-
 /* External interface for __KERNEL__, stub is needed */
 
 #define ACPI_EXTERNAL_RETURN_STATUS(prototype) \
-- 
2.17.2


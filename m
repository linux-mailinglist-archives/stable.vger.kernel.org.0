Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784772354D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390901AbfETMeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390112AbfETMeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:34:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6202F20815;
        Mon, 20 May 2019 12:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355659;
        bh=KfIra1FsUZtFZlfjeFS4uKyu9mEjfoNOlzLNspPbGf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmmIR3k3pUPbEG15QID2AcfBZ8a/LYEci4ze6aAJGC74jrMKPona0iaKE6BvZQJxv
         GQcbHtSntwlzCYYBSr2eIaotPZRu7GHrILQBW6MArDspaNL0BpfEz/cH2AU6eDq3bW
         LsEcamUyB50QrTKzLcmvTXWEeJ+VvHMmKcNY204k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel C <nix.or.die@gmail.com>,
        Erik Schmauss <erik.schmauss@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.1 076/128] ACPICA: Linux: move ACPI_DEBUG_DEFAULT flag out of ifndef
Date:   Mon, 20 May 2019 14:14:23 +0200
Message-Id: <20190520115254.864496798@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Schmauss <erik.schmauss@intel.com>

commit 11207b4dc2737f1f01695979ad5eac6c8ecc8031 upstream.

ACPICA commit c14f17fa0acf8c93497ce04b9a7f4ada51b69383

This flag should not be included in #ifndef CONFIG_ACPI. It should be
used unconditionally.

Link: https://github.com/acpica/acpica/commit/c14f17fa
Fixes: aa9aaa4d61c0 ("ACPI: use different default debug value than ACPICA")
Reported-by: Gabriel C <nix.or.die@gmail.com>
Tested-by: Gabriel C <nix.or.die@gmail.com>
Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> 5.1+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/acpi/platform/aclinux.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553001333EB
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgAGVBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgAGVBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D13E20678;
        Tue,  7 Jan 2020 21:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430899;
        bh=8GcbSDgy6eK9FBFp8P48mgRgmME/4nkm7gYC2ckulrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/cxCn7u5QfzYowdGKP+f2u7J6HKv8EdDzbhW46tBc0IgZAU/cZ4aEyhIo9+ANlnq
         fMgXck2JePPF2r1aR2cbVQ0Ek3/MjeZFgHmrnFdLV4e3aPqFK2fxaMJwvcQlZtlDhE
         /ddoXKmFKU1PKJWy7yleyaNw8rhBuGuH50I2ZU9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 142/191] ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100
Date:   Tue,  7 Jan 2020 21:54:22 +0100
Message-Id: <20200107205340.576727851@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

commit a7583e72a5f22470d3e6fd3b6ba912892242339f upstream.

The commit 0f27cff8597d ("ACPI: sysfs: Make ACPI GPE mask kernel
parameter cover all GPEs") says:
  "Use a bitmap of size 0xFF instead of a u64 for the GPE mask so 256
   GPEs can be masked"

But the masking of GPE 0xFF it not supported and the check condition
"gpe > ACPI_MASKABLE_GPE_MAX" is not valid because the type of gpe is
u8.

So modify the macro ACPI_MASKABLE_GPE_MAX to 0x100, and drop the "gpe >
ACPI_MASKABLE_GPE_MAX" check. In addition, update the docs "Format" for
acpi_mask_gpe parameter.

Fixes: 0f27cff8597d ("ACPI: sysfs: Make ACPI GPE mask kernel parameter cover all GPEs")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
[ rjw: Use u16 as gpe data type in acpi_gpe_apply_masked_gpes() ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 drivers/acpi/sysfs.c                            |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -113,7 +113,7 @@
 			the GPE dispatcher.
 			This facility can be used to prevent such uncontrolled
 			GPE floodings.
-			Format: <int>
+			Format: <byte>
 
 	acpi_no_auto_serialize	[HW,ACPI]
 			Disable auto-serialization of AML methods
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -819,14 +819,14 @@ end:
  * interface:
  *   echo unmask > /sys/firmware/acpi/interrupts/gpe00
  */
-#define ACPI_MASKABLE_GPE_MAX	0xFF
+#define ACPI_MASKABLE_GPE_MAX	0x100
 static DECLARE_BITMAP(acpi_masked_gpes_map, ACPI_MASKABLE_GPE_MAX) __initdata;
 
 static int __init acpi_gpe_set_masked_gpes(char *val)
 {
 	u8 gpe;
 
-	if (kstrtou8(val, 0, &gpe) || gpe > ACPI_MASKABLE_GPE_MAX)
+	if (kstrtou8(val, 0, &gpe))
 		return -EINVAL;
 	set_bit(gpe, acpi_masked_gpes_map);
 
@@ -838,7 +838,7 @@ void __init acpi_gpe_apply_masked_gpes(v
 {
 	acpi_handle handle;
 	acpi_status status;
-	u8 gpe;
+	u16 gpe;
 
 	for_each_set_bit(gpe, acpi_masked_gpes_map, ACPI_MASKABLE_GPE_MAX) {
 		status = acpi_get_gpe_device(gpe, &handle);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F66D1332FD
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgAGVHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:07:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbgAGVHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:07:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D5A2087F;
        Tue,  7 Jan 2020 21:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431262;
        bh=J9xPkpuPgMG01x3mnwje7ZUu4h1LnCMYS2XZVEtt/Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJrbkAkl0cT8x+wOExSP7zHBlRJZVk/k/MTH+z86k4TZQainiQ57r6slHXbq029zR
         Lk5YDvwfVrmcyPB5Y4NtJv8cpHbRYYTPaKGEx7fXDpRbuSBPJ0imBTPFmXwmcO1O4D
         0BdApsJ8bMt6A+ze4ceTCvoFdCnz8q1ExVWPMnAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 083/115] ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100
Date:   Tue,  7 Jan 2020 21:54:53 +0100
Message-Id: <20200107205305.669184595@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
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
@@ -816,14 +816,14 @@ end:
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
 
@@ -835,7 +835,7 @@ void __init acpi_gpe_apply_masked_gpes(v
 {
 	acpi_handle handle;
 	acpi_status status;
-	u8 gpe;
+	u16 gpe;
 
 	for_each_set_bit(gpe, acpi_masked_gpes_map, ACPI_MASKABLE_GPE_MAX) {
 		status = acpi_get_gpe_device(gpe, &handle);



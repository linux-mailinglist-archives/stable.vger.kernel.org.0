Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F5848C20C
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 11:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352380AbiALKOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 05:14:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45106 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346644AbiALKOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 05:14:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C69E46132E;
        Wed, 12 Jan 2022 10:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A98C36AE9;
        Wed, 12 Jan 2022 10:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641982468;
        bh=4XnroSPeuM6hFsXnidiWJR3rZo4wj36oZgNiKGW4Jmg=;
        h=From:To:Cc:Subject:Date:From;
        b=V/K3OkAyK5Tw3n4MCfTkLAfdNuevN+ov7r+Q8UTh9KTwclrGP9tz+imj1BTUfajEy
         dCpZfS3LsvS4vBTKvvcoAZCmYPj72fMK2qa/ol5/PDklZ+Tva4r+8PBRPH7w04ymXz
         HNSwosNIy2Ulsf5BYzw9+Y4ocx0Yyc10fE7+cxMK+SGVVFCDbfiXV8npJbFLFUhL4k
         HAaIFc/lcn0MtoIAgRnyAgQ2/l6Ob4QdpSjuBMU6wm0TeaGUIjC+oshV6yZ6AFkh7X
         2U7Xcv7nqzF45cWy6IejFTvHn5X/vmm/DI6Z0I9zDdX31to4R+e+qpwNwUcU0Vnbbr
         YvEt3pqUJKUlw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     torvalds@linux-foundation.org, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Aditya Garg <gargaditya08@live.com>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: [PATCH] efi: runtime: avoid EFIv2 runtime services on Apple x86 machines
Date:   Wed, 12 Jan 2022 11:14:13 +0100
Message-Id: <20220112101413.188234-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2449; h=from:subject; bh=4XnroSPeuM6hFsXnidiWJR3rZo4wj36oZgNiKGW4Jmg=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh3qn1LPcrRuKW99VcsaOMFCuUvu1HoyFfX7pkiFMe h/GCC5WJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYd6p9QAKCRDDTyI5ktmPJG2/DA CQyj3/yM4ATLSHPrpS7XcJ+93RUOO8ksfivQou0Nu3uiKycCtjZTBT5/6BamqgZL4hX40SzXJDGm6M MMNvQU5tEWNgMjGthg6HvDwAkfQEzYh3lJhSSJhMbLc/PsOvLz6JtiCvHuQ1sxJ8eohvxdxFlo43uf KrTnmk/t1egP3FqPChthjxm75Ss9keun7AV/VN/SrMFsiV4M0qpVw5VnL5JCeOakE6qnE7Zy918xjB FjVj8PzPRVFOFRfyHnwjNMPlNrYYltjsTamm57CvDwmRdb16Jf8sm9Uw3eJhWGnt97h+nnWZscNNnP TGrxTslmzgR4AIWdsPosU20KFlnFYv2CYZyLwOsFIilBf7zwUsZ09F+TSV0+6B8Axbv0fhAieQeIv6 AJI4mCo4aKIKY3pY4Xln44qZR58DQlLGtDeSdKHgvTtSMowYRWnZ9TqIy14CPu5GcAllhnCshnxap4 CorJdihIoWZgJFxb2ACayWoQ+E9lRp9Kzbdi0U8XW6y4Q=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Aditya reports [0] that his recent MacbookPro crashes in the firmware
when using the variable services at runtime. The culprit appears to be a
call to QueryVariableInfo(), which we did not use to call on Apple x86
machines in the past as they only upgraded from EFI v1.10 to EFI v2.40
firmware fairly recently, and QueryVariableInfo() (along with
UpdateCapsule() et al) was added in EFI v2.00.

The only runtime service introduced in EFI v2.00 that we actually use in
Linux is QueryVariableInfo(), as the capsule based ones are optional,
generally not used at runtime (all the LVFS/fwupd firmware update
infrastructure uses helper EFI programs that invoke capsule update at
boot time, not runtime), and not implemented by Apple machines in the
first place. QueryVariableInfo() is used to 'safely' set variables,
i.e., only when there is enough space. This prevents machines with buggy
firmwares from corrupting their NVRAMs when they run out of space.

Given that Apple machines have been using EFI v1.10 services only for
the longest time (the EFI v2.0 spec was released in 2006, and Linux
support for the newly introduced runtime services was added in 2011, but
the MacbookPro12,1 released in 2015 still claims to be EFI v1.10 only),
let's avoid the EFI v2.0 ones on all Apple x86 machines.

[0] https://lore.kernel.org/all/6D757C75-65B1-468B-842D-10410081A8E4@live.com/

Cc: <stable@vger.kernel.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Reported-by: Aditya Garg <gargaditya08@live.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index ae79c3300129..7de3f5b6e8d0 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -722,6 +722,13 @@ void __init efi_systab_report_header(const efi_table_hdr_t *systab_hdr,
 		systab_hdr->revision >> 16,
 		systab_hdr->revision & 0xffff,
 		vendor);
+
+	if (IS_ENABLED(CONFIG_X86_64) &&
+	    systab_hdr->revision > EFI_1_10_SYSTEM_TABLE_REVISION &&
+	    !strcmp(vendor, "Apple")) {
+		pr_info("Apple Mac detected, using EFI v1.10 runtime services only\n");
+		efi.runtime_version = EFI_1_10_SYSTEM_TABLE_REVISION;
+	}
 }
 
 static __initdata char memory_type_name[][13] = {
-- 
2.30.2


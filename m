Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746C815F442
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394793AbgBNSUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:20:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729688AbgBNPuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDBAA2467D;
        Fri, 14 Feb 2020 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695418;
        bh=SX59StiBv01BZsQL/M6GsKcpiCvE0GOavYHZERRX5mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDRzk23Madhjz2kIjzrSbMsfX355BIBbtERnDAanO4iMQe7MMIXIXafp3b+/6LewC
         +B0gxL+lLITy1uRc8GPlO+WOzc+uPDHmKIJnr2l4COoroDi61lZu/XCySdyAL+A2km
         zr1YDjULUAhXhNtpzA3g1G7+i26LBhaTcWVv3bQI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Matthew Garrett <mjg59@google.com>, linux-efi@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org, x86@kernel.org
Subject: [PATCH AUTOSEL 5.5 063/542] efi/x86: Map the entire EFI vendor string before copying it
Date:   Fri, 14 Feb 2020 10:40:55 -0500
Message-Id: <20200214154854.6746-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit ffc2760bcf2dba0dbef74013ed73eea8310cc52c ]

Fix a couple of issues with the way we map and copy the vendor string:
- we map only 2 bytes, which usually works since you get at least a
  page, but if the vendor string happens to cross a page boundary,
  a crash will result
- only call early_memunmap() if early_memremap() succeeded, or we will
  call it with a NULL address which it doesn't like,
- while at it, switch to early_memremap_ro(), and array indexing rather
  than pointer dereferencing to read the CHAR16 characters.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Matthew Garrett <mjg59@google.com>
Cc: linux-efi@vger.kernel.org
Fixes: 5b83683f32b1 ("x86: EFI runtime service support")
Link: https://lkml.kernel.org/r/20200103113953.9571-5-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/efi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 38d44f36d5ede..06f69bcd233fe 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -541,7 +541,6 @@ void __init efi_init(void)
 	efi_char16_t *c16;
 	char vendor[100] = "unknown";
 	int i = 0;
-	void *tmp;
 
 #ifdef CONFIG_X86_32
 	if (boot_params.efi_info.efi_systab_hi ||
@@ -566,14 +565,16 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
+	c16 = early_memremap_ro(efi.systab->fw_vendor,
+				sizeof(vendor) * sizeof(efi_char16_t));
 	if (c16) {
-		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = *c16++;
+		for (i = 0; i < sizeof(vendor) - 1 && c16[i]; ++i)
+			vendor[i] = c16[i];
 		vendor[i] = '\0';
-	} else
+		early_memunmap(c16, sizeof(vendor) * sizeof(efi_char16_t));
+	} else {
 		pr_err("Could not map the firmware vendor!\n");
-	early_memunmap(tmp, 2);
+	}
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991631A4086
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgDJD4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgDJDtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4657A214DB;
        Fri, 10 Apr 2020 03:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490585;
        bh=VYPYg6i/pKod6qF6y1lY09357dtCaYVNp3iKvoKFzC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wC+PUN367BrQplZXAqaB9h47HTQGZ4D8WWHD2JBzjYW8Pt2FvxEpS5P/p9U1JARgf
         fx0l0my+XOiMwUbLQ1Fb/221IHVJMUa74f8R2nXwF+V8QrBUVA6K9V5GwtY0+r9dy5
         PoVA5a91FFHNJ5WizAacou/eBF0L6k5xEbiFMO90=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/46] efi/x86: Ignore the memory attributes table on i386
Date:   Thu,  9 Apr 2020 23:48:53 -0400
Message-Id: <20200410034909.8922-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit dd09fad9d2caad2325a39b766ce9e79cfc690184 ]

Commit:

  3a6b6c6fb23667fa ("efi: Make EFI_MEMORY_ATTRIBUTES_TABLE initialization common across all architectures")

moved the call to efi_memattr_init() from ARM specific to the generic
EFI init code, in order to be able to apply the restricted permissions
described in that table on x86 as well.

We never enabled this feature fully on i386, and so mapping and
reserving this table is pointless. However, due to the early call to
memblock_reserve(), the memory bookkeeping gets confused to the point
where it produces the splat below when we try to map the memory later
on:

  ------------[ cut here ]------------
  ioremap on RAM at 0x3f251000 - 0x3fa1afff
  WARNING: CPU: 0 PID: 0 at arch/x86/mm/ioremap.c:166 __ioremap_caller ...
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.20.0 #48
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
  EIP: __ioremap_caller.constprop.0+0x249/0x260
  Code: 90 0f b7 05 4e 38 40 de 09 45 e0 e9 09 ff ff ff 90 8d 45 ec c6 05 ...
  EAX: 00000029 EBX: 00000000 ECX: de59c228 EDX: 00000001
  ESI: 3f250fff EDI: 00000000 EBP: de3edf20 ESP: de3edee0
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00200296
  CR0: 80050033 CR2: ffd17000 CR3: 1e58c000 CR4: 00040690
  Call Trace:
   ioremap_cache+0xd/0x10
   ? old_map_region+0x72/0x9d
   old_map_region+0x72/0x9d
   efi_map_region+0x8/0xa
   efi_enter_virtual_mode+0x260/0x43b
   start_kernel+0x329/0x3aa
   i386_start_kernel+0xa7/0xab
   startup_32_smp+0x164/0x168
  ---[ end trace e15ccf6b9f356833 ]---

Let's work around this by disregarding the memory attributes table
altogether on i386, which does not result in a loss of functionality
or protection, given that we never consumed the contents.

Fixes: 3a6b6c6fb23667fa ("efi: Make EFI_MEMORY_ATTRIBUTES_TABLE ... ")
Tested-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200304165917.5893-1-ardb@kernel.org
Link: https://lore.kernel.org/r/20200308080859.21568-21-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index ad8a4bc074fbf..e3861d267d9aa 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -562,7 +562,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 		}
 	}
 
-	if (efi_enabled(EFI_MEMMAP))
+	if (!IS_ENABLED(CONFIG_X86_32) && efi_enabled(EFI_MEMMAP))
 		efi_memattr_init();
 
 	efi_tpm_eventlog_init();
-- 
2.20.1


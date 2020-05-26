Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9E91ACB6F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895913AbgDPPq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896866AbgDPNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:34:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2EC820732;
        Thu, 16 Apr 2020 13:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044062;
        bh=8A6e/2fKQdaiQBJoePBchJCjphxGBAVEWwqunLihCsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/WxvACZAV8K/JG3DseHzzQ59CdgFhxmfz84hUQBkD2A8dxJau5HNx21kVAxRJEMS
         HSp0EgHBuouJxShS2FPV3J8GIcSAsKk7P3kDIJqpYum1E9cy8gsPPXScZvswbBLLm2
         c8VRCAIXfyGuwp15mh8P/Ndqd4AYpOy05jGGFW24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 064/257] efi/x86: Ignore the memory attributes table on i386
Date:   Thu, 16 Apr 2020 15:21:55 +0200
Message-Id: <20200416131333.934383253@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a9778591341bb..8c32054a266c9 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -570,7 +570,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 		}
 	}
 
-	if (efi_enabled(EFI_MEMMAP))
+	if (!IS_ENABLED(CONFIG_X86_32) && efi_enabled(EFI_MEMMAP))
 		efi_memattr_init();
 
 	efi_tpm_eventlog_init();
-- 
2.20.1




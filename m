Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10113D7695
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbhG0NaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236764AbhG0NTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E514B61AA3;
        Tue, 27 Jul 2021 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391969;
        bh=fvvgQ9NlGndbKm/lUZW+jV4hnC9sgAUudL+0moyF+wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSdPWxAtUNrjtHVcWpBDEJvKVEIwmXjZwtoqNdPHUFH4YZcl09cHsbBexKUxP3pG0
         8vpaMm2qC2Qx2dlEz0EuJnfXBxF9i50jPJjiUNAFDDnirOZIzohpcIwrINJJybRM2Q
         7+AyHr7OXrrLIOaWtQ5OhwM/3ICMeE3TIG5eLHMu82LRjlyhGsFZuXSa+1LazPSW2c
         AzHS9kvMPj6mrtCVWeK3FKqXxE1/0l2tdFSBykzvNDwTXRvdgnRDvE/+GjP6N9RSBw
         hLlZ3q6i8V1AMcI+4WwmV80Bu05NFwAmYzEcaGuklxfJQ4lrLlax87dJieUisxyjAT
         Jei5Qh56lLKlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 15/21] efi/mokvar: Reserve the table only if it is in boot services data
Date:   Tue, 27 Jul 2021 09:19:02 -0400
Message-Id: <20210727131908.834086-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 47e1e233e9d822dfda068383fb9a616451bda703 ]

One of the SUSE QA tests triggered:

  localhost kernel: efi: Failed to lookup EFI memory descriptor for 0x000000003dcf8000

which comes from x86's version of efi_arch_mem_reserve() trying to
reserve a memory region. Usually, that function expects
EFI_BOOT_SERVICES_DATA memory descriptors but the above case is for the
MOKvar table which is allocated in the EFI shim as runtime services.

That lead to a fix changing the allocation of that table to boot services.

However, that fix broke booting SEV guests with that shim leading to
this kernel fix

  8d651ee9c71b ("x86/ioremap: Map EFI-reserved memory as encrypted for SEV")

which extended the ioremap hint to map reserved EFI boot services as
decrypted too.

However, all that wasn't needed, IMO, because that error message in
efi_arch_mem_reserve() was innocuous in this case - if the MOKvar table
is not in boot services, then it doesn't need to be reserved in the
first place because it is, well, in runtime services which *should* be
reserved anyway.

So do that reservation for the MOKvar table only if it is allocated
in boot services data. I couldn't find any requirement about where
that table should be allocated in, unlike the ESRT which allocation is
mandated to be done in boot services data by the UEFI spec.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/mokvar-table.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/mokvar-table.c b/drivers/firmware/efi/mokvar-table.c
index d8bc01340686..38722d2009e2 100644
--- a/drivers/firmware/efi/mokvar-table.c
+++ b/drivers/firmware/efi/mokvar-table.c
@@ -180,7 +180,10 @@ void __init efi_mokvar_table_init(void)
 		pr_err("EFI MOKvar config table is not valid\n");
 		return;
 	}
-	efi_mem_reserve(efi.mokvar_table, map_size_needed);
+
+	if (md.type == EFI_BOOT_SERVICES_DATA)
+		efi_mem_reserve(efi.mokvar_table, map_size_needed);
+
 	efi_mokvar_table_size = map_size_needed;
 }
 
-- 
2.30.2


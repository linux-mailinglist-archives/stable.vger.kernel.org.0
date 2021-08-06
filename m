Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09A33E2563
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbhHFITt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238787AbhHFITE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE4E61167;
        Fri,  6 Aug 2021 08:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237927;
        bh=fvvgQ9NlGndbKm/lUZW+jV4hnC9sgAUudL+0moyF+wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ7xXDZG9jRRhmDxy+4W5jbNg9gz6CBpr2baVratzBHaPYXBOzE4cTgp2WiTDEisW
         Rns+9OgqEMH/l31Z0+g0WkEGOV3mzEKfBdYzdt6hW/Do5FA2rgHbvcJ9RruqGnlH0Z
         BKI/kAGLFWQVJTlx9efWIQJCRcLbwsVzRYn5TuGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/30] efi/mokvar: Reserve the table only if it is in boot services data
Date:   Fri,  6 Aug 2021 10:16:53 +0200
Message-Id: <20210806081113.651725422@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




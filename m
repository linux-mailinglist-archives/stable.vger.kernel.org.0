Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352DB3CF8EC
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhGTK5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 06:57:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40348 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbhGTK4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 06:56:52 -0400
Date:   Tue, 20 Jul 2021 11:37:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626781039;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=ZC9D6on5M3V9NKbfuRjdCy1uKWGTOjYynoMjv4pWtos=;
        b=jo/4MN5HfnInN2PskYnYV2ymcIMvr1dV3Lu6yiqxtavt/zkmpBfU4Xm6TA0PEjbQ7Cc4d2
        XC75rI5KJmmtnzbO9jWqUlsy4/d2N7DPvEl3viJ3VEFZ2tGfcSuLYepVcOnOg/3wlHJNCS
        j8o+VrQfGmOZXhkQ3QDi4BVwf+ZO70jtbOa5bz1wbDjirA6ivAkyMvfyQxBj4Jx9x+F6L3
        7MA/xT4sTiboFxvz/RQ6YW2R1nyRM7GzsXPPCXaT3o0AwbK1YWUInLJywlZ+qFPdtzp39X
        YKOEC6x6Urz1iSqUU2oeCS/hatGnnFB/8sM3nVtQZKxKpqMLSpkRyD6LYLfLwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626781039;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=ZC9D6on5M3V9NKbfuRjdCy1uKWGTOjYynoMjv4pWtos=;
        b=daq6/yEW6Hi7KdvwruSIlumyseFC/0fuF76rEsU4oE2dhlEo6mFE8sR0h/jiS6YFLF+75J
        1naUoKYqZP7JV3BA==
From:   "tip-bot2 for Marc Zyngier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] firmware/efi: Tell memblock about EFI iomem reservations
Cc:     Moritz Fischer <mdf@kernel.org>, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <162678103917.395.13758847379699183265.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     2bab693a608bdf614b9fcd44083c5100f34b9f77
Gitweb:        https://git.kernel.org/tip/2bab693a608bdf614b9fcd44083c5100f34b9f77
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Tue, 13 Jul 2021 19:43:26 +01:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Fri, 16 Jul 2021 18:05:49 +02:00

firmware/efi: Tell memblock about EFI iomem reservations

kexec_load_file() relies on the memblock infrastructure to avoid
stamping over regions of memory that are essential to the survival
of the system.

However, nobody seems to agree how to flag these regions as reserved,
and (for example) EFI only publishes its reservations in /proc/iomem
for the benefit of the traditional, userspace based kexec tool.

On arm64 platforms with GICv3, this can result in the payload being
placed at the location of the LPI tables. Shock, horror!

Let's augment the EFI reservation code with a memblock_reserve() call,
protecting our dear tables from the secondary kernel invasion.

Reported-by: Moritz Fischer <mdf@kernel.org>
Tested-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 4b7ee3f..847f33f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -896,6 +896,7 @@ static int __init efi_memreserve_map_root(void)
 static int efi_mem_reserve_iomem(phys_addr_t addr, u64 size)
 {
 	struct resource *res, *parent;
+	int ret;
 
 	res = kzalloc(sizeof(struct resource), GFP_ATOMIC);
 	if (!res)
@@ -908,7 +909,17 @@ static int efi_mem_reserve_iomem(phys_addr_t addr, u64 size)
 
 	/* we expect a conflict with a 'System RAM' region */
 	parent = request_resource_conflict(&iomem_resource, res);
-	return parent ? request_resource(parent, res) : 0;
+	ret = parent ? request_resource(parent, res) : 0;
+
+	/*
+	 * Given that efi_mem_reserve_iomem() can be called at any
+	 * time, only call memblock_reserve() if the architecture
+	 * keeps the infrastructure around.
+	 */
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) && !ret)
+		memblock_reserve(addr, size);
+
+	return ret;
 }
 
 int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)

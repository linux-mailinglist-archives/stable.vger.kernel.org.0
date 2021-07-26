Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C493D5FC6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbhGZPTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236483AbhGZPSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EB8860F38;
        Mon, 26 Jul 2021 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315131;
        bh=lzQKPoo8QqXewdWrppWK3ujm6LJ1rxUUg35ItxCMLk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQIfDryIELRiHvjfzZ+XAYpEjn+F9k0/cylEe4mXJaCXIDW0wcBhofj38wJOsIGZP
         JLLeg4Y8mFy/MKRSjyz/D2yjo8QZCBc8EsowuzCmuB34BTc4NzUHTIvSC++k0RQvNi
         VaFZb0drMqeoZJHEeeadiHxw5psI4IMeQlADOdEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moritz Fischer <mdf@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 088/108] firmware/efi: Tell memblock about EFI iomem reservations
Date:   Mon, 26 Jul 2021 17:39:29 +0200
Message-Id: <20210726153834.498521607@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 2bab693a608bdf614b9fcd44083c5100f34b9f77 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -975,6 +975,7 @@ static int __init efi_memreserve_map_roo
 static int efi_mem_reserve_iomem(phys_addr_t addr, u64 size)
 {
 	struct resource *res, *parent;
+	int ret;
 
 	res = kzalloc(sizeof(struct resource), GFP_ATOMIC);
 	if (!res)
@@ -987,7 +988,17 @@ static int efi_mem_reserve_iomem(phys_ad
 
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



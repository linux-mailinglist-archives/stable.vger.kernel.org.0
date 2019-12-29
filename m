Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB9812C8B1
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733185AbfL2R5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733176AbfL2R5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95932206A4;
        Sun, 29 Dec 2019 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642223;
        bh=CtXnZ4O/bMRkIkPF8BOSiIRqPkqxfuL3zIobpbcfuic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpCXkdp7ntM8lDA4w4Qp68uoMLMcILcBFbl3ceFKfiFOQJ7SSTXYXjzp5UHnh2DcF
         D1VrXEcX+/gNK9GjWrn8QjbJu3xZIrnr2ZXoC6zJrld8GwVyjXn473nSotNa7+QrMY
         jzVfokKZVw1uTVG+RdVDFyIAwonVL3PIX1jQ3MlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 393/434] efi/memreserve: Register reservations as reserved in /proc/iomem
Date:   Sun, 29 Dec 2019 18:27:26 +0100
Message-Id: <20191229172728.441663267@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit ab0eb16205b43ece4c78e2259e681ff3d645ea66 upstream.

Memory regions that are reserved using efi_mem_reserve_persistent()
are recorded in a special EFI config table which survives kexec,
allowing the incoming kernel to honour them as well. However,
such reservations are not visible in /proc/iomem, and so the kexec
tools that load the incoming kernel and its initrd into memory may
overwrite these reserved regions before the incoming kernel has a
chance to reserve them from further use.

Address this problem by adding these reservations to /proc/iomem as
they are created. Note that reservations that are inherited from a
previous kernel are memblock_reserve()'d early on, so they are already
visible in /proc/iomem.

Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Bhupesh Sharma <bhsharma@redhat.com>
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191206165542.31469-2-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/efi.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -970,6 +970,24 @@ static int __init efi_memreserve_map_roo
 	return 0;
 }
 
+static int efi_mem_reserve_iomem(phys_addr_t addr, u64 size)
+{
+	struct resource *res, *parent;
+
+	res = kzalloc(sizeof(struct resource), GFP_ATOMIC);
+	if (!res)
+		return -ENOMEM;
+
+	res->name	= "reserved";
+	res->flags	= IORESOURCE_MEM;
+	res->start	= addr;
+	res->end	= addr + size - 1;
+
+	/* we expect a conflict with a 'System RAM' region */
+	parent = request_resource_conflict(&iomem_resource, res);
+	return parent ? request_resource(parent, res) : 0;
+}
+
 int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 {
 	struct linux_efi_memreserve *rsv;
@@ -994,7 +1012,7 @@ int __ref efi_mem_reserve_persistent(phy
 			rsv->entry[index].size = size;
 
 			memunmap(rsv);
-			return 0;
+			return efi_mem_reserve_iomem(addr, size);
 		}
 		memunmap(rsv);
 	}
@@ -1004,6 +1022,12 @@ int __ref efi_mem_reserve_persistent(phy
 	if (!rsv)
 		return -ENOMEM;
 
+	rc = efi_mem_reserve_iomem(__pa(rsv), SZ_4K);
+	if (rc) {
+		free_page((unsigned long)rsv);
+		return rc;
+	}
+
 	/*
 	 * The memremap() call above assumes that a linux_efi_memreserve entry
 	 * never crosses a page boundary, so let's ensure that this remains true
@@ -1020,7 +1044,7 @@ int __ref efi_mem_reserve_persistent(phy
 	efi_memreserve_root->next = __pa(rsv);
 	spin_unlock(&efi_mem_reserve_persistent_lock);
 
-	return 0;
+	return efi_mem_reserve_iomem(addr, size);
 }
 
 static int __init efi_memreserve_root_init(void)



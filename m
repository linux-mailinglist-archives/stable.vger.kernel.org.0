Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3E21161AC
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfLHNd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:33:59 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36600 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfLHNdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:33:50 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1idwgp-0007gX-4a; Sun, 08 Dec 2019 14:33:35 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 597C91C2883;
        Sun,  8 Dec 2019 14:33:34 +0100 (CET)
Date:   Sun, 08 Dec 2019 13:33:34 -0000
From:   "tip-bot2 for Ard Biesheuvel" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/memreserve: Register reservations as 'reserved'
 in /proc/iomem
Cc:     Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>, <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191206165542.31469-2-ardb@kernel.org>
References: <20191206165542.31469-2-ardb@kernel.org>
MIME-Version: 1.0
Message-ID: <157581201424.21853.10765012673649121432.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     ab0eb16205b43ece4c78e2259e681ff3d645ea66
Gitweb:        https://git.kernel.org/tip/ab0eb16205b43ece4c78e2259e681ff3d645ea66
Author:        Ard Biesheuvel <ardb@kernel.org>
AuthorDate:    Fri, 06 Dec 2019 16:55:37 
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Sun, 08 Dec 2019 12:42:18 +01:00

efi/memreserve: Register reservations as 'reserved' in /proc/iomem

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
---
 drivers/firmware/efi/efi.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d101f07..b096195 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -979,6 +979,24 @@ static int __init efi_memreserve_map_root(void)
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
@@ -1003,7 +1021,7 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 			rsv->entry[index].size = size;
 
 			memunmap(rsv);
-			return 0;
+			return efi_mem_reserve_iomem(addr, size);
 		}
 		memunmap(rsv);
 	}
@@ -1013,6 +1031,12 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
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
@@ -1029,7 +1053,7 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 	efi_memreserve_root->next = __pa(rsv);
 	spin_unlock(&efi_mem_reserve_persistent_lock);
 
-	return 0;
+	return efi_mem_reserve_iomem(addr, size);
 }
 
 static int __init efi_memreserve_root_init(void)

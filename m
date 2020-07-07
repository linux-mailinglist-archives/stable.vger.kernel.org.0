Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2E4217123
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgGGPYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbgGGPYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959042065D;
        Tue,  7 Jul 2020 15:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135470;
        bh=ZTajoMUUDkmpT/Bv3inm+yHdJpBzFV9d/bxptjUwfsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxyYi7EQWm1+5mVnSzoLjFji/NDr6wfQTRJsKexLCnXIuPT5RVv6HKGzwIz1O7bY4
         d8kznXjqBYLhtNPrCaUL6YTYGdvDcNt/SMc6E071r3/XPJQN86QsIg/XqwgCLVN42z
         kNUiF77KokAwkNKYwG3r4uu5+OkK00c/hKJmAcw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Tesarik <ptesarik@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 026/112] mm, dump_page(): do not crash with invalid mapping pointer
Date:   Tue,  7 Jul 2020 17:16:31 +0200
Message-Id: <20200707145802.233484930@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit 002ae7057069538aa3afd500f6f60a429cb948b2 ]

We have seen a following problem on a RPi4 with 1G RAM:

    BUG: Bad page state in process systemd-hwdb  pfn:35601
    page:ffff7e0000d58040 refcount:15 mapcount:131221 mapping:efd8fe765bc80080 index:0x1 compound_mapcount: -32767
    Unable to handle kernel paging request at virtual address efd8fe765bc80080
    Mem abort info:
      ESR = 0x96000004
      Exception class = DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
    Data abort info:
      ISV = 0, ISS = 0x00000004
      CM = 0, WnR = 0
    [efd8fe765bc80080] address between user and kernel address ranges
    Internal error: Oops: 96000004 [#1] SMP
    Modules linked in: btrfs libcrc32c xor xor_neon zlib_deflate raid6_pq mmc_block xhci_pci xhci_hcd usbcore sdhci_iproc sdhci_pltfm sdhci mmc_core clk_raspberrypi gpio_raspberrypi_exp pcie_brcmstb bcm2835_dma gpio_regulator phy_generic fixed sg scsi_mod efivarfs
    Supported: No, Unreleased kernel
    CPU: 3 PID: 408 Comm: systemd-hwdb Not tainted 5.3.18-8-default #1 SLE15-SP2 (unreleased)
    Hardware name: raspberrypi rpi/rpi, BIOS 2020.01 02/21/2020
    pstate: 40000085 (nZcv daIf -PAN -UAO)
    pc : __dump_page+0x268/0x368
    lr : __dump_page+0xc4/0x368
    sp : ffff000012563860
    x29: ffff000012563860 x28: ffff80003ddc4300
    x27: 0000000000000010 x26: 000000000000003f
    x25: ffff7e0000d58040 x24: 000000000000000f
    x23: efd8fe765bc80080 x22: 0000000000020095
    x21: efd8fe765bc80080 x20: ffff000010ede8b0
    x19: ffff7e0000d58040 x18: ffffffffffffffff
    x17: 0000000000000001 x16: 0000000000000007
    x15: ffff000011689708 x14: 3030386362353637
    x13: 6566386466653a67 x12: 6e697070616d2031
    x11: 32323133313a746e x10: 756f6370616d2035
    x9 : ffff00001168a840 x8 : ffff00001077a670
    x7 : 000000000000013d x6 : ffff0000118a43b5
    x5 : 0000000000000001 x4 : ffff80003dd9e2c8
    x3 : ffff80003dd9e2c8 x2 : 911c8d7c2f483500
    x1 : dead000000000100 x0 : efd8fe765bc80080
    Call trace:
     __dump_page+0x268/0x368
     bad_page+0xd4/0x168
     check_new_page_bad+0x80/0xb8
     rmqueue_bulk.constprop.26+0x4d8/0x788
     get_page_from_freelist+0x4d4/0x1228
     __alloc_pages_nodemask+0x134/0xe48
     alloc_pages_vma+0x198/0x1c0
     do_anonymous_page+0x1a4/0x4d8
     __handle_mm_fault+0x4e8/0x560
     handle_mm_fault+0x104/0x1e0
     do_page_fault+0x1e8/0x4c0
     do_translation_fault+0xb0/0xc0
     do_mem_abort+0x50/0xb0
     el0_da+0x24/0x28
    Code: f9401025 8b8018a0 9a851005 17ffffca (f94002a0)

Besides the underlying issue with page->mapping containing a bogus value
for some reason, we can see that __dump_page() crashed by trying to read
the pointer at mapping->host, turning a recoverable warning into full
Oops.

It can be expected that when page is reported as bad state for some
reason, the pointers there should not be trusted blindly.

So this patch treats all data in __dump_page() that depends on
page->mapping as lava, using probe_kernel_read_strict().  Ideally this
would include the dentry->d_parent recursively, but that would mean
changing printk handler for %pd.  Chances of reaching the dentry
printing part with an initially bogus mapping pointer should be rather
low, though.

Also prefix printing mapping->a_ops with a description of what is being
printed.  In case the value is bogus, %ps will print raw value instead
of the symbol name and then it's not obvious at all that it's printing
a_ops.

Reported-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Link: http://lkml.kernel.org/r/20200331165454.12263-1-vbabka@suse.cz
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/debug.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/mm/debug.c b/mm/debug.c
index 2189357f09871..f2ede2df585a9 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -110,13 +110,57 @@ void __dump_page(struct page *page, const char *reason)
 	else if (PageAnon(page))
 		type = "anon ";
 	else if (mapping) {
-		if (mapping->host && mapping->host->i_dentry.first) {
-			struct dentry *dentry;
-			dentry = container_of(mapping->host->i_dentry.first, struct dentry, d_u.d_alias);
-			pr_warn("%ps name:\"%pd\"\n", mapping->a_ops, dentry);
-		} else
-			pr_warn("%ps\n", mapping->a_ops);
+		const struct inode *host;
+		const struct address_space_operations *a_ops;
+		const struct hlist_node *dentry_first;
+		const struct dentry *dentry_ptr;
+		struct dentry dentry;
+
+		/*
+		 * mapping can be invalid pointer and we don't want to crash
+		 * accessing it, so probe everything depending on it carefully
+		 */
+		if (probe_kernel_read_strict(&host, &mapping->host,
+						sizeof(struct inode *)) ||
+		    probe_kernel_read_strict(&a_ops, &mapping->a_ops,
+				sizeof(struct address_space_operations *))) {
+			pr_warn("failed to read mapping->host or a_ops, mapping not a valid kernel address?\n");
+			goto out_mapping;
+		}
+
+		if (!host) {
+			pr_warn("mapping->a_ops:%ps\n", a_ops);
+			goto out_mapping;
+		}
+
+		if (probe_kernel_read_strict(&dentry_first,
+			&host->i_dentry.first, sizeof(struct hlist_node *))) {
+			pr_warn("mapping->a_ops:%ps with invalid mapping->host inode address %px\n",
+				a_ops, host);
+			goto out_mapping;
+		}
+
+		if (!dentry_first) {
+			pr_warn("mapping->a_ops:%ps\n", a_ops);
+			goto out_mapping;
+		}
+
+		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
+		if (probe_kernel_read_strict(&dentry, dentry_ptr,
+							sizeof(struct dentry))) {
+			pr_warn("mapping->aops:%ps with invalid mapping->host->i_dentry.first %px\n",
+				a_ops, dentry_ptr);
+		} else {
+			/*
+			 * if dentry is corrupted, the %pd handler may still
+			 * crash, but it's unlikely that we reach here with a
+			 * corrupted struct page
+			 */
+			pr_warn("mapping->aops:%ps dentry name:\"%pd\"\n",
+								a_ops, &dentry);
+		}
 	}
+out_mapping:
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
 	pr_warn("%sflags: %#lx(%pGp)%s\n", type, page->flags, &page->flags,
-- 
2.25.1




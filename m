Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E401C14C5
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbgEANmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731327AbgEANmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FF7205C9;
        Fri,  1 May 2020 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340568;
        bh=GYPhc5rMNUeNYPNGbzs5OmtuGS1eXhbt6iZS9KEXzbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ryz7SCSm3LODwoOhTW80mN0GQDKaQf2ke1ZCfhzlEScX1i2eACbtcNiC09x3q8BRH
         rnzvYsAbguSEE6Sut0aZMsP9e8/Y4t6BUrWyY+OGjAq0d9O1Vt0DfalRe59XxQ2Cja
         LBY+DXmM03BwFx/DsfyeK5NsfdyFqjk2oy9iJw9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.6 035/106] efi/x86: Dont remap text<->rodata gap read-only for mixed mode
Date:   Fri,  1 May 2020 15:23:08 +0200
Message-Id: <20200501131548.137419636@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit f6103162008dfd37567f240b50e5e1ea7cf2e00c upstream.

Commit

  d9e3d2c4f10320 ("efi/x86: Don't map the entire kernel text RW for mixed mode")

updated the code that creates the 1:1 memory mapping to use read-only
attributes for the 1:1 alias of the kernel's text and rodata sections, to
protect it from inadvertent modification. However, it failed to take into
account that the unused gap between text and rodata is given to the page
allocator for general use.

If the vmap'ed stack happens to be allocated from this region, any by-ref
output arguments passed to EFI runtime services that are allocated on the
stack (such as the 'datasize' argument taken by GetVariable() when invoked
from efivar_entry_size()) will be referenced via a read-only mapping,
resulting in a page fault if the EFI code tries to write to it:

  BUG: unable to handle page fault for address: 00000000386aae88
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0003) - permissions violation
  PGD fd61063 P4D fd61063 PUD fd62063 PMD 386000e1
  Oops: 0003 [#1] SMP PTI
  CPU: 2 PID: 255 Comm: systemd-sysv-ge Not tainted 5.6.0-rc4-default+ #22
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0008:0x3eaeed95
  Code: ...  <89> 03 be 05 00 00 80 a1 74 63 b1 3e 83 c0 48 e8 44 d2 ff ff eb 05
  RSP: 0018:000000000fd73fa0 EFLAGS: 00010002
  RAX: 0000000000000001 RBX: 00000000386aae88 RCX: 000000003e9f1120
  RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000001
  RBP: 000000000fd73fd8 R08: 00000000386aae88 R09: 0000000000000000
  R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
  R13: ffffc0f040220000 R14: 0000000000000000 R15: 0000000000000000
  FS:  00007f21160ac940(0000) GS:ffff9cf23d500000(0000) knlGS:0000000000000000
  CS:  0008 DS: 0018 ES: 0018 CR0: 0000000080050033
  CR2: 00000000386aae88 CR3: 000000000fd6c004 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
  Modules linked in:
  CR2: 00000000386aae88
  ---[ end trace a8bfbd202e712834 ]---

Let's fix this by remapping text and rodata individually, and leave the
gaps mapped read-write.

Fixes: d9e3d2c4f10320 ("efi/x86: Don't map the entire kernel text RW for mixed mode")
Reported-by: Jiri Slaby <jslaby@suse.cz>
Tested-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200409130434.6736-10-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi_64.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -202,7 +202,7 @@ virt_to_phys_or_null_size(void *va, unsi
 
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
-	unsigned long pfn, text, pf;
+	unsigned long pfn, text, pf, rodata;
 	struct page *page;
 	unsigned npages;
 	pgd_t *pgd = efi_mm.pgd;
@@ -256,7 +256,7 @@ int __init efi_setup_page_tables(unsigne
 
 	efi_scratch.phys_stack = page_to_phys(page + 1); /* stack grows down */
 
-	npages = (__end_rodata_aligned - _text) >> PAGE_SHIFT;
+	npages = (_etext - _text) >> PAGE_SHIFT;
 	text = __pa(_text);
 	pfn = text >> PAGE_SHIFT;
 
@@ -266,6 +266,14 @@ int __init efi_setup_page_tables(unsigne
 		return 1;
 	}
 
+	npages = (__end_rodata - __start_rodata) >> PAGE_SHIFT;
+	rodata = __pa(__start_rodata);
+	pfn = rodata >> PAGE_SHIFT;
+	if (kernel_map_pages_in_pgd(pgd, pfn, rodata, npages, pf)) {
+		pr_err("Failed to map kernel rodata 1:1\n");
+		return 1;
+	}
+
 	return 0;
 }
 



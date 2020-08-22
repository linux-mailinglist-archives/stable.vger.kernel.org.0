Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D5624E7A9
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 15:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHVNjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 09:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgHVNjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 09:39:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9217FC061575;
        Sat, 22 Aug 2020 06:39:03 -0700 (PDT)
Date:   Sat, 22 Aug 2020 13:39:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598103542;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zd678ZKKZ255D+lweXntG7O+/mmZ8NMsjf48ukNw5I=;
        b=UGQ9y/Ebi31TXEKWekiQvM4QooQqc4O/CNs1IOJFEra4X1DVYEWR9SUOVMwEpcp6DG3252
        EyTo+0kesYSxU087uXVVw0/X5f1HXe22lDGOe9Ajk6Iln+7D5BePXhmePUv1an2jj6mab6
        iDFAOIYJ7twI2Gj37yUmljYNrMscrlZ5NxCRKZ2x990KabmYGAx+ECTOGzdLTa9yJ1jPWV
        yvuFhmFaXI6+/Rh40kWmFYl/wGbgOqmPxyDim/w0yRPsuh0d1wPt3rZ4QlOUksbbP4HmWi
        9Wf4bT0pikpTPhTO8R6M1PptWtHXGvScIKCved2jkqb/8pP1KDrjdMDMrjBykg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598103542;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zd678ZKKZ255D+lweXntG7O+/mmZ8NMsjf48ukNw5I=;
        b=w/Gyd2vd2/vTrVonUimC9cbtmBzNaUoEi8zM6omyfK9dQF3nPXLF26K9S+Q8cfV5tnhRBh
        R3GoxGaFLLn5vUDg==
From:   "tip-bot2 for Arvind Sankar" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/x86: Mark kernel rodata non-executable for mixed mode
Cc:     <stable@vger.kernel.org>, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200717194526.3452089-1-nivedita@alum.mit.edu>
References: <20200717194526.3452089-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Message-ID: <159810354148.3192.13677289427486753048.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     c8502eb2d43b6b9b1dc382299a4d37031be63876
Gitweb:        https://git.kernel.org/tip/c8502eb2d43b6b9b1dc382299a4d37031be63876
Author:        Arvind Sankar <nivedita@alum.mit.edu>
AuthorDate:    Fri, 17 Jul 2020 15:45:26 -04:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Thu, 20 Aug 2020 11:18:36 +02:00

efi/x86: Mark kernel rodata non-executable for mixed mode

When remapping the kernel rodata section RO in the EFI pagetables, the
protection flags that were used for the text section are being reused,
but the rodata section should not be marked executable.

Cc: <stable@vger.kernel.org>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200717194526.3452089-1-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 413583f..6af4da1 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -259,6 +259,8 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	npages = (__end_rodata - __start_rodata) >> PAGE_SHIFT;
 	rodata = __pa(__start_rodata);
 	pfn = rodata >> PAGE_SHIFT;
+
+	pf = _PAGE_NX | _PAGE_ENC;
 	if (kernel_map_pages_in_pgd(pgd, pfn, rodata, npages, pf)) {
 		pr_err("Failed to map kernel rodata 1:1\n");
 		return 1;

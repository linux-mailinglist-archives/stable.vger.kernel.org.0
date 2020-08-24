Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA8924F942
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgHXIoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbgHXIoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:44:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775562075B;
        Mon, 24 Aug 2020 08:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258644;
        bh=58Z6IeNs6Hg/9kOGBErvEFQIfNcXC8BC2NCSVEBxqas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byletigB+KuAu6PyEK3tg5F5ye/QkIofNBIrQIUblz+7tFkrA3KEE23Oy85g8ppzN
         /zXgCZ77W3vpqsTmZFmgrCMPt6bCQbI67e+zwnDJfDbMKkerXj9fzzR4eP2nZzTruO
         2MfkJkgZUkIZXxl+y94JGj5VY5B0/D0rf3984KqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.7 119/124] efi/x86: Mark kernel rodata non-executable for mixed mode
Date:   Mon, 24 Aug 2020 10:30:53 +0200
Message-Id: <20200824082415.261235479@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

commit c8502eb2d43b6b9b1dc382299a4d37031be63876 upstream.

When remapping the kernel rodata section RO in the EFI pagetables, the
protection flags that were used for the text section are being reused,
but the rodata section should not be marked executable.

Cc: <stable@vger.kernel.org>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200717194526.3452089-1-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi_64.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -269,6 +269,8 @@ int __init efi_setup_page_tables(unsigne
 	npages = (__end_rodata - __start_rodata) >> PAGE_SHIFT;
 	rodata = __pa(__start_rodata);
 	pfn = rodata >> PAGE_SHIFT;
+
+	pf = _PAGE_NX | _PAGE_ENC;
 	if (kernel_map_pages_in_pgd(pgd, pfn, rodata, npages, pf)) {
 		pr_err("Failed to map kernel rodata 1:1\n");
 		return 1;



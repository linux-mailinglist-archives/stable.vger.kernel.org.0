Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00BA2267F6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbgGTQQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388496AbgGTQQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 319A42064B;
        Mon, 20 Jul 2020 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261763;
        bh=2WIqrrjZ5dFloCIxE6c280prt6aRS9BfBvTLbxVQrkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDWpv3nM9k2sllut/5i50l32BX5qMKMbV9fMrO+M+TpihzGuZZJEsJSVOKEsYQkv1
         TpCgi+6zfYF34TRX20sszJh/oQznRwTp7aZ2AKrZGpcLX1vXnxW91XaCHR/Dbo7+G1
         ZyIb6dRCcy2rLpmCk4Aw69bruy7hTxPOftQg4rJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Michel Lespinasse <walken@google.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking walk_page_range
Date:   Mon, 20 Jul 2020 17:38:24 +0200
Message-Id: <20200720152836.926007002@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

commit 0e2c09011d4de4161f615ff860a605a9186cf62a upstream.

As per walk_page_range documentation, mmap lock should be acquired by the
caller before invoking walk_page_range. mmap_assert_locked gets triggered
without that. The details can be found here.

http://lists.infradead.org/pipermail/linux-riscv/2020-June/010335.html

Fixes: 395a21ff859c(riscv: add ARCH_HAS_SET_DIRECT_MAP support)
Signed-off-by: Atish Patra <atish.patra@wdc.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/mm/pageattr.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -151,6 +151,7 @@ int set_memory_nx(unsigned long addr, in
 
 int set_direct_map_invalid_noflush(struct page *page)
 {
+	int ret;
 	unsigned long start = (unsigned long)page_address(page);
 	unsigned long end = start + PAGE_SIZE;
 	struct pageattr_masks masks = {
@@ -158,11 +159,16 @@ int set_direct_map_invalid_noflush(struc
 		.clear_mask = __pgprot(_PAGE_PRESENT)
 	};
 
-	return walk_page_range(&init_mm, start, end, &pageattr_ops, &masks);
+	mmap_read_lock(&init_mm);
+	ret = walk_page_range(&init_mm, start, end, &pageattr_ops, &masks);
+	mmap_read_unlock(&init_mm);
+
+	return ret;
 }
 
 int set_direct_map_default_noflush(struct page *page)
 {
+	int ret;
 	unsigned long start = (unsigned long)page_address(page);
 	unsigned long end = start + PAGE_SIZE;
 	struct pageattr_masks masks = {
@@ -170,7 +176,11 @@ int set_direct_map_default_noflush(struc
 		.clear_mask = __pgprot(0)
 	};
 
-	return walk_page_range(&init_mm, start, end, &pageattr_ops, &masks);
+	mmap_read_lock(&init_mm);
+	ret = walk_page_range(&init_mm, start, end, &pageattr_ops, &masks);
+	mmap_read_unlock(&init_mm);
+
+	return ret;
 }
 
 void __kernel_map_pages(struct page *page, int numpages, int enable)



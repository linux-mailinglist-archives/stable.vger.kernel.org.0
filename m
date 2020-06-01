Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95301EAB1C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbgFASO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731126AbgFASOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:14:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294C2207DF;
        Mon,  1 Jun 2020 18:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035262;
        bh=MWITYB0vR5lA3KxxO0iN6yDsjvP8KH/f4rd52IxEzSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX85oL9NL4cXuSgCGogE1bQS6n5AEehN7464kXe7xkcmjCLDACwyPdxNXHedsn6g7
         X4LzEpwCoZlUbhCJDGm1otk46Lg+F3cZN1xcz332sgC67BiHdC9D6gMj3dmJnGsix3
         LFkhcQ21k+aG178Wp2m7NKalfbOziVQeOY8ShGwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 079/177] riscv: pgtable: Fix __kernel_map_pages build error if NOMMU
Date:   Mon,  1 Jun 2020 19:53:37 +0200
Message-Id: <20200601174055.484767292@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 9a6630aef93394ac54494c7e273e9bc026509375 ]

riscv64-none-linux-gnu-ld: mm/page_alloc.o: in function `.L0 ':
page_alloc.c:(.text+0xd34): undefined reference to `__kernel_map_pages'
riscv64-none-linux-gnu-ld: page_alloc.c:(.text+0x104a): undefined reference to `__kernel_map_pages'
riscv64-none-linux-gnu-ld: mm/page_alloc.o: in function `__pageblock_pfn_to_page':
page_alloc.c:(.text+0x145e): undefined reference to `__kernel_map_pages'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 05b92987f500..31d912944d8d 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -467,6 +467,8 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #define TASK_SIZE 0xffffffffUL
 
+static inline void __kernel_map_pages(struct page *page, int numpages, int enable) {}
+
 #endif /* !CONFIG_MMU */
 
 #define kern_addr_valid(addr)   (1) /* FIXME */
-- 
2.25.1




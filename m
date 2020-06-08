Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1CC1F2C1E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgFIAU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgFHXR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16E252083E;
        Mon,  8 Jun 2020 23:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658278;
        bh=MWITYB0vR5lA3KxxO0iN6yDsjvP8KH/f4rd52IxEzSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obHUcP9Xa3uitrZ2Iq4W8R+yxpy+/BcEarHg+xzX96MX6+9vv5qAPUoR2AGcSHdzy
         87c9LNBkOvowQLZVV1wVJ0zY593j1g2FV0m9WovModvdG6vS0Wf5pL6DJd5u8q97uY
         gNFJLbr1+cVVD5Ccy82Pfz0b6anE6tzBEgsh9Za0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 284/606] riscv: pgtable: Fix __kernel_map_pages build error if NOMMU
Date:   Mon,  8 Jun 2020 19:06:49 -0400
Message-Id: <20200608231211.3363633-284-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


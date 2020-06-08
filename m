Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CB31F23ED
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgFHXRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbgFHXRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CB8208B3;
        Mon,  8 Jun 2020 23:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658270;
        bh=6N2uRjlh/wR1nNEdVNdwFs6zFXOV8xD1YmT4D8/8yAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRFvQrP15fNWw2hQONRjTx33+HM3NYkUeOERdRBuwYg/gJiA9WFqc6ysMS5Akgp44
         btz0aobii1fQ7DltuZPH2UClLzQe5t7we0NZ4Qc4h61PFaVpM38deD+cART8t/tzJy
         e1S56TmmM37P+ZZf63k3LQdow7VkVWH59UuNmaFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 277/606] riscv: Add pgprot_writecombine/device and PAGE_SHARED defination if NOMMU
Date:   Mon,  8 Jun 2020 19:06:42 -0400
Message-Id: <20200608231211.3363633-277-sashal@kernel.org>
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

[ Upstream commit fa8174aa225fe3d53b37552e5066e6f0301dbabd ]

Some drivers use PAGE_SHARED, pgprot_writecombine()/pgprot_device(),
add the defination to fix build error if NOMMU.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/mmio.h    | 2 ++
 arch/riscv/include/asm/pgtable.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/mmio.h b/arch/riscv/include/asm/mmio.h
index a2c809df2733..56053c9838b2 100644
--- a/arch/riscv/include/asm/mmio.h
+++ b/arch/riscv/include/asm/mmio.h
@@ -16,6 +16,8 @@
 
 #ifndef CONFIG_MMU
 #define pgprot_noncached(x)	(x)
+#define pgprot_writecombine(x)	(x)
+#define pgprot_device(x)	(x)
 #endif /* CONFIG_MMU */
 
 /* Generic IO read/write.  These perform native-endian accesses. */
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 393f2014dfee..05b92987f500 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -460,6 +460,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #else /* CONFIG_MMU */
 
+#define PAGE_SHARED		__pgprot(0)
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
 #define VMALLOC_START		0
-- 
2.25.1


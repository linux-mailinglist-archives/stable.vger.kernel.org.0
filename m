Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDA61DEB00
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgEVOue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbgEVOud (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:50:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80CD0222B9;
        Fri, 22 May 2020 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159033;
        bh=6N2uRjlh/wR1nNEdVNdwFs6zFXOV8xD1YmT4D8/8yAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTNBrp4P+129ZZy9+hL2feyA1y0e5S2ynvKhPfsBzwFXAD7FEhgy6yx+WXHKtWAxA
         rYmajRO4PecxUmmGVmrgqs1CDatrU5P+uKaafUXmoy+PfEMnulgUOroyjmJXcPsjqF
         y2I8PHB6UCzGLFW1g0HnOHwoCiY4o7ZoPYoSAifc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 30/41] riscv: Add pgprot_writecombine/device and PAGE_SHARED defination if NOMMU
Date:   Fri, 22 May 2020 10:49:47 -0400
Message-Id: <20200522144959.434379-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522144959.434379-1-sashal@kernel.org>
References: <20200522144959.434379-1-sashal@kernel.org>
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


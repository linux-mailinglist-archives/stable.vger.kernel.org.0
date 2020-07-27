Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C361A22FD7B
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 01:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgG0X17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 19:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgG0XYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 19:24:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2352208E4;
        Mon, 27 Jul 2020 23:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892281;
        bh=n1FukGZuQXyu2MVVpZOdKAmj1C0W92scKOGnuT4UQO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDUbjLgVDLKH3ZBC4o7O0sap26ef3QtaCDvmkjqFi+SD9BugZw8dVVC38vJ9Paimo
         p5KL0t9biHW/+x1xtTj3V3u7n8Q4FQXDSM31o1Kv8hIOUd8zAq89DFw4Dsmx4IAdVO
         gJOyunQXPWZ/c7jeXP2XlRYnnOvkt9KyqMl1LpOU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 16/17] RISC-V: Set maximum number of mapped pages correctly
Date:   Mon, 27 Jul 2020 19:24:19 -0400
Message-Id: <20200727232420.717684-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232420.717684-1-sashal@kernel.org>
References: <20200727232420.717684-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

[ Upstream commit d0d8aae64566b753c4330fbd5944b88af035f299 ]

Currently, maximum number of mapper pages are set to the pfn calculated
from the memblock size of the memblock containing kernel. This will work
until that memblock spans the entire memory. However, it will be set to
a wrong value if there are multiple memblocks defined in kernel
(e.g. with efi runtime services).

Set the the maximum value to the pfn calculated from dram size.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 3198129230126..b1eb6a0411183 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -115,9 +115,9 @@ void __init setup_bootmem(void)
 	/* Reserve from the start of the kernel to the end of the kernel */
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
-	set_max_mapnr(PFN_DOWN(mem_size));
 	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
 	max_low_pfn = max_pfn;
+	set_max_mapnr(max_low_pfn);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	setup_initrd();
-- 
2.25.1


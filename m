Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AFC1E6067
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389077AbgE1MJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388727AbgE1L40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F67F212CC;
        Thu, 28 May 2020 11:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666986;
        bh=04t9itlU1J/2xv4vUewI0M8oZPMJaRDzx3JulnAkUFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJe1VwNfjoR0kqxZhd0hTc6qG1waXXQnkottho9kjB8R4/eDnfuxcHcQolMDJdmye
         JhOmn7meQBr5OZwOujG6LimGiFNWLzWohLZGvxff45mBx4o320Bnmg4w1xgX6676ex
         JPnZiCvvXjYuWXAvDZ2wRH4WdwED4cqgYtWpxQ8M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 22/47] riscv: Fix print_vm_layout build error if NOMMU
Date:   Thu, 28 May 2020 07:55:35 -0400
Message-Id: <20200528115600.1405808-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 8fa3cdff05f009855a6a99a7d77a41004009bbab ]

arch/riscv/mm/init.c: In function ‘print_vm_layout’:
arch/riscv/mm/init.c:68:37: error: ‘FIXADDR_START’ undeclared (first use in this function);
arch/riscv/mm/init.c:69:20: error: ‘FIXADDR_TOP’ undeclared
arch/riscv/mm/init.c:70:37: error: ‘PCI_IO_START’ undeclared
arch/riscv/mm/init.c:71:20: error: ‘PCI_IO_END’ undeclared
arch/riscv/mm/init.c:72:38: error: ‘VMEMMAP_START’ undeclared
arch/riscv/mm/init.c:73:20: error: ‘VMEMMAP_END’ undeclared (first use in this function);

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 157924baa191..1dc26384a6c4 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -46,7 +46,7 @@ static void setup_zero_page(void)
 	memset((void *)empty_zero_page, 0, PAGE_SIZE);
 }
 
-#ifdef CONFIG_DEBUG_VM
+#if defined(CONFIG_MMU) && defined(CONFIG_DEBUG_VM)
 static inline void print_mlk(char *name, unsigned long b, unsigned long t)
 {
 	pr_notice("%12s : 0x%08lx - 0x%08lx   (%4ld kB)\n", name, b, t,
-- 
2.25.1


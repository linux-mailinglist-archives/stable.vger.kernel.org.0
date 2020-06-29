Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6AC20E6BE
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbgF2VuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgF2Sfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853392478D;
        Mon, 29 Jun 2020 15:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444097;
        bh=KGTxbpDBwea5FTUqlV3d9WT6LzTHKFm5813Edct4Qfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylvJ/sq5T0QxF72mI88ldVRIv1aOHYEryufRvqYgWujXZ+jNpIHo7klmi8mcYIq6c
         LjP66kzxSYIF7hXWd41ekWF8wPRGjXC2ysBMR2pOS4IqUjKLvuHyd5Wdd9NqI007SX
         nYAMiCmm8JbZ4jQHXtzNLQvjAtkU79eQh+i7aqdY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yash Shah <yash.shah@sifive.com>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 207/265] RISC-V: Don't allow write+exec only page mapping request in mmap
Date:   Mon, 29 Jun 2020 11:17:20 -0400
Message-Id: <20200629151818.2493727-208-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yash Shah <yash.shah@sifive.com>

[ Upstream commit e0d17c842c0f824fd4df9f4688709fc6907201e1 ]

As per the table 4.4 of version "20190608-Priv-MSU-Ratified" of the
RISC-V instruction set manual[0], the PTE permission bit combination of
"write+exec only" is reserved for future use. Hence, don't allow such
mapping request in mmap call.

An issue is been reported by David Abdurachmanov, that while running
stress-ng with "sysbadaddr" argument, RCU stalls are observed on RISC-V
specific kernel.

This issue arises when the stress-sysbadaddr request for pages with
"write+exec only" permission bits and then passes the address obtain
from this mmap call to various system call. For the riscv kernel, the
mmap call should fail for this particular combination of permission bits
since it's not valid.

[0]: http://dabbelt.com/~palmer/keep/riscv-isa-manual/riscv-privileged-20190608-1.pdf

Signed-off-by: Yash Shah <yash.shah@sifive.com>
Reported-by: David Abdurachmanov <david.abdurachmanov@gmail.com>
[Palmer: Refer to the latest ISA specification at the only link I could
find, and update the terminology.]
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/sys_riscv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index f3619f59d85cc..12f8a7fce78b1 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -8,6 +8,7 @@
 #include <linux/syscalls.h>
 #include <asm/unistd.h>
 #include <asm/cacheflush.h>
+#include <asm-generic/mman-common.h>
 
 static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 			   unsigned long prot, unsigned long flags,
@@ -16,6 +17,11 @@ static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 {
 	if (unlikely(offset & (~PAGE_MASK >> page_shift_offset)))
 		return -EINVAL;
+
+	if ((prot & PROT_WRITE) && (prot & PROT_EXEC))
+		if (unlikely(!(prot & PROT_READ)))
+			return -EINVAL;
+
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd,
 			       offset >> (PAGE_SHIFT - page_shift_offset));
 }
-- 
2.25.1


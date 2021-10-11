Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1066428F9B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbhJKN7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238454AbhJKN6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AAE160F38;
        Mon, 11 Oct 2021 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960521;
        bh=mPjU0xKomhCES4vTJlwmRam0i1r3BCuYgXV59/CXwXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCjenP0BvYBuFCfOvCcZUWmhZbJh12ixjbisSVunr3wHNjBAxJLxhEhakARqDNQvA
         YMfT7cq8eLnhDgLrX3wG/RDPnOG3wG1QDdoTFJkGl64w2vyOorkNvbpd6r4vkgrCJ3
         viKXth+q7cNaxtaWvZ1HD3Qqp8VokzGSk1IRJMvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 70/83] riscv/vdso: make arch_setup_additional_pages wait for mmap_sem for write killable
Date:   Mon, 11 Oct 2021 15:46:30 +0200
Message-Id: <20211011134510.799792173@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit 8bb0ab3ae7a4dbe6cf32deb830cf2bdbf5736867 ]

riscv architectures relying on mmap_sem for write in their
arch_setup_additional_pages. If the waiting task gets killed by the oom
killer it would block oom_reaper from asynchronous address space reclaim
and reduce the chances of timely OOM resolving.  Wait for the lock in
the killable mode and return with EINTR if the task got killed while
waiting.

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index 3f1d35e7c98a..73d45931a053 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -65,7 +65,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 	vdso_len = (vdso_pages + 1) << PAGE_SHIFT;
 
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
 	vdso_base = get_unmapped_area(NULL, 0, vdso_len, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
 		ret = vdso_base;
-- 
2.33.0




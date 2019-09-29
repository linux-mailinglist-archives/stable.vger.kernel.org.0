Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3DCC1826
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbfI2RdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730020AbfI2RdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:33:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FDC721928;
        Sun, 29 Sep 2019 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778400;
        bh=BPODHx9SJViM3rcdfGPO6Ypkbm/NKj/WB+7yagIecvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0pFBTJL/3c86cf0SUr9mQmYIxIYFAWZVPAlbaERbsu0ombEkI66M6wmPOJHxue9u
         jiveCGsKcRkY6exZ+NL/a5EwvgGuj/S4bUwe4XeQfBVFeSRAu7C6GLQ5Q1TRsGy/WB
         ewFy7qUnxQSfNUg8OOyAU5V7L8BYPpfV1LlguxKQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Orion Hodson <oth@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 14/42] ARM: 8898/1: mm: Don't treat faults reported from cache maintenance as writes
Date:   Sun, 29 Sep 2019 13:32:13 -0400
Message-Id: <20190929173244.8918-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173244.8918-1-sashal@kernel.org>
References: <20190929173244.8918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 834020366da9ab3fb87d1eb9a3160eb22dbed63a ]

Translation faults arising from cache maintenance instructions are
rather unhelpfully reported with an FSR value where the WnR field is set
to 1, indicating that the faulting access was a write. Since cache
maintenance instructions on 32-bit ARM do not require any particular
permissions, this can cause our private 'cacheflush' system call to fail
spuriously if a translation fault is generated due to page aging when
targetting a read-only VMA.

In this situation, we will return -EFAULT to userspace, although this is
unfortunately suppressed by the popular '__builtin___clear_cache()'
intrinsic provided by GCC, which returns void.

Although it's tempting to write this off as a userspace issue, we can
actually do a little bit better on CPUs that support LPAE, even if the
short-descriptor format is in use. On these CPUs, cache maintenance
faults additionally set the CM field in the FSR, which we can use to
suppress the write permission checks in the page fault handler and
succeed in performing cache maintenance to read-only areas even in the
presence of a translation fault.

Reported-by: Orion Hodson <oth@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 4 ++--
 arch/arm/mm/fault.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 0048eadd0681a..e76155d5840bd 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -211,7 +211,7 @@ static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
 {
 	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
 
-	if (fsr & FSR_WRITE)
+	if ((fsr & FSR_WRITE) && !(fsr & FSR_CM))
 		mask = VM_WRITE;
 	if (fsr & FSR_LNX_PF)
 		mask = VM_EXEC;
@@ -282,7 +282,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (fsr & FSR_WRITE)
+	if ((fsr & FSR_WRITE) && !(fsr & FSR_CM))
 		flags |= FAULT_FLAG_WRITE;
 
 	/*
diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
index c063708fa5032..9ecc2097a87a0 100644
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -6,6 +6,7 @@
  * Fault status register encodings.  We steal bit 31 for our own purposes.
  */
 #define FSR_LNX_PF		(1 << 31)
+#define FSR_CM			(1 << 13)
 #define FSR_WRITE		(1 << 11)
 #define FSR_FS4			(1 << 10)
 #define FSR_FS3_0		(15)
-- 
2.20.1


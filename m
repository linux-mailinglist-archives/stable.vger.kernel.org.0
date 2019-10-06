Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A76BCD682
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfJFRnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbfJFRnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:43:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2F432080F;
        Sun,  6 Oct 2019 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383784;
        bh=fDMWIJ2q2yQifpis9eqvA9OLwFuD2uX2kyQjV7oQPDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkA2jyquem22cWSs/P1dw3ot47v/WBCXZDBJvvyhdPLeUA3aTK+WmQnbW5zU2nhQl
         lXgTTEhhXcQ+PHsiWKlbBDYOkZDPCGeBPNejnoBoiRLUtkqKUf55AofZAXja6K8yRF
         1Z1dG7HPhxFIh+G7f7Lv10U/9I74FpFUSPAjegHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Orion Hodson <oth@google.com>,
        Will Deacon <will@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 095/166] ARM: 8898/1: mm: Dont treat faults reported from cache maintenance as writes
Date:   Sun,  6 Oct 2019 19:21:01 +0200
Message-Id: <20191006171221.562399005@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 890eeaac3cbba..bd0f4821f7e11 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -191,7 +191,7 @@ static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
 {
 	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
 
-	if (fsr & FSR_WRITE)
+	if ((fsr & FSR_WRITE) && !(fsr & FSR_CM))
 		mask = VM_WRITE;
 	if (fsr & FSR_LNX_PF)
 		mask = VM_EXEC;
@@ -262,7 +262,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 
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




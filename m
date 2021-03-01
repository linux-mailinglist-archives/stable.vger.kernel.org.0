Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0483C328EE4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbhCATkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241940AbhCAT35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0363F65224;
        Mon,  1 Mar 2021 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619393;
        bh=DNsNJhRVm6UC89UhRP1anUjHNomOEFNusblbO2r/SnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9DMZYyjzSjbKb5G7f7Y1l/nxNdCxkaE2J1p4GuOKYhLfXBpNhEn9P5FRRUWKNeTp
         TUCze00v9bXu+QsowhCG9c3U6ruwI/FEO8pQQqJ+ft66db3y2flcbHM4Yg7eMoplV/
         YAOZb+mylIAgvAV0EBmCCccKSzD+z7McrU9vcsf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Ley Foon Tan <ley.foon.tan@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 439/663] Take mmap lock in cacheflush syscall
Date:   Mon,  1 Mar 2021 17:11:27 +0100
Message-Id: <20210301161203.616326263@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit c26958cb5a0d9053d1358258827638773f3d36ed ]

We need to take the mmap lock around find_vma() and subsequent use of the
VMA. Otherwise, we can race with concurrent operations like munmap(), which
can lead to use-after-free accesses to freed VMAs.

Fixes: 1000197d8013 ("nios2: System calls handling")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/kernel/sys_nios2.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/nios2/kernel/sys_nios2.c b/arch/nios2/kernel/sys_nios2.c
index cd390ec4f88bf..b1ca856999521 100644
--- a/arch/nios2/kernel/sys_nios2.c
+++ b/arch/nios2/kernel/sys_nios2.c
@@ -22,6 +22,7 @@ asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len,
 				unsigned int op)
 {
 	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
 
 	if (len == 0)
 		return 0;
@@ -34,16 +35,22 @@ asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len,
 	if (addr + len < addr)
 		return -EFAULT;
 
+	if (mmap_read_lock_killable(mm))
+		return -EINTR;
+
 	/*
 	 * Verify that the specified address region actually belongs
 	 * to this process.
 	 */
-	vma = find_vma(current->mm, addr);
-	if (vma == NULL || addr < vma->vm_start || addr + len > vma->vm_end)
+	vma = find_vma(mm, addr);
+	if (vma == NULL || addr < vma->vm_start || addr + len > vma->vm_end) {
+		mmap_read_unlock(mm);
 		return -EFAULT;
+	}
 
 	flush_cache_range(vma, addr, addr + len);
 
+	mmap_read_unlock(mm);
 	return 0;
 }
 
-- 
2.27.0




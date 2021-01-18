Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076712FA27E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbhARLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390528AbhARLpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B4F922472;
        Mon, 18 Jan 2021 11:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970271;
        bh=lT5SoK+lDeJQt0Wpn3MeX1H2CQIisdnCwo3hGHtmxs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtPXmfWa+ihxqU4UACMQpZA1dv+Kg/Ws6xtcQA0fpE645PPdgopv9HeLqFskR926s
         1oqEH2kdauEwR0NeXrpAMwcA5ONoxIMZpDECAX3n5aAF0OfkfZbKDPF02FXyINGeR6
         b89xyKzpIMolV3GS8ktYfbFBv2vjhxMOP5LI2lVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/152] mm: dont play games with pinned pages in clear_page_refs
Date:   Mon, 18 Jan 2021 12:34:45 +0100
Message-Id: <20210118113358.001978134@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 9348b73c2e1bfea74ccd4a44fb4ccc7276ab9623 ]

Turning a pinned page read-only breaks the pinning after COW.  Don't do it.

The whole "track page soft dirty" state doesn't work with pinned pages
anyway, since the page might be dirtied by the pinning entity without
ever being noticed in the page tables.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ab7d700b2caa4..602e3a52884d8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1035,6 +1035,25 @@ struct clear_refs_private {
 };
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
+
+#define is_cow_mapping(flags) (((flags) & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE)
+
+static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
+{
+	struct page *page;
+
+	if (!pte_write(pte))
+		return false;
+	if (!is_cow_mapping(vma->vm_flags))
+		return false;
+	if (likely(!atomic_read(&vma->vm_mm->has_pinned)))
+		return false;
+	page = vm_normal_page(vma, addr, pte);
+	if (!page)
+		return false;
+	return page_maybe_dma_pinned(page);
+}
+
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *pte)
 {
@@ -1049,6 +1068,8 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 	if (pte_present(ptent)) {
 		pte_t old_pte;
 
+		if (pte_is_pinned(vma, addr, ptent))
+			return;
 		old_pte = ptep_modify_prot_start(vma, addr, pte);
 		ptent = pte_wrprotect(old_pte);
 		ptent = pte_clear_soft_dirty(ptent);
-- 
2.27.0




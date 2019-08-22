Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAFE99A81
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbfHVRN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390574AbfHVRI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:56 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C23023406;
        Thu, 22 Aug 2019 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493735;
        bh=3A6m9fMUKPW0uA/L4zOoMyYo00AiR3KuJVo9+xKS1CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9RDPz/1wAmFIEaQl2NhgCSPMk5Mju20gZmfQ552c+YfSy7wbYrS304Tjv/w98rP+
         1tTvEEMxrVQC08cE+nFAKg/yZIU858ifFo2jsfr06XE5QkJG2x8VrA0eYDT92d6gX+
         cQaWCS0NFB76j8hMYU0c2F8gZXhkm+ypaK60VeDA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 075/135] arm64/mm: fix variable 'tag' set but not used
Date:   Thu, 22 Aug 2019 13:07:11 -0400
Message-Id: <20190822170811.13303-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 7732d20a160c76006c7fe7bca5178aea6af1d2e8 ]

When CONFIG_KASAN_SW_TAGS=n, set_tag() is compiled away. GCC throws a
warning,

mm/kasan/common.c: In function '__kasan_kmalloc':
mm/kasan/common.c:464:5: warning: variable 'tag' set but not used
[-Wunused-but-set-variable]
  u8 tag = 0xff;
     ^~~

Fix it by making __tag_set() a static inline function the same as
arch_kasan_set_tag() in mm/kasan/kasan.h for consistency because there
is a macro in arch/arm64/include/asm/kasan.h,

 #define arch_kasan_set_tag(addr, tag) __tag_set(addr, tag)

However, when CONFIG_DEBUG_VIRTUAL=n and CONFIG_SPARSEMEM_VMEMMAP=y,
page_to_virt() will call __tag_set() with incorrect type of a
parameter, so fix that as well. Also, still let page_to_virt() return
"void *" instead of "const void *", so will not need to add a similar
cast in lowmem_page_address().

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/memory.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b7ba75809751e..fb04f10a78ab3 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -210,7 +210,11 @@ extern u64			vabits_user;
 #define __tag_reset(addr)	untagged_addr(addr)
 #define __tag_get(addr)		(__u8)((u64)(addr) >> 56)
 #else
-#define __tag_set(addr, tag)	(addr)
+static inline const void *__tag_set(const void *addr, u8 tag)
+{
+	return addr;
+}
+
 #define __tag_reset(addr)	(addr)
 #define __tag_get(addr)		0
 #endif
@@ -301,8 +305,8 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define page_to_virt(page)	({					\
 	unsigned long __addr =						\
 		((__page_to_voff(page)) | PAGE_OFFSET);			\
-	unsigned long __addr_tag =					\
-		 __tag_set(__addr, page_kasan_tag(page));		\
+	const void *__addr_tag =					\
+		__tag_set((void *)__addr, page_kasan_tag(page));	\
 	((void *)__addr_tag);						\
 })
 
-- 
2.20.1


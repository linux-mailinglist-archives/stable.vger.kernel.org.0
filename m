Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895A117FD99
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgCJN2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgCJMxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:53:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D15E2469D;
        Tue, 10 Mar 2020 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844794;
        bh=3tNMU60XprKBxNN/4NIwRJhgpOF0fvOSbMzUIaiajjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaXpLoljTk983T7xhOSPjJvQjaOnal7GDn27kGmxDLxGjbFh4zABgCLqnxEyEvjSe
         /CZNW2BWKmJQNHrIWNWy/reU/gZMQpvxFwoXkgszz/kUwY+nFSvzDyRYrU5RR4hNhD
         FvY3sSccdo1BLW8KO5WPlSSgdrRngdLiSH1+3gSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alastair DSilva <alastair@d-silva.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/168] powerpc: define helpers to get L1 icache sizes
Date:   Tue, 10 Mar 2020 13:39:28 +0100
Message-Id: <20200310123647.792962275@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

[ Upstream commit 7a0745c5e03ff1129864bc6d80f5c4417e8d7893 ]

This patch adds helpers to retrieve icache sizes, and renames the existing
helpers to make it clear that they are for dcache.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191104023305.9581-4-alastair@au1.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cache.h      | 29 +++++++++++++++++++++++----
 arch/powerpc/include/asm/cacheflush.h | 12 +++++------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 45e3137ccd71c..afb88754e0e07 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -55,25 +55,46 @@ struct ppc64_caches {
 
 extern struct ppc64_caches ppc64_caches;
 
-static inline u32 l1_cache_shift(void)
+static inline u32 l1_dcache_shift(void)
 {
 	return ppc64_caches.l1d.log_block_size;
 }
 
-static inline u32 l1_cache_bytes(void)
+static inline u32 l1_dcache_bytes(void)
 {
 	return ppc64_caches.l1d.block_size;
 }
+
+static inline u32 l1_icache_shift(void)
+{
+	return ppc64_caches.l1i.log_block_size;
+}
+
+static inline u32 l1_icache_bytes(void)
+{
+	return ppc64_caches.l1i.block_size;
+}
 #else
-static inline u32 l1_cache_shift(void)
+static inline u32 l1_dcache_shift(void)
 {
 	return L1_CACHE_SHIFT;
 }
 
-static inline u32 l1_cache_bytes(void)
+static inline u32 l1_dcache_bytes(void)
 {
 	return L1_CACHE_BYTES;
 }
+
+static inline u32 l1_icache_shift(void)
+{
+	return L1_CACHE_SHIFT;
+}
+
+static inline u32 l1_icache_bytes(void)
+{
+	return L1_CACHE_BYTES;
+}
+
 #endif
 #endif /* ! __ASSEMBLY__ */
 
diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index eef388f2659f4..ed57843ef4524 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -63,8 +63,8 @@ static inline void __flush_dcache_icache_phys(unsigned long physaddr)
  */
 static inline void flush_dcache_range(unsigned long start, unsigned long stop)
 {
-	unsigned long shift = l1_cache_shift();
-	unsigned long bytes = l1_cache_bytes();
+	unsigned long shift = l1_dcache_shift();
+	unsigned long bytes = l1_dcache_bytes();
 	void *addr = (void *)(start & ~(bytes - 1));
 	unsigned long size = stop - (unsigned long)addr + (bytes - 1);
 	unsigned long i;
@@ -89,8 +89,8 @@ static inline void flush_dcache_range(unsigned long start, unsigned long stop)
  */
 static inline void clean_dcache_range(unsigned long start, unsigned long stop)
 {
-	unsigned long shift = l1_cache_shift();
-	unsigned long bytes = l1_cache_bytes();
+	unsigned long shift = l1_dcache_shift();
+	unsigned long bytes = l1_dcache_bytes();
 	void *addr = (void *)(start & ~(bytes - 1));
 	unsigned long size = stop - (unsigned long)addr + (bytes - 1);
 	unsigned long i;
@@ -108,8 +108,8 @@ static inline void clean_dcache_range(unsigned long start, unsigned long stop)
 static inline void invalidate_dcache_range(unsigned long start,
 					   unsigned long stop)
 {
-	unsigned long shift = l1_cache_shift();
-	unsigned long bytes = l1_cache_bytes();
+	unsigned long shift = l1_dcache_shift();
+	unsigned long bytes = l1_dcache_bytes();
 	void *addr = (void *)(start & ~(bytes - 1));
 	unsigned long size = stop - (unsigned long)addr + (bytes - 1);
 	unsigned long i;
-- 
2.20.1




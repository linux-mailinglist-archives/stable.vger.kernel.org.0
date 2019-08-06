Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4088783B6F
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfHFVfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbfHFVfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:35:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9FD3217D9;
        Tue,  6 Aug 2019 21:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127314;
        bh=IB6SHesi+A+4IuSaCxBprlGHXn7PaDRVN21talzL+Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKXvf3D62mJWxNaWzGWXyJxt9xCCSI+axvqfo4YAIfLzKbFdoW3gWEEFkl4GW6xuU
         3NmSNWdYLO7igq02iRH8h1GH11RMakxicVRz+WjaRG8UJDvs4WCCA0OLshAespTE62
         +n9B0OceBYWjD+EjQ33XuZIoj38RHxmuYf0hbKio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 56/59] page flags: prioritize kasan bits over last-cpuid
Date:   Tue,  6 Aug 2019 17:33:16 -0400
Message-Id: <20190806213319.19203-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ee38d94a0ad89890b770f6c876263cf9fcbfde84 ]

ARM64 randdconfig builds regularly run into a build error, especially
when NUMA_BALANCING and SPARSEMEM are enabled but not SPARSEMEM_VMEMMAP:

  #error "KASAN: not enough bits in page flags for tag"

The last-cpuid bits are already contitional on the available space, so
the result of the calculation is a bit random on whether they were
already left out or not.

Adding the kasan tag bits before last-cpuid makes it much more likely to
end up with a successful build here, and should be reliable for
randconfig at least, as long as that does not randomize NR_CPUS or
NODES_SHIFT but uses the defaults.

In order for the modified check to not trigger in the x86 vdso32 code
where all constants are wrong (building with -m32), enclose all the
definitions with an #ifdef.

[arnd@arndb.de: build fix]
  Link: http://lkml.kernel.org/r/CAK8P3a3Mno1SWTcuAOT0Wa9VS15pdU6EfnkxLbDpyS55yO04+g@mail.gmail.com
Link: http://lkml.kernel.org/r/20190722115520.3743282-1-arnd@arndb.de
Link: https://lore.kernel.org/lkml/20190618095347.3850490-1-arnd@arndb.de/
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/vdso/vdso.h             |  1 +
 include/linux/page-flags-layout.h | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/mips/vdso/vdso.h b/arch/mips/vdso/vdso.h
index 14b1931be69c3..b65b169778e31 100644
--- a/arch/mips/vdso/vdso.h
+++ b/arch/mips/vdso/vdso.h
@@ -9,6 +9,7 @@
 #if _MIPS_SIM != _MIPS_SIM_ABI64 && defined(CONFIG_64BIT)
 
 /* Building 32-bit VDSO for the 64-bit kernel. Fake a 32-bit Kconfig. */
+#define BUILD_VDSO32_64
 #undef CONFIG_64BIT
 #define CONFIG_32BIT 1
 #ifndef __ASSEMBLY__
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
index 1dda31825ec4a..71283739ffd23 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -32,6 +32,7 @@
 
 #endif /* CONFIG_SPARSEMEM */
 
+#ifndef BUILD_VDSO32_64
 /*
  * page->flags layout:
  *
@@ -76,20 +77,22 @@
 #define LAST_CPUPID_SHIFT 0
 #endif
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#ifdef CONFIG_KASAN_SW_TAGS
+#define KASAN_TAG_WIDTH 8
+#else
+#define KASAN_TAG_WIDTH 0
+#endif
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT+KASAN_TAG_WIDTH \
+	<= BITS_PER_LONG - NR_PAGEFLAGS
 #define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
 #else
 #define LAST_CPUPID_WIDTH 0
 #endif
 
-#ifdef CONFIG_KASAN_SW_TAGS
-#define KASAN_TAG_WIDTH 8
 #if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH+LAST_CPUPID_WIDTH+KASAN_TAG_WIDTH \
 	> BITS_PER_LONG - NR_PAGEFLAGS
-#error "KASAN: not enough bits in page flags for tag"
-#endif
-#else
-#define KASAN_TAG_WIDTH 0
+#error "Not enough bits in page flags"
 #endif
 
 /*
@@ -104,4 +107,5 @@
 #define LAST_CPUPID_NOT_IN_PAGE_FLAGS
 #endif
 
+#endif
 #endif /* _LINUX_PAGE_FLAGS_LAYOUT */
-- 
2.20.1

